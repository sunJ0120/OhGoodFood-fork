package kr.co.ohgoodfood.controller.users;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.SessionAttribute;

import kr.co.ohgoodfood.dto.Mypage;
import kr.co.ohgoodfood.service.users.MypageService;

public class MypageController {
	@RestController
	@RequestMapping("/api/mypage")
	public class MyPageRestController {
	    private final MypageService service;
	    public MyPageRestController(MypageService service) {
	        this.service = service;
	    }

	    @GetMapping
	    public Mypage getMypage(@SessionAttribute("user_id") String userId) {
	        return service.getMypage(userId);
	    }
	}
}
