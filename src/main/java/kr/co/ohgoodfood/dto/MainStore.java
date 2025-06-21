package kr.co.ohgoodfood.dto;

import lombok.*;

import java.sql.Time;
import java.util.Date;

/**
 * MainStore.java
 *
 * - Main과 Bookmark에서 가게 정보를 사용하기 위한 DTO 클래스
 * - 카드 안에 들어가는 모든 정보들을 한 번에 저장해서 사용한다.
 */
@ToString
@Data
@AllArgsConstructor
@NoArgsConstructor
public class MainStore {
    //Store table에서 가져오는 정보들
    private String store_id;
    private String store_name;
    private String store_menu;
    private String store_status;
    private String category_bakery;
    private String category_fruit;
    private String category_salad;
    private String category_others;
    private Time closed_at;

    //Product table에서 가져오는 정보들
    private int product_no;
    private Date pickup_start;
    private Date pickup_end;
    int origin_price;
    int sale_price;
    int amount;

    //Image table에서 가져오는 정보들
    private String store_img;

    //Bookmark table에서 가져오는 정보들
    private Integer bookmark_no;

    //Bookmark 여부를 판단하기 위한 정보
    private Boolean bookmark;

    //[추가 정보] DB에는 없는 추가 정보
    private String pickup_date; //오늘픽업인지 내일 픽업인지 마감인지를 저장
    private String category_name; //카테고리 이름 저장
    private String amount_time_tag; //수량이나 time 넣는 tag

    //차후 필요하다면 검색을 위한 컬럼들 추가 필요
}
