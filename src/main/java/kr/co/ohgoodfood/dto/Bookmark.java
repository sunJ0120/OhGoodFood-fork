package kr.co.ohgoodfood.dto;

import lombok.Data;

@Data
public class Bookmark {
    private int bookmark_no;
    private String user_id;
    private String store_id;

    private int s_bookmark_no;
}
