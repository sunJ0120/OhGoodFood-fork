package kr.co.ohgoodfood.service.common;

import java.security.MessageDigest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.ohgoodfood.dao.CommonMapper;
import kr.co.ohgoodfood.dto.Account;
import kr.co.ohgoodfood.dto.Store;

@Service
public class CommonServiceImpl implements CommonService{
	
	@Autowired
	private CommonMapper commonMapper;
	
	@Override
	public Account loginAccount(String id, String pwd) {
		return commonMapper.loginAccount(id, md5(pwd));
	}
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
}
