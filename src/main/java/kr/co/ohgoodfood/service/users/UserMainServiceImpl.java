package kr.co.ohgoodfood.service.users;

import kr.co.ohgoodfood.dao.UserMainMapper;
import kr.co.ohgoodfood.dto.*;
import kr.co.ohgoodfood.exception.InvalidPickupDataException;
import kr.co.ohgoodfood.util.StringSplitUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * UserMainServiceImpl.java - UsersMainService interface 구현체
 *
 * @see UserMainService - 세부 기능은 해당 클래스인 UserMainServiceImpl에 구현한다.
 * - 의존성 주입은 생성자 주입으로 구성한다.
 * - 스프링은 기본 빈 주입이 싱글톤이기 때문에, 따로 싱글톤 처리 없이 @Service로 해결한다.
 */

@Slf4j
@RequiredArgsConstructor
@Service
public class UserMainServiceImpl implements UserMainService {
    private final UserMainMapper userMainMapper;

    /**
     * 메인 화면에 뿌릴 DTO리스트를 가져오는 method
     *
     * @param userMainFilter : 필터링을 위한 객체가 담겨있다. ()
     * @return               : MainStoreDTOList (MainStore DTO의 리스트 객체)
     */
    @Override
    public List<MainStoreDTO> getMainStoreList(UserMainFilter userMainFilter) {
        List<MainStoreDTO> mainStoreList = userMainMapper.selectAllStore(userMainFilter);

        // 카테고리 이름과 pickup 상태를 저장
        // 이상 데이터 값이 있어도 , 이는 로그에 남기고 정상 데이터들은 잘 보여주기 위해 continue 처리한다.
        for(MainStoreDTO mainStore : mainStoreList){
            PickupStatus pickup_status;
            try{
                pickup_status = getPickupDateStatus(
                        mainStore.getStore().getStore_status(),
                        mainStore.getProduct().getPickup_start(),
                        mainStore.getProduct().getAmount()
                );
            } catch (InvalidPickupDataException e){
                log.error("픽업 상태 계산 실패(storeId={}): {}",
                        mainStore.getStore().getStore_id(), e.getMessage());
                //이상 데이터 값의 경우, continue로 숨김처리
                continue;
            }
            mainStore.setPickup_status(pickup_status);
            mainStore.setCategory_list(getCategoryList(mainStore.getStore()));
            mainStore.setMainmenu_list(StringSplitUtils.splitMenu(mainStore.getStore().getStore_menu(), "\\s*\\|\\s*"));
        }
        return mainStoreList;
    }

    /**
     * 지도에 표시할 가게 정보를 가져오는 method
     *
     * @param userMainFilter : 필터링을 위한 객체가 담겨있다. main에서 사용하는걸 그대로 사용한다
     * @return               : MainStoreDTO
     */
    //selectOneStoreByStoreId
    @Override
    public MainStoreDTO getMainStoreOne(UserMainFilter userMainFilter){
        MainStoreDTO mainStore = userMainMapper.selectOneStoreByStoreId(userMainFilter);

        //단일건의 경우, 따로 예외처리 하거나 null을 return 하지 않고 ControllerAdvice에서 처리하도록 한다.
        PickupStatus pickup_status = getPickupDateStatus(
                mainStore.getStore().getStore_status(),
                mainStore.getProduct().getPickup_start(),
                mainStore.getProduct().getAmount()
        );

        mainStore.setPickup_status(pickup_status);
        mainStore.setCategory_list(getCategoryList(mainStore.getStore()));
        mainStore.setMainmenu_list(StringSplitUtils.splitMenu(mainStore.getStore().getStore_menu(), "\\s*\\|\\s*"));

        return mainStore;
    }

    /**
     * LocalDate.now()로 오늘픽업, 내일픽업, 매진, 마감 상태를 판별합니다.
     *
     * @param store_status          : store가 현재 오픈 상태인지 판단
     * @param pickup_start          : store가 오늘 픽업인지, 내일 픽업인지를 판단
     * @param amount                : store가 매진인지 판단
     *
     * @return                      : PickupStatus ENUM 객체
     */
    @Override
    public PickupStatus getPickupDateStatus(String store_status, Timestamp pickup_start, int amount) {
        LocalDate today = LocalDate.now();
        // [마감] - store_status = N
        if("N".equals(store_status)){
            return PickupStatus.CLOSED;
        }else{
            LocalDate pickupDate;
            if (pickup_start == null) {
                //null에러일 경우, 에러 메세지 없이 로깅
                throw new InvalidPickupDataException(store_status, pickup_start, amount);
            }

            //한번 null 위험 처리를 하고나면, 그 다음부터는 time_stamp 형식 예외 등의 로직만 잡으므로, 더 안전하게 체크가 가능하다.
            try{
                pickupDate = pickup_start.toLocalDateTime().toLocalDate();
            } catch (Exception e){
                //에러 로그를 보존한채 넘긴다.
                throw new InvalidPickupDataException(store_status, pickup_start, amount, e);
            }

            // [매진] - amount = 0
            if(amount == 0){
                return PickupStatus.SOLD_OUT;
            }else{
                // [오늘픽업] 현재 날짜와 같음
                if (pickupDate.isEqual(today)) {
                    return PickupStatus.TODAY;
                } else if (pickupDate.isEqual(today.plusDays(1))) { //[내일픽업] 현재 날짜 + 1과 같음
                     return PickupStatus.TOMORROW;
                }
            }

        }
        throw new InvalidPickupDataException(store_status, pickup_start, amount); //custom exception 던지기
    }

    /**
     * |(구분자) 구분은 확장성을 위해 프론트 단에 위임
     * 서버에서는 리스트에 담아서 보내도록 한다.
     *
     * @param store              : store dto 내부에 있는 cateogory_ 값에 따라 list를 구현하기 위함이다.
     * @return                   : 카테고리 이름이 담긴 List
     */
    @Override
    public List<String> getCategoryList(Store store) {
        List<String> category_list = new ArrayList<>();

        if(store.getCategory_bakery().equals("Y")){
            category_list.add(StoreCategory.BAKERY.getDisplayName());
        }

        if(store.getCategory_fruit().equals("Y")){
            category_list.add(StoreCategory.FRUIT.getDisplayName());
        }

        if(store.getCategory_salad().equals("Y")){
            category_list.add(StoreCategory.SALAD.getDisplayName());
        }

        if(store.getCategory_others().equals("Y")){
            category_list.add(StoreCategory.ETC.getDisplayName());
        }

        return category_list;
    }
}
