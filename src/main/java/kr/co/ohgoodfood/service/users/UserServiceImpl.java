package kr.co.ohgoodfood.service.users;

import kr.co.ohgoodfood.dao.UserMapper;
import kr.co.ohgoodfood.dto.*;
import kr.co.ohgoodfood.util.StringSplitUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.sql.Time;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * UsersServiceImpl.java
 * - UsersService interface 구현체
 * @see UsersService
 * - 세부 기능은 해당 클래스인 UsersServiceImpl에 구현한다.
 * - 의존성 주입은 생성자 주입으로 구현
 */

@Slf4j
@RequiredArgsConstructor
@Service
public class UserServiceImpl implements UsersService{
    private final UserMapper userMapper;

    /**
     * 메인 화면에 뿌릴 DTO리스트를 가져오는 메서드
     *
     * @param userMainFilter 필터링을 위한 객체가 담겨있다. (필터링 대상 : Category, 가게 상세, 가게 이름)
     * @return mainStoreList (MainStore DTO의 리스트 객체)
     */
    @Override
    public List<MainStore> getMainStoreList(UserMainFilter userMainFilter) {
        List<MainStore> mainStoreList = userMapper.selectAllStore(userMainFilter);

        // 여기에 카테고리 이름과 pickup 상태를 저장
        for(MainStore mainStore : mainStoreList){
            mainStore.setPickup_status(getPickupDateStatus(mainStore));
            mainStore.setCategory_list(getCategoryList(mainStore));
            mainStore.setMainmenu_list(StringSplitUtils.splitMenu(mainStore.getStore_menu(), "/"));
        }
        log.info("[log/UserServiceImpl.getMainStoreList] mainStoreList 결과 log : {}", mainStoreList);

        return mainStoreList;
    }

    @Override
    public List<UserOrder> getUserOrderList(UserOrderFilter userOrderFilter){
        List<UserOrder> orderList = userMapper.selectOrderList(userOrderFilter);

        // userOrder에 pickup_status를 저장.
        for(UserOrder userOrder : orderList){
            userOrder.setPickup_status(getPickupDateStatus(userOrder));
        }

        return orderList;
    }

    /**
     * 사용자가 가진 북마크 리스트를 가져오는 함수
     *
     * @param user_id user_id
     * @return mainStoreList (MainStore DTO의 리스트 객체)
     */
    @Override
    public List<Bookmark> getBookmarkList(String user_id){
        List<Bookmark> bookmarkList = userMapper.selectAllBookmark(user_id);

        // 여기에 카테고리 이름과 pickup 상태를 저장
        for(Bookmark bookmark : bookmarkList){
            bookmark.setPickup_status(getPickupDateStatus(bookmark));
            bookmark.setCategory_list(getCategoryList(bookmark));
            bookmark.setMainmenu_list(StringSplitUtils.splitMenu(bookmark.getStore_menu(), "/"));
        }
        log.info("[log/UserServiceImpl.getBookmarkList] mainStoreList 결과 log : {}", bookmarkList);

        return bookmarkList;
    }

    /**
     * LocalDate.now()로 오늘픽업, 내일픽업, 매진, 마감을 판별합니다.
     *
     * @param mainStore 판별 데이터가 담긴 객체
     * @return PickupStatus enum 객체
     */
    @Override
    public PickupStatus getPickupDateStatus(MainStore mainStore) {

        LocalDate today = LocalDate.now();

        // [마감] - store_status = N
        if("N".equals(mainStore.getStore_status())){
            return PickupStatus.CLOSED;
        }else{
            LocalDate pickupDate = mainStore.getPickup_start().toLocalDateTime().toLocalDate();
            // [매진] - amount = 0
            if(mainStore.getAmount() == 0){
                return PickupStatus.SOLD_OUT;
            }else{
                // [오늘픽업] 현재 날짜와 같음
                if (pickupDate.isEqual(today)) {
                    return PickupStatus.TODAY;
                }
                // [내일픽업] 현재 날짜 + 1과 같음
                if (pickupDate.isEqual(today.plusDays(1))) {
                    return PickupStatus.TOMORROW;
                }
            }
        }
        throw new IllegalStateException();
    }

    /**
     * 로직 변경, | 구분은 확장성을 위해 프론트 단에 위임
     * 서버에서는 리스트에 담아서 보내도록 한다.
     *
     * @param mainStore
     * @return 카테고리 이름이 담긴 List
     */

    @Override
    public List<String> getCategoryList(MainStore mainStore) {
        List<String> category_list = new ArrayList<>();

        if(mainStore.getCategory_bakery().equals("Y")){
            category_list.add("빵 & 디저트");
        }

        if(mainStore.getCategory_fruit().equals("Y")){
            category_list.add("과일");
        }

        if(mainStore.getCategory_salad().equals("Y")){
            category_list.add("샐러드");
        }

        if(mainStore.getCategory_others().equals("Y")){
            category_list.add("그 외");
        }

        return category_list;
    }

    @Override
    public boolean deleteUserBookMark(BookmarkDelete bookmarkDelete) {
        String user_id = bookmarkDelete.getUser_id();
        int bookmark_no = bookmarkDelete.getBookmark_no();

        int cnt = userMapper.deleteBookmark(user_id, bookmark_no);

        if (cnt == 1) {
            return true;
        }
        return false; //delete 실패!
    }
}
