package kr.co.ohgoodfood.dao;

import kr.co.ohgoodfood.dto.*;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * User가 사용하는 Mapper Interface
 */

@Mapper
public interface UserMapper {
    //[user] user main 화면 & 북마크에서 보이는 가게 리스트
    List<MainStore> selectAllStore(String user_id);

    //[user] user 북마크 삭제
    int deleteBookmark(@Param("user_id") String user_id,
                        @Param("bookmark_no") int bookmark_no);

    //[user] user 주문 내역 출력 (all, no filter)
    List<UserOrder> selectOrderList(String user_id);

    //[user] user 주문 내역 출력 (filter 적용)
    List<UserOrder> selectOrderListWithFilter(@Param("user_id") String user_id,
                                    @Param("order_status") String order_status);

    //[user] user 주문 취소
    void updateOrderCancledByUser(@Param("order_status") String order_status,
                                  @Param("cancled_from") String cancled_from,
                                  @Param("order_no") int order_no,
                                  @Param("user_id") String user_id);

    //[user] user 확정 이후 상태 변경 및 픽업 코드 설정
    void updateOrderConfirmed(@Param("order_status") String order_status,
                              @Param("order_code") String order_code,
                              @Param("order_no") int order_no,
                              @Param("user_id") String user_id);

    //[user] user 픽업 완료 후 상태 변경
    void updateOrderPickup(@Param("order_status") String order_status,
                           @Param("order_no") int order_no,
                           @Param("user_id") String user_id);

    //[user] user 결제 진행 화면 출력
    UserOrder selectUserOrderPay(int product_no);

    //[user] user 결제 전 제품 수량과 가게 상태 체크
    OrderPayCheck selectUserOrderPayCheck(int product_no);

    //----------[test 필요] alarm 옮겼으므로, 추가 test가 필요하다.----------

    //[alarm] 사용자별 전체 알람 list를 가져오는 메서드
    List<Alarm> selectAlarmList(String userId);

    //[alarm] 사용자의 알람들을 읽음처리 하는 메서드
    void updateAlarmRead(String user_id);

    //[alarm] 사용자의 특정 알람을 (X 누를 경우) hidden 처리하는 메서드
    void updateAlarmHidden(@Param("user_id") String user_id,
                           @Param("alarm_no") int alarm_no);
}
