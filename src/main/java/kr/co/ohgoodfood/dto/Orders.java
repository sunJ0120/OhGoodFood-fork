package kr.co.ohgoodfood.dto;


import java.time.LocalDateTime;

import org.springframework.format.annotation.DateTimeFormat;


import lombok.Data;

@Data
public class Orders {
    private int order_no;

    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime ordered_at;
    private int quantity;
    private String order_status;
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime picked_at;
    private String user_id;
    private String store_id;
    private String order_code;
    private String canceld_from;

    private int s_order_no;
    private Date s_ordered_at;
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

