package kr.co.ohgoodfood.controller.store;

import java.beans.PropertyEditorSupport;
import java.sql.Time;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

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

	// 로그인 처리
	@PostMapping("/login")
	public String login(HttpSession sess, Store vo, Model model) {
		Store login = storeService.login(vo);
		if (login != null) {
			sess.setAttribute("store", login);
			model.addAttribute("msg", "로그인 성공");
			model.addAttribute("url", "/store/main");
			return "store/alert";
		} else {
			model.addAttribute("msg", "로그인 실패");
			model.addAttribute("url", "/store/login");
			return "store/login";
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
			return "store/alert";
		}
	}

	// 영업 시간
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
			// 로그인 안 되어 있으면 로그인 페이지로
			model.addAttribute("msg", "로그인이 필요합니다.");
			model.addAttribute("url", "/store/login");
			return "store/alert";
		}

		// 로그인 되어 있으면 viewsales.jsp로
		return "store/main";
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

		if (login == null) {
			// 로그인 안 되어 있으면 로그인 페이지로
			model.addAttribute("msg", "로그인이 필요합니다.");
			model.addAttribute("url", "/store/login");
			return "store/alert";
		}

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

		// 로그인 되어 있으면 updatemypage.jsp로
		return "store/updatemypage";
	}

}
