package kr.co.ohgoodfood.service.users;

import org.springframework.stereotype.Service;

import kr.co.ohgoodfood.dao.MypageMapper;
import kr.co.ohgoodfood.dto.Mypage;


@Service
public class MypageService {
    private final MypageMapper mapper;

    public MypageService(MypageMapper mapper) {
        this.mapper = mapper;
    }

    /** 세션에서 받은 user_id로 Mypage DTO 전체 조회 */
    public Mypage getMypage(String userId) {
        return mapper.selectMypage(userId);
    }
}