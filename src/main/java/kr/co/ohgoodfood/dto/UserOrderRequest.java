package kr.co.ohgoodfood.dto;

import lombok.*;

/**
 * [DTO] UserOrderRequest.java
 *
 * - OrderList에서 필요한 CRUD 기능을 수행하기 위한 DTO
 */

@Getter
@Setter
@ToString
@Builder
@AllArgsConstructor //Builder와 테스트용 생성자
@NoArgsConstructor  // MyBatis 매핑용 기본 생성자
public class UserOrderRequest {
    private String user_id;
    private int order_no;
    private int product_no;
    private int quantity;
    private String canceld_from;
    private String order_status;
    private int order_code;
}
