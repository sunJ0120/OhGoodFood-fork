<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/storeheader.css" />
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<header>
    <div class="headerContainer">
        <img src="${pageContext.request.contextPath}/img/store_ohgoodfood_logo.png" alt="Logo Image">
        <div class="iconContainer">
            <a href="/store/alarm" id="alarm-icon">
                <img src="${pageContext.request.contextPath}/img/storealarm.png" alt="알람" class="icon alarmIcon">
            </a>  
            <img src="${pageContext.request.contextPath}/img/store_logout.png" alt="로그아웃" class="icon logoutIcon">
        </div>
    </div>
</header>