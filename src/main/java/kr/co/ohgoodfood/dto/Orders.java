package kr.co.ohgoodfood.dto;

import java.sql.Date;

import lombok.Data;

@Data
public class Orders {
    private int order_no;
    private Date ordered_at;
    private int quantity;
    private String order_status;
    private Date picked_at;
    private String user_id;
    private String store_id;
    private String order_code;
    private String cancled_from; //db에 있는 오타 그대로 반영

    private int s_order_no;
    private Date s_ordered_at;
    private String s_order_status;
}   