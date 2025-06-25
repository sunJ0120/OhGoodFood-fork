package kr.co.ohgoodfood.dto;

import java.util.List;

import lombok.Data;
import lombok.NoArgsConstructor;

/*
 *  Mypage용 DTO
 */
@Data
//@Builder
@NoArgsConstructor 
public class Mypage {
    /** 내 정보 */
    private String       user_id;
    private String       user_nickname;

    /** 내가 쓴 리뷰 전체 */
    private List<Review> reviews;
}