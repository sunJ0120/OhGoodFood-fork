package kr.co.ohgoodfood.dto;
/*
Main과 Bookmark에서 가게 정보를 사용하기 위한 DTO 클래스
카드 안에 들어가는 모든 정보들을 한 번에 저장해서 사용한다.
 */
import lombok.Builder;
import lombok.Data;
import lombok.ToString;

import java.util.Date;

@ToString
@Data
@Builder //빌더 패턴 사용
public class MainStore {
    //Store table에서 가져오는 정보들
    private String store_name;
    private String store_menu;
    private Boolean store_status;
    private Boolean category_bakery;
    private Boolean category_fruit;
    private Boolean category_salad;
    private Boolean category_others;

    //Product table에서 가져오는 정보들
    private Date pickup_start;
    private Date pickup_end;
    int origin_price;
    int sale_price;

    //Image table에서 가져오는 정보들
    private String store_img;

    //Bookmark table에서 가져오는 정보들
    private int bookmark_no;

    //Bookmark 여부를 판단하기 위한 정보
    private Boolean is_bookmark;

    //차후 필요하다면 검색을 위한 컬럼들 추가 필요
}
