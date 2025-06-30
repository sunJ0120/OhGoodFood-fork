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

	public List<Review> getReviews(String storeId);

	public List<Orders> getOrders(String storeId, String type);

	public int confirmOrders(int id, String type);

	public int cancleOrders(int id, String type);

	public int createUserAlarm(int no, String type);

	public int createStoreAlarm(int no, String type);

	public int pickupOrders(int id, String type);

	public int confirmPickupOrders(int id, String type);

	public List<Orders> getConfirmedOrPickupOrders(String id);

	public StoreSales getSales(String store_id, String start, String end);

	public int createOrderCode(int id, String string);

	public boolean isDuplicateId(String store_id);
	
	public void registerStore(Store vo, MultipartFile[] storeImageFiles, String storeAddressDetail, String store_menu2, String store_menu3, HttpServletRequest request) throws Exception;
	
	public void saveImage(String storeId, MultipartFile file, HttpServletRequest request) throws Exception;
	
	public Store getStoreDetail(String store_id);

	public void updateStoreCategory(Store vo);
	
	public List<Image> getImagesByStoreId(String store_id);
	
	public Product getProductByStoreId(String store_id);
	
	public void updateStoreStatus(String store_id, String status);
	
	public void createProduct(Store store, String productExplain, String pickupDateType, String pickupStartTime, String pickupEndTime, int originPrice, int salePrice, int amount);

	public int checkOrderStatus(String store_id);
	
	public boolean isTodayReservationClosed(String store_id);
}
