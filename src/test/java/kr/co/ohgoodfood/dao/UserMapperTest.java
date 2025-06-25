package kr.co.ohgoodfood.dao;

import kr.co.ohgoodfood.dto.*;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.context.web.WebAppConfiguration;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;

/**
 * UserMapper의 핵심 매퍼 메서드들을 검증하는 단위 테스트 클래스.
 */

@Slf4j
@ExtendWith(SpringExtension.class)
@WebAppConfiguration
@ContextConfiguration(classes = {kr.co.ohgoodfood.config.MvcConfig.class})
public class UserMapperTest {
    Orders orders = null;
    Bookmark bookmark = null;

    //[Mapper] userMapper 주입
    @Autowired
    private UserMapper userMapper;

    //[Mapper] testMapper 주입
    @Autowired
    private TestMapper testMapper;

    //[테스트 객체] 테스트용 Orders BeforeEach로 생성
    @BeforeEach
    public void createTestObject() throws Exception {
        //주문 정보 생성, 모든 정보들은 test에서 사용하는 것이므로 임의로 한다.
        orders = new Orders();

        orders.setOrdered_at(Timestamp.valueOf(LocalDateTime.now()));
        orders.setQuantity(2);
        orders.setOrder_status("reservation");

        orders.setPicked_at(Timestamp.valueOf(LocalDateTime.now()));
        orders.setUser_id("u02");
        orders.setStore_id("st01");

        testMapper.insertOrder(orders);

        //bookmark 정보 생성, 모든 정보들은 test에서 사용하는 것이므로 임의로 한다.
        bookmark = new Bookmark();
        bookmark.setUser_id("u02");
        bookmark.setStore_id("st01");

        testMapper.insertBookmark(bookmark);
    }

    //[테스트 객체] 테스트용 객체들 @AfterEach로 제거
    @AfterEach
    public void deleteTestObject() throws Exception{
        testMapper.deleteBookmark(bookmark);
        testMapper.deleteOrder(orders);
    }

    @Test
    @DisplayName("✅ [Correct] 전체 가게 목록 조회: 필터 없이 4건 확인")
    public void selectAllStoreCorrectTest() throws Exception {
        //given
        UserMainFilter userMainFilter = new UserMainFilter();

        //when
        List<MainStore> dtoList = userMapper.selectAllStore(userMainFilter);

        //then
        log.info("MainStore_dtoList : {}", dtoList);
        //현재 가게가 4개이므로, Mapper 실행 결과 가게가 4개여야 한다.
        Assertions.assertEquals(dtoList.size(),4);
    }

    @Test
    @DisplayName("✅ [Correct] 북마크 삭제 기능 검증")
    public void deleteBookmarkCorrectTest() throws Exception {
        //given

        //when
        log.info("삭제해야 할 북마크 객체 : {}", bookmark);
        userMapper.deleteBookmark(bookmark.getUser_id(), bookmark.getBookmark_no());

        //then
        Assertions.assertNull(testMapper.selectOneBookmark(bookmark.getBookmark_no()));
    }

//    @Test
//    @DisplayName("✅ [Correct] 주문 목록 조회: 전체 내역 확인")
//    public void selectOrderListCorrectTest() throws Exception {
//        //given
//        //임시로 사용할 유저 아이디를 가져온다.
//        String user_id = "u02";
//
//        //when
//        List<UserOrder> orderList = userMapper.selectOrderList(user_id);
//
//        //then
//        log.info("orderList 결과 반환 : {}", orderList);
//        Assertions.assertEquals(orderList.size(), 3);
//
//    }

//    @Test
//    @DisplayName("✅ [Correct] 주문 취소 처리 검증")
//    public void updateOrderCancledByUserCorrectTest() throws Exception {
//        //given
//
//        //when
//        userMapper.updateOrderCancledByUser("cancle", "user", orders.getOrder_no(), orders.getUser_id());
//
//        //then
//        // 주문 상태가 변경되었는지 확인하기 위해서 주문을 가져온다.
//        Orders testOrder = testMapper.selectOneOrder(orders.getOrder_no(), orders.getUser_id());
//        log.info("testOrder 값 확인 : {}", testOrder);
//
//        Assertions.assertEquals(testOrder.getOrder_status(),"cancle");
//        Assertions.assertEquals(testOrder.getCancled_from(), "user");
//    }

    @Test
    @DisplayName("✅ [Correct] 주문 확정 처리 검증")
    public void updateOrderConfirmedCorrectTest() throws Exception {
        //given
        String order_code = "123456";

        //when
        userMapper.updateOrderConfirmed("confirmed", order_code, orders.getOrder_no(), orders.getUser_id());

        //then
        Orders testOrder = testMapper.selectOneOrder(orders.getOrder_no(), orders.getUser_id());
        log.info("testOrder 값 확인 : {}", testOrder);

        Assertions.assertEquals(testOrder.getOrder_status(), "confirmed");
        Assertions.assertEquals(testOrder.getOrder_code(), order_code);
    }

    @Test
    @DisplayName("✅ [Correct] 주문 픽업 처리 검증")
    public void updateOrderPickupCorrectTest() throws Exception {
        //given
        //when
        userMapper.updateOrderPickup("picked", orders.getOrder_no(), orders.getUser_id());

        //then
        Orders testOrder = testMapper.selectOneOrder(orders.getOrder_no(), orders.getUser_id());
        log.info("testOrder 값 확인 : {}", testOrder);

        //픽업의 경우, 픽업 완료로 상태가 잘 들어가는지 확인한다.
        Assertions.assertEquals(testOrder.getOrder_status(), "picked");
    }

    @Test
    @DisplayName("✅ [Correct] 결제 전 주문 정보 조회 검증")
    public void selectUserOrderPayCorrectTest() throws Exception {
        //given
        int product_no = 2; //임시 product_no

        //when
        UserOrder payOrder = userMapper.selectUserOrderPay(product_no);

        //then
        log.info("payOrder log 찍어보기 : {}",payOrder);
        Assertions.assertEquals(product_no, payOrder.getProduct_no()); //가져온 product_no가 맞는지 검사한다.
    }

    @Test
    @DisplayName("✅ [Correct] 결제 가능 여부 조회 검증")
    public void selectUserOrderPayCheckCorrectTest() throws Exception {
        //given
        int product_no = 2; //임시 product_no

        //when
        OrderPayCheck orderPayCheck = userMapper.selectUserOrderPayCheck(product_no);

        //then
        log.info("orderPayCheck 찍어보기 : {}", orderPayCheck);
        Assertions.assertEquals(orderPayCheck.getAmount(), 3); //저장되어 있는 그대로의 amount가 있는지 검사
        Assertions.assertEquals(orderPayCheck.getStore_status(), "N");
    }

    @Test
    @DisplayName("✅ [Correct] 알람 목록 조회 검증")
    public void selectAlarmListCorrectTest() throws Exception {
        //given
        String user_id = "u01";

        //when
        List<Alarm> alarmList = userMapper.selectAlarmList(user_id);

        //then
        log.info("alarmList 결과 반환 : {}", alarmList);
        Assertions.assertEquals(4, alarmList.size());
    }

    @Test
    @DisplayName("✅ [Correct] 알람 읽음 처리 검증")
    public void updateAlarmReadCorrectTest() throws Exception {
        //given
        String user_id = "u01";

        //when
        userMapper.updateAlarmRead(user_id);
        List<Alarm> alarmList = userMapper.selectAlarmList(user_id);

        //then
        //전부 읽음 처리 되었는지 확인한다.
        log.info("alarmList 결과 반환 : {}", alarmList);
        for(Alarm alarm : alarmList){
            Assertions.assertEquals(alarm.getAlarm_read(), "Y");
        }
    }

    @Test
    @DisplayName("✅ [Correct] 알람 숨김 처리 검증")
    public void updateAlarmHiddenCorrectTest() throws Exception {
        //given
        //임시로 사용할 알람 번호를 하나 지정한다.
        int alarm_no = 1;
        String user_id = "u01";

        //when
        //alarm_displayed : Y -> N
        userMapper.updateAlarmHidden(user_id, alarm_no);
        Alarm alarm = testMapper.selectOneAlarm(alarm_no);

        //then
        log.info("alarm 결과 반환 : {}", alarm);
        Assertions.assertEquals(alarm.getAlarm_displayed(), "N"); //알람이 숨김 처리 되었는지 확인
    }
}