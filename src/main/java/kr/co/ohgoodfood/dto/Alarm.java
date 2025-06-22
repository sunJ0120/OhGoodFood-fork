package kr.co.ohgoodfood.dto;

import java.util.Date;

import lombok.Data;

@Data
public class Alarm {
    private int alarm_no;
    private String alarm_title;
    private String alarm_contents;
    private Date sended_at;
    private String alarm_displayed;
    private String receive_id;
    private String alarm_read;

    private int s_alarm_no;
    private String s_receive_id;

    private String s_type;
    private String s_value;

    private int page;
    private int startIdx;

    public Alarm() {
        this.page = 1;
    }
    
    public int getStartIdx() {
        return (page - 1) * 10;
    }
}