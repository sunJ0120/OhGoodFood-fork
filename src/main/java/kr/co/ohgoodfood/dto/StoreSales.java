package kr.co.ohgoodfood.dto;

import java.sql.Date;

import lombok.Data;

@Data
public class StoreSales {
	private String store_id;
    private int sales;
    private Date start_date;
    private Date end_date;
}
