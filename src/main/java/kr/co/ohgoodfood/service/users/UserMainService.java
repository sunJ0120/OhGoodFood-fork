package kr.co.ohgoodfood.service.users;

import kr.co.ohgoodfood.dto.MainStoreDTO;
import kr.co.ohgoodfood.dto.PickupStatus;
import kr.co.ohgoodfood.dto.Store;
import kr.co.ohgoodfood.dto.UserMainFilter;

import java.sql.Timestamp;
import java.util.List;

/**
 * UserMainService interface
 * - UsersService 기능 틀 interface
 * - 유지 보수 편의성 및, DIP 원칙을 준수하기 위해 interface로 구성한다.
 */

public interface UserMainService {
    //[Controller 로직] 메인화면 Controller 연결 로직
    public List<MainStoreDTO> getMainStoreList(UserMainFilter userMainFilter);

    //[Controller 로직] Map에서 클릭한 pin 정보 Controller 연결 로직
    public MainStoreDTO getMainStoreOne(UserMainFilter userMainFilter);

    //[판별 로직] 오늘 픽업, 내일 픽업, 마감 판별 연결 로직
    public PickupStatus getPickupDateStatus(String store_status, Timestamp pickup_start, Integer amount);

    //[판별 로직] 카테고리 List<String> 저장 로직
    public List<String> getCategoryList(Store store);
}
