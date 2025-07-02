package kr.co.ohgoodfood.controller.common;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import kr.co.ohgoodfood.dto.Account;
import kr.co.ohgoodfood.dto.Store;
import kr.co.ohgoodfood.service.common.CommonService;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class CommonController {
	
	private final CommonService commonService;
	
	// 로그인 페이지 리턴
	@GetMapping("/login") 
	public String login() {
		return "common/login";
	}
	
	@PostMapping("/login")
	public String login(HttpServletRequest request, HttpSession sess, Model model) {
		String id = request.getParameter("id"); // 아이디 파라미터로
		String pwd = request.getParameter("pwd"); // 비번 파라미터로 가져옴
		sess.invalidate();
		sess = request.getSession(true);
		Account account = commonService.loginAccount(id, pwd);
		if (account != null) {
			sess.setAttribute("user", account);
			model.addAttribute("user", account);
			return "/common/intro";
		}

		Store store = commonService.loginStore(id, pwd);
		if (store != null) {
			if ("N".equals(store.getConfirmed())) {
				sess.setAttribute("store", store);
				model.addAttribute("showConfirmationModal", true);
           		return "common/login";
			}
			sess.setAttribute("store", store);
			model.addAttribute("store", store);
			return "/common/intro";
		}

		model.addAttribute("msg", "아이디 또는 비밀번호가 일치하지 않습니다.");
		model.addAttribute("url", "/login");
		return "store/alert";
	}

	// 로그아웃
	@GetMapping("/logout") 
	public String logout(HttpSession session) {
		session.invalidate();                    // 세션 무효화
		return "redirect:/login";                // 로그인 페이지로 리다이렉트
	}

	@GetMapping("/jointype") // 회원가입 유형 선택 페이지
	public String jointype() {
		return "/common/jointype";
	}
	
	@GetMapping("/intro") // 인트로 페이지
	public String intro() {
		return "/common/intro";
	}
}
