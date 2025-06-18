package kr.co.ohgoodfood.dto;

import lombok.Data;
import lombok.ToString;

//test 출력을 위해 ToString 추가
@ToString
@Data
public class Bookmark {
    private int bookmark_no;
    private String user_id;
    private String store_id;

    private int s_bookmark_no;
}
