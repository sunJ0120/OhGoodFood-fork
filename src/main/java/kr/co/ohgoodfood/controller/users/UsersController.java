package kr.co.ohgoodfood.controller.users;

import java.util.Collections;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import kr.co.ohgoodfood.dto.*;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.co.ohgoodfood.service.common.CommonService;
import kr.co.ohgoodfood.service.common.PayService;
import kr.co.ohgoodfood.service.users.UsersService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * UsersController
 *
 * 사용자 페이지 전용 기능을 처리하는 컨트롤러입니다.
 * - POST /user/signup	              : 사용자 회원가입 페이지
 * - GET  /user/main                  : 사용자 메인 화면 조회
 * - POST /user/filter/store          : AJAX 기반 가게 목록 필터링
 * - GET  /user/bookmark              : 해당 user_id가 가진 bookmark 목록 조회
 * - POST /user/bookmark/delete       : 해당하는 bookmark 삭제
 * - POST /user/bookmark/insert       : 해당하는 bookmark 추가
 * - GET  /user/main/orderList        : 유저가 가진 orderList 목록 조회
 * - POST /user/filter/order          : AJAX 기반 오더 목록 필터링
 * - POST /user/order/cancel          : 유저가 선택한 오더 주문 취소
 * - GET  /user/map/pin               : AJAX 기반 핀으로 선택한 스토어 fragment 조회
 * - GET  /user/mypage                : 유저 mypage 이동
 * - GET  /user/reviewList            : 하단 메뉴바 Review탭 이동시 전체 리뷰 목록 조회
 *
 */
@Controller
@RequestMapping("/user")
@Slf4j
@RequiredArgsConstructor
public class UsersController {
    private final UsersService usersService;
    private final CommonService commonService;
    private final PayService payService;

    // 지도 사용을 위한 앱키
    @Value("${kakao.map.appKey}")
    private String kakaoMapAppKey;

    /**
     * 사용자 메인 화면을 조회하고, 가게 목록을 뷰에 바인딩한다.
     *
     * @param userMainFilter 요청 파라미터와 바인딩되어 뷰로 전달되는 DTO
     * @param model          뷰에 전달할 데이터(Model)
     * @return               포워딩할 JSP 뷰 이름 ("users/userMain")
     */
    @GetMapping("/main")
    public String userMain(@ModelAttribute UserMainFilter userMainFilter,
                           Model model){

        List<MainStore> mainStoreList = usersService.getMainStoreList(userMainFilter);
        model.addAttribute("kakaoMapAppKey", kakaoMapAppKey);
        model.addAttribute("mainStoreList", mainStoreList);

        return "users/userMain";
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

        List<MainStore> mainStoreList = usersService.getMainStoreList(userMainFilter);
        model.addAttribute("mainStoreList", mainStoreList);
        // JSP fragment만 리턴
        return "users/fragment/userMainStoreList";
    }

    /**
     * 해당 user가 가진 북마크 리스트를 조회한다.
     *
     * @param userMainFilter 요청 파라미터와 바인딩되어 뷰로 전달되는 DTO
     * @param model          뷰에 전달할 데이터(Model)
     * @param session        현재 HTTP 세션(로그인된 사용자 정보)
     * @return               users/userBookmark.jsp로 포워딩
     */
    @GetMapping("/bookmark")
    public String userBookmark(@ModelAttribute UserMainFilter userMainFilter,
                               Model model,
                               HttpSession session){

        //세션에서 받아오는 로직
        Account loginUser = (Account) session.getAttribute("user");
        String user_id = loginUser.getUser_id();

        List<Bookmark> bookmarkList = usersService.getBookmarkList(user_id);
        model.addAttribute("bookmarkList", bookmarkList);

        return "users/userBookmark"; // /WEB-INF/views/users/userBookmark.jsp로 forwarding
    }

    /**
     * 해당 user가 가진 북마크 리스트 중, 특정 북마크를 삭제한다.
     *
     * @param bookmarkFilter bookMark delete에 필요한 필드 정보가 담긴 DTO
     * @param model          뷰에 전달할 데이터(Model)
     * @param session        현재 HTTP 세션(로그인된 사용자 정보)
     * @return               json 응답, 성공시 {"code" : 200} / 실패시 {"code" : 500}
     */
    @PostMapping("/bookmark/delete")
    @ResponseBody //json으로 code응답을 주기 위함이다.
    public Map<String,Integer> userBookmarkDelete(@RequestBody BookmarkFilter bookmarkFilter,
                                                  Model model,
                                                  HttpSession session){
        //세션에서 받아오는 로직
        Account loginUser = (Account) session.getAttribute("user");
        String user_id = loginUser.getUser_id();

        //bookmark를 위해 user_id 세팅
        bookmarkFilter.setUser_id(user_id);

        //delete bookmark 실행
        boolean result = usersService.deleteUserBookMark(bookmarkFilter);
        return Collections.singletonMap("code", result ? 200 : 500);
    }

    /**
     * 해당 user가 가진 북마클 리스트에서 삭제 된 것을 살리기 위함이다.
     *
     * @param bookmarkFilter bookMark delete에 필요한 필드 정보가 담긴 DTO
     * @param model          뷰에 전달할 데이터(Model)
     * @param session        현재 HTTP 세션(로그인된 사용자 정보)
     * @return               json 응답, 성공시 {"code" : 200} / 실패시 {"code" : 500}
     */
    @PostMapping("/bookmark/insert")
    @ResponseBody //json으로 code응답을 주기 위함이다.
    public Map<String,Integer> userBookmarkInsert(@RequestBody BookmarkFilter bookmarkFilter,
                                                  Model model,
                                                  HttpSession session){
        //세션에서 받아오는 로직
        Account loginUser = (Account) session.getAttribute("user");
        String user_id = loginUser.getUser_id();

        //bookmark를 위해 user_id 세팅
        bookmarkFilter.setUser_id(user_id);

        //delete bookmark 실행
        boolean result = usersService.insertUserBookMark(bookmarkFilter);
        return Collections.singletonMap("code", result ? 200 : 500);
    }

    /**
     * 세션에 있는 유저가 가진 주문 목록을 조회한다.
     *
     * @param userOrderFilter 요청 파라미터와 바인딩되어 뷰로 전달되는 DTO
     * @param model           뷰에 전달할 데이터(Model)
     * @param session         현재 HTTP 세션(로그인된 사용자 정보)
     * @return                users/userOrders.jsp로 포워딩
     */
    @GetMapping("/orderList")
    public String userOrderList(@ModelAttribute UserOrderFilter userOrderFilter,
                                Model model,
                                HttpSession session){

        Account loginUser = (Account) session.getAttribute("user");
        String user_id = loginUser.getUser_id();

        userOrderFilter.setUser_id(user_id); //필터에 id값 추가
        List<UserOrder> userOrderList = usersService.getUserOrderList(userOrderFilter);

        model.addAttribute("userOrderList", userOrderList);

        return "users/userOrders";
    }

    /**
     * AJAX 필터링 결과에 따른 주문 목록을 조회하고 뷰 프래그먼트만 반환한다.
     *
     * @param userOrderFilter JSON 바디로 전달된 필터 정보 (필터 DTO에 자동 매핑)
     * @param model           뷰에 전달할 데이터(Model)
     * @param session         현재 HTTP 세션(로그인된 사용자 정보)
     * @return                필터링 된 가게 주문 목록만 포함한 JSP 프래그먼트 ("users/fragment/userOrderList")
     */
    @PostMapping("/filter/order")
    public String filterOrderList(@RequestBody UserOrderFilter userOrderFilter,
                                  Model model,
                                  HttpSession session){
        //세션에서 받아오는 로직
        Account loginUser = (Account) session.getAttribute("user");
        String user_id = loginUser.getUser_id();

        userOrderFilter.setUser_id(user_id); //필터에 id값 추가
        List<UserOrder> userOrderList = usersService.getUserOrderList(userOrderFilter);
        model.addAttribute("userOrderList",userOrderList);

        return "users/fragment/userOrderList";
    }

    /**
     * 세션에 있는 유저가 가진 주문 목록중 선택한 것을 취소한다.
     *
     * @param userOrderRequest 요청 파라미터와 바인딩되어 뷰로 전달되는 DTO
     * @param session          현재 HTTP 세션(로그인된 사용자 정보)
     * @return                 PRG : /user/orderList 로 리다이렉트
     */
    @PostMapping("/order/cancel")
    public String cancelOrder(@ModelAttribute UserOrderRequest userOrderRequest,
                              HttpSession session,
                              RedirectAttributes redirectAttributes){

        Account loginUser = (Account) session.getAttribute("user");
        String user_id = loginUser.getUser_id();

        userOrderRequest.setUser_id(user_id);

        //주문 취소의 경우는, 두 테이블을 UPDATE 하므로 @Transactional 처리, 그러므로 예외처리해준다.
        try {
            usersService.updateUserOrderCancel(userOrderRequest);
            redirectAttributes.addFlashAttribute("msg", "주문이 정상적으로 취소되었습니다.");
        } catch (IllegalStateException e) {
            // 트랜잭션은 exception 던졌을 때 롤백됨
            redirectAttributes.addFlashAttribute("errorMsg", "[ERROR!] 주문 취소에 실패했습니다.");
        }
        return "redirect:/user/orderList";
    }

    /**
     * map에서 pin 선택한 가게의 정보를 AJAX로 조회하고 뷰 프래그먼트만 반환한다.
     *
     * @param userMainFilter JSON 바디로 전달된 필터 정보 (필터 DTO에 자동 매핑)
     * @return               가게 정보를 포함한 JSP 프래그먼트 ("users/fragment/userMapPinStore")
     */
    @GetMapping("/map/pin")
    public String getMapPinStore(@ModelAttribute UserMainFilter userMainFilter,
                                 Model model){

        MainStore mainStore = usersService.getMainStoreOne(userMainFilter);
        model.addAttribute("mainStore", mainStore);

        //fragment return
        return "users/fragment/userMapPinStore";
    }

    /**
     *  사용자 회원가입
     */
    /**  회원가입 폼 보여주기 */
    @GetMapping("/signup")
    public String showSignupForm() {
        return "users/userSignup"; 
    }

    /** 아이디 중복 확인 */
    @GetMapping("/checkId")
    @ResponseBody
    public boolean checkId(@RequestParam("user_id") String userId) {
        return usersService.isDuplicateId(userId);
    }
    /** 회원가입 처리 */
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
            model.addAttribute("url", "/login");
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
    	
        // String userId = (String) session.getAttribute("user_id");
        // if (userId == null) userId = "u10"; // 임시 하드코딩값
        // 세션에서 user_id 가져오기
        Account loginUser = (Account) session.getAttribute("user");
        String user_id = loginUser.getUser_id();

        UserMypage page = usersService.getMypage(user_id);
        model.addAttribute("userMypage", page);
        return "users/userMypage";
        
    }
    /**
     * 제품 상세보기
     */
    @GetMapping("/productDetail")
    public String productDetail(
            @RequestParam("product_no") int product_no,
            HttpSession session,
            Model model
    ) {
    	
        ProductDetail detail = usersService.getProductDetail(product_no);
        
        List<String> images = usersService.getProductImages(product_no);
        model.addAttribute("images", images);
        
        // 세션에서 로그인한 사용자 정보 가져오기
        Account loginUser = (Account) session.getAttribute("user");

        boolean isBookmarked = false;
        if (loginUser != null) {
            String user_id = loginUser.getUser_id();
            String store_id = detail.getStore_id();
            isBookmarked = usersService.isBookmarked(user_id, store_id);  // 북마크 여부 조회
        }
        detail.setBookmarked(isBookmarked);  // 실제 여부 세팅
        model.addAttribute("productDetail", detail);
        
        List<Review> reviews = usersService.getReviewsByProductNo(product_no);
        model.addAttribute("reviews", reviews);
        return "users/userProductDetail";
        
    }

    /**
     * 하단 메뉴바 Review 페이지
     */
    @GetMapping("/reviewList")
    public String listReviews(Model model) {
        List<Review> reviews = usersService.getAllReviews(1, Integer.MAX_VALUE);
        model.addAttribute("reviews", reviews);
        return "users/userReviewList";  
    }
    
    /**
     * 확정 주문내역 -> 리뷰쓰기
     */
    // GET : 주문번호로 화면용 DTO 꺼내서 JSP에 바인딩
    @GetMapping("/reviewWrite")
    public String showReviewForm(@RequestParam("order_no") int orderNo,
                                 Model model) {
        ReviewForm form = usersService.getReviewForm(orderNo);
        model.addAttribute("reviewForm", form);
        return "users/userReviewWrite";
    }


    /**
     * 결제 페이지
     */

    @PostMapping("/userPaid")
    public String userPaid(@RequestParam("productNo") int productNo, Model model, HttpSession session) {
        ProductDetail detail = usersService.getProductDetail(productNo);
        detail.setStore_img(usersService.getStoreImg(detail.getStore_id()));
        model.addAttribute("productDetail", detail);
        model.addAttribute("userPoint", usersService.getUserPoint(((Account)session.getAttribute("user")).getUser_id()));
        return "users/userPaid";
    }

    /**
     * 결제 실패 페이지
     */
    @GetMapping("/paidfail")
    public String paidfail(@RequestParam("orderId") String orderId, Model model, HttpSession session) {
        int orderNo = payService.getOrderNoByPaidCode(orderId);
        model.addAttribute("orderNo", orderNo);
        return "users/paidfail";
    }


    // POST : 폼 제출 → DTO에 user_id 세팅 → 서비스 호출 → 마이페이지로 리다이렉트
    @PostMapping("/review/submit")
    public String submitReview(@ModelAttribute ReviewForm reviewForm,
                               HttpSession session) {
        String userId = ((Account)session.getAttribute("user")).getUser_id();
        reviewForm.setUser_id(userId);
        usersService.writeReview(reviewForm, userId);
        return "redirect:/user/mypage";
    }

    /**
     * 알람 페이지
     */
    @GetMapping("/alarm")
    public String showAlarm(Model model, HttpSession session) {
        Account loginUser = (Account) session.getAttribute("user");
        String user_id = loginUser.getUser_id();
        List<Alarm> alarms = commonService.getAlarm(user_id);
        model.addAttribute("alarms", alarms);
        return "users/alarm";
    }

    // 알람 읽음 처리
	@PostMapping("/alarmread")
	@ResponseBody
	public boolean readAlarm(HttpSession sess, Model model) {
		Account login = (Account) sess.getAttribute("user");
		if(commonService.updateAlarm(login.getUser_id()) > 0){
			return true;
		}
		return false;
	}

	// 알람 디스플레이 숨김 처리
	@PostMapping("/alarmhide")
	@ResponseBody
	public boolean hideAlarm(@RequestParam("alarm_no") int alarm_no) {
		if(commonService.hideAlarm(alarm_no) > 0){
			return true;
		}
		return false;
	}

    // 안 읽은 알람 확인
	@PostMapping("/alarmcheck")
	@ResponseBody
	public boolean checkUnreadAlarm(HttpSession sess, Model model) {
		Account login = (Account) sess.getAttribute("user");
		return commonService.checkUnreadAlarm(login.getUser_id()) > 0;
	}
}
