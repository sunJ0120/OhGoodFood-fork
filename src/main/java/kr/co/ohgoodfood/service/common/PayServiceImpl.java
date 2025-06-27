package kr.co.ohgoodfood.service.common;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.ohgoodfood.dao.PayMapper;
import kr.co.ohgoodfood.dto.Orders;
import kr.co.ohgoodfood.dto.Paid;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class PayServiceImpl implements PayService {

    private final PayMapper payMapper;

    // 주문,결제 정보 삽입
    @Transactional
    @Override
    public boolean insertOrderAndPaid(String user_id, String store_id, int product_no, 
            int quantity, int paid_price, String orderId) {
        try {
            Orders orders = new Orders();
            orders.setUser_id(user_id);
            orders.setStore_id(store_id);
            orders.setProduct_no(product_no);
            orders.setQuantity(quantity);
            orders.setOrder_status("ready");
            Paid paid = new Paid();
            paid.setUser_id(user_id);
            paid.setOrder_no(orders.getOrder_no());
            paid.setPaid_type("tosspayments");
            paid.setPaid_price(paid_price);
            paid.setPaid_status("N");
            paid.setPaid_code(orderId);
            payMapper.insertOrder(orders);
            paid.setOrder_no(orders.getOrder_no());
            payMapper.insertPaid(paid);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    // 주문,결제 상태 업데이트
    @Transactional
    @Override
    public boolean updateOrderStatusAndPaidStatus(String orderId) {
        try {
            payMapper.updatePaidStatusByPaidCode(orderId);
            payMapper.updateOrderStatusByPaidCode(orderId);
            Map<String, Object> map = new HashMap<>();  
            map.put("paid_code", orderId);
            map.put("quantity", payMapper.getOrderQuantityByPaidCode(orderId));
            payMapper.updateProductAmount(map);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    // 상품 재고에서 주문 개수만큼 차감 가능 여부 확인
    @Override
    public boolean checkProductAmount(int product_no, int quantity) {
        int productAmount = payMapper.getProductAmount(product_no);
        return productAmount >= quantity;
    }

    // 최종 결제 전 paid_code로 상품 재고에서 주문 개수만큼 차감 가능 여부 확인
    @Override  
    public boolean checkProductAmountByPaidCode(String paid_code) {
        int productAmount = payMapper.getProductAmountByPaidCode(paid_code);
        int orderQuantity = payMapper.getOrderQuantityByPaidCode(paid_code);
        return productAmount >= orderQuantity;
    }

    // 결제 실패 시 주문 canceld_from 업데이트
    @Override
    public boolean updateOrderCanceldFromByPaidCode(String paid_code) {
        try {
            payMapper.updateOrderCanceldFromByPaidCode(paid_code);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    // 결제 실패 시 주문 canceld_from 가져오기
    @Override
    public String getOrderCanceldFromByPaidCode(String paid_code) {
        return payMapper.getOrderCanceldFromByPaidCode(paid_code);
    }
}
