package kr.co.ohgoodfood.service.common;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.ohgoodfood.dao.AdminMapper;
import kr.co.ohgoodfood.dao.ScheduleMapper;
import kr.co.ohgoodfood.dto.Alarm;
import kr.co.ohgoodfood.dto.ReservationConfirmed;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ScheduleServiceImpl implements ScheduleService {

	private final ScheduleMapper scheduleMapper;
    private final AdminMapper adminMapper;


    // 예약 확정 스케쥴드
	@Scheduled(cron = "0 0,30 * * * ?")
	@Transactional
    @Override
	public void reservationCheck() {
		Date currentDate = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:00");
		String formattedDate = sdf.format(currentDate);

		// 금일 오픈한(예약) 가게 가져오기
		List<ReservationConfirmed> reservationStoreList = scheduleMapper.todayReservation(formattedDate);
		// 금일 오픈한(예약) 가게 상태 업데이트 ( Y --> N )
        // 사장님에게 확정 시간 종료 알람 보내기
		for (ReservationConfirmed store : reservationStoreList) {
			scheduleMapper.updateStoreStatus(store);
            Alarm alarm = new Alarm();
            alarm.setAlarm_title("확정 시간 종료");  
            alarm.setAlarm_contents("확정 시간이 종료되었습니다.");
            alarm.setReceive_id(store.getStore_id());
            alarm.setAlarm_displayed("Y");
            alarm.setAlarm_read("N");
            adminMapper.sendAlarm(alarm);
		}

		// 금일 예약 가게 주문 가져오기
		List<ReservationConfirmed> reservationOrderList = scheduleMapper.todayReservationOrder(formattedDate);
		// 금일 예약 가게 주문 상태 업데이트 ( reservation --> confirmed )
        // 유저에게 확정 알람 보내기
		for (ReservationConfirmed order : reservationOrderList) {
            order.setOrder_code((int)(Math.random() * 900000) + 100000);
			scheduleMapper.updateOrderStatus(order);
            Alarm alarm = new Alarm();
            alarm.setAlarm_title("예약 확정");  
            alarm.setAlarm_contents("예약 확정되었습니다.");
            alarm.setReceive_id(order.getUser_id());
            alarm.setAlarm_displayed("Y");
            alarm.setAlarm_read("N");
            adminMapper.sendAlarm(alarm);
		}
	}

    // 예약 확정 1시간 전 알림 스케쥴드
    @Scheduled(cron = "0 0,30 * * * ?")
	@Transactional
    @Override
	public void reservationCheckBeforeOneHour() {
        // 현재 시간 + 1시간
        Date currentDate = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:00");
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(currentDate);
        calendar.add(Calendar.HOUR_OF_DAY, 1);
        Date oneHourLater = calendar.getTime();
        String formattedOneHourLater = sdf.format(oneHourLater);

        // 현재 시간 + 1시간 이후 예약 가게 가져오기
        List<ReservationConfirmed> reservationStoreList = scheduleMapper.todayReservation(formattedOneHourLater);
        // 사장님에게 확정 시간 1시간 전 알람 보내기
        for (ReservationConfirmed store : reservationStoreList) {
            Alarm alarm = new Alarm();
            alarm.setAlarm_title("확정 임박");  
            alarm.setAlarm_contents("확정 마감 1시간 전입니다.");
            alarm.setReceive_id(store.getStore_id());
            alarm.setAlarm_displayed("Y");
            alarm.setAlarm_read("N");
            adminMapper.sendAlarm(alarm);
        }
	}

    // 픽업 시간 종료 스케쥴드
    @Scheduled(cron = "0 0,30 * * * ?")
	@Transactional
    @Override
	public void pickupCheck() {
		Date currentDate = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:00");
		String formattedDate = sdf.format(currentDate);
        // 픽업 안 된 주문 가져오기
        List<ReservationConfirmed> pickupNotDoneList = scheduleMapper.pickupNotDone(formattedDate);
        // 픽업 안 된 주문 상태 업데이트 ( reservation --> cancel )
        // 유저에게 픽업 안 된 주문 알람 보내기
        for (ReservationConfirmed order : pickupNotDoneList) {
            // 픽업 안 된 주문 상태 업데이트 ( reservation --> cancel )
            scheduleMapper.updateOrderStatusCancel(order);
            // 유저에게 픽업 안 된 주문 알람 보내기
            Alarm alarm = new Alarm();
            alarm.setAlarm_title("픽업 실패");  
            alarm.setAlarm_contents("픽업하지 못했습니다.");
            alarm.setReceive_id(order.getUser_id());
            alarm.setAlarm_displayed("Y");
            alarm.setAlarm_read("N");
            adminMapper.sendAlarm(alarm);
        }
	}

    //픽업 시작 알람 스케줄드
    @Scheduled(cron = "0 0,30 * * * ?")
	@Transactional
    @Override
	public void pickupStartCheck() {
		Date currentDate = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:00");
		String formattedDate = sdf.format(currentDate);
        // 픽업 안 된 주문 가져오기, 픽업 시간 시작 기준
        List<ReservationConfirmed> pickupNotDoneStartList = scheduleMapper.pickupNotDoneStart(formattedDate);
        // 유저에게 픽업 안 된 주문 알람 보내기
        for (ReservationConfirmed order : pickupNotDoneStartList) {
            Alarm alarm = new Alarm();
            alarm.setAlarm_title("픽업 시작");  
            alarm.setAlarm_contents("픽업 가능 시간이 되었습니다.");
            alarm.setReceive_id(order.getUser_id());
            alarm.setAlarm_displayed("Y");
            alarm.setAlarm_read("N");
            adminMapper.sendAlarm(alarm);
        }
	}
}
