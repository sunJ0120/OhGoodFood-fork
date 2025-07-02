package kr.co.ohgoodfood.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.co.ohgoodfood.dto.Account;
import kr.co.ohgoodfood.dto.KakaoUser;
import kr.co.ohgoodfood.dto.Store;

@Mapper
public interface CommonMapper {

	// 유저 로그인 검증 로직
	public Account loginAccount(@Param("id") String id, @Param("pwd") String pwd);

	// 가게 사장 로그인 검증 로직
	public Store loginStore(@Param("id") String id, @Param("pwd") String pwd);
	
	// kakao_12345 형식으로 객체 찾음
	public Account findById(String userId);
	
	// 카카오 회원가입 
	public void insertKakaoUser(KakaoUser user);

	// 카카오 로그인시 사용자 정보 업데이트
	public int updateInfo(@Param("id") String id, @Param("nickname") String nickname, @Param("email") String email);
}
