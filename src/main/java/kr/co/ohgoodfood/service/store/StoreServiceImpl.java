package kr.co.ohgoodfood.service.store;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.ohgoodfood.dao.StoreMapper;
import kr.co.ohgoodfood.dto.Alarm;
import kr.co.ohgoodfood.dto.Orders;
import kr.co.ohgoodfood.dto.Review;
import kr.co.ohgoodfood.dto.Store;
import kr.co.ohgoodfood.dto.StoreSales;


@Service
public class StoreServiceImpl implements StoreService{

	@Autowired
	private StoreMapper mapper;
	
	@Override
	public Store login(Store vo) {
		return mapper.login(vo);
	}
	
	@Override
	public Review viewRiew(Store vo) {
		return mapper.viewReview(vo);
	}
	@Override
	public List<Review> getReviews(String storeId) {
		return mapper.getReviews(storeId);
	}
	@Override
	public List<Orders> getOrders(String storeId, String type) {
		return mapper.getOrders(storeId, type);
	}
	@Override
	public int confirmOrders(int id, String type) {
		return mapper.confirmOrders(id, type);
	}
	@Override
	public int cancleOrders(int id, String type) {
		return mapper.cancleOrders(id, type);
	}
	@Override
	public int createUserAlarm(int no, String type) {
		Orders order = mapper.getOrderById(no);
		String userId = order.getUser_id();
		String storeId = order.getStore_id();
		String title = "";
		String content = "";
		
		if("confirmed".equals(type)) {
			title = "확정 완료";
			content = order.getOrdered_at() + " " + order.getUser_id() + 
					" 님의 오굿백" + order.getQuantity() + "개 예약";
		}else if("cancle".equals(type)) {
			title = "취소 완료";
			content = order.getOrdered_at() + " " + order.getUser_id() + 
					" 님의 오굿백" + order.getQuantity() + "개 예약";
		}else if("pickup".equals(type)) {
			title = " 픽업 완료";
			content = order.getOrdered_at() + " " + order.getUser_id() + 
					" 님의 오굿백" + order.getQuantity() + "개 예약";
		}
		
		Alarm alarm = new Alarm();
		alarm.setAlarm_title(title);
		alarm.setAlarm_contents(content);
		alarm.setSended_at(new java.sql.Timestamp(System.currentTimeMillis()));
		alarm.setAlarm_displayed("Y");
		alarm.setReceive_id(userId);
		alarm.setAlarm_read("N");
		return mapper.insertAlarm(alarm);
	}
	@Override
	public int createStoreAlarm(int no, String type) {
		Orders order = mapper.getOrderById(no);
		String userId = order.getUser_id();
		String storeId = order.getStore_id();
		String title = "";
		String content = "";
		
		if("confirmed".equals(type)) {
			title = "확정 완료";
			content = order.getOrdered_at() + " " + order.getUser_id() + 
					" 님의 오굿백" + order.getQuantity() + "개 예약";
		}else if("cancle".equals(type)) {
			title = "취소 완료";
			content = order.getOrdered_at() + " " + order.getUser_id() + 
					" 님의 오굿백" + order.getQuantity() + "개 예약";
		}else if("pickup".equals(type)) {
			title = "픽업 완료";
			content = order.getOrdered_at() + " " + order.getUser_id() + 
					" 님의 오굿백" + order.getQuantity() + "개 예약";
		}
		
		Alarm alarm = new Alarm();
		alarm.setAlarm_title(title);
		alarm.setAlarm_contents(content);
		alarm.setSended_at(new java.sql.Timestamp(System.currentTimeMillis()));
		alarm.setAlarm_displayed("Y");
		alarm.setReceive_id(storeId);
		alarm.setAlarm_read("N");
		return mapper.insertAlarm(alarm);
	}
	@Override
	public int pickupOrders(int id, String type) {
		return mapper.pickupOrders(id, type);
	}
	
	@Override
	public int confirmPickupOrders(int id, String type) {
		return mapper.confirmOrders(id, type);
	}
	
	@Override
	public List<Orders> getConfirmedOrPickupOrders(String id) {
		return mapper.getConfirmedOrPickupOrders(id);
	}
	
	@Override
	public StoreSales getSales(String store_id, String start, String end) {
		return mapper.getSales(store_id, start, end);
	}
	
	
	@Override
	public int createOrderCode(int id, String type) {
		Random rand = new Random();
	    int randomCode = rand.nextInt(900000) + 100000;
		return mapper.createOrderCode(id, type, randomCode);
	}
	
	
}
