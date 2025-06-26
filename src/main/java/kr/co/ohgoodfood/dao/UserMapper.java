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
 * - 결제 전 처리
 * - 알림 조회 및 상태 변경
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
     * @param bookmark_no      삭제할 북마크 고유번호
     * @return                 영향받은 행(row) 수
     */
    int deleteBookmark(@Param("user_id") String user_id,
                        @Param("bookmark_no") int bookmark_no);

    /**
     * 사용자의 모든 주문내역을 출력
     *
     * @param userOrderFilter  필터 DTO
     * @return         UserOrder 리스트
     */
    List<UserOrder> selectOrderList(@Param("filter") UserOrderFilter userOrderFilter);

    /**
     * 사용자가 주문을 취소할 때 호출
     *
     * @param order_status  변경할 주문 상태
     * @param canceld_from  취소한 사람
     * @param order_no      주문번호
     * @param user_id       user_id
     */
    void updateOrderCanceldByUser(@Param("order_status") String order_status,
                                  @Param("canceld_from") String canceld_from,
                                  @Param("order_no") int order_no,
                                  @Param("user_id") String user_id);

    /**
     * 주문이 확정된 이후 상태 변경 및 픽업 코드를 설정
     *
     * @param order_status  변경할 주문 상태
     * @param order_code    픽업 코드
     * @param order_no      주문번호
     * @param user_id       user_id
     */
    void updateOrderConfirmed(@Param("order_status") String order_status,
                              @Param("order_code") String order_code,
                              @Param("order_no") int order_no,
                              @Param("user_id") String user_id);

    /**
     * 픽업 완료 후 주문 상태를 업데이트
     *
     * @param order_status  변경할 주문 상태
     * @param order_no      주문번호
     * @param user_id       user_id
     */
    void updateOrderPickup(@Param("order_status") String order_status,
                           @Param("order_no") int order_no,
                           @Param("user_id") String user_id);

    /**
     * 결제 진행을 위해 특정 상품의 주문 정보를 조회
     *
     * @param product_no  조회할 상품 번호
     * @return           UserOrder DTO
     */
    UserOrder selectUserOrderPay(int product_no);

    /**
     * 결제 전 상품 수량과 가게 오픈 상태를 확인
     *
     * @param product_no  조회할 상품 번호
     * @return           OrderPayCheck
     */
    OrderPayCheck selectUserOrderPayCheck(int product_no);

    /**
     * 사용자별 전체 알림 목록을 조회
     *
     * @param user_id  user_id
     * @return         Alarm 리스트
     */
    List<Alarm> selectAlarmList(String user_id);

    /**
     * 사용자의 모든 알림을 읽음 처리
     *
     * @param user_id user_id
     */
    void updateAlarmRead(String user_id);

    /**
     * X가 눌린 or 기한이 지난 알림을 숨김 처리
     *
     * @param user_id  사용자 ID
     * @param alarm_no 숨김 처리할 알림 번호
     */
    void updateAlarmHidden(@Param("user_id") String user_id,
                           @Param("alarm_no") int alarm_no);

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
}
