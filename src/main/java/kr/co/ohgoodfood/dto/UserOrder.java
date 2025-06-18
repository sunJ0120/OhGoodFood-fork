package kr.co.ohgoodfood.dto;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.sql.Date;

/*
User 화면의 Order list에 들어오는 정보들을 가져온다.
 */

@ToString
@Data
@NoArgsConstructor
public class UserOrder {
    private String store_img;

    private String store_name;

    private String store_id;
    private int product_no;

    private Date pickup_start;
    private Date pickup_end;
    private int sale_price;

    private int order_no;
    private Date ordered_at;
    private int quantity;
    private String order_status;
    private String cancled_from;
    private String order_code;

    private Boolean block_cancle; //확정 시간 한 시간 전에 취소하지 못하도록 변수 생성
}
