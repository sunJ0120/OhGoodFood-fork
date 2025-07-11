package kr.co.ohgoodfood;

import java.sql.Date;
import java.util.List;

import org.junit.jupiter.api.Test;

import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.context.web.WebAppConfiguration;

import kr.co.ohgoodfood.dao.AdminMapper;
import kr.co.ohgoodfood.dto.Account;
import kr.co.ohgoodfood.dto.Alarm;
import kr.co.ohgoodfood.dto.Orders;
import kr.co.ohgoodfood.dto.Paid;
import kr.co.ohgoodfood.dto.Review;
import kr.co.ohgoodfood.dto.Store;
import kr.co.ohgoodfood.dto.StoreSales;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(classes = { kr.co.ohgoodfood.config.MvcConfig.class })
@WebAppConfiguration
public class AdminTest {
    
    @Autowired
    AdminMapper adminMapper;

    // 계정 목록 조회
    @Test
    public void getAccountListTest() {
        List<Account> accountList = adminMapper.getAccountList();
        for (Account account : accountList) {
            System.out.println(account);
        }
    }

    // 미승인 점포 목록 조회
    @Test
    public void getUnapprovedStoreTest() {
        Store store = new Store();
        store.setPage(1);
        List<Store> storeList = adminMapper.getUnapprovedStore(store);
        for (Store store1 : storeList) {
            System.out.println(store1);
        }
    }

    // 미승인 점포 수 조회
    @Test
    public void getUnapprovedStoreCountTest() {
        int count = adminMapper.getUnapprovedStoreCountTotal();
        System.out.println(count);
    }

    // 전년 전체 매출 검색
    @Test
    public void getLastYearSalesTotalTest() {
        int sales = adminMapper.getLastYearSalesTotal();
        System.out.println(sales);
    }

    // 금년 전체 매출 검색
    @Test
    public void getThisYearSalesTotalTest() {
        int sales = adminMapper.getThisYearSalesTotal();
        System.out.println(sales);
    }

    // 전월 전체 매출 검색
    @Test
    public void getPreviousMonthSalesTotalTest() {
        int sales = adminMapper.getPreviousMonthSalesTotal();
        System.out.println(sales);
    }

    // 이번 달 전체 매출 검색
    @Test
    public void getThisMonthSalesTotalTest() {
        int sales = adminMapper.getThisMonthSalesTotal();
        System.out.println(sales);
    }

    // 전년 전체 주문 건수 검색
    @Test
    public void getLastYearOrderCountTotalTest() {
        int count = adminMapper.getLastYearOrderCountTotal();
        System.out.println(count);
    }

    // 금년 전체 주문 건수 검색
    @Test
    public void getThisYearOrderCountTotalTest() {
        int count = adminMapper.getThisYearOrderCountTotal();
        System.out.println(count);
    }

    // 전월 전체 주문 건수 검색
    @Test
    public void getPreviousMonthOrderCountTotalTest() {
        int count = adminMapper.getPreviousMonthOrderCountTotal();
        System.out.println(count);
    }

    // 이번 달 전체 주문 건수 검색
    @Test
    public void getThisMonthOrderCountTotalTest() {
        int count = adminMapper.getThisMonthOrderCountTotal();
        System.out.println(count);
    }

    // 계정 검색
    @Test
    public void searchAccountsTest() {
        Account account = new Account();
        account.setS_type("user_id");
        account.setS_value("u01");
        List<Account> accountList = adminMapper.searchAccounts(account);
        for (Account account1 : accountList) {
            System.out.println(account1);
        }
        account.setS_type("user_name");
        account.setS_value("김민중");
        List<Account> accountList1 = adminMapper.searchAccounts(account);
        for (Account account1 : accountList1) {
            System.out.println(account1);
        }
        account.setS_type("user_nickname");
        account.setS_value("군만두");
        List<Account> accountList2 = adminMapper.searchAccounts(account);
        for (Account account1 : accountList2) {
            System.out.println(account1);
        }
    }  

    // 계정 수 조회
    @Test
    public void countAccountsTest() {
        Account account = new Account();
        account.setS_type("user_id");
        account.setS_value("u01");
        int count = adminMapper.countAccounts(account);
        System.out.println(count);
    }

    // 매장 검색
    @Test
    public void searchStoresTest() {
        Store store = new Store();
        store.setS_type("store_id");
        store.setS_value("st01");
        List<Store> storeList = adminMapper.searchStores(store);
        for (Store store1 : storeList) {
            System.out.println(store1);
        }
    }

    // 매장 수 조회
    @Test
    public void countStoresTest() {
        Store store = new Store();
        store.setS_type("store_id");
        store.setS_value("st01");
        int count = adminMapper.countStores(store);
        System.out.println(count);
    }

    @Test
    public void approveStoreTest() {
        Store store = new Store();
        store.setStore_id("st01");
        adminMapper.approveStore(store);
    }

    // 매장 전년 매출 조회
    @Test
    public void getLastYearSales() {
        StoreSales store = new StoreSales();
        store.setStore_id("st01");
        int store1 = adminMapper.getLastYearSalesStore(store);
        System.out.println(store1);
    }

    // 매장 금년 매출 조회
    @Test
    public void getThisYearSales() {
        StoreSales store = new StoreSales();
        store.setStore_id("st01");
        int store1 = adminMapper.getThisYearSalesStore(store);
        System.out.println(store1);
    }

    // 매장 전월 매출 조회
    @Test
    public void getPreviousMonthSales() {
        StoreSales store = new StoreSales();
        store.setStore_id("st01");
        int store1 = adminMapper.getPreviousMonthSalesStore(store);
        System.out.println(store1);
    }

    // 매장 이번 달 매출 조회
    @Test
    public void getThisMonthSales() {
        StoreSales store = new StoreSales();
        store.setStore_id("st02");
        int store1 = adminMapper.getThisMonthSalesStore(store);
        System.out.println(store1);
    }

    // 매장 기간 지정 매출 조회
    // @Test
    // public void getPeriodSales() {
    //     StoreSales store = new StoreSales();
    //     store.setStore_id("st02");
    //     store.setStart_date(new Date(System.currentTimeMillis() - 30 * 24 * 60 * 60 * 1000));
    //     store.setEnd_date(new Date(System.currentTimeMillis()));
    //     int store1 = adminMapper.getPeriodSalesStore(store);
    //     System.out.println(store1);
    // }

    // Orders 검색
    @Test
    public void searchOrders() {
        Orders orders = new Orders();
        orders.setS_type("order_no");
        orders.setS_value("1");
        List<Orders> ordersList = adminMapper.searchOrdersPersonal(orders);
        for (Orders orders1 : ordersList) {
            System.out.println(orders1);
        }
    }

    // Orders 주문 상태 변경
    @Test
    public void updateOrderStatus() {
        Orders orders = new Orders();
        orders.setOrder_no(1);
        orders.setOrder_status("confirmed");
        adminMapper.updateOrderStatusPersonal(orders);
    }

    // Paid 검색
    @Test
    public void searchPaid() {
        Paid paid = new Paid();
        paid.setUser_id("u01");
        List<Paid> paidList = adminMapper.searchPaidPersonal(paid);
        for (Paid paid1 : paidList) {
            System.out.println(paid1);
        }
    }

    // Paid 결제 상태 변경
    @Test
    public void updatePaidStatus() {
        Paid paid = new Paid();
        paid.setPaid_no(1);
        paid.setPaid_status("Y");
        adminMapper.updatePaidStatusPersonal(paid);
    }

    // Paid 실패 이유 변경
    @Test
    public void updatePaidFailReason() {
        Paid paid = new Paid();
        paid.setPaid_no(1);
        paid.setFail_reason("잔액 부족");
        adminMapper.updatePaidFailReasonPersonal(paid);
    }

    // Alarm 검색
    @Test
    public void searchAlarm() {
        Alarm alarm = new Alarm();
        alarm.setS_receive_id("u01");
        List<Alarm> alarmList = adminMapper.searchAlarm(alarm);
        for (Alarm alarm1 : alarmList) {
            System.out.println(alarm1);
        }
    }

    // Alarm 읽음 처리
    @Test
    public void readAlarm() {
        Alarm alarm = new Alarm();
        alarm.setAlarm_no(1);
        alarm.setAlarm_read("Y");
        adminMapper.readAlarm(alarm);
    }

    // Alarm 디스플레이 처리
    @Test
    public void displayAlarm() {
        Alarm alarm = new Alarm();
        alarm.setAlarm_no(1);
        alarm.setAlarm_displayed("Y");
        adminMapper.displayAlarm(alarm);
    }

    // Alarm 보내기
    @Test
    public void sendAlarm() {
        Alarm alarm = new Alarm();
        alarm.setAlarm_title("테스트");
        alarm.setAlarm_contents("테스트");
        alarm.setReceive_id("u01");
    }

    // 수신자 유효성 검사
    @Test
    public void checkReceiver() {
        String receiveId = "u01";
        int result = adminMapper.checkReceiverAccount(receiveId);
        System.out.println(result);
        result = adminMapper.checkReceiverStore(receiveId);
        System.out.println(result);
    }

    // Review 검색
    @Test
    public void searchReview() {
        Review review = new Review();
        review.setS_type("store_id");
        review.setS_value("st01");
        List<Review> reviewList = adminMapper.searchReview(review);
        for (Review review1 : reviewList) {
            System.out.println(review1);
        }
    }

    // Review 블러드 처리
    @Test
    public void blockReview() {
        Review review = new Review();
        review.setReview_no(1);
        review.setIs_blocked("Y");
        adminMapper.blockReview(review);
    }
}
