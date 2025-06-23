package kr.co.ohgoodfood.dao;

import kr.co.ohgoodfood.dto.*;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

/**
 * Test에서만 사용하는 Mapper interface
 * - user 화면에서 사용하는 mapper가 아닌, test code에서만 사용한다.
 */

//test code에서만 사용하는 mapper 인터페이스
@Mapper
public interface TestMapper {
    //[test 용] user 북마크 추가 mapper
    void insertBookmark(Bookmark bookmark);

    //[test 용] bookmark 찾는 mapper
    Bookmark selectOneBookmark(int bookmark_no);

    //[test 용] alarm selectOne mapper
    Alarm selectOneAlarm(int alarm_no);

    //[test 용] Order insert mapper, test 용이므로 그냥 vo를 그대로 넣는다.
    void insertOrder(Orders orders);

    //[test 용] Order selectOne mapper
    Orders selectOneOrder(@Param("order_no") int order_no,
                          @Param("user_id") String user_id);

    //[test 용] Order deleteOrder mapper
    void deleteOrder(Orders orders);

    //[test 용] Bookmark deleteBookmark mapper
    void deleteBookmark(Bookmark bookmark);

    //[test 용] MainStore selectOneStore mapper
    MainStore selectOneStore(@Param("user_id") String user_id,
                             @Param("store_id") String store_id);
}
