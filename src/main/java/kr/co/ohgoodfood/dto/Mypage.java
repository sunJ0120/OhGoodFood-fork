package kr.co.ohgoodfood.dto;

import java.util.List;
import java.sql.Date;
import lombok.Builder;
import lombok.Data;

/*
 *  Mypage용 DTO
 */
@Data
@Builder
public class Mypage {
    /** 내 정보 - Account table */
    private String user_id;
    private String user_nickname;

    /** 내가 쓴 리뷰 리스트 */
    // Review table
    private int review_no;
    private List<Review> reviews;
    private String review_content;
    private Date writed_at;
    
    // Product table
    private int origin_price;
    private int sale_price;
    
    // Store table
    private String store_id;
    private String store_name;
    private String store_menu;

   // Image table
    private String store_img;
}