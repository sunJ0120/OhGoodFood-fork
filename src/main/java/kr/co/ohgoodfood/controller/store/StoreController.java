package kr.co.ohgoodfood.controller.store;


import java.beans.PropertyEditorSupport;
import java.sql.Time;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import kr.co.ohgoodfood.dto.Orders;
import kr.co.ohgoodfood.dto.Review;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam; 
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.co.ohgoodfood.dto.Image;
import kr.co.ohgoodfood.dto.Product;

import kr.co.ohgoodfood.dto.Store;
import kr.co.ohgoodfood.dto.StoreSales;
import kr.co.ohgoodfood.service.store.StoreService;

import oracle.jdbc.proxy.annotation.Post;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;


@Controller
@RequestMapping("/store")
@Slf4j
@RequiredArgsConstructor
public class StoreController {



	private final StoreService storeService;

	@GetMapping("/jointype")
	public String jointype() {
		return "/common/jointype";
	}
	
	@GetMapping("/intro")
	public String intro() {
		return "/common/intro";
	}



	// 로그아웃
	@GetMapping
	public String logout(HttpSession sess, Model model) {
		sess.invalidate();
		model.addAttribute("msg", "로그아웃 성공");
		model.addAttribute("url", "/store/login");
		return "store/alert"; 
	}

	// 회원가입
	@GetMapping("/signup")
	public String showSignup() {
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

	// 회원가입 처리
	@PostMapping("/signup")
	public String signup(Store vo,
			@RequestParam("storeImage") MultipartFile[] storeImageFiles,
			@RequestParam("storeAddressDetail") String storeAddressDetail,
			HttpServletRequest request,
			Model model) {
		try {
			storeService.registerStore(vo, storeImageFiles, storeAddressDetail, request);
			model.addAttribute("msg", "회원가입이 성공적으로 완료되었습니다.");
			model.addAttribute("url", "/store/login");
			return "store/alert";
		} catch (Exception e) {
			model.addAttribute("msg", "회원가입 중 오류가 발생했습니다.");
			model.addAttribute("url", "/store/signup");
			e.printStackTrace();			
			return "store/alert";
		}
	}

	// Time 타입 변환용 바인딩(영업 시간)
	@InitBinder
	public void initBinder(WebDataBinder binder) {
		binder.registerCustomEditor(Time.class, new PropertyEditorSupport() {
			@Override
			public void setAsText(String text) throws IllegalArgumentException {
				try {
					// "HH:mm" → "HH:mm:ss"로 보정
					if (text != null && text.length() == 5) {
						text += ":00";
					}
					setValue(Time.valueOf(text));
				} catch (Exception e) {
					setValue(null);
				}
			}
		});
	}

	// 아이디 중복확인
	@GetMapping("/checkId")
	@ResponseBody
	public boolean checkId(@RequestParam("store_id") String store_id) {
		// true면 중복, false면 사용가능
		return storeService.isDuplicateId(store_id);
	}

	// 메인화면
	@GetMapping("/main")
	public String showMain(HttpSession sess, Model model) {
	    Store login = (Store) sess.getAttribute("store");

	    if (login == null) {
	        model.addAttribute("msg", "로그인이 필요합니다.");
	        model.addAttribute("url", "/store/login");
	        return "store/alert";
	    }

	    List<Image> images = storeService.getImagesByStoreId(login.getStore_id());
	    model.addAttribute("images", images);

	    Store store = storeService.getStoreDetail(login.getStore_id());
	    model.addAttribute("store", store);

	    Product product = storeService.getProductByStoreId(login.getStore_id());
	    model.addAttribute("product", product);

	    boolean isToday = false;
	    if (product != null && product.getPickup_start() != null) {
	        LocalDate pickupDate = product.getPickup_start().toLocalDateTime().toLocalDate();
	        LocalDate today = LocalDate.now();
	        isToday = pickupDate.equals(today);
	    }
	    model.addAttribute("isToday", isToday);

	    return "store/main";
	}

	@PostMapping("/updateStatus")
	@ResponseBody
	public String updateStatus(HttpSession session, @RequestParam("status") String status) {
	    Store store = (Store) session.getAttribute("store");
	    String store_id = store.getStore_id();

	    storeService.updateStoreStatus(store_id, status);

	    store.setStore_status(status);
	    session.setAttribute("store", store);
	    
	    return "success";
	}

	// 상품
	@GetMapping("/product")
	@ResponseBody
	public Product getProduct(HttpSession sess) {
	    Store login = (Store) sess.getAttribute("store");
	    if (login == null) {
	        return null;
	    }
	    return storeService.getProductByStoreId(login.getStore_id());
	}

	// 매출확인
	@GetMapping("/viewsales")
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
	@GetMapping("/alarm")
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

	// 마이페이지
	@GetMapping("/mypage")
	public String showMypage(HttpSession sess, Model model) {
		Store login = (Store) sess.getAttribute("store");

		Store store = storeService.getStoreDetail(login.getStore_id());
		model.addAttribute("store", store);

		// 오픈시간, 마감시간(시,분)
		Time openedTime = store.getOpened_at();
		Time closedTime = store.getClosed_at();

		String openedStr = openedTime.toLocalTime().format(DateTimeFormatter.ofPattern("HH:mm"));
		String closedStr = closedTime.toLocalTime().format(DateTimeFormatter.ofPattern("HH:mm"));

		model.addAttribute("openedTime", openedStr);
		model.addAttribute("closedTime", closedStr);

		// 카테고리
		List<String> categories = new ArrayList<>();
		if ("Y".equals(store.getCategory_bakery()))
			categories.add("빵 & 디저트");
		if ("Y".equals(store.getCategory_salad()))
			categories.add("샐러드");
		if ("Y".equals(store.getCategory_fruit()))
			categories.add("과일");
		if ("Y".equals(store.getCategory_others()))
			categories.add("그 외");

		model.addAttribute("categories", categories);

		// 로그인 되어 있으면 mypage.jsp로
		return "store/mypage";
	}

	// 마이페이지 수정
	@GetMapping("/updatemypage")
	public String updateMyPage(HttpSession sess, Model model) {
		Store login = (Store) sess.getAttribute("store");

		if (login == null) {
			// 로그인 안 되어 있으면 로그인 페이지로
			model.addAttribute("msg", "로그인이 필요합니다.");
			model.addAttribute("url", "/store/login");
			return "store/alert";
		}
		Store store = storeService.getStoreDetail(login.getStore_id());
		model.addAttribute("store", store);

		// 오픈시간, 마감시간(시,분)
		Time openedTime = store.getOpened_at();
		Time closedTime = store.getClosed_at();

		String openedStr = openedTime.toLocalTime().format(DateTimeFormatter.ofPattern("HH:mm"));
		String closedStr = closedTime.toLocalTime().format(DateTimeFormatter.ofPattern("HH:mm"));

		model.addAttribute("openedTime", openedStr);
		model.addAttribute("closedTime", closedStr);

		// 로그인 되어 있으면 updatemypage.jsp로
		return "store/updatemypage";
	}


	@PostMapping("/updatemypage")
	public String updateMyPagePost(HttpSession sess,
			@ModelAttribute Store store,
			Model model) {

		Store login = (Store) sess.getAttribute("store");
		if (login == null) {
			model.addAttribute("msg", "로그인이 필요합니다.");
			model.addAttribute("url", "/store/login");
			return "store/alert";
		}

		store.setStore_id(login.getStore_id());
		storeService.updateStoreCategory(store);

		model.addAttribute("msg", "정보가 수정되었습니다.");
		model.addAttribute("url", "/store/mypage");
		return "store/alert";
	}

}
