package kr.co.ohgoodfood.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@ToString
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Bookmark extends MainStore{
    //Bookmark table에서 가져오는 정보들
    private Integer bookmark_no;
    private String user_id;
}
