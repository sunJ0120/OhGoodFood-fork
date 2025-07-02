package kr.co.ohgoodfood.service.users;

import kr.co.ohgoodfood.dto.*;

import java.sql.Timestamp;
import java.util.List;

import kr.co.ohgoodfood.dto.Account;
import kr.co.ohgoodfood.dto.MainStore;
import kr.co.ohgoodfood.dto.ProductDetail;
import kr.co.ohgoodfood.dto.Review;
import kr.co.ohgoodfood.dto.UserMainFilter;
import kr.co.ohgoodfood.dto.UserMypage;

/**
 * UsersService interface
 * - UsersService 기능 틀 interface
 * - 유지 보수 및 확장 편의성을 위해 interface로 구성한다.
 */
public interface UsersService {
    //[Controller 로직] 메인화면 Controller 연결 로직
    List<MainStore> getMainStoreList(UserMainFilter userMainFilter);

    //[Controller 로직] Map에서 클릭한 pin 정보 Controller 연결 로직
    MainStore getMainStoreOne(UserMainFilter userMainFilter);

    //[Controller 로직] 북마크 Controller 연결 로직
    List<Bookmark> getBookmarkList(String user_id);

    //[판별 로직] 오늘 픽업, 내일 픽업, 마감 판별 연결 로직
    PickupStatus getPickupDateStatus(MainStore mainStore);

    //[판별 로직] UserOrder에서는 마감과 매진은 필요 없으므로, 오늘 픽업, 내일 픽업만 판별하는 로직
    PickupStatus getOrderPickupDateStatus(UserOrder userOrder);

    //[판별 로직] 카테고리 List<String> 저장 로직
    List<String> getCategoryList(MainStore mainStore);

    //[Controller 로직] 북마크 삭제 Controller 연결 로직
    boolean deleteUserBookMark(BookmarkFilter bookmarkFilter);

    //[Controller 로직] 북마크 추가 Controller 연결 로직
    boolean insertUserBookMark(BookmarkFilter bookmarkFilter);

    //[Controller 로직] 주문내역 Controller 연결 로직
    List<UserOrder> getUserOrderList(UserOrderFilter userOrderFilter);
    
    //[판별 로직] 구매 금액별 point를 계산하기 위한 메서드
    int getOrderPoint(UserOrder userOrder);
    
    //[판별 로직] reservation_end 한 시간 전에 주문취소를 막아두기 위한 상태 판별 로직
    boolean getOrderBlockCancel(PickupStatus pickup_status, Timestamp reservation_end);

    //[Controller 로직] 주문내역 취소 Controller 연결 로직
    boolean updateUserOrderCancel(UserOrderRequest userOrderRequest);

    /* 사용자 기본 정보 한 건 조회*/
    UserMypage getUserInfo(String userId);
    
    /* 리뷰 리스트 여러 건 조회 */
    List<Review> getUserReviews(String userId);
    
    /* 마이페이지 전체 조립 (유저정보+리뷰리스트) */
    UserMypage getMypage(String userId);
    
    //[Controller 로직]     
    /* 상품 상세 정보 조회 */
    ProductDetail getProductDetail(int productId);
    
    /* 상품(가게)별 리뷰 조회 */
	List<Review> getReviewsByProductNo(int productNo);
	
	/* 상품(가게)별 사진 조회*/
	List<String> getProductImages(int product_no);
	
	/* 북마크 조회 */
	boolean isBookmarked(String user_id, String store_id);
	
    /* 예약 처리 메서드 (추후 개발) */
    boolean reserveProduct(String userId, int productId);
    
    /* 아이디 중복 체크 */
    boolean isDuplicateId(String user_id);
    
    /* 회원가입 처리 */
	  void registerUser(Account account);
	
	/* 모든 리뷰를 조회 */
    List<Review> getAllReviews(int page, int size);
    
    /* 리뷰 업데이트 */
    // 화면에 뿌릴 주문·상품·가게 정보 조회
    ReviewForm getReviewForm(int orderNo);

    // 실제 리뷰 저장 (이미지 포함)
    void writeReview(ReviewForm form, String userId);

    /* 가게 이미지 하나 가져오기 */
    String getStoreImg(String store_id);

    /* 포인트 조회 */
    int getUserPoint(String user_id);

}
