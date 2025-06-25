package kr.co.ohgoodfood.service.store;

<<<<<<< HEAD
import java.time.LocalDate;
import java.util.List;

import kr.co.ohgoodfood.dto.Orders;
import kr.co.ohgoodfood.dto.Review;
=======
import java.util.List;
import kr.co.ohgoodfood.dto.Image;
import kr.co.ohgoodfood.dto.Product;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartFile;

>>>>>>> 1029caaef18d8228f9ed164b94c15c583b4a3143
import kr.co.ohgoodfood.dto.Store;
import kr.co.ohgoodfood.dto.StoreSales;

public interface StoreService {

	public Store login(Store vo);

	public Review viewRiew(Store vo);

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
	
	public void registerStore(Store vo, MultipartFile[] storeImageFiles, String storeAddressDetail, HttpServletRequest request) throws Exception;
	
	public void saveImage(String storeId, MultipartFile file, HttpServletRequest request) throws Exception;
	
	public Store getStoreDetail(String store_id);

	public void updateStoreCategory(Store vo);
	
	public List<Image> getImagesByStoreId(String store_id);
	
	public Product getProductByStoreId(String store_id);
	
	public void updateStoreStatus(String store_id, String status);

}
