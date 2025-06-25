package kr.co.ohgoodfood.dto;


import java.sql.Timestamp;

import lombok.Data;

@Data
public class Orders {
    private int order_no;

    private Timestamp ordered_at;
    private int quantity;
    private String order_status;
    private Timestamp picked_at;
    private String user_id;
    private String store_id;
    private String order_code;
    private String cancled_from ; //이거 db랑 맞춰야 합니다,,!

    private int s_order_no;
    private Timestamp s_ordered_at;
    private String s_order_status;

    private String s_price;

    private String s_type;
    private String s_value;

    private int page;
    private int startIdx;

    public Orders() {
        this.page = 1;
    }

    public int getStartIdx() {
        return (page - 1) * 7;
    }
}   

