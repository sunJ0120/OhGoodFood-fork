package kr.co.ohgoodfood.controller.store;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import kr.co.ohgoodfood.dto.Review;
import kr.co.ohgoodfood.dto.Store;
import kr.co.ohgoodfood.service.store.StoreService;

@Controller
public class StoreController {

	@Autowired
	private StoreService Storeservice;
	
	
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
	
	
	@GetMapping("/store/review")
	public String review(Store vo ) {
		Review review= Storeservice.viewRiew(vo);
		return null;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
