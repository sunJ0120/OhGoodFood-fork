package kr.co.ohgoodfood.controller.common;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import kr.co.ohgoodfood.dto.Account;
import kr.co.ohgoodfood.dto.Store;
import kr.co.ohgoodfood.service.common.CommonService;
import kr.co.ohgoodfood.service.store.StoreService;
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
		String id = request.getParameter("id"); // 아이디 파라미터
		String pwd = request.getParameter("pwd");  // 비밀번호 파라미터
		Account account = commonService.loginAccount(id, pwd);
		if(account != null) {
			sess.setAttribute("user", account);
			model.addAttribute("user", account);
			return "/common/intro";
		}
		Store store = commonService.loginStore(id, pwd);
		if(store != null) {
			sess.setAttribute("store", store);
			model.addAttribute("store", store);
			return "/common/intro";
		}
		model.addAttribute("msg", "로그인 실패");
		model.addAttribute("url", "/login"); // [gaeun] 로그인 실패시 다시 로그인 창으로 이동
		return "store/alert";
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
