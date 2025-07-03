<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="utf-8" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/storefooter.css" />
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>

<%
    String uri = request.getRequestURI();
%>

<footer>
    <div class="footer-container">
        <div class="menu-container">
            <div class="menu-item <%= uri.contains("/store/main") ? "active" : "" %>">
                <a href="/store/main">
                    <img src="${pageContext.request.contextPath}/img/store_home<%= uri.contains("/store/main") ? "_active" : "" %>.png"
                         data-name="home" alt="홈" class="menu-icon">
                </a>
            </div>
            <div class="menu-item <%= uri.contains("/store/review") ? "active" : "" %>">
                <a href="/store/review">
                    <img src="${pageContext.request.contextPath}/img/store_review<%= uri.contains("/store/review") ? "_active" : "" %>.png"
                         data-name="review" alt="리뷰" class="menu-icon">
                </a>
            </div>
            <div class="menu-item <%= uri.contains("/store/order") ? "active" : "" %>">
                <a href="/store/reservation">
                    <img src="${pageContext.request.contextPath}/img/store_order<%= uri.contains("/store/order") ? "_active" : "" %>.png"
                         data-name="order" alt="주문" class="menu-icon">
                </a>
            </div>
            <div class="menu-item <%= uri.contains("/store/mypage") ? "active" : "" %>">
                <a href="/store/mypage">
                    <img src="${pageContext.request.contextPath}/img/store_mypage<%= uri.contains("/store/mypage") ? "_active" : "" %>.png"
                         data-name="mypage" alt="마이페이지" class="menu-icon">
                </a>
            </div>
        </div>
    </div>
</footer>

<script>
    $(document).ready(function () {
        const currentPath = window.location.pathname;
        $('.menu-container a').each(function () {
            if ($(this).attr('href') === currentPath) {
                $(this).on('click', function (e) {
                    e.preventDefault(); // 클릭 막기
                }).css('pointer-events', 'none'); // 마우스도 막기 (선택사항)
            }
        });

        // 새로운 알람이 있을 때 알람 이미지 변경
        $.ajax({
            type: "POST",
            url: "/store/alarmcheck",
            success: function(res){
                if(res == true || res === "true"){
                    $(".alarmIcon").attr('src', '${pageContext.request.contextPath}/img/storealarm_active.png');
                }
            }

        });
    });

</script>

