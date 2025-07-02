package kr.co.ohgoodfood.service.common;

import java.security.MessageDigest;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.ohgoodfood.dao.CommonMapper;
import kr.co.ohgoodfood.dto.Account;
import kr.co.ohgoodfood.dto.Alarm;
import kr.co.ohgoodfood.dto.Store;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CommonServiceImpl implements CommonService{
	
	private final CommonMapper commonMapper;
	
	// 사용자 로그인
	@Override
	public Account loginAccount(String id, String pwd) {
		return commonMapper.loginAccount(id, md5(pwd));
	}


	// 가게 사장 로그인
	@Override
	public Store loginStore(String id, String pwd) {
		return commonMapper.loginStore(id, md5(pwd));
	}

	// MD5 암호화 메서드 추가
	private String md5(String input) {
		try {
			MessageDigest md = MessageDigest.getInstance("MD5");
			byte[] messageDigest = md.digest(input.getBytes());
			StringBuilder sb = new StringBuilder();
			for (byte b : messageDigest) {
				sb.append(String.format("%02x", b));
			}
			return sb.toString();
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}

	// 알람 가져오기
	@Override
	public List<Alarm> getAlarm(String id) {
		return commonMapper.getAlarm(id);
	}

	// 알람 읽음 처리
	@Override
	public int updateAlarm(String id) {
		return commonMapper.updateAlarm(id);
	}

	// 알람 디스플레이 숨김 처리
	@Override
	public int hideAlarm(int alarm_no) {
		return commonMapper.hideAlarm(alarm_no);
	}

	// 안 읽은 알람 확인
	@Override
	public int checkUnreadAlarm(String id) {
		return commonMapper.checkUnreadAlarm(id);
	}
}
