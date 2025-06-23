package kr.co.ohgoodfood.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * [DTO] UserMainStoreFilter.java
 *
 * - Main에서 가게 정보를 사용할때, filtering을 위한 dto
 * - ajax 요청에서 들어가는 모든 정보를 여기에 넣어서 구성한다.
 */

@ToString
@Data
@AllArgsConstructor
@NoArgsConstructor
public class UserMainFilter {
    //카테고리 modal 토글
    private String category_bakery;
    private String category_fruit;
    private String category_salad;
    private String category_others;

    //예약 가능만 토글
    private String store_status;
    //오늘예약 & 내일 예약 토글
    //필터링 사용할때, LocalDate 사용하면 계속 에러나서 LocalDate 사용
    private LocalDate pickup_start;
    //검색어
    private String search;
}
