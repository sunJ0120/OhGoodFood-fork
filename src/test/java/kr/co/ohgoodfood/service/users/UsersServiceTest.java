package kr.co.ohgoodfood.service.users;

//import kr.co.ohgoodfood.dao.TestMapper;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.context.web.WebAppConfiguration;

/**
 * UserService의 핵심 로직 메서드들을 검증하는 단위 테스트 클래스.
 */

@Slf4j
@ExtendWith(SpringExtension.class) //JUnit5 기반 test
@WebAppConfiguration
@ContextConfiguration(classes = {kr.co.ohgoodfood.config.MvcConfig.class}) //mvc config를 사용해서 test
class UsersServiceTest {

//    MainStore testMainStore;
//
//    @Autowired
//    UsersService usersService;
//
//    @Autowired
//    TestMapper testMapper;
//
//    //[테스트 객체] 테스트용 MainStore BeforeEach로 생성
//    @BeforeEach
//    public void createTestObject() throws Exception {
//        //MaiStore를 가져오기 위한 하드코딩 정보
//        String user_id = "u02";
//        String store_id = "st01";
//
//        testMainStore = testMapper.selectOneStore(user_id, store_id);
//    }
//
//    @Test
//    @DisplayName("✅ [Correct] getPickupDateStatus 테스트 : 가게 매진일 경우")
//    public void testStoreSoldOut() throws Exception {
//        //given - test용으로 데이터를 약간씩 수정
//        LocalDateTime pickupStart = LocalDate.now().plusDays(1).atStartOfDay(); //자정으로 지정해둠
//        testMainStore.setPickup_start(pickupStart);
//        testMainStore.setStore_status("N");
//        testMainStore.setAmount(0);
//
//        //when
//        String result = usersService.getPickupDateStatus(testMainStore);
//
//        //then
//        Assertions.assertEquals(result, "매진");
//    }
//
//    @Test
//    @DisplayName("✅ [Correct] getPickupDateStatus 테스트 : 가게 마감일 경우")
//    public void testStoreClose() throws Exception {
//        //given
//        LocalDateTime pickupStart = LocalDate.now().plusDays(1).atStartOfDay(); //자정으로 지정해둠
//        testMainStore.setPickup_start(pickupStart);
//        testMainStore.setStore_status("N");
//        testMainStore.setAmount(3);
//
//        //when
//        String result = usersService.getPickupDateStatus(testMainStore);
//
//        //then
//        Assertions.assertEquals(result, "마감");
//    }
//
//    @Test
//    @DisplayName("✅ [Correct] getPickupDateStatus 테스트 : 오늘픽업일 경우")
//    public void testPickupToday() throws Exception {
//        //given
//        LocalDateTime pickupStart = LocalDate.now().atStartOfDay(); //자정으로 지정해둠
//        testMainStore.setPickup_start(pickupStart);
//        testMainStore.setStore_status("Y");
//        testMainStore.setAmount(5);
//
//        //when
//        String result = usersService.getPickupDateStatus(testMainStore);
//
//        //then
//        Assertions.assertEquals(result, "오늘픽업");
//    }
//
//    @Test
//    @DisplayName("✅ [Correct] getPickupDateStatus 테스트 : 내일픽업일 경우")
//    public void testPickupTomorrow() throws Exception {
//        //given
//        LocalDateTime pickupStart = LocalDate.now().plusDays(1).atStartOfDay(); //자정으로 지정해둠
//        testMainStore.setPickup_start(pickupStart);
//        testMainStore.setStore_status("Y");
//        testMainStore.setAmount(3);
//
//        //when
//        String result = usersService.getPickupDateStatus(testMainStore);
//
//        //then
//        Assertions.assertEquals(result, "내일픽업");
//    }
}