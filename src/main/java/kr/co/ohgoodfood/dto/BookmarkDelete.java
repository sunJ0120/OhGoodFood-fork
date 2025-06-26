package kr.co.ohgoodfood.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * [DTO] BookmarkDelete
 *
 * - user가 가진 bookmark를 삭제하기 위해 필요한 정보 모음
 * - 유효성 검증을 위해 DTO로 따로 분리하였다.
 */

@Data
@NoArgsConstructor
public class BookmarkDelete {
    private int bookmark_no;
    private String user_id;
}
