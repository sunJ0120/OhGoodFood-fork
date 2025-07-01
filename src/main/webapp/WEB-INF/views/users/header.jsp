<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/userheader.css" />
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<header>
    <div class="headerContainer">
        <img src="${pageContext.request.contextPath}/img/user_ohgoodfood_logo.png" alt="Logo Image">
        <div class="iconContainer">
            <%-- 알람 이동 --%>
            <a href="${pageContext.request.contextPath}/user/alarm">
                <img src="${pageContext.request.contextPath}/img/user_alarm_active.png" alt="알람" class="icon">
            </a>
            <%-- 즐겨찾기 적용 --%>
            <a href="${pageContext.request.contextPath}/user/bookmark">
                <img src="${pageContext.request.contextPath}/img/user_bookmark.png" alt="즐겨찾기" class="icon">
            </a>
            <%-- 로그아웃 이동 --%>
            <a href="${pageContext.request.contextPath}/logout">
                <img src="${pageContext.request.contextPath}/img/user_logout.png" alt="로그아웃" class="icon">
            </a>
        </div>
    </div>
</header>