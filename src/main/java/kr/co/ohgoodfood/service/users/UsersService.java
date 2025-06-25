package kr.co.ohgoodfood.service.users;

import kr.co.ohgoodfood.dto.*;
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
    //[Controller 로직] UsersController.userMain 연결 로직
    List<MainStore> getMainStoreList(UserMainFilter userMainFilter);

    //[Controller 로직] UsersController.userBookmark 연결 로직
    List<Bookmark> getBookmarkList(String user_id);

    //[판별 로직] 오늘 픽업, 내일 픽업, 마감 판별 연결 로직
    PickupStatus getPickupDateStatus(MainStore mainStore);

    //[판별 로직] 카테고리 List<String> 저장 로직
    List<String> getCategoryList(MainStore mainStore);

    //[Controller 로직] UsersController.userBookmarkDelete 연결 로직
    boolean deleteUserBookMark(BookmarkDelete bookmarkDelete);

    //[Controller 로직] UsersController.userOrders 연결 로직
    List<UserOrder> getUserOrderList(UserOrderFilter userOrderFilter);

    //[Controller 로직] UsersController.userMain 연결 로직
    /* 사용자 기본 정보 한 건 조회*/
    UserMypage getUserInfo(String userId);
    /* 리뷰 리스트 여러 건 조회 */
    List<Review> getUserReviews(String userId);
    /* 마이페이지 전체 조립 (유저정보+리뷰리스트) */
    UserMypage getMypage(String userId);
    
    //[Controller 로직] UsersController.   제품 상세 보기    
    /* 상품 상세 정보 조회 */
    ProductDetail getProductDetail(int productId);

    /* 예약 처리 메서드 (추후 개발) */
    boolean reserveProduct(String userId, int productId);
    
    /* 아이디 중복 체크 */
    boolean isDuplicateId(String user_id);
    
    /* 회원가입 처리 */
	  void registerUser(Account account);
	
	/* 모든 리뷰를 조회 */
    List<Review> getAllReviews(int page, int size);
    

}
