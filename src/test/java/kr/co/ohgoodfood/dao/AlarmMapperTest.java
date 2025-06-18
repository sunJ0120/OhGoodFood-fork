package kr.co.ohgoodfood.dao;

import kr.co.ohgoodfood.dto.Alarm;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.context.web.WebAppConfiguration;

import java.util.List;

/**
 * AlarmMapperTest.java
 * - AlarmMapper의 테스트 클래스
 * - AlarmMapper의 메서드들을 테스트한다.
 *
 * - 맞는 로직 검증의 경우, @@CorrectTest로 명명한다.
 * - 예외 로직 검증의 경우, @@ExceptionTest로 명명한다.
 */

@Slf4j
@ExtendWith(SpringExtension.class) //JUnit5 기반 test
@WebAppConfiguration
@ContextConfiguration(classes = {kr.co.ohgoodfood.config.MvcConfig.class}) //mvc config를 사용해서 test
public class AlarmMapperTest {

    //[Mapper] alarmMapper 주입
    @Autowired
    AlarmMapper alarmMapper;

    //[Mapper] testMapper 주입
    @Autowired
    TestMapper testMapper;

    @Test
    @DisplayName("✅ [Correct] selectAlarmListCorrect 테스트")
    public void selectAlarmListCorrectTest() throws Exception {
        //given
        String user_id = "u01";

        //when
        List<Alarm> alarmList = alarmMapper.selectAlarmList(user_id);

        //then
        log.info("alarmList 결과 반환 : {}", alarmList);
        Assertions.assertEquals(1, alarmList.size());
    }

    @Test
    @DisplayName("✅ [Correct] updateAlarmReadCorrect 테스트")
    public void updateAlarmReadCorrectTest() throws Exception {
        //given
        String user_id = "u01";

        //when
        alarmMapper.updateAlarmRead(user_id);
        List<Alarm> alarmList = alarmMapper.selectAlarmList(user_id);

        //then
        //전부 읽음 처리 되었는지 확인한다.
        log.info("alarmList 결과 반환 : {}", alarmList);
        for(Alarm alarm : alarmList){
            Assertions.assertEquals(alarm.getAlarm_read(), "Y");
        }
    }

    @Test
    @DisplayName("✅ [Correct] updateAlarmHiddenCorrect 테스트")
    public void updateAlarmHiddenCorrectTest() throws Exception {
        //given
        //임시로 사용할 알람 번호를 하나 지정한다.
        int alarm_no = 1;
        String user_id = "u01";

        //when
        //alarm_displayed : Y -> N
        alarmMapper.updateAlarmHidden(user_id, alarm_no);
        Alarm alarm = testMapper.selectOneAlarm(alarm_no);

        //then
        log.info("alarm 결과 반환 : {}", alarm);
        Assertions.assertEquals(alarm.getAlarm_displayed(), "N"); //알람이 숨김 처리 되었는지 확인
    }
}