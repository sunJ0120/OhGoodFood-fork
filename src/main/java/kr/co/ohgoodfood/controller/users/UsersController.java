package kr.co.ohgoodfood.controller.users;

import kr.co.ohgoodfood.dto.Account;
import kr.co.ohgoodfood.dto.MainStore;
import kr.co.ohgoodfood.dto.ProductDetail;
import kr.co.ohgoodfood.dto.Review;
import kr.co.ohgoodfood.dto.UserMainFilter;
import kr.co.ohgoodfood.dto.UserMypage;
import kr.co.ohgoodfood.dto.UserSignup;
import kr.co.ohgoodfood.service.users.UsersService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

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
    /**
     *  사용자 회원가입
     */
    /**  회원가입 폼 보여주기 */
    @GetMapping("/signup")
    public String showSignupForm() {
        return "users/userSignup";  // /WEB-INF/views/users/userSignup.jsp
    }

    /** AJAX 아이디 중복 확인 */
    @GetMapping("/checkId")
    @ResponseBody
    public boolean checkId(@RequestParam("user_id") String userId) {
        return usersService.isDuplicateId(userId);
    }
    /**  실제 회원가입 처리 */
    @PostMapping("/signup")
    public String signup(
            @ModelAttribute Account account,
            Model model
    ) {
        // 서버 측 중복 재검증
        if (usersService.isDuplicateId(account.getUser_id())) {
            model.addAttribute("msg", "이미 사용 중인 아이디입니다.");
            model.addAttribute("url", "/user/signup");
            return "users/alert";
        }

        try {
        	usersService.registerUser(account);
            model.addAttribute("msg", "회원가입이 성공적으로 완료되었습니다.");
            model.addAttribute("url", "/user/login");
        } catch (Exception e) {
            model.addAttribute("msg", "회원가입 중 오류가 발생했습니다.");
            model.addAttribute("url", "/user/signup");
        }
        return "users/alert";
    }

    /**
     *  사용자 마이페이지 조회
     *
     */
    
    @GetMapping("/mypage")
    public String userMypage(Model model, HttpSession session) {
        String userId = (String) session.getAttribute("user_id");
        if (userId == null) userId = "u10";

        UserMypage page = usersService.getMypage(userId);
        model.addAttribute("userMypage", page);
        return "users/userMypage";
        
    }
    /**
     * 제품 상세보기
     * URL: /user/productdetail?product_no=123
     */
    @GetMapping("/productDetail")
    public String productDetail(
            @RequestParam("product_no") int product_no,
            Model model
    ) {
        // productService → usersService 로 교체
        ProductDetail detail = usersService.getProductDetail(product_no);       
        model.addAttribute("productDetail", detail);
        return "users/productDetail";
        
        
    }

    /**
     * POST /user/productdetail
     * (GET과 같은 URL, HTTP 메서드만 POST로 분기)
     */
    @PostMapping("/productDetail")
    public String reserve(
            @RequestParam("product_no") int product_no,
            HttpSession session,
            RedirectAttributes redirectAttrs
    ) {
        String userId = (String) session.getAttribute("user_id");
        if (userId == null) {
            redirectAttrs.addFlashAttribute("error", "로그인이 필요합니다.");
            return "redirect:/login";
        }

        // 여기 역시 productService → usersService 로
        boolean success = usersService.reserveProduct(userId, product_no);
        if (success) {
            redirectAttrs.addFlashAttribute("msg", "예약이 완료되었습니다.");
        } else {
            redirectAttrs.addFlashAttribute("error", "예약에 실패했습니다.");
        }
        return "redirect:/user/productDetail?product_no=" + product_no;
    }
    /**
     * 하단 메뉴바 Review 페이지
     */
    @GetMapping("/reviewList")
    public String listReviews(Model model) {
    	List<Review> review = usersService.getAllReviews();
    	model.addAttribute("review", review);
        return "users/reviewList";  // reviewList
    }
}
