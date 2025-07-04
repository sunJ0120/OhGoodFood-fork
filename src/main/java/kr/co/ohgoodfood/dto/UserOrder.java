package kr.co.ohgoodfood.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import java.sql.Timestamp;

/**
 * [DTO] UserOrder.java
 *
 * - Order List 정보에 필요한 DTO
 * - Service로직을 사용하기 위해 MainStore를 상속받도록 구성한다.
 */

@Data
@NoArgsConstructor
public class UserOrder extends MainStore {
    //Order table에서 가져오는 정보들
    private int order_no;
    private Timestamp ordered_at;
    private int quantity;
    private String order_status;
    private String canceld_from; //null 방지 필요
    private String order_code; //null 방지 필요

    //[추가 정보] DB에는 없는 추가 정보
    private Boolean block_cancel; //확정 시간 한 시간 전에 취소하지 못하도록 변수 생성
    private Boolean has_review; //리뷰가 존재하는 주문인지 판단하기 위함이다.
    private int point; //주문에 해당하는 point 지급을 위한 컬럼 (order 금액의 1%)

    //Paid 테이블에서 가져오는 정보
    private int paid_no;
    private int paid_price;
    private int paid_point; // 포인트 사용 기능 추가로 field 추가
    private String paid_status; //결제 상태, Y or N
}
