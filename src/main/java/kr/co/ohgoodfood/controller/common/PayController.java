package kr.co.ohgoodfood.controller.common;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;

import okhttp3.Credentials;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

@Controller
public class PayController {
    private final String CLIENT_KEY = "test_ck_PBal2vxj814v1pqBmX2Gr5RQgOAN";
    private final String SECRET_KEY = "test_sk_DpexMgkW36PJRzJBRgGdrGbR5ozO";

    @PostMapping("/payment/ready")
    @ResponseBody
    public Map<String, Object> readyPayment() {
        Map<String, Object> map = new HashMap<>();
        map.put("clientKey", CLIENT_KEY);
        map.put("amount", 1000); // 테스트용 10,000원
        map.put("orderId", "order_" + UUID.randomUUID());
        return map;
    }

    @GetMapping("/payment/success")
    public String confirmPayment(@RequestParam String paymentKey,
                                 @RequestParam String orderId,
                                 @RequestParam int amount) throws IOException {
        OkHttpClient client = new OkHttpClient();

        Map<String, Object> jsonMap = Map.of(
            "paymentKey", paymentKey,
            "orderId", orderId,
            "amount", amount
        );

        String json = new Gson().toJson(jsonMap);

        Request request = new Request.Builder()
            .url("https://api.tosspayments.com/v1/payments/confirm")
            .post(RequestBody.create(json, MediaType.get("application/json")))
            .addHeader("Authorization", Credentials.basic(SECRET_KEY, ""))
            .addHeader("Content-Type", "application/json")
            .build();

        try (Response response = client.newCall(request).execute()) {
            if (response.isSuccessful()) {
                System.out.println("결제 성공");
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
