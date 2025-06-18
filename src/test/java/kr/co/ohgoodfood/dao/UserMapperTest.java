package kr.co.ohgoodfood.dao;

import kr.co.ohgoodfood.dto.*;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.context.web.WebAppConfiguration;

import java.sql.Date;
import java.util.List;

/**
 * UserMapperTest.java
 * - UserMapper에 대한 테스트 클래스
 * - 예외 처리 제외 맞는 로직에 대한 테스트만 존재한다. 예외 처리 테스트는 /exceptionTest/ 안에 존재한다.
 * - UserMapper의 메서드들을 테스트한다.
 * - 테스트용으로 Orders, Bookmark 객체를 생성하여 사용한다.
 *
 * - 맞는 로직 검증의 경우, @@CorrectTest로 명명한다.
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
    public void createTestOrders() throws Exception {
        //주문 정보 생성, 모든 정보들은 test에서 사용하는 것이므로 임의로 한다.
        orders = new Orders();

        orders.setOrdered_at(new Date(System.currentTimeMillis()));
        orders.setQuantity(2);
        orders.setOrder_status("reservation");

        orders.setPicked_at(new Date(System.currentTimeMillis()));
        orders.setUser_id("u02");
        orders.setStore_id("st01");

        testMapper.insertOrder(orders);
    }

    //[테스트 객체] 테스트용 Bookamark BeforeEach로 생성
    @BeforeEach
    public void createTestBookMark() throws Exception {
        //bookmark 정보 생성, 모든 정보들은 test에서 사용하는 것이므로 임의로 한다.
        bookmark = new Bookmark();
        bookmark.setUser_id("u02");
        bookmark.setStore_id("st01");

        testMapper.insertBookmark(bookmark);
    }

    @Test
    @DisplayName("✅ [Correct] selectAllStoreCorrect 테스트")
    public void selectAllStoreCorrectTest() throws Exception {
        //given
        String user_id = "u02";

        //when
        List<MainStore> dtoList = userMapper.selectAllStore(user_id);

        //then
        log.info("MainStore_dtoList : {}", dtoList);
        //현재 가게가 3개이므로, Mapper 실행 결과 가게가 3개여야 한다.
        Assertions.assertEquals(dtoList.size(),3);
    }

    @Test
    @DisplayName("✅ [Correct] deleteBookmarkCorrect 테스트")
    public void deleteBookmarkCorrectTest() throws Exception {
        //given

        //when
        log.info("삭제해야 할 북마크 객체 : {}", bookmark);
        userMapper.deleteBookmark(bookmark.getUser_id(), bookmark.getBookmark_no());

        //then
        Assertions.assertNull(testMapper.selectOneBookmark(bookmark.getBookmark_no()));
    }

    @Test
    @DisplayName("✅ [Correct] selectOrderListCorrect 테스트")
    public void selectOrderListCorrectTest() throws Exception {
        //given
        //임시로 사용할 유저 아이디를 가져온다.
        String user_id = "u02";

        //when
        List<UserOrder> orderList = userMapper.selectOrderList(user_id);

        //then
        log.info("orderList 결과 반환 : {}", orderList);
        Assertions.assertEquals(orderList.size(), 3);

    }

    @Test
    @DisplayName("✅ [Correct] selectOrderListWithFilterCorrect 테스트")
    public void selectOrderListWithFilterCorrectTest() throws Exception {
        //given
        String user_id = "u02";
        String order_status = "pickup";

        //when
        List<UserOrder> orderList = userMapper.selectOrderListWithFilter(user_id, order_status);

        //then
        log.info("orderList 결과 반환 : {}", orderList);
        Assertions.assertEquals(orderList.size(), 2);
    }


    @Test
    @DisplayName("✅ [Correct] updateOrderCancledByUserCorrect 테스트")
    public void updateOrderCancledByUserCorrectTest() throws Exception {
        //given

        //when
        userMapper.updateOrderCancledByUser("cancle", "user", orders.getOrder_no(), orders.getUser_id());

        //then
        // 주문 상태가 변경되었는지 확인하기 위해서 주문을 가져온다.
        Orders testOrder = testMapper.selectOneOrder(orders.getOrder_no(), orders.getUser_id());
        log.info("testOrder 값 확인 : {}", testOrder);

        Assertions.assertEquals(testOrder.getOrder_status(),"cancle");
        Assertions.assertEquals(testOrder.getCancled_from(), "user");
    }

    @Test
    @DisplayName("✅ [Correct] updateOrderConfirmedCorrect 테스트")
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
    @DisplayName("✅ [Correct] updateOrderPickupCorrect 테스트")
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
    @DisplayName("✅ [Correct] selectUserOrderPayCorrect 테스트")
    public void selectUserOrderPayCorrect() throws Exception {
        //given
        int product_no = 2; //임시 product_no

        //when
        UserOrder payOrder = userMapper.selectUserOrderPay(product_no);

        //then
        log.info("payOrder log 찍어보기 : {}",payOrder);
        Assertions.assertEquals(product_no, payOrder.getProduct_no()); //가져온 product_no가 맞는지 검사한다.
    }

    @Test
    @DisplayName("✅ [Correct] selectUserOrderPayCheckCorrect 테스트")
    public void selectUserOrderPayCheckCorrect() throws Exception {
        //given
        int product_no = 2; //임시 product_no

        //when
        OrderPayCheck orderPayCheck = userMapper.selectUserOrderPayCheck(product_no);

        //then
        log.info("orderPayCheck 찍어보기 : {}", orderPayCheck);
        Assertions.assertEquals(orderPayCheck.getAmount(), 3); //저장되어 있는 그대로의 amount가 있는지 검사
        Assertions.assertEquals(orderPayCheck.getStore_status(), "Y");
    }
}