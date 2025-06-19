package kr.co.ohgoodfood.controller.store;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import kr.co.ohgoodfood.dto.Store;
import kr.co.ohgoodfood.service.store.StoreService;

@Controller
public class StoreController {

	@Autowired
	private StoreService Storeservice;

	@GetMapping("/store/login")
	public String login() {
		return "store/login";
	}

	@PostMapping("/store/login")
	public String login(HttpSession sess, Store vo, Model model) {
		Store login = Storeservice.login(vo);
		if (login != null) {
			sess.setAttribute("store", login);
			model.addAttribute("msg", "로그인 성공");
			model.addAttribute("url", "/store/mypage");
			return "store/alert";
		} else {
			model.addAttribute("msg", "로그인 실패");
			model.addAttribute("url", "/store/login");
			return "store/login";
		}
	}

	@GetMapping
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

	@PostMapping("/store/signup")
	public String signup(Store vo, Model model) {
		int res = Storeservice.insert(vo);
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
	}
	@GetMapping("/store/viewsales")
    public String showViewSales() {
        return "store/viewsales";
    }

}
