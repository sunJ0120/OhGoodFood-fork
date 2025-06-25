<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/intro.css">
</head>
<body>
     <div id="wrapper">
        <div style="display: flex; justify-content: center; align-items: center; height: 100vh;">
            <img src="${pageContext.request.contextPath}/img/storeintro.png" alt="Intro Image">
        </div>
     </div>
     
     <script>
        // 3초 뒤에 /user/main으로 이동
        //session 값에 ㄸ라서 /user/main 혹은 /store/main으로
        let url = "";

        <c:choose>
            <c:when test="${not empty user}">
                url = "${pageContext.request.contextPath}/user/main";
            </c:when>
            <c:when test="${not empty store}">
                url = "${pageContext.request.contextPath}/store/main";
            </c:when>
            <c:otherwise>
            	url = "${pageContext.request.contextPath}/login";
            </c:otherwise>
        </c:choose>

        setTimeout(function () { // 3초 뒤에 이동
            window.location.href = url;
        }, 3000);
     </script>
</body>
</html>