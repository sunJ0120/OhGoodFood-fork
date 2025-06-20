package kr.co.ohgoodfood.dto;

import java.sql.Date;
import java.time.LocalDateTime;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Data
public class Review {
    private int review_no;
    private String review_content;
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime writed_at;
    private String is_blocked;
    private String review_img;
    private String user_id;
    private String store_id;
    private int oreder_no;

    private int s_review_no;
    private int s_user_id;
    private int s_sotre_id;
    
    private String s_type;
    private String s_value;

    private int page;
    private int startIdx;

    public Review() {
        this.page = 1;
    }

    public void setStartIdx() {
        this.startIdx = (this.page - 1) * 7;
    }
}
