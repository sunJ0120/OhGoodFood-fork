package kr.co.ohgoodfood.service.users;

import java.security.MessageDigest;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.ohgoodfood.dao.UserMapper;
import kr.co.ohgoodfood.dto.*;
import kr.co.ohgoodfood.util.StringSplitUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.sql.Time;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import kr.co.ohgoodfood.dto.Account;
import kr.co.ohgoodfood.dto.MainStore;
import kr.co.ohgoodfood.dto.ProductDetail;
import kr.co.ohgoodfood.dto.Review;
import kr.co.ohgoodfood.dto.UserMainFilter;
import kr.co.ohgoodfood.dto.UserMypage;
import lombok.RequiredArgsConstructor;

/**
 * UsersServiceImpl.java - UsersService interface 구현체
 * 
 * @see UsersService - 세부 기능은 해당 클래스인 UsersServiceImpl에 구현한다. - 의존성 주입은 생성자 주입으로
 */

@Slf4j
@RequiredArgsConstructor
@Service
public class UserServiceImpl implements UsersService{
    private final UserMapper userMapper;

    /**
     * 메인 화면에 뿌릴 DTO리스트를 가져오는 method
     *
     * @param userMainFilter : 필터링을 위한 객체가 담겨있다. (필터링 대상 : Category, 가게 상세, 가게 이름)
     * @return               : mainStoreList (MainStore DTO의 리스트 객체)
     */
    @Override
    public List<MainStore> getMainStoreList(UserMainFilter userMainFilter) {
        List<MainStore> mainStoreList = userMapper.selectAllStore(userMainFilter);

        // 여기에 카테고리 이름과 pickup 상태를 저장
        for(MainStore mainStore : mainStoreList){
            mainStore.setPickup_status(getPickupDateStatus(mainStore));
            mainStore.setCategory_list(getCategoryList(mainStore));
            mainStore.setMainmenu_list(StringSplitUtils.splitMenu(mainStore.getStore_menu(), "/"));
        }
        log.info("[log/UserServiceImpl.getMainStoreList] mainStoreList 결과 log : {}", mainStoreList);

        return mainStoreList;
    }

    /**
     * 사용자가 가진 북마크 리스트를 가져오는 method
     *
     * @param user_id           : 현재 세션에 접속한 사용자 id
     * @return                  : mainStoreList (MainStore DTO의 리스트 객체)
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
        log.info("[log/UserServiceImpl.getBookmarkList] mainStoreList 결과 log : {}", bookmarkList);

        return bookmarkList;
    }

    /**
     * LocalDate.now()로 오늘픽업, 내일픽업, 매진, 마감을 판별합니다.
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
            // NullPointerException이 걸려서 우선 추가
            if (mainStore.getPickup_start() == null) {
                return PickupStatus.CLOSED;
            }
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
     * |(구분자) 구분은 확장성을 위해 프론트 단에 위임
     * 서버에서는 리스트에 담아서 보내도록 한다.
     *
     * @param bookmarkDelete     : Bookmark 삭제시 필요한 정보값이 담긴 DTO
     * @return                   : 결과 행 수에 따라 Boolean
     */
    @Override
    public boolean deleteUserBookMark(BookmarkDelete bookmarkDelete) {
        String user_id = bookmarkDelete.getUser_id();
        int bookmark_no = bookmarkDelete.getBookmark_no();

        int cnt = userMapper.deleteBookmark(user_id, bookmark_no);

        if (cnt == 1) {
            return true;
        }
        return false; //delete 실패!
    }

    /**
     * 사용자의 OrderList를 가져오는 method
     *
     * @param userOrderFilter    : 세션에 접속한 사용자 id와 필터링을 위한 객체가 담겨있다. (필터링 대상 : order_status)
     * @return                   : 조회한 UserOrderList
     */
    @Override
    public List<UserOrder> getUserOrderList(UserOrderFilter userOrderFilter){
        List<UserOrder> orderList = userMapper.selectOrderList(userOrderFilter);

        // userOrder에 pickup_status를 저장.
        for(UserOrder userOrder : orderList){
            userOrder.setPickup_status(getPickupDateStatus(userOrder));
        }

        return orderList;
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

}
