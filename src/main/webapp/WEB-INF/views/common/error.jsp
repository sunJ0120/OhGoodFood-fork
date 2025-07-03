<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> 
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/commonerror.css">
    <title>에러 페이지</title>
</head>
<body>
     <div id="wrapper">
        <div class="image-container">
            <img src="${pageContext.request.contextPath}/img/commonerror.png" alt="error Image">
        </div>
        <!-- 이전 페이지로 돌아가기 버튼 -->
        <button id="Button" onclick="window.history.back();">이전으로 돌아가기</button>
     </div>
</body>
</html>
