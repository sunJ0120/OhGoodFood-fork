package kr.co.ohgoodfood.service.admin;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.ohgoodfood.dao.AdminMapper;
import kr.co.ohgoodfood.dto.Account;
import kr.co.ohgoodfood.dto.Orders;
import kr.co.ohgoodfood.dto.Paid;
import kr.co.ohgoodfood.dto.Store;
import kr.co.ohgoodfood.dto.StoreSales;

@Service
public class AdminServiceImpl implements AdminService{

    @Autowired
    private AdminMapper adminMapper;

    // 전년 전체 매출 조회
    @Override
    public int getLastYearSales() {
        return adminMapper.getLastYearSalesTotal();
    }

    // 금년 전체 매출 조회
    @Override
    public int getThisYearSales() {
        return adminMapper.getThisYearSalesTotal();
    }

    // 전월 전체 매출 조회
    @Override
    public int getPreviousMonthSales() {
        return adminMapper.getPreviousMonthSalesTotal();
    }
    
    // 이번 달 전체 매출 조회
    @Override
    public int getThisMonthSales() {
        return adminMapper.getThisMonthSalesTotal();
    }

    // 전년 전체 주문 건수 조회
    @Override
    public int getLastYearOrderCount() {
        return adminMapper.getLastYearOrderCountTotal();
    }
    
    // 금년 전체 주문 건수 조회
    @Override
    public int getThisYearOrderCount() {
        return adminMapper.getThisYearOrderCountTotal();
    }
    
    // 전월 전체 주문 건수 조회
    @Override
    public int getPreviousMonthOrderCount() {
        return adminMapper.getPreviousMonthOrderCountTotal();
    }
    
    // 이번 달 전체 주문 건수 조회
    @Override
    public int getThisMonthOrderCount() {
        return adminMapper.getThisMonthOrderCountTotal();
    }

    // 미승인 점포 수 조회
    @Override
    public int getUnapprovedStoreCount() {
        return adminMapper.getUnapprovedStoreCountTotal();
    }
    
    
    // 회원 목록 조회
    @Override
    public Map<String, Object> usersList(Account account) {
        int count = adminMapper.countAccounts(account);
        int totalPage = count / 7;
        if(count % 7 != 0) {
            totalPage++;
        }
        List<Account> list = adminMapper.searchAccounts(account);
        Map<String, Object> map = new HashMap<>();
        map.put("list", list);
        map.put("totalPage", totalPage);
        map.put("count", count);
        
        int endPage = (int)Math.ceil(account.getPage() / 10.0) * 10;
        int startPage = endPage - 9;
        if(endPage > totalPage) {
            endPage = totalPage;
        }
        boolean isPrev = startPage > 1;
        boolean isNext = endPage < totalPage;
        map.put("isPrev", isPrev);
        map.put("isNext", isNext);
        map.put("startPage", startPage);
        map.put("endPage", endPage);
        return map;
    }
    
    // 가게 목록 조회
    @Override
    public Map<String, Object> storesList(Store store) {
        int count = adminMapper.countStores(store);
        int totalPage = count / 7;
        if(count % 7 != 0) {
            totalPage++;
        }
        List<Store> list = adminMapper.searchStores(store);
        Map<String, Object> map = new HashMap<>();
        map.put("list", list);
        map.put("totalPage", totalPage);
        map.put("count", count);
        
        int endPage = (int)Math.ceil(store.getPage() / 10.0) * 10;
        int startPage = endPage - 9;
        if(endPage > totalPage) {
            endPage = totalPage;
        }
        boolean isPrev = startPage > 1;
        boolean isNext = endPage < totalPage;
        map.put("isPrev", isPrev);
        map.put("isNext", isNext);
        map.put("startPage", startPage);
        map.put("endPage", endPage);
        return map;
    }
    
    //미승인 가게 목록 가져오기
    @Override
    public Map<String, Object> unapprovedStoresList(Store store) {
        int count = adminMapper.countStores(store);
        int totalPage = count / 7;
        if(count % 7 != 0) {
            totalPage++;
        }
        List<Store> list = adminMapper.getUnapprovedStore(store);
        Map<String, Object> map = new HashMap<>();
        map.put("list", list);
        map.put("totalPage", totalPage);
        map.put("count", count);
        
        int endPage = (int)Math.ceil(store.getPage() / 10.0) * 10;
        int startPage = endPage - 9;
        if(endPage > totalPage) {
            endPage = totalPage;
        }
        boolean isPrev = startPage > 1;
        boolean isNext = endPage < totalPage;
        map.put("isPrev", isPrev);
        map.put("isNext", isNext);
        map.put("startPage", startPage);
        map.put("endPage", endPage);
        return map;
    }

    // 가게 승인
    @Override
    public boolean approveStore(Store store) {
        adminMapper.approveStore(store);
        return true;
    }

    // 가게 전년 매출 조회
    @Override
    public Integer getLastYearSales(StoreSales storeSales) {
        return adminMapper.getLastYearSalesStore(storeSales);
    }

    // 가게 금년 매출 조회
    @Override
    public Integer getThisYearSales(StoreSales storeSales) {
        return adminMapper.getThisYearSalesStore(storeSales);
    }
    
    // 가게 전월 매출 조회
    @Override
    public Integer getPreviousMonthSales(StoreSales storeSales) {
        return adminMapper.getPreviousMonthSalesStore(storeSales);
    }
    
    // 가게 금월 매출 조회
    @Override
    public Integer getThisMonthSales(StoreSales storeSales) {
        return adminMapper.getThisMonthSalesStore(storeSales);
    }
    
    // 가게 기간 매출 조회
    @Override
    public Integer getPeriodSales(StoreSales storeSales) {
        return adminMapper.getPeriodSalesStore(storeSales);
    }

    // 가게 금일 주문 건수 조회
    @Override
    public Integer getTodayOrderCount(StoreSales storeSales) {
        return adminMapper.getTodayOrderCountStore(storeSales);
    }
    
    // 가게 금월 주문 건수 조회
    @Override
    public Integer getThisMonthOrderCount(StoreSales storeSales) {
        return adminMapper.getThisMonthOrderCountStore(storeSales);
    }
    
    // 가게 금년 주문 건수 조회
    @Override
    public Integer getThisYearOrderCount(StoreSales storeSales) {
        return adminMapper.getThisYearOrderCountStore(storeSales);
    }
    
    // 가게 전년 주문 건수 조회
    @Override
    public Integer getLastYearOrderCount(StoreSales storeSales) {
        return adminMapper.getLastYearOrderCountStore(storeSales);
    }
    
    // 가게 기간 지정 주문 건수 조회
    @Override
    public Integer getPeriodOrderCount(StoreSales storeSales) {
        return adminMapper.getPeriodOrderCountStore(storeSales);
    }
    
    // 주문 목록 가져오기
    @Override
    public Map<String, Object> ordersList(Orders orders) {
        int count = adminMapper.countOrders(orders);
        int totalPage = count / 7;
        if(count % 7 != 0) {
            totalPage++;
        }
        List<Orders> list = adminMapper.searchOrdersPersonal(orders);
        Map<String, Object> map = new HashMap<>();
        map.put("list", list);
        map.put("totalPage", totalPage);
        map.put("count", count);
        
        int endPage = (int)Math.ceil(orders.getPage() / 10.0) * 10;
        int startPage = endPage - 9;
        if(endPage > totalPage) {
            endPage = totalPage;
        }
        boolean isPrev = startPage > 1;
        boolean isNext = endPage < totalPage;
        map.put("isPrev", isPrev);
        map.put("isNext", isNext);
        map.put("startPage", startPage);
        map.put("endPage", endPage);
        return map;
    }

    // 주문 상태 변경
    @Override
    public boolean updateOrderStatus(Orders orders) {
        adminMapper.updateOrderStatusPersonal(orders);
        return true;
    }

    // 결제 목록 가져오기
    @Override
    public Map<String, Object> paidList(Paid paid) {
        int count = adminMapper.countPaid(paid);
        int totalPage = count / 7;
        if(count % 7 != 0) {
            totalPage++;
        }
        List<Paid> list = adminMapper.searchPaidPersonal(paid);
        Map<String, Object> map = new HashMap<>();
        map.put("list", list);
        map.put("totalPage", totalPage);
        map.put("count", count);
        
        int endPage = (int)Math.ceil(paid.getPage() / 10.0) * 10;
        int startPage = endPage - 9;
        if(endPage > totalPage) {
            endPage = totalPage;
        }
        boolean isPrev = startPage > 1;
        boolean isNext = endPage < totalPage;
        map.put("isPrev", isPrev);
        map.put("isNext", isNext);
        map.put("startPage", startPage);
        map.put("endPage", endPage);
        return map;
    }
    
    // 결제 상태 변경
    @Override
    public boolean updatePaidStatus(Paid paid) {
        adminMapper.updatePaidStatusPersonal(paid);
        return true;
    }
    
    // 결제 실패 이유 변경     
    @Override
    public boolean updatePaidFailReason(Paid paid) {
        adminMapper.updatePaidFailReasonPersonal(paid);
        return true;
    }
}
