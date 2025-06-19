package kr.co.ohgoodfood.dao;

import org.apache.ibatis.annotations.Param;

import kr.co.ohgoodfood.dto.Mypage;

public interface MypageMapper {
	
	  /** 세션의 user_id 로 MyPage DTO 전체를 조회 */
    Mypage selectMypage(@Param("user_id") String user_id);
}