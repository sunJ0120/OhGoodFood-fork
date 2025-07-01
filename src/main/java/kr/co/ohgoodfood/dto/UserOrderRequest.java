package kr.co.ohgoodfood.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * [DTO] UserOrderRequest.java
 *
 * - OrderList에서 필요한 CRUD 기능을 수행하기 위한 DTO
 */

@Data
@NoArgsConstructor
public class UserOrderRequest {
    private String user_id;
    private int order_no;
    private int product_no;
    private int quantity;
    private String canceld_from;
    private String order_status;
    private int order_code;
}
