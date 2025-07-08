<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ohgoodfood</title>
    <link rel="icon" type="image/jpeg" href="https://ohgoodfood.s3.ap-northeast-2.amazonaws.com/shinhanmoilicon32x32.jpg">
    <link rel="stylesheet" href="../../../css/reset.css" />
    <link rel="stylesheet" href="../../../css/adminlayout.css"/>
    <link rel="stylesheet" href="../../../css/adminlogin.css"/>
</head>
<body>
    <div class="wrapper">
        <div class="menu">
            <div class="toHome">
                <a href="">5조은푸드</a>
            </div>
            <form method="post" action="<c:url value='/admin/login'/>">
            <div class="loginBox">
                <input class="idBox inputBox" type="text" name="admin_id" placeholder="ID">
                <input class="pwdBox inputBox" type="password" name="admin_pwd" placeholder="PASSWORD">
                <input class="loginButton" type="submit" value="login">
            </div>
            </form>
        </div>
        <div class="main">
            <div>
                <div class="header">
                    <p>5조은푸드</p>
                </div>
                <div class="content">
                    <p>로그인이 필요합니다</p>
                </div>
            </div>
        </div>
    </div>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script>
        $(document).ready(function() {
            <c:choose>
                <c:when test="${not empty error}">
                    alert("${error}");
                </c:when>
            </c:choose>
        });
    </script>
</body>
</html>