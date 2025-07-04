package kr.co.ohgoodfood.dto;

import java.util.List;

import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * [DTO] MainStore
 *
 * - Main에 나오는 가게 정보 카드를 사용하기 위한 DTO 클래스
 * - 카드 안에 들어가는 모든 정보들을 한 번에 저장해서 사용한다.
 */

@Data
@NoArgsConstructor
public class MainStoreDTO {
    //Store table에서 가져오는 정보들
    private Store store;
    //Product table에서 가져오는 정보들
    private Product product;
    //Image table에서 가져오는 정보들
    private Image image;

    //[추가 정보] DB에는 없는 추가 정보
    private PickupStatus pickup_status; //오늘픽업인지 내일 픽업인지 마감인지를 저장
    private List<String> category_list; //카테고리 리스트 저장
    private List<String> mainmenu_list; //store_menu -> 메인메뉴 리스트 저장

    //[추가 정보] 검색용 상세정보
    private String product_explain; //검색용, 상품 상세

    //[추가 정보] 세션 체크를 위한 정보
    private String user_id;
}
