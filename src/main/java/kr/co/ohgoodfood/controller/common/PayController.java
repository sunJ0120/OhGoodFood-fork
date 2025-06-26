package kr.co.ohgoodfood.controller.common;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;

import kr.co.ohgoodfood.service.common.PayService;
import lombok.RequiredArgsConstructor;
import okhttp3.Credentials;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

@Controller
@RequiredArgsConstructor
public class PayController {
    private final String CLIENT_KEY = "test_ck_PBal2vxj814v1pqBmX2Gr5RQgOAN";
    private final String SECRET_KEY = "test_sk_DpexMgkW36PJRzJBRgGdrGbR5ozO";

    private final PayService payService;
    private final OkHttpClient okHttpClient;

    // @PostMapping("/payment/ready")
    // @ResponseBody
    // public Map<String, Object> readyPayment(@RequestParam int amount) {
    //     Map<String, Object> map = new HashMap<>();
    //     map.put("clientKey", CLIENT_KEY);
    //     map.put("amount", amount); // 테스트용 10,000원
    //     map.put("orderId", "order_" + UUID.randomUUID());
    //     return map;
    // }

    @PostMapping("/payment/insert")
    @ResponseBody
    public Map<String, Object> insertPayment(@RequestParam String user_id, @RequestParam String store_id, 
            @RequestParam int product_no, @RequestParam int quantity, @RequestParam int paid_price) {
        String orderId = "order_" + UUID.randomUUID();
        if(payService.checkProductAmount(product_no, quantity)) {
            payService.insertOrderAndPaid(user_id, store_id, product_no, quantity, paid_price,orderId);
            Map<String, Object> map = new HashMap<>();
            map.put("result", "success");
            map.put("orderId", orderId);
            map.put("amount", paid_price);
            return map;
        } else {
            Map<String, Object> map = new HashMap<>();
            map.put("result", "fali");
            map.put("orderId", orderId);
            map.put("amount", paid_price);
            return map;
        }
    }

    @GetMapping("/payment/success")
    public String confirmPayment(@RequestParam String paymentKey,
                                 @RequestParam String orderId,
                                 @RequestParam int amount) throws IOException {

        Map<String, Object> jsonMap = Map.of(
            "paymentKey", paymentKey,
            "orderId", orderId,
            "amount", amount
        );

        String json = new Gson().toJson(jsonMap);
        System.out.println("결제 진입");
        Request request = new Request.Builder()
            .url("https://api.tosspayments.com/v1/payments/confirm")
            .post(RequestBody.create(json, MediaType.get("application/json")))
            .addHeader("Authorization", Credentials.basic(SECRET_KEY, ""))
            .addHeader("Content-Type", "application/json")
            .build();

        try (Response response = okHttpClient.newCall(request).execute()) {
            if (response.isSuccessful() && payService.checkProductAmountByPaidCode(orderId)) {
                System.out.println("결제 성공");
                payService.updateOrderStatusAndPaidStatus(orderId);
                return "redirect:/home";
            } else {
                System.out.println("결제 실패");
                return "redirect:/home";
            }
        }
    }

    @GetMapping("/payment/fail")
    public String failPage() {
        System.out.println("결제 실패");
        return "home";
    }
}
