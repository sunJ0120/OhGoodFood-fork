package kr.co.ohgoodfood.service.common;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.security.MessageDigest;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.ohgoodfood.dao.CommonMapper;
import kr.co.ohgoodfood.dto.Account;
import kr.co.ohgoodfood.dto.KakaoUser;
import kr.co.ohgoodfood.dto.Store;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CommonServiceImpl implements CommonService{
	
	private final CommonMapper commonMapper;

	// 사용자 로그인 
	@Override
	public Account loginAccount(String id, String pwd) {
		return commonMapper.loginAccount(id, md5(pwd));
	}

	// 가게 사장 로그인
	@Override
	public Store loginStore(String id, String pwd) {
		return commonMapper.loginStore(id, md5(pwd));
	}

	// MD5 암호화 메서드 추가
	private String md5(String input) {
		try {
			MessageDigest md = MessageDigest.getInstance("MD5");
			byte[] messageDigest = md.digest(input.getBytes());
			StringBuilder sb = new StringBuilder();
			for (byte b : messageDigest) {
				sb.append(String.format("%02x", b));
			}
			return sb.toString();
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}
	
	@Value("${kakao.rest.apiKey}")
    private String kakaoClientId;

    @Value("${kakao.redirect-uri}")
    private String kakaoRedirectUri;

    private final String KAKAO_TOKEN_URL = "https://kauth.kakao.com/oauth/token";
    private final String KAKAO_USER_URL = "https://kapi.kakao.com/v2/user/me";
    private final ObjectMapper mapper = new ObjectMapper();

    // access_token만 사용하여 사용자 정보를 가져오는 로직
    @Override
    public KakaoUser getKakaoUserInfo(String code) {
        try {
            // 전송할 파라미터 만들기
            String params = "grant_type=authorization_code"
                    + "&client_id=" + kakaoClientId
                    + "&redirect_uri=" + URLEncoder.encode(kakaoRedirectUri, "UTF-8")
                    + "&code=" + code;

            HttpURLConnection conn = (HttpURLConnection) new URL(KAKAO_TOKEN_URL).openConnection();
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded;charset=utf-8"); // 헤더 설정
            
            // 파라미터 전송
            try (BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()))) {
                bw.write(params);
                bw.flush();
            }

            //access_token을 받아옴
            String accessToken;
            try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
                String response = br.readLine();
                Map<String, Object> tokenMap = mapper.readValue(response, Map.class); // json -> java 파싱
                accessToken = (String) tokenMap.get("access_token");
            }

            // access_token 으로 사용자 정보 조회
            HttpURLConnection userConn = (HttpURLConnection) new URL(KAKAO_USER_URL).openConnection();
            userConn.setRequestMethod("GET");
            userConn.setRequestProperty("Authorization", "Bearer " + accessToken);

            int responseCode = userConn.getResponseCode();
            if (responseCode == 200) {
                try (BufferedReader br = new BufferedReader(new InputStreamReader(userConn.getInputStream()))) {
                    StringBuilder sb = new StringBuilder();
                    String line;
                    while ((line = br.readLine()) != null) {
                        sb.append(line);
                    }
                    String userInfo = sb.toString();
                    Map<String, Object> jsonMap = mapper.readValue(userInfo, Map.class);
                    
                    // user_id = kakao_id_12345로 만드는 로직
                    String id = "kakao_id_" + jsonMap.get("id").toString();
                    Map<String, Object> properties = (Map<String, Object>) jsonMap.get("properties");
                    
                    // nickname 받아옴
                    String nickname = (String) properties.get("nickname");
                    Map<String, Object> kakaoAccount = (Map<String, Object>) jsonMap.get("kakao_account");
                    
                    // email 받아옴, email이 없으면 기본값으로 none@example.com
                    String email = kakaoAccount.getOrDefault("email", "none@example.com").toString();
           
                    // 카카오 로그인 시 매번 nickname, email 들고와서 갱신
                    int r = commonMapper.updateInfo(id, nickname, email);
                    if(r > 0) {
                    	return new KakaoUser(id, nickname, email, accessToken);
                    }else {
                    	throw new IllegalStateException("카카오 사용자 정보 업데이트에 실패했습니다. [id: " + id + "]");
                    }
                }
            } else {
                throw new RuntimeException("카카오 사용자 정보 요청 실패. 응답 코드: " + responseCode);
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // DB에 해당 계정이 없으면 가입, 있으면 바로 로그인
    @Override
    public Account autoLoginOrRegister(KakaoUser kakaoUser) {
        Account existing = commonMapper.findById(kakaoUser.getId());
        if (existing != null) return existing;
        commonMapper.insertKakaoUser(kakaoUser);
        return commonMapper.findById(kakaoUser.getId());
    }
}
