package kr.co.ohgoodfood.service.store;

import java.time.LocalDate;
import java.util.List;

import kr.co.ohgoodfood.dto.Orders;
import kr.co.ohgoodfood.dto.Review;
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

	
	

}
