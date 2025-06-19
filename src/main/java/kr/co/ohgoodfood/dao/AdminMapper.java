package kr.co.ohgoodfood.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.co.ohgoodfood.dto.Account;
import kr.co.ohgoodfood.dto.Admin;
import kr.co.ohgoodfood.dto.Alarm;
import kr.co.ohgoodfood.dto.Orders;
import kr.co.ohgoodfood.dto.Paid;
import kr.co.ohgoodfood.dto.Review;
import kr.co.ohgoodfood.dto.Store;
import kr.co.ohgoodfood.dto.StoreSales;

@Mapper
public interface AdminMapper {
    public List<Account> getAccountList();
    // 작년 매출 조회 
    public int getLastYearSalesTotal();
    // 금년 매출 조회 
    public int getThisYearSalesTotal();
    // 전월 매출 조회 
    public int getPreviousMonthSalesTotal();
    // 이번 달 매출 조회 
    public int getThisMonthSalesTotal();
    // 기간 매출 조회 
    public int getPeriodSalesTotal();
    // 작년 주문 건수 조회 
    public int getLastYearOrderCountTotal();
    // 금년 주문 건수 조회 
    public int getThisYearOrderCountTotal();
    // 전월 주문 건수 조회 
    public int getPreviousMonthOrderCountTotal();
    // 이번 달 주문 건수 조회 
    public int getThisMonthOrderCountTotal();
    // 미승인 가게 수 조회 
    public int getUnapprovedStoreCountTotal();
    // 회원 목록 조회 
    public List<Account> searchAccounts(Account account);
    // 회원 수 조회 
    public int countAccounts(Account account);
    // 가게 목록 조회 
    public List<Store> searchStores(Store store);
    // 가게 수 조회 
    public int countStores(Store store);
    // 미승인 가게 목록 조회 
    public List<Store> getUnapprovedStore(Store store);
    // 가게 승인 
    public void approveStore(Store store);
    // 작년 가게 매출 조회 
    public Integer getLastYearSalesStore(StoreSales store);
    // 금년 가게 매출 조회 
    public Integer getThisYearSalesStore(StoreSales store);
    // 전월 가게 매출 조회 
    public Integer getPreviousMonthSalesStore(StoreSales store);
    // 이번 달 가게 매출 조회 
    public Integer getThisMonthSalesStore(StoreSales store);
    // 기간 가게 매출 조회 
    public Integer getPeriodSalesStore(StoreSales store);
    // 금일 가게 주문 건수 조회 
    public Integer getTodayOrderCountStore(StoreSales store);
    // 금월 가게 주문 건수 조회 
    public Integer getThisMonthOrderCountStore(StoreSales store);
    // 금년 가게 주문 건수 조회 
    public Integer getThisYearOrderCountStore(StoreSales store);
    // 전년 가게 주문 건수 조회 
    public Integer getLastYearOrderCountStore(StoreSales store);
    // 기간 지정 가게 주문 건수 조회 
    public Integer getPeriodOrderCountStore(StoreSales store);
    // 주문 목록 조회 
    public List<Orders> searchOrdersPersonal(Orders orders);
    // 주문 개수 조회 
    public int countOrders(Orders orders);
    // 주문 상태 수정 
    public void updateOrderStatusPersonal(Orders orders);
    // 결제 목록 조회 
    public List<Paid> searchPaidPersonal(Paid paid);
    // 결제 개수 조회 
    public int countPaid(Paid paid);
    // 결제 상태 수정 
    public void updatePaidStatusPersonal(Paid paid);
    // 결제 실패 사유 수정 
    public void updatePaidFailReasonPersonal(Paid paid);
    // 알람 목록 조회 
    public List<Alarm> searchAlarm(Alarm alarm);
    // 알람 개수 조회 
    public int countAlarm(Alarm alarm);
    // 알람 읽음 처리 
    public void readAlarm(Alarm alarm);
    // 알람 표시 처리 
    public void displayAlarm(Alarm alarm);
    // 알람 보내기 
    public void sendAlarm(Alarm alarm);
    // 알람 수신자 체크 유저
    public Integer checkReceiverAccount(String receiveId);
    // 알람 수신자 체크 가게
    public Integer checkReceiverStore(String receiveId);
    // 리뷰 목록 조회 
    public List<Review> searchReview(Review review);
    // 리뷰 개수 조회 
    public int countReview(Review review);
    // 리뷰 차단 
    public void blockReview(Review review);
    // Admin 로그인 체크 
    public int checkAdminLogin(Admin admin);
}