<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> 
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/commonerror.css">
    <title>Ohgoodfood</title>
    <link rel="icon" type="image/jpeg" href="https://ohgoodfood.s3.ap-northeast-2.amazonaws.com/shinhanmoilicon32x32.jpg">
</head>
<body>
     <div id="wrapper">
        <div class="image-container">
            <img src="${pageContext.request.contextPath}/img/common500.png" alt="error Image">
        </div>
        <!-- 이전 페이지로 돌아가기 버튼 -->
        <button id="Button" onclick="window.history.back();">이전으로 돌아가기</button>
     </div>
</body>
</html>
