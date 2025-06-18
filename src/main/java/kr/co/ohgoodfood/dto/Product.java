package kr.co.ohgoodfood.dto;

import java.sql.Date;

import lombok.Data;

@Data
public class Product {
    private int product_no;
    private String store_id;
    private Date pickup_start;
    private Date pickup_end;
    private Date reservation_end;
    private int origin_price;
    private int sale_price;
    private String product_explain;
    private int amount;

    private int s_product_no;
    private String s_store_id;
}
