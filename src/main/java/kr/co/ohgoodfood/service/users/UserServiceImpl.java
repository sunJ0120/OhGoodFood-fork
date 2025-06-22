package kr.co.ohgoodfood.service.users;

import kr.co.ohgoodfood.dao.UserMapper;
import kr.co.ohgoodfood.dto.MainStore;
import kr.co.ohgoodfood.dto.UserMainFilter;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.sql.Time;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.ZoneId;
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

    @Override
    public List<MainStore> getMainStoreList(String user_id, UserMainFilter userMainFilter) {
        List<MainStore> mainStoreList = userMapper.selectAllStore(user_id, userMainFilter);

        // 여기에 카테고리 이름과 pickup 상태를 저장
        for(MainStore mainStore : mainStoreList){
            mainStore.setPickup_date(getPickupDateStatus(mainStore));
            mainStore.setCategory_name(getCategoryName(mainStore));
            mainStore.setAmount_time_tag(getAmountOrEndTime(mainStore));
        }
        log.info("[log/UserServiceImpl.getMainStoreList] mainStoreList 결과 log : {}", mainStoreList);

        return mainStoreList;
    }

    /**
     * LocalDate.now()로 오늘픽업, 내일픽업, 매진, 마감을 판별합니다.
     *
     * @param mainStore 판별 데이터가 담긴 객체
     * @return "오늘픽업", "내일픽업", "매진", "마감" 중 하나
     * @see #getAmountOrEndTime(MainStore)
     */
    @Override
    public String getPickupDateStatus(MainStore mainStore) {

        LocalDate today = LocalDate.now();

        //store_status = false, 수량 0이면 매진
        if(mainStore.getAmount() <= 0 && mainStore.getStore_status().equals("N")){
            return "매진";
        }
        
        if(mainStore.getStore_status().equals("N")){ //status가 false이면 현재 마감
            return "마감";
        }

        if (mainStore.getPickup_start().toLocalDate().isEqual(today)) {
            return "오늘픽업";
        } else if (mainStore.getPickup_start().toLocalDate().isEqual(today.plusDays(1))) {
            return "내일픽업";
        } else if (mainStore.getPickup_start().toLocalDate().isBefore(today)) {
            return "마감";
        } else {
            return "error"; // 예외 상황 처리가 필요하다.
        }
    }

    /**
     * 내부적으로 {@link StringBuilder}를 사용하여 문자열을 누적하고,
     * 마지막에 남은 구분자("| ")를 제거하여 반환한다.
     *
     * @param mainStore
     * @return '|' 구분자로 결합된 카테고리 이름 (예: "빵 & 디저트 | 과일")
     */

    @Override
    public String getCategoryName(MainStore mainStore) {
        StringBuilder categoryName = new StringBuilder();

        if(mainStore.getCategory_bakery().equals("Y")){
            categoryName.append("빵 & 디저트 | ");
        }

        if(mainStore.getCategory_fruit().equals("Y")){
            categoryName.append("과일 | ");
        }

        if(mainStore.getCategory_salad().equals("Y")){
            categoryName.append("샐러드 | ");
        }

        if(mainStore.getCategory_others().equals("Y")){
            categoryName.append("그 외 | ");
        }
        //끝에 3개 제외
        categoryName.setLength(categoryName.length() - 3);

        return categoryName.toString();
    }

    /**
     * - store_status.equals("N")일 경우 : closed_at을 return
     * - amount > 5 일 경우, +5로 처리한다.
     * - amount < 5 일 경우, amount를 그대로 내보낸다.
     *
     * @param mainStore
     * @return 표시할 마감 시간 또는 수량 문자열
     */

    @Override
    public String getAmountOrEndTime(MainStore mainStore) {
        StringBuilder amount_time_tag = new StringBuilder();

        //매진이나 마감 상태
        if(mainStore.getStore_status().equals("N")){
            SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
            amount_time_tag.append(sdf.format(mainStore.getClosed_at()));
            return amount_time_tag.toString();
        }

        if(mainStore.getAmount() > 5){ //5개 초과일 경우, +5로 설정
            amount_time_tag.append("+");
            amount_time_tag.append(mainStore.getAmount());
            amount_time_tag.append(" 개"); //갯수 붙였는데..일단 보기
        }else{
            amount_time_tag.append(mainStore.getAmount());
            amount_time_tag.append(" 개");
        }

        return amount_time_tag.toString();
    }
}
