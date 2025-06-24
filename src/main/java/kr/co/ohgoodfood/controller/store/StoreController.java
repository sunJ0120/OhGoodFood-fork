package kr.co.ohgoodfood.controller.store;

import java.time.LocalDate;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.ohgoodfood.dto.Orders;
import kr.co.ohgoodfood.dto.Review;
import kr.co.ohgoodfood.dto.Store;
import kr.co.ohgoodfood.dto.StoreSales;
import kr.co.ohgoodfood.service.store.StoreService;
import oracle.jdbc.proxy.annotation.Post;

@Controller
public class StoreController {

	@Autowired
	private StoreService storeService;

	@GetMapping("/store/logout")
	public String logout(HttpSession sess, Model model) {
		sess.invalidate();
		model.addAttribute("msg", "로그아웃 성공");
		model.addAttribute("url", "/store/login");
		return "store/alert"; 
	}

	@GetMapping("/store/signup")
	public String signup() {
		return "store/signup";
	}

	@GetMapping("/store/review")
	public String getReviews(HttpSession sess, Model model) {
		Store login = (Store) sess.getAttribute("store");
		if (login == null) {
			model.addAttribute("msg", "로그인이 필요합니다.");
			model.addAttribute("url", "/store/login");
			return "store/alert";
		}
		String storeId = login.getStore_id();
		List<Review> lists = storeService.getReviews(storeId);
		model.addAttribute("reviews", lists);
		
		return "store/review";
	}
	@GetMapping("/store/reservation") // main에서 order 탭을 눌렀을때 기본 미확정 주문 조회
	public String getReservationOrders(HttpSession sess, Model model) {
		
		Store login = (Store) sess.getAttribute("store");
		if (login == null) {
			model.addAttribute("msg", "로그인이 필요합니다.");
			model.addAttribute("url", "/store/login");
			return "store/alert";
		}
		//List<Orders> lists = storeService.getOrders(login.getStore_id(), "reservation");
		//System.out.println("lists 사이즈" + lists.size());
		//model.addAttribute("order", lists);
		return "/store/order";
		
	}
	// 이 밑에가 ajax 동적 처리 컨트롤러
	@PostMapping("/store/order/{status}")
	public String loadOrderByStatus(@PathVariable("status") String status, HttpSession session, Model model) {
	    
	    Store store = (Store) session.getAttribute("store");
	    if (store == null) {
	        return "store/alert"; 
	    }
	    List<Orders> orders = storeService.getOrders(store.getStore_id(), status);
	    
	    model.addAttribute("order", orders); 
	    System.out.println("서버 들어옴" + status);
	    System.out.println("컨트롤러에서 order 사이즈" + orders.size());
	    switch (status) {
	        case "reservation":
	        	System.out.println("reservation 컨트롤러 들어옴");
	            return "/store/fragments/reservation";
	        case "confirmed":
	        	System.out.println("confirm 컨트롤러 들어옴");
	            return "/store/fragments/confirmed";
	        case "cancel":
	        	System.out.println("cancel 컨트롤러 들어옴");
	            return "/store/fragments/cancel";
	        default:
	            return "/store/fragments/reservation"; 
	    }
	}
	
	
	
	@PostMapping("/store/reservation/{id}/confirm") // 미확정 탭에서 확정 버튼 클릭시
	@ResponseBody
	public String confirmOrders(@PathVariable("id") int id ,HttpSession sess, Model model) {
		Store login = (Store) sess.getAttribute("store");
		if (login == null) {
			model.addAttribute("msg", "로그인이 필요합니다.");
			model.addAttribute("url", "/store/login");
			return "store/alert";
		}
		int r = storeService.confirmOrders(id, "confirmed");
		if(r > 0) {
			int a = storeService.createUserAlarm(id, "confirmed");
			int b = storeService.createStoreAlarm(id, "confirmed");
			int c = storeService.createOrderCode(id, "confirmed");
			
			if(a > 0 && b > 0 && c > 0) {
				return "success";
			}
			return "failed";
		
		}else {
			return "failed";
		}
		
	}
	@PostMapping("/store/reservation/{id}/cancle") // 미확정 탭에서 취소 버튼 클릭시
	@ResponseBody
	public String cancleOrders(@PathVariable("id") int id, HttpSession sess, Model model) {
		Store login = (Store) sess.getAttribute("store");
		if (login == null) {
			model.addAttribute("msg", "로그인이 필요합니다.");
			model.addAttribute("url", "/store/login");
			return "store/alert";
		}
		int r = storeService.cancleOrders(id, "cancle");
		if(r > 0) {
			int a = storeService.createUserAlarm(id, "cancle");
			int b = storeService.createStoreAlarm(id, "cancle");
			if(a > 0 && b > 0) {
				return "success";
			}
			return "failed";
		
		}else {
			return "failed";
		}
	}
	
	@GetMapping("/store/confirmed") // 토글에서 확정주문 클릭시
	public String getConfirmedOrders(HttpSession sess, Model model) {
		Store login = (Store) sess.getAttribute("store");
		if (login == null) {
			model.addAttribute("msg", "로그인이 필요합니다.");
			model.addAttribute("url", "/store/login");
			return "store/alert";
		}
		//List<Orders> lists = storeService.getOrders(login.getStore_id(), "confirmed"); pickup도 가져와야함
		//List<Orders> lists = storeService.getOrders(login.getStore_id(), "confirmed");
		
		List<Orders> lists = storeService.getConfirmedOrPickupOrders(login.getStore_id());
		
		for(Orders order : lists) {
			if("pickup".equals(order.getOrder_status())) {
				order.setPickup_status("complete");
			}else {
				order.setPickup_status("today");
			}
		}
		model.addAttribute("order", lists);
		
		
		return "/store/confirmedorder";
	}
	
	@GetMapping("/store/cancled") // 토글에서 취소한 주문클릭시
	public String getCancledOrders(HttpSession sess, Model model) {
		Store login = (Store) sess.getAttribute("store");
		if (login == null) {
			model.addAttribute("msg", "로그인이 필요합니다.");
			model.addAttribute("url", "/store/login");
			return "store/alert";
		}
		List<Orders> lists = storeService.getOrders(login.getStore_id(), "cancle");
		model.addAttribute("order", lists);
		return "/store/cancledorder";
	}
	@PostMapping("/store/confirmed/{id}/pickup")
	@ResponseBody
	public String pickupOrders(@PathVariable("id") int id, HttpSession sess, Model model) {
		Store login = (Store) sess.getAttribute("store");
		if (login == null) {
			model.addAttribute("msg", "로그인이 필요합니다.");
			model.addAttribute("url", "/store/login");
			return "store/alert";
		}
		int r = storeService.pickupOrders(id, "pickup");
		if(r > 0) {
			int a = storeService.createUserAlarm(id, "pickup");
			int b = storeService.createStoreAlarm(id, "pickup");
			if(a > 0 && b > 0) {
				return "success";
			}
			return "failed";
		}else {
			return "failed";
		}
	}
	@PostMapping("/store/confirmed/{id}/confirmed")
	@ResponseBody
	public String confirmPickupOrders(@PathVariable("id") int id, HttpSession sess, Model model) {
		Store login = (Store) sess.getAttribute("store");
		if (login == null) {
			model.addAttribute("msg", "로그인이 필요합니다.");
			model.addAttribute("url", "/store/login");
			return "store/alert";
		}
		int r = storeService.confirmPickupOrders(id, "confirmed");
		if(r > 0) {
			int a = storeService.createUserAlarm(id, "confirmed");
			int b = storeService.createStoreAlarm(id, "confirmed");
			if(a > 0 && b > 0) {
				return "success";
			}
			return "failed";
		}else {
			return "failed";
		}
	}
	
	
	/*
	@PostMapping("/store/signup")
	public String signup(Store vo, Model model) {
		
		int res = storeService.insert(vo);
		String msg = "";
		String url = "";
		if (res > 0) {
			msg = "회원가입 성공";
			url = "/store/mypage";
		} else {
			msg = "회원가입 실패";
			url = "/store/signup";
		}
		model.addAttribute("msg", msg);
		model.addAttribute("url", url);
		return "store/alert";
	
	}*/

	// 메인화면
	@GetMapping("/store/main")
	public String showMain(HttpSession sess, Model model) {
		Store login = (Store) sess.getAttribute("store");

		if (login == null) {
			// 로그인 안 되어 있으면 로그인 페이지로
			model.addAttribute("msg", "로그인이 필요합니다.");
			model.addAttribute("url", "/store/login");
			return "store/alert";
		}

		// 로그인 되어 있으면 viewsales.jsp로
		return "store/main";
	}

	// 매출확인
	@GetMapping("/store/viewsales")
	public String showViewSales(HttpSession sess, Model model) {
		Store login = (Store) sess.getAttribute("store");

		if (login == null) {
			// 로그인 안 되어 있으면 로그인 페이지로
			model.addAttribute("msg", "로그인이 필요합니다.");
			model.addAttribute("url", "/store/login");
			return "store/alert";
		}
		LocalDate now = LocalDate.now();
	    LocalDate start = now.withDayOfMonth(1);
	    LocalDate end = now.withDayOfMonth(now.lengthOfMonth()).plusDays(1);
	    StoreSales vo = storeService.getSales(login.getStore_id(), start.toString(), end.toString());
	    vo.setStart_date(start.toString());
	    vo.setEnd_date(end.toString());
	    String month = vo.getStart_date().substring(5,7);
	    model.addAttribute("month", month);
	    model.addAttribute("vo", vo);
	    model.addAttribute("store", login);
		
		return "store/viewsales";
	}
	
	@PostMapping("/store/viewsales/{date}")
	@ResponseBody
	public StoreSales getDailySales(@PathVariable("date") String date, HttpSession session) {
	    Store login = (Store) session.getAttribute("store");
	    if (login == null) {
	        return null; 
	    }
	    
	    return storeService.getSales(login.getStore_id(), date, date); 
	    
	}

	// 알람
	@GetMapping("/store/alarm")
	public String showAlarm(HttpSession sess, Model model) {
		Store login = (Store) sess.getAttribute("store");

		if (login == null) {
			// 로그인 안 되어 있으면 로그인 페이지로
			model.addAttribute("msg", "로그인이 필요합니다.");
			model.addAttribute("url", "/store/login");
			return "store/alert";
		}

		// 로그인 되어 있으면 alarm.jsp로
		return "store/alarm";
	}
	//마이페이지
	@GetMapping("/store/mypage")
	public String showMypage(HttpSession sess, Model model) {
		Store login = (Store) sess.getAttribute("store");

		if (login == null) {
			// 로그인 안 되어 있으면 로그인 페이지로
			model.addAttribute("msg", "로그인이 필요합니다.");
			model.addAttribute("url", "/store/login");
			return "store/alert";
		}

		// 로그인 되어 있으면 mypage.jsp로
		return "store/mypage";
	}
	//마이페이지 수정
	@GetMapping("/store/updatemypage")
	public String updateMyPage(HttpSession sess, Model model) {
		Store login = (Store) sess.getAttribute("store");

		if (login == null) {
			// 로그인 안 되어 있으면 로그인 페이지로
			model.addAttribute("msg", "로그인이 필요합니다.");
			model.addAttribute("url", "/store/login");
			return "store/alert";
		}

		// 로그인 되어 있으면 updatemypage.jsp로
	    return "store/updatemypage";
	}

}
