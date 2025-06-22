package kr.co.ohgoodfood.controller.users;

import kr.co.ohgoodfood.dto.MainStore;
import kr.co.ohgoodfood.dto.UserMainFilter;
import kr.co.ohgoodfood.service.users.UsersService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * UsersController
 *
 * 사용자 페이지 전용 기능을 처리하는 컨트롤러입니다.
 * - GET  /user/main           : 사용자 메인 화면 조회
 * - POST /user/filter/store   : AJAX 기반 가게 목록 필터링
 *
 * @since 2025-06-22 : 필터에 Map이 아닌, DTO 필터 객체 적용
 */
@Controller
@RequestMapping("/user")
@Slf4j
@RequiredArgsConstructor
public class UsersController {
    private final UsersService usersService;

    /**
     * 사용자 메인 화면을 조회하고, 가게 목록을 뷰에 바인딩한다.
     *
     * @param userMainFilter 쿼리 파라미터로 전달된 필터 정보
     * @param model          뷰에 전달할 데이터(Model)
     * @param session        현재 HTTP 세션(로그인된 사용자 정보)
     * @return               포워딩할 JSP 뷰 이름 ("users/userMain")
     */
    @GetMapping("/main")
    public String userMain(@ModelAttribute UserMainFilter userMainFilter,
                           Model model,
                           HttpSession session){

//        //세션에서 받아오는 로직
//        // store 단에서 store로 키값을 저장했으므로, user로 맞춘다.
//        Account loginUser = (Account) session.getAttribute("user");
//        String user_id = loginUser.getUser_id();

        //임시 하드코딩 값, 실제로는 세션에서 받아온다.
        String user_id = "u04";
        List<MainStore> mainStoreList = usersService.getMainStoreList(user_id, userMainFilter);
        log.info("[log/UsersController.userMain] mainStoreList 결과 log : {}", mainStoreList);
        model.addAttribute("mainStoreList", mainStoreList);

        return "users/userMain"; // /WEB-INF/views/user/userMain.jsp로 forwarding
    }

    /**
     * AJAX 필터링 결과에 따른 가게 목록을 조회하고 뷰 프래그먼트만 반환한다.
     *
     * @param userMainFilter JSON 바디로 전달된 필터 정보 (필터 DTO에 자동 매핑)
     * @param model          뷰에 전달할 데이터(Model)
     * @param session        현재 HTTP 세션(로그인된 사용자 정보)
     * @return               가게 카드 목록만 포함한 JSP 프래그먼트 ("users/fragment/userMainStoreList")
     */
    @PostMapping("/filter/store")
    public String filterStoreList(@RequestBody UserMainFilter userMainFilter,
                                  Model model,
                                  HttpSession session){
        log.info("[log/UsersController.filterStoreList] 받은 필터 파라미터 결과 log : {}", userMainFilter);

        //임시 하드코딩 값, 실제로는 세션에서 받아온다.
        String user_id = "u04";

        List<MainStore> mainStoreList = usersService.getMainStoreList(user_id, userMainFilter);
        log.info("[log/UsersController.filterStoreList] filtering된 mainStoreList 결과 log : {}", mainStoreList);
        model.addAttribute("mainStoreList", mainStoreList);

        // JSP fragment만 리턴
        return "users/fragment/userMainStoreList";
    }
}
