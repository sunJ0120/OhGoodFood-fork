package kr.co.ohgoodfood.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.co.ohgoodfood.dto.Account;
import kr.co.ohgoodfood.dto.Alarm;
import kr.co.ohgoodfood.dto.Store;

@Mapper
public interface CommonMapper {
	// 사용자 로그인
	public Account loginAccount(@Param("id") String id, @Param("pwd") String pwd);
	// 가게 로그인
	public Store loginStore(@Param("id") String id, @Param("pwd") String pwd);
	// 알람 가져오기
	public List<Alarm> getAlarm(@Param("id") String id);
	// 알람 읽음 처리
	public int updateAlarm(@Param("id") String id);
	// 알람 디스플레이 숨김 처리
	public int hideAlarm(@Param("alarm_no") int alarm_no);
	// 안 읽은 알람 확인
	public int checkUnreadAlarm(@Param("id") String id);
}
