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
import kr.co.ohgoodfood.service.store.StoreService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/store")
@Slf4j
@RequiredArgsConstructor
public class StoreController {

	private final StoreService storeService;

	// 로그인
	@GetMapping("/login")
	public String login() {
		return "store/login";
	}

	//로그인 처리
	@PostMapping("/login")
	public String login(HttpSession sess, Store vo, Model model) {
	    Store login = storeService.login(vo);
	    if (login != null) {
	        if ("N".equals(login.getConfirmed())) {
	            return "store/loginconfirmed";
	        }
	        sess.setAttribute("store", login);
	        model.addAttribute("msg", "로그인 성공");
	        model.addAttribute("url", "/store/main");
	        return "store/alert";
	    } else {
	        model.addAttribute("msg", "로그인 실패");
	        model.addAttribute("url", "/store/login");
	        return "store/alert";
	    }
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

	// test
	@GetMapping("/test")
	public String showTest() {
		return "store/test";
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
	        LocalDate pickupDate = product.getPickup_start().toLocalDate();
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

		// 로그인 되어 있으면 viewsales.jsp로
		return "store/viewsales";
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
