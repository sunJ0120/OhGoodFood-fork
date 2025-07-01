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
	// 로그인
	public Store login(Store vo);

	public Review viewReview(Store vo);
	
	public List<Review> getReviews(String storeId);

	// 회원가입(가게 등록)
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
	
	// 아이디로 가게 조회
	public Store findById(String store_id);

	// 가게 이미지 등록
	public void insertImage(Image image);

	// 가게 정보 수정
	public void updateStore(Store vo);

	// 가게별 이미지 목록 조회
	public List<Image> findImagesByStoreId(String store_id);
	
	// 가게별 상품 정보 조회(오늘)
	public Product findProductByStoreId(String store_id);
	
	// 가게 상태(오픈/마감) 변경
	public void updateStoreStatus(Map<String, Object> param);
	
	// 상품 등록
	public int insertProduct(Product product);
	
	// 가게별 최신 상품 조회
	public Product findLatestProductByStoreId(String storeId);

	// 미확정 주문 개수 조회
	public int checkOrderStatus(String store_id);

	// 오늘 마감 여부 확인
	public int checkTodayReservationEnd(String storeId);
}
