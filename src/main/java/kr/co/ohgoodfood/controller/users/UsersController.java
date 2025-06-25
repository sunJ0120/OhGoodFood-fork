package kr.co.ohgoodfood.controller.users;

import kr.co.ohgoodfood.dto.*;
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
import java.util.Collections;

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
 * - GET  /user/main/bookmark  : 해당 user_id가 가진 bookmark 목록 조회
 * - POST /user/main/bookmark  : 해당하는 bookmark
 *
 * @since 2025-06-22 : 필터에 Map이 아닌, DTO 필터 객체 적용
 * @since 2025-06-25 : 인터셉트로 로그인 정보 체크할 예정이라, 인터셉터에서 alert을 뿌려주는 방식이므로 따로 처리하지는 않은 상태
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
     * @return               포워딩할 JSP 뷰 이름 ("users/userMain")
     */
    @GetMapping("/main")
    public String userMain(@ModelAttribute UserMainFilter userMainFilter,
                           Model model){

        List<MainStore> mainStoreList = usersService.getMainStoreList(userMainFilter);
        log.info("[log/UsersController.userMain] mainStoreList 결과 log : {}", mainStoreList);
        model.addAttribute("mainStoreList", mainStoreList);

        return "users/userMain"; // /WEB-INF/views/user/userMain.jsp로 forwarding
    }

    /**
     * AJAX 필터링 결과에 따른 가게 목록을 조회하고 뷰 프래그먼트만 반환한다.
     *
     * @param userMainFilter JSON 바디로 전달된 필터 정보 (필터 DTO에 자동 매핑)
     * @param model          뷰에 전달할 데이터(Model)
     * @return               가게 카드 목록만 포함한 JSP 프래그먼트 ("users/fragment/userMainStoreList")
     */
    @PostMapping("/filter/store")
    public String filterStoreList(@RequestBody UserMainFilter userMainFilter,
                                  Model model){
        log.info("[log/UsersController.filterStoreList] 받은 필터 파라미터 결과 log : {}", userMainFilter);

        List<MainStore> mainStoreList = usersService.getMainStoreList(userMainFilter);
        log.info("[log/UsersController.filterStoreList] filtering된 mainStoreList 결과 log : {}", mainStoreList);
        model.addAttribute("mainStoreList", mainStoreList);
        // JSP fragment만 리턴
        return "users/fragment/userMainStoreList";
    }

    /**
     * 해당 user가 가진 북마크 리스트를 조회한다.
     *
     * @param userMainFilter JSON 바디로 전달된 필터 정보 (필터 DTO에 자동 매핑)
     * @param model          뷰에 전달할 데이터(Model)
     * @param session        현재 HTTP 세션(로그인된 사용자 정보)
     * @return               users/userBookmark.jsp로 포워딩
     */
    @GetMapping("/bookmark")
    public String userBookmark(@ModelAttribute UserMainFilter userMainFilter,
                               Model model,
                               HttpSession session){

//        //세션에서 받아오는 로직
//        // store 단에서 store로 키값을 저장했으므로, user로 맞춘다.
//        Account loginUser = (Account) session.getAttribute("user");
//        String user_id = loginUser.getUser_id();

        //임시 하드코딩 값, 실제로는 세션에서 받아온다.
        String user_id = "u01";
        //bookmark를 위해 user_id 세팅

        List<Bookmark> bookmarkList = usersService.getBookmarkList(user_id);
        log.info("[log/UsersController.userBookmark] user_id가 가진 userBookmark 결과 log : {}", bookmarkList);
        model.addAttribute("bookmarkList", bookmarkList);

        return "users/userBookmark"; // /WEB-INF/views/users/userBookmark.jsp로 forwarding
    }

    /**
     * 해당 user가 가진 북마클 리스트 중, 특정 북마크를 삭제한다.
     *
     * @param bookmarkDelete bookMark delete에 필요한 필드 정보가 담긴 DTO
     * @param model          뷰에 전달할 데이터(Model)
     * @param session        현재 HTTP 세션(로그인된 사용자 정보)
     * @return               json 응답, 성공시 {"code" : 200} / 실패시 {"code" : 500}
     */
    @PostMapping("/bookmark")
    @ResponseBody //json으로 code응답을 주기 위함이다.
    public Map<String,Integer> userBookmarkDelete(@RequestBody BookmarkDelete bookmarkDelete,
                                                  Model model,
                                                  HttpSession session){

//        //세션에서 받아오는 로직
//        // store 단에서 store로 키값을 저장했으므로, user로 맞춘다.
//        Account loginUser = (Account) session.getAttribute("user");
//        String user_id = loginUser.getUser_id();

        //임시 하드코딩 값, 실제로는 세션에서 받아온다.
        String user_id = "u01";
        //bookmark를 위해 user_id 세팅
        bookmarkDelete.setUser_id(user_id);

        //delete bookmark 실행
        boolean result = usersService.deleteUserBookMark(bookmarkDelete);
        return Collections.singletonMap("code", result ? 200 : 500);
    }

    //현재 jsp 연결 확인 완료.
    @GetMapping("/orderList")
    public String userOrderList(@ModelAttribute UserOrderFilter userOrderFilter,
                                Model model,
                                HttpSession session){
//        //세션에서 받아오는 로직
//        // store 단에서 store로 키값을 저장했으므로, user로 맞춘다.
//        Account loginUser = (Account) session.getAttribute("user");
//        String user_id = loginUser.getUser_id();

        //임시 하드코딩 값, 실제로는 세션에서 받아온다.
        String user_id = "u01";

        userOrderFilter.setUser_id(user_id); //필터에 id값 추가
        List<UserOrder> userOrderList = usersService.getUserOrderList(userOrderFilter);
        log.info("[log/UsersController.userOrderList] user_id가 가진 userOrderList 결과 log : {}", userOrderList);
        model.addAttribute("userOrderList", userOrderList);

        return "users/userOrders";
    }

    /**
     * AJAX 필터링 결과에 따른 주문 목록을 조회하고 뷰 프래그먼트만 반환한다.
     *
     * @param userOrderFilter JSON 바디로 전달된 필터 정보 (필터 DTO에 자동 매핑)
     * @param model          뷰에 전달할 데이터(Model)
     * @return               가게 주문 목록만 포함한 JSP 프래그먼트 ("users/fragment/userOrderList")
     */
    @PostMapping("/filter/order")
    public String filterOrderList(@RequestBody UserOrderFilter userOrderFilter,
                                  Model model,
                                  HttpSession session){
//        //세션에서 받아오는 로직
//        // store 단에서 store로 키값을 저장했으므로, user로 맞춘다.
//        Account loginUser = (Account) session.getAttribute("user");
//        String user_id = loginUser.getUser_id();

        //임시 하드코딩 값, 실제로는 세션에서 받아온다.
        String user_id = "u01";

        userOrderFilter.setUser_id(user_id); //필터에 id값 추가
        List<UserOrder> userOrderList = usersService.getUserOrderList(userOrderFilter);
        log.info("[log/UsersController.userOrderList] user_id가 가진 userOrderList 결과 log : {}", userOrderList);
        model.addAttribute("userOrderList",userOrderList);
        // JSP fragment만 리턴
        return "users/fragment/userOrderList";
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
        return "users/userProductDetail";
        
        
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
        return "users/userReviewList";  // reviewList
    }
}
