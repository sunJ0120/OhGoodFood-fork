package kr.co.ohgoodfood.controller.users;

import kr.co.ohgoodfood.dto.Account;
import kr.co.ohgoodfood.dto.MainStore;
import kr.co.ohgoodfood.service.users.UsersService;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * UserController.java
 *
 * - User가 사용하는 모든 기능이 있는 Controller
 * - endpoint는 /user/**로 맞춘다.
 * - 의존성은 생성자 주입을 적용한다.
 */

/**
 * 🤔 고민중...
 * [sunjung] userMain에 Parameter로 BindingResult로 유효성 검사를 어떻게 넣을지 고민중입니다.
 */

@Controller
@RequestMapping("/user")
@Slf4j
@RequiredArgsConstructor
public class UsersController {
    private final UsersService usersService;

    @GetMapping("/main")
    public String userMain(MainStore mainStore, Model model, HttpServletRequest req){

        HttpSession session = req.getSession();

//        //세션에서 받아오는 로직
//        // store 단에서 store로 키값을 저장했으므로, user로 맞춘다.
//        Account loginUser = (Account) session.getAttribute("user");
//        String user_id = loginUser.getUser_id();

        //임시 하드코딩 값, 실제로는 세션에서 받아온다.
        String user_id = "u04";
        Map<String, String> emptyFilter = new HashMap<>(); //필터 조건이 없으므로 빈 맵을 넘긴다.

        List<MainStore> mainStoreList = usersService.getMainStoreList(user_id, emptyFilter);
        log.info("[log/UsersController.userMain] mainStoreList 결과 log : {}", mainStoreList);
        model.addAttribute("mainStoreList", mainStoreList);

        return "users/userMain"; // /WEB-INF/views/user/userMain.jsp로 forwarding
    }

    @PostMapping("/filter/store")
    public String filterStoreList(@RequestBody Map<String, String> filterParams, Model model){
        log.info("[log/UsersController.filterStoreList] 받은 필터 파라미터 결과 log : {}", filterParams);

        //임시 하드코딩 값, 실제로는 세션에서 받아온다.
        String user_id = "u04";

        List<MainStore> mainStoreList = usersService.getMainStoreList(user_id, filterParams);
        model.addAttribute("mainStoreList", mainStoreList);

        // JSP fragment만 리턴
        return "users/fragment/userMainStoreList";
    }
}
