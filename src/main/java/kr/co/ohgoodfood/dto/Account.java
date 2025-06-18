package kr.co.ohgoodfood.dto;

import java.sql.Date;

import lombok.Data;

@Data
public class Account {
    private String user_id;
    private String user_nickname;
    private String user_name;
    private String user_pwd;
    private String phone_number;
    private Date join_date;
    private String user_status;
    private String location_agreement;
}
