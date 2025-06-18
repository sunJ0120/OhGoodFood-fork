package kr.co.ohgoodfood.dto;

import java.sql.Date;

import lombok.Data;

@Data
public class Paid {
    private int paid_no;
    private String paid_type;
    private String paid_price;
    private Date paid_time;
    private String paid_status;
    private String fail_reason;
    private String refund_request;
    private String user_id;
    private String order_no;

    private int s_paid_no;
    private int s_paid_time;
    private int s_user_id;
}
