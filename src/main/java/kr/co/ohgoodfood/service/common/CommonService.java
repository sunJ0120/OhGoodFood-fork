package kr.co.ohgoodfood.service.common;

import kr.co.ohgoodfood.dto.Account;
import kr.co.ohgoodfood.dto.KakaoUser;
import kr.co.ohgoodfood.dto.Store;

public interface CommonService {

	// 유저 로그인 입력 정보 조회
	public Account loginAccount(String id, String pwd);
	
	// 가게 사장 로그인 입력 정보 조회 
	public Store loginStore(String id, String pwd);

	// code로 access_token 받고 사용자 객체정보 가져옴
	KakaoUser getKakaoUserInfo(String code);

	// 사용자가 없으면 자동 회원가입, 있으면 해당 객체 정보 리턴
	Account autoLoginOrRegister(KakaoUser kakaoUser);

}
