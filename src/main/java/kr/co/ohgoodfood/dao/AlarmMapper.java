package kr.co.ohgoodfood.dao;

import kr.co.ohgoodfood.dto.Alarm;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * Alarm이 사용하는 Mapper Interface
 * 알람의 경우는, 사용자와 사장 둘 다 사용하므로 별도의 매퍼로 구성합니다.
 */
@Mapper
public interface AlarmMapper {
    //[alarm] 사용자별 전체 알람 list를 가져오는 메서드
    List<Alarm> selectAlarmList(String userId);

    //[alarm] 사용자의 알람들을 읽음처리 하는 메서드
    void updateAlarmRead(String user_id);

    //[alarm] 사용자의 특정 알람을 (X 누를 경우) hidden 처리하는 메서드
    void updateAlarmHidden(@Param("user_id") String user_id,
                           @Param("alarm_no") int alarm_no);
}
