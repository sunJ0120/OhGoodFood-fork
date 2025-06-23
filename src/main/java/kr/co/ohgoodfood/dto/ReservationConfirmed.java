package kr.co.ohgoodfood.dto;

import java.time.LocalDateTime;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Data
public class ReservationConfirmed {

	private String store_id;
	private int order_no;
	private int product_no;
	private String user_id;
	private String order_status;
	private String store_status;
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private LocalDateTime reservation_end;
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private LocalDateTime pickup_end;
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private LocalDateTime pickup_start;
}
