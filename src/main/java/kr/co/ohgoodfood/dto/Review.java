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
    
}
