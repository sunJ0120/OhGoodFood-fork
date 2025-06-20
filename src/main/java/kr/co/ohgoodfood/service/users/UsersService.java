package kr.co.ohgoodfood.service.users;

import kr.co.ohgoodfood.dto.MainStore;

import java.sql.Time;
import java.util.Date;
import java.util.List;

/**
 * UsersService interface
 * - UsersService 기능 틀 interface
 * - 유지 보수 및 확장 편의성을 위해 interface로 구성한다.
 */
public interface UsersService {
    //[Controller 로직] UsersController.userMain 연결 로직
    List<MainStore> getMainStoreList(String user_id);

    //[판별 로직] 오늘 픽업, 내일 픽업, 마감 판별 연결 로직
    String getPickupDateStatus(Date pickup_start, String store_status, int amount);

    //[판별 로직] 카테고리 String 판별 연결 로직
    String getCategoryName(String category_bakery, String category_fruit, String category_salad, String category_others);

    //[판별 로직] 마감시간 & 수량 판별 연결 로직
    String getAmountOrEndTime(Time pickup_end, String store_status, int amount);

}
