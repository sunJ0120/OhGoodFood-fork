<%@ page contentType="text/html; charset=UTF-8" language="java" %>
	<!DOCTYPE html>
	<html lang="en">

	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>Document</title>
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/userSignup.css">
		<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

	</head>

	<body>
		<div id="wrapper">
			<header>
				<div class="headerContainer">
					<img src="${pageContext.request.contextPath}/img/user_ohgoodfood_logo.png" alt="Logo Image">
					<div class="icon-container">
						<img src="${pageContext.request.contextPath}/img/user_login.png" alt="로그인" class="icon">
					</div>
				</div>
			</header>
			<main>
				<div class="signupContainer">
					<div class="signupTitle">
						<div class="title"> 회원가입 </div>
					</div>
					<form id="signupForm" class="signupForm" action="${pageContext.request.contextPath}/user/signup" method="post">
						<p>id<span id="idCheckMessage" style="font-size:14px; margin-left:10px; color:red;"></span></p>
						<div class="idGroup">
							<input type="text" id="user_id" name="user_id" placeholder="아이디를 입력하세요">
							<button id="checkIdButton" class="checkButton">중복확인</button>
						</div>
						
						<p>password<span id="pwCheckMessage" style="font-size:14px; margin-left:10px; color:red;"></span></p>
						<div class="inputGroup">
							<input type="password" id="user_pwd" name="user_pwd" placeholder="비밀번호를 입력하세요">
							<input type="password" id="confirmPassword" name="confirmPassword" placeholder="비밀번호 확인하세요">
						</div>
						<span id="pwCheckMessage"></span>
						<p>닉네임</p>
						<input type="text" id="user_nickname" name="user_nickname" placeholder="닉네임을 입력하세요">
						<p>이름</p>
						<input type="text" id="user_name" name="user_name" placeholder="이름을 입력하세요">
						<p>전화번호</p>
						<input type="text" id="phone_number" name="phone_number" placeholder="전화번호를 입력하세요">

						<div class="location_agreement">
							<input type="hidden" name="location_agreement" value="N" />
							<label for="location_agreement">
								<input type="checkbox" id="location_agreement" name="location_agreement" value="Y" />
								[필수] 위치정보 이용에 동의합니다.
							</label>
						</div>

						<div class="signupButtons">
							<button type="submit" class="submitButton">회원가입</button>
						</div>
					</form>
				</div>
			</main>

		</div>

		<script>
			let isIdChecked = false;
			let isPwMatched = false;

			$(function () {
				let isIdChecked = false;
				let isPwMatched = false;

				// 아이디 유효성 검사
				$("#user_id").on("input", function () {
					const userId = $(this).val();
					const idRegex = /^[a-z0-9]{8,15}$/;

					if (userId === "") {
						$("#idCheckMessage").css("color", "red").text("* 아이디를 입력하세요.");
						isIdChecked = false;
						return;
					}
					if (!idRegex.test(userId)) {
						$("#idCheckMessage").css("color", "red").text("* 영어 소문자, 숫자 8~15자만 가능합니다.");
						isIdChecked = false;
						return;
					}
					$("#idCheckMessage").css("color", "red").text("* 중복확인을 해주세요.");
				});
				// 아이디 중복확인 버튼 클릭
				$("#checkIdButton").click(function () {
					const userId = $("#user_id").val();
					if (userId === "") {
						$("#idCheckMessage").css("color", "red").text("* 아이디를 입력하세요.");
						isIdChecked = false;
						return;
					}

					$.ajax({
						url: "/user/checkId",
						type: "GET",
						data: { user_id: userId },
						success: function (res) {
							if (res) { // 중복
								$("#idCheckMessage").css("color", "red").text("* 이미 사용중인 아이디입니다.");
								isIdChecked = false;
							} else { //사용 가능 
								$("#idCheckMessage").css("color", "green").text("* 사용 가능한 아이디입니다.");
								isIdChecked = true;
							}
						},
						error: function () {
							$("#idCheckMessage").css("color", "red").text("* 서버 오류");
							isIdChecked = false;
						}
					});
				});
				// 비밀번호 유효성 검사
				$("#user_pwd").on("input", function () {
					const pw = $(this).val();
					// 영어(대소문자), 숫자, ?, !, @, . 만 허용
					const pwRegex = /^[a-zA-Z0-9?!@.]+$/;

					if (pw === "") {
						$("#pwCheckMessage").css("color", "red").text("* 비밀번호를 입력하세요.");
						isPwMatched = false;
						return;
					}
					if (!pwRegex.test(pw)) {
						$("#pwCheckMessage").css("color", "red").text("* 영어, 숫자, ?, !, @, .만 사용 가능합니다.");
						isPwMatched = false;
						return;
					}
					$("#pwCheckMessage").text("");
					isPwMatched = true;
				});
				// 비밀번호 확인
				$("#confirmPassword").on("keyup", function () {
					const pw = $("#user_pwd").val();
					const pwConfirm = $("#confirmPassword").val();

					if (pw !== pwConfirm) { // 비밀번호 일치 x
						$("#pwCheckMessage").css("color", "red").text("* 비밀번호가 일치하지 않습니다.");
						isPwMatched = false;
					} else { // 비밀번호 일치 o
						$("#pwCheckMessage").css("color", "green").text("* 비밀번호가 일치합니다.");
						isPwMatched = true;
					}
				});

				// 전화번호 하이픈 자동포맷 (010-####-####)
				$("#phone_number").on("input", function () {
					const input = this;
					// 숫자 이외 제거
					let num = input.value.replace(/[^0-9]/g, "");
					let formatted = num;

					if (num.startsWith("010")) {
						// 010 + 중간 4자리 + 끝 4자리
						if (num.length > 3 && num.length <= 7) {
							// 010-1234
							formatted = num.slice(0, 3) + "-" + num.slice(3);
						} else if (num.length > 7) {
							// 010-1234-5678 (끝 4자리까지만)
							formatted = num.slice(0, 3)
								+ "-" + num.slice(3, 7)
								+ "-" + num.slice(7, 11);
						}
					} else {
						// 010이 아닐 땐 3-4-4 또는 3-3-4 기본 패턴
						if (num.length > 3 && num.length <= 7) {
							formatted = num.slice(0, 3) + "-" + num.slice(3);
						} else if (num.length > 7) {
							formatted = num.slice(0, 3)
								+ "-" + num.slice(3, 7)
								+ "-" + num.slice(7, 11);
						}
					}

					input.value = formatted;
				});

				// 위치정보 동의 체크
				const locAgree = document.getElementById("location_agreement");
				// 체크 해제 상태에서 submit 시 메시지 설정
				document.getElementById("signupForm")
					.addEventListener("submit", function (e) {
						if (!locAgree.checked) {
							locAgree.setCustomValidity("위치정보 이용에 꼭 동의하셔야 합니다.");
						} else {
							locAgree.setCustomValidity("");
						}
					});
				// 사용자가 체크박스 변경할 때마다 커스텀 메시지 초기화
				locAgree.addEventListener("change", function () {
					if (locAgree.checked) {
						locAgree.setCustomValidity("");
					}
				});
				// 최종 회원가입 버튼 클릭
				$("#signupForm").submit(function (e) {
					// 아이디 유효성 검사
					const storeId = $("#user_id").val();
					const idRegex = /^[a-z0-9]{8,15}$/;
					if (storeId === "") {
						$("#idCheckMessage").css("color", "red").text("* 아이디를 입력하세요.");
						$("#user_id").focus();
						e.preventDefault();
						return;
					}
					if (!idRegex.test(storeId)) {
						$("#idCheckMessage").css("color", "red").text("* 영어 소문자, 숫자 8~15자만 가능합니다.");
						$("#user_id").focus();
						e.preventDefault();
						return;
					}

					// 비밀번호 유효성 검사
					const pw = $("#user_pwd").val();
					const pwRegex = /^[a-zA-Z0-9?!@.]+$/;
					if (pw === "") {
						$("#pwCheckMessage").css("color", "red").text("* 비밀번호를 입력하세요.");
						$("#user_pwd").focus();
						e.preventDefault();
						return;
					}
					if (!pwRegex.test(pw)) {
						$("#pwCheckMessage").css("color", "red").text("* 영어, 숫자, ?, !, @, .만 사용 가능합니다.");
						$("#user_pwd").focus();
						e.preventDefault();
						return;
					}

					// 비밀번호 확인 검사
					const pwConfirm = $("#confirmPassword").val();
					if (pw !== pwConfirm) {
						$("#pwCheckMessage").css("color", "red").text("* 비밀번호가 일치하지 않습니다.");
						$("#confirmPassword").focus();
						e.preventDefault();
						return;
					}

					// 아이디 중복확인 버튼 클릭
					if (!isIdChecked) {
						alert("아이디 중복확인을 진행해주세요.");
						e.preventDefault();
						$("#user_id").focus();
						return;
					}
					if (!isPwMatched) {
						alert("비밀번호가 일치하지 않습니다.");
						e.preventDefault();
						$("#confirmPassword").focus();
						return;
					}
					// 위치정보 동의 체크
					if (!locAgree.checked) {
						alert("위치정보 이용에 동의해주세요.");
						e.preventDefault();
						return;
					}

				});
			});

		</script>
	</body>

	</html>