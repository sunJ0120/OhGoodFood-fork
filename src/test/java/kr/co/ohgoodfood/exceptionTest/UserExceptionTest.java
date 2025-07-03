//package kr.co.ohgoodfood.exceptionTest;
//
//import kr.co.ohgoodfood.dao.UserMapper;
//import kr.co.ohgoodfood.dto.Bookmark;
//import kr.co.ohgoodfood.dto.Orders;
//import lombok.extern.slf4j.Slf4j;
//import org.apache.ibatis.binding.BindingException;
//import org.junit.jupiter.api.*;
//import org.junit.jupiter.api.extension.ExtendWith;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.test.context.ContextConfiguration;
//import org.springframework.test.context.junit.jupiter.SpringExtension;
//import org.springframework.test.context.web.WebAppConfiguration;
//
//import java.sql.Timestamp;
//import java.time.LocalDateTime;
//
//import static org.junit.jupiter.api.Assertions.assertThrows;
//
///**
// * UserExceptionTest.java
// * - 로직 검증의 경우, @@ExceptionTest로 명명한다.
// */
//
//@Slf4j
//@ExtendWith(SpringExtension.class)
//@WebAppConfiguration
//@ContextConfiguration(classes = {kr.co.ohgoodfood.config.MvcConfig.class})
//public class UserExceptionTest {
//    Orders orders = null;
//    Bookmark bookmark = null;
//
//    //[Mapper] userMapper 주입
//    @Autowired
//    private UserMapper userMapper;
//
//    //[Mapper] testMapper 주입
//    @Autowired
//    private TestMapper testMapper;
//
//    //[테스트 객체] 테스트용 Orders BeforeEach로 생성
//    @BeforeEach
//    public void createTestOrders() throws Exception {
//        //주문 정보 생성, 모든 정보들은 test에서 사용하는 것이므로 임의로 한다.
//        orders = new Orders();
//
//        orders.setOrdered_at(Timestamp.valueOf(LocalDateTime.now()));
//        orders.setQuantity(2);
//        orders.setOrder_status("reservation");
//
//        orders.setPicked_at(Timestamp.valueOf(LocalDateTime.now()));
//        orders.setUser_id("u02");
//        orders.setStore_id("st01");
//
//        testMapper.insertOrder(orders);
//    }
//
//    //[테스트 객체] 테스트용 Bookamark BeforeEach로 생성
//    @BeforeEach
//    public void createTestBookMark() throws Exception {
//        //bookmark 정보 생성, 모든 정보들은 test에서 사용하는 것이므로 임의로 한다.
//        bookmark = new Bookmark();
//        bookmark.setUser_id("u02");
//        bookmark.setStore_id("st01");
//
//        testMapper.insertBookmark(bookmark);
//    }
//
//    //화면에서 직접 발생하는 예외는 아니지만, db상에 이상이 없는지 확인하기 위해 필요하다.
//    @Test
//    @DisplayName("🔃 [Exception] deleteBookmark - 유저가 소유하지 않은 북마크 삭제 시 영향 없음")
//    void deleteBookmark_NullUserId_ThrowsException() {
//        //given
//        //여기서 db상에 존재하지 않는 조합을 넣는다.
//        String user_id = "mock_user";
//        Bookmark bookmark = testMapper.selectOneBookmark(49);
//
//        //when
//        int deleteRow = userMapper.deleteBookmark(user_id, bookmark.getBookmark_no());
//
//        //then
//        //존재하지 않는 조합은 삭제되지 말아야 한다.
//        Assertions.assertEquals(0, deleteRow);
//    }
//
//    //  Mapper가 아닌, 서비스 단에서 검증이 필요하다.
//    @Test
//    @DisplayName("🔃 selectOrderList - user_id가 null일 때 BindingException 발생")
//    void selectOrderList_NullUserId_ThrowsBindingException() {
//        assertThrows(BindingException.class, () -> {
//            userMapper.selectOrderList(null);
//        });
//    }
//}