package kr.co.ohgoodfood.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

/**
 * [DTO] UserMainStoreFilter.java
 *
 * - Main에서 가게 정보를 사용할때, filtering을 위한 dto
 * - ajax 요청에서 들어가는 모든 정보를 여기에 넣어서 구성한다.
 */

@Data
@NoArgsConstructor
public class UserMainFilter {
    //지도에서 사용하기 위한 store_id
    private String store_id;

    //카테고리 modal 토글
    private String category_bakery;
    private String category_fruit;
    private String category_salad;
    private String category_others;

    //예약 가능만 토글
    private String store_status;

    //필터링 기본값은 1, 이하면 매진
    private int amount = 1;

    //오늘예약 & 내일 예약 토글
    //필터링 사용할때, LocalDate 사용하면 계속 에러나서 LocalDate 사용
    private LocalDate pickup_start;
    //[추가] 검색어
    private String search;

    //위도, 경도
    private Double latitude;
    private Double longitude;
}
