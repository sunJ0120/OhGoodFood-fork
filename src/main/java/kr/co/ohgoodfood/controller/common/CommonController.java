package kr.co.ohgoodfood.controller.common;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.co.ohgoodfood.dto.Account;
import kr.co.ohgoodfood.dto.KakaoUser;
import kr.co.ohgoodfood.dto.Store;
import kr.co.ohgoodfood.service.common.CommonService;
import kr.co.ohgoodfood.service.store.StoreService;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@PropertySource("classpath:db.properties")
public class CommonController {
	
	private final CommonService commonService;
	
	 @Value("${kakao.rest.apiKey}")
	 private String kakaoClientId;
	 
	 @Value("${kakao.redirect-uri}")
	 private String kakaoRedirectUri;
	
	// 로그인 페이지 리턴
	@GetMapping("/login") 
	public String login(Model model) {
		model.addAttribute("kakaoClientId", kakaoClientId);
		model.addAttribute("kakaoRedirectUri", kakaoRedirectUri);
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

	@GetMapping("/oauth/kakaocallback")
	public String kakaoCallback(@RequestParam("code") String code, HttpSession session) {
		// 카카오 로그인 클릭시 리다이렉트uri로 이동하고 code 받음
		//이 code로 가지고 access_token 요청
		KakaoUser kakaoUser = commonService.getKakaoUserInfo(code); 
		//code 넘겨서 access_token 받고 사용자 객체 저장
        if (kakaoUser == null) {
            return "redirect:/login";
        }
		Account account = commonService.autoLoginOrRegister(kakaoUser);
		//회원정보가 없으면 자동 회원가입, 있으면 해당 객체정보 리턴
		
        session.setAttribute("user", account);
        return "redirect:/user/main";
	}


}
