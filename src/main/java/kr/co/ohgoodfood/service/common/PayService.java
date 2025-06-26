package kr.co.ohgoodfood.service.common;

public interface PayService {
    // 주문,결제 정보 삽입
    public boolean insertOrderAndPaid(String user_id, String store_id, int product_no, int quantity, int paid_price, String orderId);
    // 주문,결제 상태 업데이트
    public boolean updateOrderStatusAndPaidStatus(String orderId);
    // 상품 재고에서 주문 개수만큼 차감 가능 여부 확인
    public boolean checkProductAmount(int product_no, int quantity);
    // piad_code로 상품 재고에서 주문 개수만큼 차감 가능 여부 확인
    public boolean checkProductAmountByPaidCode(String paid_code);
}
