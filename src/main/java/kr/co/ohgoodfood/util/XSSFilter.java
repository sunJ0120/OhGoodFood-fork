package kr.co.ohgoodfood.util;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

public class XSSFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 초기화 필요 시 작성
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        XSSRequestWrapper xssRequestWrapper = new XSSRequestWrapper(httpRequest);

        chain.doFilter(xssRequestWrapper, response);
    }

    @Override
    public void destroy() {
        // 리소스 해제 필요 시 작성
    }
}
