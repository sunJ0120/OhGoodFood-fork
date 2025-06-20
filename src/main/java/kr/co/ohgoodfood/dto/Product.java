package kr.co.ohgoodfood.dto;

import java.sql.Date;
import java.time.LocalDateTime;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Data
public class Product {
    private int product_no;
    private String store_id;
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime pickup_start;
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime pickup_end;
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime reservation_end;
    private int origin_price;
    private int sale_price;
    private String product_explain;
    private int amount;

    private int s_product_no;
    private String s_store_id;
}
