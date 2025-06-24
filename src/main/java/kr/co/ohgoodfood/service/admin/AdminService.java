package kr.co.ohgoodfood.service.admin;

import java.util.Map;

import kr.co.ohgoodfood.dto.Account;
import kr.co.ohgoodfood.dto.Admin;
import kr.co.ohgoodfood.dto.Alarm;
import kr.co.ohgoodfood.dto.Orders;
import kr.co.ohgoodfood.dto.Paid;
import kr.co.ohgoodfood.dto.Review;
import kr.co.ohgoodfood.dto.Store;
import kr.co.ohgoodfood.dto.StoreSales;

public interface AdminService {

    // 전년 전체 매출 조회
    public int getLastYearSales();

    // 금년 전체 매출 조회
    public int getThisYearSales();

    // 전월 전체 매출 조회
    public int getPreviousMonthSales();

    // 이번 달 전체 매출 조회
    public int getThisMonthSales();

    // 전년 전체 주문 건수 조회
    public int getLastYearOrderCount();

    // 금년 전체 주문 건수 조회
    public int getThisYearOrderCount();

    // 전월 전체 주문 건수 조회
    public int getPreviousMonthOrderCount();

    // 이번 달 전체 주문 건수 조회
    public int getThisMonthOrderCount();

    // 미승인 가게 수 조회
    public int getUnapprovedStoreCount();

    // 회원 목록 조회
    public Map<String, Object> usersList(Account account);

    // 가게 목록 조회
    public Map<String, Object> storesList(Store store);
    
    // 미승인 가게 목록 가져오기
    public Map<String, Object> unapprovedStoresList(Store store);

    // 가게 승인
    public boolean approveStore(Store store);
    
    // 가게 전년 매출 조회
    public Integer getLastYearSales(StoreSales storeSales);

    // 가게 금년 매출 조회
    public Integer getThisYearSales(StoreSales storeSales);
    
    // 가게 전월 매출 조회
    public Integer getPreviousMonthSales(StoreSales storeSales);

    // 가게 금월 매출 조회
    public Integer getThisMonthSales(StoreSales storeSales);

    // 가게 전년 주문 건수 조회
    public Integer getLastYearOrderCount(StoreSales storeSales);

    // 가게 금년 주문 건수 조회
    public Integer getThisYearOrderCount(StoreSales storeSales);

    // 가게 금월 주문 건수 조회
    public Integer getThisMonthOrderCount(StoreSales storeSales);

    // 가게 금일 주문 건수 조회
    public Integer getTodayOrderCount(StoreSales storeSales);

    // 가게 기간 매출 조회
    public Integer getPeriodSales(StoreSales storeSales);

    // 가게 기간 주문 건수 조회
    public Integer getPeriodOrderCount(StoreSales storeSales);

    // 주문 목록 가져오기
    public Map<String, Object> ordersList(Orders orders);

    // 주문 상태 변경
    public boolean updateOrderStatus(Orders orders);

    // 결제 목록 가져오기
    public Map<String, Object> paidList(Paid paid);

    // 결제 상태 변경
    public boolean updatePaidStatus(Paid paid);

    // 결제 실패 이유 변경
    public boolean updatePaidFailReason(Paid paid);

    // 알람 목록 가져오기
    public Map<String, Object> alarmList(Alarm alarm);

    // 알람 상태 변경
    public boolean updateAlarm(Alarm alarm);
    
    // 알람 수신자 체크
    public boolean alarmCheckId(String receiveId);

    // 알람 보내기
    public boolean sendAlarm(Alarm alarm);

    // 리뷰 목록 가져오기
    public Map<String, Object> reviewList(Review review);

    // 리뷰 블러드 처리
    public boolean updateReview(Review review);

    // Admin 로그인 체크
    public int checkAdminLogin(Admin admin);
}
