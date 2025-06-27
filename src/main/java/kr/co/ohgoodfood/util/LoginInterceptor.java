package kr.co.ohgoodfood.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;

public class LoginInterceptor implements HandlerInterceptor{
    @Override
	public boolean preHandle(HttpServletRequest request, 
							HttpServletResponse response, 
							Object handler)
							throws Exception {
		HttpSession sess = request.getSession();
		
		if (sess.getAttribute("user") == null && sess.getAttribute("store") == null) {
			response.sendRedirect("/login");
			return false;
		}

		return true; // 가던길가
	}
}
