package kr.co.ohgoodfood.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * [DTO] Bookmark
 *
 * - user가 가진 bookmark DTO
 * - Service로직을 사용하기 위해 MainStore를 상속받도록 구성한다.
 */

@Data
@NoArgsConstructor
public class Bookmark extends MainStore{
    //Bookmark table에서 가져오는 정보들
    private Integer bookmark_no;
    private String user_id;
}
