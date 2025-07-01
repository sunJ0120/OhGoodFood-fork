package kr.co.ohgoodfood.dao;

import kr.co.ohgoodfood.dto.*;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * UserMapper
 *
 * 사용자 관련 주요 CRUD 및 조회 기능을 정의하는 MyBatis Mapper 인터페이스
 * - 메인 화면 & 북마크 조회
 * - 주문 내역 조회 및 상태 변경
 * - 마이페이지 조회
 */
@Mapper
public interface UserMapper {
    /**
     * 사용자 메인 화면 영역에 표시할 가게 목록을 조회
     *
     * @param userMainFilter   필터 DTO
     * @return                 필터 적용된 MainStore 리스트
     */
    List<MainStore> selectAllStore(@Param("filter") UserMainFilter userMainFilter);

    /**
     * 사용자 지도 영역에 핀을 클릭했을때 가게 정보 조회
     *
     * @param userMainFilter   필터 DTO
     * @return                 필터 적용된 MainStore 요소
     */
    MainStore selectOneStoreByStoreId(@Param("filter") UserMainFilter userMainFilter);
    /**
     * 사용자 북마크 화면에서 표시할 가게 목록을 조회
     *
     * @param user_id          조회 대상 user_id
     * @return                 필터 적용된 MainStore 리스트
     */
    List<Bookmark> selectAllBookmark(String user_id);

    /**
     * 사용자의 특정 북마크를 삭제 처리
     *
     * @param user_id          조회 대상 user_id
     * @param store_id         user_id + store_id 조합으로 삭제
     * @return                 영향받은 행(row) 수
     */
    int deleteBookmark(@Param("user_id") String user_id,
                       @Param("store_id") String store_id);

    /**
     * 사용자 북마크 추가
     *
     * @param user_id          조회 대상 user_id
     * @param store_id         북마크에 추가할 store 정보
     * @return                 영향받은 행(row) 수
     */
    int insertBookmark(@Param("user_id") String user_id,
                       @Param("store_id") String store_id);

    /**
     * 사용자의 모든 주문내역을 출력
     *
     * @param userOrderFilter  필터 DTO
     * @return                 UserOrder 리스트
     */
    List<UserOrder> selectOrderList(@Param("filter") UserOrderFilter userOrderFilter);

    /**
     * 사용자가 주문 상태를 변경해야 할때 사용한다.
     *
     * @param userOrderRequest 필터 DTO
     */
    int updateOrderStatus(@Param("order_request") UserOrderRequest userOrderRequest);

    /**
     * 사용자 주문 취소시, Product의 amount를 복원하기 위함이다.
     *
     * @param userOrderRequest 필터 DTO
     */
    int restoreProductAmount(@Param("order_request") UserOrderRequest userOrderRequest);

    /**
    * 세션의 user_id 로 MyPage DTO 전체를 조회 
    * @param user_id  사용자 ID
    */
    
    /** 유저 정보만 조회 */
    UserMypage selectUserInfo(@Param("user_id") String userId);

    /** 리뷰 리스트만 조회 (기존 Review DTO 재사용) */
    List<Review> selectUserReviews(@Param("user_id") String userId);
    
    /**
     * 메인에서 제품 클릭 후 제품 상세 정보 및 리뷰 조회
     */
    /** 제품 상세 조회 (Account, Store, Product 조인) */
    ProductDetail selectProductInfo(@Param("product_no") int product_no);

    /** 제품 이미지 목록 조회 */
    List<String> selectProductImages(@Param("product_no") int product_no);

    /** 제품 리뷰 리스트 조회 */
    List<Review> selectProductReviews(@Param("product_no") int product_no);

    /** 사용자 예약 정보 insert */
    int insertReservation( @Param("user_id") String user_id, @Param("product_no") int product_no);
    
    /** 사용자 회원가입*/
	int insertUser(Account account);    
    /** 아이디 중복 체크 */
	int countByUserId(@Param("user_id") String user_id);


	/** 모든 리뷰 모아보기
     * startIdx부터 size만큼 모든 리뷰를 조인 결과로 가져옵니다.
     * @param startIdx  조회 시작 오프셋
     * @param size      한 번에 조회할 건 수
     */
    List<Review> getAllReviews(
        @Param("startIdx") int startIdx,
        @Param("size")     int size
    );
    
    /**
     * 리뷰 insert
     * 주문 번호 파라미터로 받아 리뷰 작성
     * @param orderNo
     * @return
     */
	ReviewForm selectReviewFormByOrderNo(int orderNo);
	
	/**
	 * 리뷰 update
	 * @param form
	 */
    void insertReview(ReviewForm form);

    /**
     * 가게 이미지 하나 가져오기
     * @param store_id
     * @return
     */
    String selectStoreImg(String store_id);
    
    /**
     * 북마크 여부
     * @param user_id
     * @param store_id
     * @return
     */
    int isBookmarked(@Param("user_id") String user_id, @Param("store_id") String store_id);

}
