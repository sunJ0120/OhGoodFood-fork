package kr.co.ohgoodfood.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.sql.Date;
import java.sql.Timestamp;

/*
User 화면의 Order list에 들어오는 정보들을 가져온다.
 */

@ToString
@Data
@NoArgsConstructor
public class UserOrder extends MainStore{
    //Order table에서 가져오는 정보들
    private int order_no;
    private Timestamp ordered_at;
    private int quantity;
    private String order_status;
    private String canceld_from; //null 방지 필요
    private String order_code; //null 방지 필요

    //[추가 정보] DB에는 없는 추가 정보
    private Boolean block_cancel; //확정 시간 한 시간 전에 취소하지 못하도록 변수 생성

    //Paid 테이블에서 가져오는 정보
    private int paid_no;
    private int paid_price;
    private String paid_status; //결제 상태, Y or N
}
