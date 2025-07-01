package kr.co.ohgoodfood.service.common;

import kr.co.ohgoodfood.dto.Account;
import kr.co.ohgoodfood.dto.Store;

public interface CommonService {

	// 유저 로그인 입력 정보 조회
	public Account loginAccount(String id, String pwd);
	
	// 가게 사장 로그인 입력 정보 조회 
	public Store loginStore(String id, String pwd);
}
