package kr.co.ohgoodfood.dto;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class Paid {
    private int paid_no;
    private String paid_type;
    private String paid_price;
    private Timestamp paid_time;
    private String paid_status;
    private String fail_reason;
    private String refund_request;
    private String user_id;
    private int order_no;

    private int s_paid_no;
    private int s_paid_time;
    private int s_user_id;
    private String s_store_id;

    private String s_type;
    private String s_value;

    private int page;
    private int startIdx;

    public Paid() {
        this.page = 1;
    }

    public int getStartIdx() {
        return (page - 1) * 7;
    }
}
