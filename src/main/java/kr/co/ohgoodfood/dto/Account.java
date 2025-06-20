package kr.co.ohgoodfood.dto;

import java.sql.Date;
import java.time.LocalDateTime;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Data
public class Account {
    private String user_id;
    private String user_nickname;
    private String user_name;
    private String user_pwd;
    private String phone_number;
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime join_date;
    private String user_status;
    private String location_agreement;

    private String s_type;
    private String s_value;
    private String s_user_id;
    private String s_user_nickname;
    private String s_user_name;

    private int page;
    private int startIdx;

    public Account(){
        this.page = 1;
    }

    public int getStartIdx(){
        return (page - 1) * 7;
    }
}
