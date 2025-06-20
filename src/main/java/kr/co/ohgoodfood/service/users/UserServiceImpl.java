package kr.co.ohgoodfood.service.users;

import kr.co.ohgoodfood.dao.UserMapper;
import kr.co.ohgoodfood.dto.MainStore;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.sql.Time;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;

/**
 * UsersServiceImpl.java
 * - UsersService interface 구현체
 * - 세부 기능은 해당 클래스인 UsersServiceImpl에 구현한다.
 *
 * - 의존성 주입은 생성자 주입으로 구현
 */

/**
 * 계산 로직 설명
 * 📌 LocalDate를 이용해서 비교하므로, 시간 제외 Date 만으로 판별이 가능하다.
 *
 * ① {@link #getPickupDateStatus} : 오늘픽업, 내일픽업, 매진, 마감을 판별
 * - 오늘픽업 : pickup_start가 LocalDate.now() (today)와 같을 경우
 * - 내일픽업 : pickup_start가 LocalDate.now().plusDays(1) (DAY를 하루 더한것)와 같은 경우
 * - 매진 : amount가 0이고 store_status가 "N"일 경우
 *   - 두가지 조건을 전부 체크해야 하므로 AND로 구성
 * - 마감 : store_status가 "N"일 경우
 *
 * ② {@link #getCategoryName} : 카테고리 Y, N값에 따라 카테고리 조합을 생성
 * 📌 String의 경우 객체 생성시 새로운 메모리를 사용하므로, StringBuilder로 구성한 후 String으로 return
 * - category_bakery.equals("Y") ... 등으로 다중 카테고리를 판별해서 StringBuilder 생성
 *
 * ③ {@link #getAmountOrEndTime} : closed_at값에 따라 마감 시간, 혹은 마감이 아닐경우 amount 값을 가져오도록 구성
 * - store_status.equals("N")일 경우 : closed_at을 return
 * - amount > 5 일 경우, +5로 처리한다.
 * - amount < 5 일 경우, amount를 그대로 내보낸다.
 */

@Slf4j
@RequiredArgsConstructor
@Service
public class UserServiceImpl implements UsersService{
    private final UserMapper userMapper;

    @Override
    public List<MainStore> getMainStoreList(String user_id) {
        List<MainStore> mainStoreList = userMapper.selectAllStore(user_id);

        // 여기에 카테고리 이름과 pickup 상태를 저장
        for(MainStore mainStore : mainStoreList){
            mainStore.setPickup_date(getPickupDateStatus(mainStore.getPickup_start(), mainStore.getStore_status(), mainStore.getAmount()));
            mainStore.setCategory_name(getCategoryName(mainStore.getCategory_bakery(), mainStore.getCategory_fruit(), mainStore.getCategory_salad(), mainStore.getCategory_others()));
            mainStore.setAmount_time_tag(getAmountOrEndTime(mainStore.getClosed_at(), mainStore.getStore_status(), mainStore.getAmount()));
        }
        log.info("[log/UserServiceImpl.getMainStoreList] mainStoreList 결과 log : {}", mainStoreList);

        return mainStoreList;
    }

    @Override
    public String getPickupDateStatus(Date pickup_start, String store_status, int amount) {
        LocalDate pickupDate = pickup_start.toInstant()
                .atZone(ZoneId.systemDefault())
                .toLocalDate();

        LocalDate today = LocalDate.now();

        //store_status = false, 수량 0이면 매진
        if(amount <= 0 && store_status.equals("N")){
            return "매진";
        }
        
        if(store_status.equals("N")){ //status가 false이면 현재 마감
            return "마감";
        }

        if (pickupDate.isEqual(today)) {
            return "오늘픽업";
        } else if (pickupDate.isEqual(today.plusDays(1))) {
            return "내일픽업";
        } else if (pickupDate.isBefore(today)) {
            return "마감";
        } else {
            return "error"; // 예외 상황 처리가 필요하다.
        }
    }

    @Override
    public String getCategoryName(String category_bakery, String category_fruit, String category_salad, String category_others) {
        StringBuilder categoryName = new StringBuilder();

        if(category_bakery.equals("Y")){
            categoryName.append("빵 & 디저트 | ");
        }

        if(category_fruit.equals("Y")){
            categoryName.append("과일 | ");
        }

        if(category_salad.equals("Y")){
            categoryName.append("샐러드 | ");
        }

        if(category_others.equals("Y")){
            categoryName.append("그 외 | ");
        }
        //끝에 3개 제외
        categoryName.setLength(categoryName.length() - 3);

        return categoryName.toString();
    }

    //db 데이터를 바꿔야 할 것 같은데,
    @Override
    public String getAmountOrEndTime(Time closed_at, String store_status, int amount) {
        StringBuilder amount_time_tag = new StringBuilder();

        //매진이나 마감 상태
        if(store_status.equals("N")){
            SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
            amount_time_tag.append(sdf.format(closed_at));
            return amount_time_tag.toString();
        }

        if(amount > 5){ //5개 초과일 경우, +5로 설정
            amount_time_tag.append("+");
            amount_time_tag.append(amount);
            amount_time_tag.append(" 개"); //갯수 붙였는데..일단 보기
        }else{
            amount_time_tag.append(amount);
            amount_time_tag.append(" 개");
        }

        return amount_time_tag.toString();
    }
}
