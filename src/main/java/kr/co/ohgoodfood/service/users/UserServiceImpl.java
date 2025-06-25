package kr.co.ohgoodfood.service.users;

import java.security.MessageDigest;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.ohgoodfood.dao.UserMapper;
import kr.co.ohgoodfood.dto.Account;
import kr.co.ohgoodfood.dto.MainStore;
import kr.co.ohgoodfood.dto.ProductDetail;
import kr.co.ohgoodfood.dto.Review;
import kr.co.ohgoodfood.dto.UserMainFilter;
import kr.co.ohgoodfood.dto.UserMypage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * UsersServiceImpl.java - UsersService interface 구현체
 * 
 * @see UsersService - 세부 기능은 해당 클래스인 UsersServiceImpl에 구현한다. - 의존성 주입은 생성자 주입으로
 *      구현
 */

@Slf4j
@RequiredArgsConstructor
@Service
public class UserServiceImpl implements UsersService {
	private final UserMapper userMapper;

	@Override
	public List<MainStore> getMainStoreList(String user_id, UserMainFilter userMainFilter) {
		List<MainStore> mainStoreList = userMapper.selectAllStore(user_id, userMainFilter);

		// 여기에 카테고리 이름과 pickup 상태를 저장
		for (MainStore mainStore : mainStoreList) {
//            mainStore.setPickup_date(getPickupDateStatus(mainStore));
			mainStore.setCategory_name(getCategoryName(mainStore));
			mainStore.setAmount_time_tag(getAmountOrEndTime(mainStore));
		}
		log.info("[log/UserServiceImpl.getMainStoreList] mainStoreList 결과 log : {}", mainStoreList);

		return mainStoreList;
	}

	/**
	 * LocalDate.now()로 오늘픽업, 내일픽업, 매진, 마감을 판별합니다.
	 *
	 * @param mainStore 판별 데이터가 담긴 객체
	 * @return "오늘픽업", "내일픽업", "매진", "마감" 중 하나
	 * @see #getAmountOrEndTime(MainStore)
	 */
    @Override
    public String getPickupDateStatus(MainStore mainStore) {

        LocalDate today = LocalDate.now();

        //store_status = false, 수량 0이면 매진
        if(mainStore.getAmount() <= 0 && mainStore.getStore_status().equals("N")){
            return "매진";
        }
        
        if(mainStore.getStore_status().equals("N")){ //status가 false이면 현재 마감
            return "마감";
        }

        if (mainStore.getPickup_start().toLocalDateTime().toLocalDate().isEqual(today)) {
            return "오늘픽업";
        } else if (mainStore.getPickup_start().toLocalDateTime().toLocalDate().isEqual(today.plusDays(1))) {
            return "내일픽업";
        } else if (mainStore.getPickup_start().toLocalDateTime().toLocalDate().isBefore(today)) {
            return "마감";
        } else {
            return "error"; // 예외 상황 처리가 필요하다.
        }
    }

	/**
	 * 내부적으로 {@link StringBuilder}를 사용하여 문자열을 누적하고, 마지막에 남은 구분자("| ")를 제거하여 반환한다.
	 *
	 * @param mainStore
	 * @return '|' 구분자로 결합된 카테고리 이름 (예: "빵 & 디저트 | 과일")
	 */

	@Override
	public String getCategoryName(MainStore mainStore) {
		StringBuilder categoryName = new StringBuilder();

		if (mainStore.getCategory_bakery().equals("Y")) {
			categoryName.append("빵 & 디저트 | ");
		}

		if (mainStore.getCategory_fruit().equals("Y")) {
			categoryName.append("과일 | ");
		}

		if (mainStore.getCategory_salad().equals("Y")) {
			categoryName.append("샐러드 | ");
		}

		if (mainStore.getCategory_others().equals("Y")) {
			categoryName.append("그 외 | ");
		}
		// 끝에 3개 제외
		categoryName.setLength(categoryName.length() - 3);

		return categoryName.toString();
	}

	/**
	 * - store_status.equals("N")일 경우 : closed_at을 return - amount > 5 일 경우, +5로
	 * 처리한다. - amount < 5 일 경우, amount를 그대로 내보낸다.
	 *
	 * @param mainStore
	 * @return 표시할 마감 시간 또는 수량 문자열
	 */

	@Override
	public String getAmountOrEndTime(MainStore mainStore) {
		StringBuilder amount_time_tag = new StringBuilder();

		// 매진이나 마감 상태
		if (mainStore.getStore_status().equals("N")) {
			SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
			amount_time_tag.append(sdf.format(mainStore.getClosed_at()));
			return amount_time_tag.toString();
		}

		if (mainStore.getAmount() > 5) { // 5개 초과일 경우, +5로 설정
			amount_time_tag.append("+");
			amount_time_tag.append(mainStore.getAmount());
			amount_time_tag.append(" 개"); // 갯수 붙였는데..일단 보기
		} else {
			amount_time_tag.append(mainStore.getAmount());
			amount_time_tag.append(" 개");
		}

		return amount_time_tag.toString();
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

}
