package kr.co.ohgoodfood.dto;

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
    //Store table에서 가져오는 정보들
    private String store_img;
    private String store_name;
    private String store_id;

    //Product table에서 가져오는 정보들
    private int product_no;
    private Date pickup_start;
    private Date pickup_end;
    private int sale_price;

    //Order table에서 가져오는 정보들
    private int order_no;
    private Date ordered_at;
    private int quantity;
    private String order_status;
    private String cancled_from;
    private String order_code;

    //[추가 정보] DB에는 없는 추가 정보
    private Boolean block_cancle; //확정 시간 한 시간 전에 취소하지 못하도록 변수 생성
}
