package kr.co.ohgoodfood.dto;

import java.sql.Date;

import lombok.Data;

@Data
public class Review {
    private int review_no;
    private String review_content;
    private Date writed_at;
    private String is_blocked;
    private String review_img;
    private String user_id;
    private String store_id;
    private int oreder_no;

    private int s_review_no;
    private int s_user_id;
    private int s_sotre_id;
    
    // --- 가격 정보 추가 필요 ---
    // Product table
    private int    origin_price;
    private int    sale_price;

    // Store table
    private String store_name;
    private String store_menu;

    // 대표 이미지 (Image 서브쿼리)
    private String store_img;
}
