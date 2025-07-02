package kr.co.ohgoodfood.service.common;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.MessageDigest;
import java.util.List;

import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.ohgoodfood.dao.CommonMapper;
import kr.co.ohgoodfood.dto.Account;
import kr.co.ohgoodfood.dto.Alarm;
import kr.co.ohgoodfood.dto.Store;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;

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
    @Value("${naver.client_id}")
    private String clientId;

    @Value("${naver.client_secret}")
    private String clientSecret;
    
    // 네이버 소셜로그인 관련 신규 유저 삽입
    @Override
    public void insertNaverUser(Account account) {
        commonMapper.insertNaverUser(account);
    }

    // 유저 ID로 계정 조회
    @Override
    public Account getAccountById(String userId) {
        return commonMapper.getAccountById(userId);
    }

    // 네이버 소셜로그인
    @Override
    public Account processNaverLogin(String code, String state, String sessionState) throws Exception {

        // CSRF 방지용: 콜백으로 받은 state와 세션에 저장된 state가 일치하는지 검증
        if (!state.equals(sessionState)) {
            throw new IllegalStateException("State mismatch");
        }

        // 콜백 URI (네이버 API 등록 시 설정한 redirect URI)
        String redirectUri = "http://localhost:8090/naver/callback";

        // 네이버 OAuth 서버에 Access Token 요청 URL 구성
        String tokenUrl = "https://nid.naver.com/oauth2.0/token" +
                "?grant_type=authorization_code" +
                "&client_id=" + clientId +
                "&client_secret=" + clientSecret +
                "&code=" + code +
                "&state=" + state;

        // Access Token 요청
        URL url = new URL(tokenUrl);
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestMethod("GET");

        // 응답 받기
        BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()));
        String line;
        StringBuilder res = new StringBuilder();
        while ((line = br.readLine()) != null) {
            res.append(line);
        }
        br.close();

        // JSON 파싱하여 Access Token 추출
        ObjectMapper mapper = new ObjectMapper();
        JsonNode node = mapper.readTree(res.toString());
        String accessToken = node.get("access_token").asText();

        // 추출한 Access Token으로 사용자 프로필 API 호출
        URL profileUrl = new URL("https://openapi.naver.com/v1/nid/me");
        HttpURLConnection profileCon = (HttpURLConnection) profileUrl.openConnection();
        profileCon.setRequestMethod("GET");
        profileCon.setRequestProperty("Authorization", "Bearer " + accessToken);

        // 사용자 프로필 응답 읽기
        BufferedReader profileBr = new BufferedReader(new InputStreamReader(profileCon.getInputStream()));
        StringBuilder profileRes = new StringBuilder();
        while ((line = profileBr.readLine()) != null) {
            profileRes.append(line);
        }
        profileBr.close();

        // JSON 파싱하여 유저 정보 추출
        JsonNode profileNode = mapper.readTree(profileRes.toString());
        JsonNode response = profileNode.get("response");

        // 네이버 고유 ID
        String rawNaverId = response.get("id").asText();
        // 내부 시스템 유저 ID는 'naver_id_' 붙여서 생성
        String userId = "naver_id_" + rawNaverId;
        String name = response.get("name").asText();
        String nickname = response.get("nickname").asText();
        String mobile = response.get("mobile").asText();

        // DB에 동일 유저 ID가 이미 존재하는지 확인
        Account account = getAccountById(userId);

        // 없으면 신규 계정 등록
        if (account == null) {
            Account newAccount = new Account();
            newAccount.setUser_id(userId);
            newAccount.setUser_name(name);
            // 닉네임은 최대 10자 제한
            newAccount.setUser_nickname(nickname.length() > 10 ? nickname.substring(0, 10) : nickname);
            newAccount.setPhone_number(mobile);
            // 소셜로그인은 비밀번호를 따로 받지 않으므로 식별값 저장
            newAccount.setUser_pwd("naver_login");
            insertNaverUser(newAccount);
            account = newAccount;
        }

        // 로그인 완료 Account 리턴
        return account;
    }

	// 알람 가져오기
	@Override
	public List<Alarm> getAlarm(String id) {
		return commonMapper.getAlarm(id);
	}

	// 알람 읽음 처리
	@Override
	public int updateAlarm(String id) {
		return commonMapper.updateAlarm(id);
	}

	// 알람 디스플레이 숨김 처리
	@Override
	public int hideAlarm(int alarm_no) {
		return commonMapper.hideAlarm(alarm_no);
	}

	// 안 읽은 알람 확인
	@Override
	public int checkUnreadAlarm(String id) {
		return commonMapper.checkUnreadAlarm(id);
	}
}
