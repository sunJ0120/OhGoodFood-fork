package kr.co.ohgoodfood.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import kr.co.ohgoodfood.dto.Alarm;
import kr.co.ohgoodfood.dto.Orders;
import kr.co.ohgoodfood.dto.Review;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;
import kr.co.ohgoodfood.dto.Image;
import kr.co.ohgoodfood.dto.Product;
import kr.co.ohgoodfood.dto.Store;
import kr.co.ohgoodfood.dto.StoreSales;

@Mapper
public interface StoreMapper {
	public Store login(Store vo);

	public Review viewReview(Store vo);
	
	public List<Review> getReviews(String storeId);

	public int insert(Store vo);

	public List<Orders> getOrders(@Param("storeId") String storeId, @Param("type") String type);

	public int confirmOrders(@Param("id") int id, @Param("type") String type);

	public int cancleOrders(@Param("id") int id, @Param("type") String type);

	public Orders getOrderById(int no);

	public int insertAlarm(Alarm alarm);

	public int pickupOrders(@Param("id") int id, @Param("type") String type);

	public List<Orders> getConfirmedOrPickupOrders(@Param("id") String id);

	public StoreSales getSales(@Param("store_id") String store_id, @Param("start") String start, @Param("end") String end);

	public int createOrderCode(@Param("id") int id, @Param("type") String type, @Param("randomCode") int randomCode);
	
	public Store findById(String store_id);

	public void insertImage(Image image);

	public void updateStore(Store vo);

	public List<Image> findImagesByStoreId(String store_id);
	
	public Product findProductByStoreId(String store_id);
	
	public void updateStoreStatus(Map<String, Object> param);
}
