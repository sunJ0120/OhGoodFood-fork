package kr.co.ohgoodfood.service.users;

import java.io.IOException;
import java.io.InputStream;
import java.io.UncheckedIOException;
import java.security.MessageDigest;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import kr.co.ohgoodfood.dto.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;

import kr.co.ohgoodfood.config.AwsS3Config;
import kr.co.ohgoodfood.dao.UserMapper;
import kr.co.ohgoodfood.dto.Account;
import kr.co.ohgoodfood.dto.Bookmark;
import kr.co.ohgoodfood.dto.MainStore;
import kr.co.ohgoodfood.dto.PickupStatus;
import kr.co.ohgoodfood.dto.ProductDetail;
import kr.co.ohgoodfood.dto.Review;
import kr.co.ohgoodfood.dto.ReviewForm;
import kr.co.ohgoodfood.dto.UserMainFilter;
import kr.co.ohgoodfood.dto.UserMypage;
import kr.co.ohgoodfood.dto.UserOrder;
import kr.co.ohgoodfood.dto.UserOrderFilter;
import kr.co.ohgoodfood.dto.UserOrderRequest;
import kr.co.ohgoodfood.util.StringSplitUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * UsersServiceImpl.java - UsersService interface 구현체
 * 
 * @see UsersService - 세부 기능은 해당 클래스인 UsersServiceImpl에 구현한다.
 * 의존성 주입은 생성자 주입으로 구성한다.
 */

@Slf4j
@RequiredArgsConstructor
@Service
public class UserServiceImpl implements UsersService{
    private final UserMapper userMapper;
	private final AwsS3Config awsS3Config;

    /**
     * 메인 화면에 뿌릴 DTO리스트를 가져오는 method
     *
     * @param userMainFilter : 필터링을 위한 객체가 담겨있다.
     * @return               : mainStoreList (MainStore DTO의 리스트 객체)
     */
    @Override
    public List<MainStore> getMainStoreList(UserMainFilter userMainFilter) {
        List<MainStore> mainStoreList = userMapper.selectAllStore(userMainFilter);

        // 카테고리 이름과 pickup 상태를 저장
        for(MainStore mainStore : mainStoreList){
            mainStore.setPickup_status(getPickupDateStatus(mainStore));
            mainStore.setCategory_list(getCategoryList(mainStore));
            mainStore.setMainmenu_list(StringSplitUtils.splitMenu(mainStore.getStore_menu(), "\\s*\\|\\s*"));
        }
        return mainStoreList;
    }

    /**
     * 지도에 표시할 가게 정보를 가져오는 method
     *
     * @param userMainFilter : 필터링을 위한 객체가 담겨있다. main에서 사용하는걸 그대로 사용한다
     * @return               : mainStore
     */
    //selectOneStoreByStoreId
    @Override
    public MainStore getMainStoreOne(UserMainFilter userMainFilter){

        MainStore mainStore = userMapper.selectOneStoreByStoreId(userMainFilter);

        mainStore.setPickup_status(getPickupDateStatus(mainStore));
        mainStore.setCategory_list(getCategoryList(mainStore));
        mainStore.setMainmenu_list(StringSplitUtils.splitMenu(mainStore.getStore_menu(), "\\s*\\|\\s*"));

        return mainStore;
    }

    /**
     * 사용자가 가진 북마크 리스트를 가져오는 method
     *
     * @param user_id           : 현재 세션에 접속한 사용자 id
     * @return                  : bookmarkList (Bookmark DTO의 리스트 객체)
     */
    @Override
    public List<Bookmark> getBookmarkList(String user_id){
        List<Bookmark> bookmarkList = userMapper.selectAllBookmark(user_id);

        // 여기에 카테고리 이름과 pickup 상태를 저장
        for(Bookmark bookmark : bookmarkList){
            bookmark.setPickup_status(getPickupDateStatus(bookmark));
            bookmark.setCategory_list(getCategoryList(bookmark));
            bookmark.setMainmenu_list(StringSplitUtils.splitMenu(bookmark.getStore_menu(), "/"));
        }

        return bookmarkList;
    }

    /**
     * LocalDate.now()로 오늘픽업, 내일픽업, 매진, 마감 상태를 판별합니다.
     *
     * @param mainStore          : 판별이 필요한 데이터가 담긴 객체
     * @return                   : PickupStatus ENUM 객체
     */
    @Override
    public PickupStatus getPickupDateStatus(MainStore mainStore) {
        LocalDate today = LocalDate.now();

        // [마감] - store_status = N
        if("N".equals(mainStore.getStore_status())){
            return PickupStatus.CLOSED;
        }else{
            LocalDate pickupDate = mainStore.getPickup_start().toLocalDateTime().toLocalDate();
            // [매진] - amount = 0
            if(mainStore.getAmount() == 0){
                return PickupStatus.SOLD_OUT;
            }else{
                // [오늘픽업] 현재 날짜와 같음
                if (pickupDate.isEqual(today)) {
                    return PickupStatus.TODAY;
                }
                // [내일픽업] 현재 날짜 + 1과 같음
                if (pickupDate.isEqual(today.plusDays(1))) {
                    return PickupStatus.TOMORROW;
                }
            }
        }
        throw new IllegalStateException();
    }

    /**
     * LocalDate.now()로 오늘픽업, 내일픽업만을 판별합니다.
     * Orders 페이지에서는 마감,매진 값은 필요 없기 때문에, 이것만을 판별하는 로직을 따로 만듭니다.
     *
     * @param userOrder        : 판별이 필요한 데이터가 담긴 객체
     * @return                 : PickupStatus ENUM 객체
     */
    @Override
    public PickupStatus getOrderPickupDateStatus(UserOrder userOrder) {
        LocalDate today = LocalDate.now();
        LocalDate pickupDate = userOrder.getPickup_start().toLocalDateTime().toLocalDate();

        // [오늘픽업] 현재 날짜와 같음
        if (pickupDate.isEqual(today)) {
            return PickupStatus.TODAY;
        }
//        // [내일픽업] 현재 날짜 + 1과 같음
//        if (pickupDate.isEqual(today.plusDays(1))) {
//            return PickupStatus.TOMORROW;
//        }
        //불안정 하긴 하지만, 이틀 뒤가 pick_up start인 경우가 없기 때문에 나머진 다 내일 픽업
        return PickupStatus.TOMORROW;
    }

    /**
     * |(구분자) 구분은 확장성을 위해 프론트 단에 위임
     * 서버에서는 리스트에 담아서 보내도록 한다.
     *
     * @param mainStore          : 판별이 필요한 데이터가 담긴 객체
     * @return                   : 카테고리 이름이 담긴 List
     */
    @Override
    public List<String> getCategoryList(MainStore mainStore) {
        List<String> category_list = new ArrayList<>();

        if(mainStore.getCategory_bakery().equals("Y")){
            category_list.add("빵 & 디저트");
        }

        if(mainStore.getCategory_fruit().equals("Y")){
            category_list.add("과일");
        }

        if(mainStore.getCategory_salad().equals("Y")){
            category_list.add("샐러드");
        }

        if(mainStore.getCategory_others().equals("Y")){
            category_list.add("그 외");
        }

        return category_list;
    }

    /**
     * 북마크를 삭제하기 위한 기능이다.
     *
     * @param bookmarkFilter     : Bookmark 삭제시 필요한 정보값이 담긴 DTO
     * @return                   : 실행 결과 행 수에 따라 Boolean
     */
    @Override
    public boolean deleteUserBookMark(BookmarkFilter bookmarkFilter) {
        String user_id = bookmarkFilter.getUser_id();
        String store_id = bookmarkFilter.getStore_id();

        int cnt = userMapper.deleteBookmark(user_id, store_id);

        if (cnt == 1) {
            return true;
        }
        return false; //delete 실패!
    }

    /**
     * 북마크를 추가하기 위한 기능이다.
     *
     * @param bookmarkFilter     : Bookmark 삭제시 필요한 정보값이 담긴 DTO
     * @return                   : 결과 행 수에 따라 Boolean
     */
    @Override
    public boolean insertUserBookMark(BookmarkFilter bookmarkFilter) {
        String user_id = bookmarkFilter.getUser_id();
        String store_id = bookmarkFilter.getStore_id();

        int cnt = userMapper.insertBookmark(user_id, store_id);

        if (cnt == 1) {
            return true;
        }
        return false; //insert 실패!
    }

    /**
     * 사용자의 OrderList를 가져오는 method
     *
     * @param userOrderFilter    : 세션에 접속한 사용자 id와 필터링을 위한 객체가 담겨있다.
     * @return                   : 조회한 UserOrderList
     */
    @Override
    public List<UserOrder> getUserOrderList(UserOrderFilter userOrderFilter){
        List<UserOrder> orderList = userMapper.selectOrderList(userOrderFilter);

        // userOrder에 pickup_status와 block_cancel 상태를 저장.
        for(UserOrder userOrder : orderList){
            userOrder.setPickup_status(getOrderPickupDateStatus(userOrder));
            userOrder.setBlock_cancel(getOrderBlockCancel(userOrder.getPickup_status(), userOrder.getReservation_end()));
        }
        return orderList;
    }

    /**
     * pickup_status가 오늘픽업 혹은 내일 픽업인 경우에, (즉, confirmed 상태) 한 시간 전에 취소 block 상태를 만들기 위함입니다.
     * reservation_end -1이 NOW일때를 계산합니다.
     *
     * @param pickup_status      : 블락 판별에 필요한 pickup_status (confirmed 인 경우, 즉 오늘픽업이나 내일 픽업인 경우에만 진행)
     * @param reservation_end    : 예약 마감 한시간 전을 계산하기 위한 reservation_end
     * @return                   : block_cancel 값을 설정하기 위해 boolean return
     */
    public boolean getOrderBlockCancel(PickupStatus pickup_status, Timestamp reservation_end){
        if(pickup_status.equals(PickupStatus.TODAY) || pickup_status.equals(PickupStatus.TOMORROW)){
            Timestamp now = new Timestamp(System.currentTimeMillis());

            long oneHourInMillis = 60L * 60L * 1000L; //한시간 계산
            Timestamp reservationEndOneHourBefore = new Timestamp(reservation_end.getTime() - oneHourInMillis);

            //reservation_end -1h < now < reservation_end
            if (now.after(reservationEndOneHourBefore) && now.before(reservation_end)) {
                return true;  // 마감 1시간 전 이내이면, 취소 블록하고 막는다.
            }
            return false;
        }
        return false; //오늘 픽업, 내일 픽업이 아니라면 이 block 변수는 false
    }

    /**
     * 사용자가 선택한 order를 취소 처리 합니다.
     *
     * @param userOrderRequest   : 사용자 주문 상태 변경 처리에 필요한 DTO
     * @return                   : UPDATE 쿼리가 잘 실행 되었는지 보기 위해 row return
     */
    @Override
    @Transactional
    public boolean updateUserOrderCancel(UserOrderRequest userOrderRequest){
        userOrderRequest.setOrder_status("cancel");
        userOrderRequest.setCanceld_from("user");

        int updateOrderCnt = userMapper.updateOrderStatus(userOrderRequest);
        int updateAmountCnt = userMapper.restoreProductAmount(userOrderRequest);

        // 하나라도 오류가 발생할 경우, 롤백을 위해 exception throws
        if (updateOrderCnt != 1 || updateAmountCnt != 1) {
            throw new IllegalStateException("주문 취소 처리 중 오류 발생");
        }
        return true;
    }
    
	/** 유저 정보 한 건 조회 */
	@Override
	public UserMypage getUserInfo(String userId) {
		UserMypage info = userMapper.selectUserInfo(userId);
		return (info != null ? info : new UserMypage());
	}

	/** 리뷰 리스트 여러 건 조회 */
	@Override
	public List<Review> getUserReviews(String userId) {
		return userMapper.selectUserReviews(userId);
	}

	/** 마이페이지 전체 조립 (유저정보+리뷰리스트) */
	@Override
	public UserMypage getMypage(String userId) {
		UserMypage page = getUserInfo(userId);
		page.setReviews(getUserReviews(userId));
		return page;
	}

	/** 제품 상세 보기 */
	@Override
	@Transactional(readOnly = true)
	public ProductDetail getProductDetail(int product_no) {
		// 기본 상품·매장·계정 정보
		ProductDetail detail = userMapper.selectProductInfo(product_no);
		// 이미지 리스트
		detail.setImages(userMapper.selectProductImages(product_no));
		// 리뷰 리스트
		detail.setReviews(userMapper.selectProductReviews(product_no));
		detail.setReviewCount(detail.getReviews().size());
		return detail;
	}
	
	@Override
	public boolean isBookmarked(String user_id, String store_id) {
	    return userMapper.isBookmarked(user_id, store_id) > 0;
	}
	
	@Override
    @Transactional(readOnly = true)
    public List<String> getProductImages(int product_no) {
        return userMapper.selectProductImages(product_no);
    }
	
	@Override
    @Transactional(readOnly = true)
    public List<Review> getReviewsByProductNo(int productNo) {
        return userMapper.selectProductReviews(productNo);
    }
	

    @Override
    @Transactional
    public boolean reserveProduct(String userId, int product_no) {
        // 간단 insert 결과로 성공 여부 판단
        return userMapper.insertReservation(userId, product_no) > 0;
    }

	/** 사용자 회원가입 */
	/** 아이디 중복 체크 */
	@Override
	public boolean isDuplicateId(String user_id) {
		return userMapper.countByUserId(user_id) > 0;
	}

	@Override
	public void registerUser(Account account) {
	    // 비밀번호 MD5 해시
	    String rawPwd = account.getUser_pwd();
	    if (rawPwd != null && !rawPwd.isEmpty()) {
	        account.setUser_pwd(md5(rawPwd));
	    }

	    // 가입일, 상태 기본값 세팅
	    account.setJoin_date(new Timestamp(System.currentTimeMillis()));
	    account.setUser_status("ACTIVE");

	    // *디버그: 최종 저장될 Account 객체 내용 확인
	    System.out.println("최종 저장 정보: " + account);

	    // DB 저장 (한 번만)
	    int cnt = userMapper.insertUser(account);
	    System.out.println("insertUser 반환값: " + cnt);
	    if (cnt != 1) {
	        throw new RuntimeException("회원가입 실패 (insertUser 반환값=" + cnt + ")");
	    }
	}

	/** MD5 해시 유틸 */
	private String md5(String input) {
		try {
			MessageDigest md = MessageDigest.getInstance("MD5");
			byte[] digest = md.digest(input.getBytes());
			StringBuilder sb = new StringBuilder();
			for (byte b : digest) {
				sb.append(String.format("%02x", b));
			}
			return sb.toString();
		} catch (Exception e) {
			throw new RuntimeException("MD5 암호화 오류", e);
		}
	}
	
	/**
	 * 메뉴바 review 탭
	 * */

	@Override
    public List<Review> getAllReviews(int page, int size) {
        int startIdx = (page - 1) * size;
        return userMapper.getAllReviews(startIdx, size);
    }

	
	/**
	 * 리뷰 이미지 AWS S3에 업로드하고, public URL을 반환
	 */
	// GET: orderNo로 DTO 채우기
    @Override
    @Transactional(readOnly = true)
    public ReviewForm getReviewForm(int orderNo) {
        return userMapper.selectReviewFormByOrderNo(orderNo);
    }

    // POST: 이미지 업로드 후 DB INSERT
    @Override
    @Transactional
    public void writeReview(ReviewForm form, String userId) {
        form.setUser_id(userId);

        // — 이미지 업로드 —
        MultipartFile imgFile = form.getImageFile();
        if (imgFile != null && !imgFile.isEmpty()) {
            String fileName = UUID.randomUUID() + "_" + imgFile.getOriginalFilename();
            ObjectMetadata meta = new ObjectMetadata();
            meta.setContentType(imgFile.getContentType());
            meta.setContentLength(imgFile.getSize());

         // InputStream은 try‐with‐resources 로 안전하게 열고 닫기
            try (InputStream is = imgFile.getInputStream()) {
                awsS3Config.amazonS3()
                    .putObject(new PutObjectRequest(
                        awsS3Config.getBucket(),
                        fileName,
                        is,
                        meta
                    ));
            } catch (IOException e) {
                throw new UncheckedIOException("리뷰 이미지 업로드 실패", e);
            }

            form.setReview_img(fileName);
        }
    	
    	

        // — 기타 기본값 세팅 —
//        form.setIs_blocked("N");
        // writed_at : INSERT 쿼리에서 NOW() 처리

        // — 최종 INSERT 호출 —
        userMapper.insertReview(form);
    }
    // AWS S3 인스턴스 반환
    	private AmazonS3 amazonS3() {
            return awsS3Config.amazonS3();
        }

    /* 가게 이미지 하나 가져오기 */
    @Override
    public String getStoreImg(String store_id) {
        return userMapper.selectStoreImg(store_id);
    }

    /* 포인트 조회 */
    @Override
    public int getUserPoint(String user_id) {
        return (Integer)userMapper.selectUserPoint(user_id) == null ? 0 : userMapper.selectUserPoint(user_id);
    }

}
