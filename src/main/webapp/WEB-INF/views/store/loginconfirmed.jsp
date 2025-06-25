<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>승인 대기중</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/storeloginconfirmed.css">
</head>
<body>

<div class="container">
    <h2>사장님 계정 승인 대기중입니다.</h2>
    <p>관리자의 승인이 완료되면 로그인 하실 수 있습니다.<br>조금만 기다려 주세요!</p>
    <button onclick="location.href='/store/login'">로그인 화면으로 돌아가기</button>
</div>

</body>
</html>
