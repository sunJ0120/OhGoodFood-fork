<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/storejointype.css">
</head>
<body>
     <div id="wrapper">
        <header>
            <div class="header-container">
                <img src="${pageContext.request.contextPath}/img/storeohgoodfood_logo.png" alt="Logo Image">
                <div class="icon-container">
                        <img src="${pageContext.request.contextPath}/img/storelogin.png" alt="로그인" class="icon">
                </div>
            </div>
        </header>
        <main>
            <div class="main-container">
                <div class="main-body-container">
                    <div class="main-middle-container">
                        <h2 class="join-title">가입 유형을 선택해 주세요</h2>
                        <div class="join-box" id="joinbox1">
                            <div class="join-desc">가게를 운영 중이에요~</div>
                            <div class="join-button" onclick="location.href='/store/signup'">
                                <span>사장님으로 가입하기</span>
                                <img src="${pageContext.request.contextPath}/img/storerightvector.png">
                            </div>
                        </div>
                        <div class="join-box" id="joinbox2">
                            <div class="join-desc">저는 소비자예요~</div>
                            <div class="join-button" onclick="location.href='/user/signup'">
                                <span>일반 회원으로 가입하기</span>
                                <img src="${pageContext.request.contextPath}/img/storerightvector2.png">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
     </div>
</body>
</html>