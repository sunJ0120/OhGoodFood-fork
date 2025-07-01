package kr.co.ohgoodfood.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.co.ohgoodfood.dto.Account;
import kr.co.ohgoodfood.dto.Store;

@Mapper
public interface CommonMapper {

	// 유저 로그인 검증 로직
	public Account loginAccount(@Param("id") String id, @Param("pwd") String pwd);

	// 가게 사장 로그인 검증 로직
	public Store loginStore(@Param("id") String id, @Param("pwd") String pwd);
}
