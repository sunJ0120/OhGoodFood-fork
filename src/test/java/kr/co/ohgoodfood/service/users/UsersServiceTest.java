package kr.co.ohgoodfood.service.users;

import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.context.web.WebAppConfiguration;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;

/**
 * UsersServiceTest.java
 * - getPickupDateStatus에 대한 test : 픽업 상태를 잘 받아오는지를 check한다.
 */

@Slf4j
@ExtendWith(SpringExtension.class) //JUnit5 기반 test
@WebAppConfiguration
@ContextConfiguration(classes = {kr.co.ohgoodfood.config.MvcConfig.class}) //mvc config를 사용해서 test
class UsersServiceTest {
    @Autowired
    UsersService usersService;

    @Test
    @DisplayName("✅ [Correct] getPickupDateStatus 테스트 : 가게 매진일 경우")
    public void testStoreSoldOut() throws Exception {
        //given
        Date pickupStart = Date.from(LocalDate.now().plusDays(1)
                .atStartOfDay(ZoneId.systemDefault()).toInstant());

        //when
        String result = usersService.getPickupDateStatus(pickupStart, "N", 0);

        //then
        Assertions.assertEquals(result, "매진");
    }

    @Test
    @DisplayName("✅ [Correct] getPickupDateStatus 테스트 : 가게 마감일 경우")
    public void testStoreClose() throws Exception {
        //given
        Date pickupStart = Date.from(LocalDate.now().plusDays(1)
                .atStartOfDay(ZoneId.systemDefault()).toInstant());

        //when
        String result = usersService.getPickupDateStatus(pickupStart, "N", 3);

        //then
        Assertions.assertEquals(result, "마감");
    }

    @Test
    @DisplayName("✅ [Correct] getPickupDateStatus 테스트 : 오늘픽업일 경우")
    public void testPickupToday() throws Exception {
        //given
        Date pickupStart = Date.from(LocalDate.now()
                .atStartOfDay(ZoneId.systemDefault()).toInstant());

        //when
        String result = usersService.getPickupDateStatus(pickupStart, "Y", 5);

        //then
        Assertions.assertEquals(result, "오늘픽업");
    }

    @Test
    @DisplayName("✅ [Correct] getPickupDateStatus 테스트 : 내일픽업일 경우")
    public void testPickupTomorrow() throws Exception {
        //given
        Date pickupStart = Date.from(LocalDate.now().plusDays(1)
                .atStartOfDay(ZoneId.systemDefault()).toInstant());

        //when
        String result = usersService.getPickupDateStatus(pickupStart, "Y", 3);

        //then
        Assertions.assertEquals(result, "내일픽업");
    }
}