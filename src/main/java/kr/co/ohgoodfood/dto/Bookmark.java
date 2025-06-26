package kr.co.ohgoodfood.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Bookmark extends MainStore{
    //Bookmark table에서 가져오는 정보들
    private Integer bookmark_no;
    private String user_id;
}
