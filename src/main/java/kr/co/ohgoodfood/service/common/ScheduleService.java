package kr.co.ohgoodfood.service.common;

public interface ScheduleService {
    public void reservationCheck();
    public void reservationCheckBeforeOneHour();
    public void pickupCheck();
    public void pickupStartCheck();
}
