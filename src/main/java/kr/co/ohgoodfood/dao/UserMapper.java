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
 */
@Mapper
public interface UserMapper {
    /**
     * 사용자 메인 화면 및 북마크 영역에 표시할 가게 목록을 조회
     *
     * @param user_id          조회 대상 user_id
     * @param userMainFilter   필터 DTO
     * @return                 필터 적용된 MainStore 리스트w
     */
    List<MainStore> selectAllStore(@Param("user_id") String user_id,
                                   @Param("filter") UserMainFilter userMainFilter);

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
     * @param user_id  user_id
     * @return         UserOrder 리스트
     */
    List<UserOrder> selectOrderList(String user_id);

    /**
     * [📌 동적쿼리로 수정후 제거 예정.] 사용자의 필터링된 주문내역을 출력
     *
     * @param user_id       user_id
     * @param order_status  주문 상태
     * @return              필터된 UserOrder 리스트
     */
    List<UserOrder> selectOrderListWithFilter(@Param("user_id") String user_id,
                                    @Param("order_status") String order_status);

    /**
     * 사용자가 주문을 취소할 때 호출
     *
     * @param order_status  변경할 주문 상태
     * @param cancled_from  취소한 사람
     * @param order_no      주문번호
     * @param user_id       user_id
     */
    void updateOrderCancledByUser(@Param("order_status") String order_status,
                                  @Param("cancled_from") String cancled_from,
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
}
