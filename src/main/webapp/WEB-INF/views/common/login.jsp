<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/storelogin.css">
    
</head>
<body>
     <div id="wrapper">
        <header>
			<div class="header-container">
				<img src="${pageContext.request.contextPath}/img/store_ohgoodfood_logo.png" alt="Logo Image">
			</div>
		</header>
        <main>
            <form id="loginForm" action="/login" method="post">
			    <div class="main-head-container" id="main-image">
			        <img src="${pageContext.request.contextPath}/img/storegroup.png" alt="Family" width="446px" height="317px">
			        <div class="main-body-container">
			            <div class="main-middle-container">
			                <input type="text" placeholder="id" id="userId" name="id">
			                <input type="password" placeholder="password" id="userPwd" name="pwd">
			                <button type="submit" class="login-button" >로그인</button>
			                <div class="sub-links">
			                    <a href="/findid">아이디 찾기</a> |
			                    <a href="/findpwd">비밀번호 찾기</a> |
			                    <a href="/jointype">회원가입</a>
			                </div>
			                <div class="main-line"></div>
			                <div class="sns-login-box">
			                    <div class="sns-login-title">SNS로그인</div>
			                    <img src="${pageContext.request.contextPath}/img/storekakaologin.png" alt="카카오로그인" />
			                </div>
			            </div>
			        </div>
			    </div>
			</form>
        </main>
		<!-- 승인 대기 모달 -->
		<c:if test="${showConfirmationModal}">
			<div id="confirmationModal" class="modal">
				<div class="modal-content">
					<h2>사장님 계정 승인 대기중입니다.</h2>
					<p>관리자의 승인이 완료되면 로그인 하실 수 있습니다.<br>조금만 기다려 주세요!</p>
					<button onclick="closeModal()">확인</button>
				</div>
			</div>
		</c:if>
     </div>
     <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
     <script>
	     $(document).ready(function() {
	   	    $('#loginForm').on('submit', function(e) {
	   	        const id = $('#userId').val().trim();
	   	        const password = $('#userPwd').val().trim();
	   	        console.log('logincheck 실행됨', id, password);
	   	        if(id === '') {
	   	            alert('아이디 입력바람');
	   	            e.preventDefault();
	   	            return;
	   	        }
	   	        if(password === '') {
	   	            alert('비밀번호 입력바람');
	   	            e.preventDefault();
	   	            return;
	   	        }
	   	        if(id.length > 15) {
	   	            alert('아이디는 15자 이하로 입력바람');
	   	            e.preventDefault();
	   	            return;
	   	        }
	   	        if (!/^[a-zA-Z0-9]+$/.test(id)) {
	   	            alert("아이디는 영문자와 숫자만 입력 가능함");
	   	            e.preventDefault();
	   	            return;
	   	        }
	   	    });			
	     });
		 $(document).on('click', '#confirmationModal button', function () {
			$('#confirmationModal').hide();
		});
     </script>
</body>
</html>