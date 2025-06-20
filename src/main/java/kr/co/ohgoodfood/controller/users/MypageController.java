package kr.co.ohgoodfood.controller.users;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.SessionAttribute;
import kr.co.ohgoodfood.dto.Mypage;
import kr.co.ohgoodfood.service.users.MypageService;

@Controller                  // ← REST가 아니라 View를 반환할 컨트롤러
@RequestMapping("/mypage")   // URL 매핑
public class MypageController {
    private final MypageService service;

    public MypageController(MypageService service) {
        this.service = service;
    }

//    @GetMapping
//    public String mypage(@SessionAttribute("user_id") String userId, Model model){
//        // Service에서 DTO 가져와서 Model에 담기
//        Mypage dto = service.getMypage(userId);
//        model.addAttribute("Mypage", dto);
//        // → /WEB-INF/views/mypage.jsp 를 렌더링
//        return "users/userMypage";
//    }
    @GetMapping
    public String mypage(Model model) {
        // 세션 대신 하드코딩된 테스트용 사용자 ID
        String userId = "u02";

        Mypage dto = service.getMypage(userId);
        model.addAttribute("mypage", dto);
        return "users/userMypage";
    }
}
