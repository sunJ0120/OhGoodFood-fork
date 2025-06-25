package kr.co.ohgoodfood.service.users;

import kr.co.ohgoodfood.dto.*;
import java.util.List;

/**
 * UsersService interface
 * - UsersService 기능 틀 interface
 * - 유지 보수 및 확장 편의성을 위해 interface로 구성한다.
 */
public interface UsersService {
    //[Controller 로직] UsersController.userMain 연결 로직
    List<MainStore> getMainStoreList(UserMainFilter userMainFilter);

    //[Controller 로직] UsersController.userBookmark 연결 로직
    List<Bookmark> getBookmarkList(String user_id);

    //[판별 로직] 오늘 픽업, 내일 픽업, 마감 판별 연결 로직
    PickupStatus getPickupDateStatus(MainStore mainStore);

    //[판별 로직] 카테고리 List<String> 저장 로직
    List<String> getCategoryList(MainStore mainStore);

    //[Controller 로직] UsersController.userBookmarkDelete 연결 로직
    boolean deleteUserBookMark(BookmarkDelete bookmarkDelete);

    //[Controller 로직] UsersController.userOrders 연결 로직
    List<UserOrder> getUserOrderList(UserOrderFilter userOrderFilter);

}
