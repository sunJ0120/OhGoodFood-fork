package kr.co.ohgoodfood.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.co.ohgoodfood.dto.Alarm;
import kr.co.ohgoodfood.dto.Orders;
import kr.co.ohgoodfood.dto.Review;
import kr.co.ohgoodfood.dto.Store;
import kr.co.ohgoodfood.dto.StoreSales;

@Mapper
public interface StoreMapper {
	public Store login(Store vo);

	public Review viewReview(Store vo);
	
	public List<Review> getReviews(String storeId);

	public List<Orders> getOrders(@Param("storeId") String storeId, @Param("type") String type);

	public int confirmOrders(@Param("id") int id, @Param("type") String type);

	public int cancleOrders(@Param("id") int id, @Param("type") String type);

	public Orders getOrderById(int no);

	public int insertAlarm(Alarm alarm);

	public int pickupOrders(@Param("id") int id, @Param("type") String type);

	public List<Orders> getConfirmedOrPickupOrders(@Param("id") String id);

	public StoreSales getSales(@Param("store_id") String store_id, @Param("start") String start, @Param("end") String end);

	public int createOrderCode(@Param("id") int id, @Param("type") String type, @Param("randomCode") int randomCode);
	
	
}
