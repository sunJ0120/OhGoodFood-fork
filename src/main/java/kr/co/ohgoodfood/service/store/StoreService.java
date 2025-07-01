package kr.co.ohgoodfood.service.store;

import java.util.List;
import kr.co.ohgoodfood.dto.Orders;
import kr.co.ohgoodfood.dto.Review;
import kr.co.ohgoodfood.dto.Image;
import kr.co.ohgoodfood.dto.Product;
import javax.servlet.http.HttpServletRequest;
import org.springframework.web.multipart.MultipartFile;
import kr.co.ohgoodfood.dto.Store;
import kr.co.ohgoodfood.dto.StoreSales;

public interface StoreService {

	public int insert(Store vo);

	// 내 가게 리뷰보기
	public List<Review> getReviews(String storeId);

	// 주문내역 조회(미확정, 확정, 취소)
	public List<Orders> getOrders(String storeId, String type, String selectedDate);

	// 주문을 확정
	public int confirmOrders(int id, String type);

	// 주문을 취소
	public int cancleOrders(int id, String type);

	// 유저에게 알람생성
	public int createUserAlarm(int no, String type);

	// 사장님에게 알람생성
	public int createStoreAlarm(int no, String type);

	// 주문을 픽업상태로 변경
	public int pickupOrders(int id, String type);

	// 픽업상태 주문을 다시 확정으로 변경
	public int confirmPickupOrders(int id, String type);

	// 주문상태가 확정 혹은 픽업을 조회
	public List<Orders> getConfirmedOrPickupOrders(String id);

	// 내 가게 매출 조회
	public StoreSales getSales(String store_id, String start, String end);

	// 주문 코드 생성
	public int createOrderCode(int id, String string);

	public boolean isDuplicateId(String store_id);
	
	public void registerStore(Store vo, MultipartFile[] storeImageFiles, String storeAddressDetail, HttpServletRequest request) throws Exception;
	
	public void saveImage(String storeId, MultipartFile file, HttpServletRequest request) throws Exception;
	
	public Store getStoreDetail(String store_id);

	public void updateStoreCategory(Store vo);
	
	public List<Image> getImagesByStoreId(String store_id);
	
	public Product getProductByStoreId(String store_id);
	
	public void updateStoreStatus(String store_id, String status);

}
