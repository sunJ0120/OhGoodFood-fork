package kr.co.ohgoodfood.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@ToString
@Data
@NoArgsConstructor
public class OrderPayCheck {
    private String store_id;
    private String store_status; //이걸 String으로 그대로 받을지 아니면 boolean 처리 할지 고민중....입니다.
    private int product_no;
    private int amount;
}
