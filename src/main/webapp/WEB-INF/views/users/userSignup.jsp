<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">

<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Document</title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/userSignup.css">
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
				<div class="signupForm">
					<p>id</p>
					<div class="idGroup">
						<input type="text" id="id" name="id" placeholder="아이디를 입력하세요">
						<button id="checkIdButton" class="checkButton">중복확인</button>
					</div>
					<p>password</p>
					<div class="inputGroup">
						<input type="password" id="password" name="password" placeholder="비밀번호를 입력하세요">
						<input type="password" id="confirmPassword" name="confirmPassword" placeholder="비밀번호 확인하세요">
					</div>
					<p>닉네임</p>
					<input type="text" id="nickname" name="nickname" placeholder="닉네임을 입력하세요">
					<p>이름</p>
					<input type="text" id="name" name="name" placeholder="이름을 입력하세요">
					<p>전화번호</p>
					<input type="text" id="phone" name="phone" placeholder="전화번호를 입력하세요">

					<label>
						<input type="checkbox" id="location_agreement" name="locationAgreement" value="Y" required />
						[필수] 위치정보 이용에 동의합니다.
					</label>
					<br />
					<button type="submit" class="submit-button">회원가입</button>
				</div>
			</div>

		</main>

	</div>
</body>
<script>
	$(function () {
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
			$("#idCheckMessage").text(""); // 조건 통과 시 메시지 제거
			isIdChecked = true;
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

		// 전화번호 하이픈 자동포맷
		$("#userTelnumber").on("input", function () {
			const that = this;
			let number = $(that).val().replace(/[^0-9]/g, "");
			let formatted = "";

			if (number.startsWith("02")) {
				if (number.length <= 2) formatted = number;
				else if (number.length <= 5) formatted = number.substring(0, 2) + "-" + number.substring(2);
				else if (number.length <= 9) formatted = number.substring(0, 2) + "-" + number.substring(2, 5) + "-" + number.substring(5);
				else formatted = number.substring(0, 2) + "-" + number.substring(2, 6) + "-" + number.substring(6, 10);
			} else {
				if (number.length <= 3) formatted = number;
				else if (number.length <= 7) formatted = number.substring(0, 3) + "-" + number.substring(3);
				else if (number.length <= 11) formatted = number.substring(0, 3) + "-" + number.substring(3, 7) + "-" + number.substring(7);
				else formatted = number.substring(0, 3) + "-" + number.substring(3, 7) + "-" + number.substring(7, 11);
			}

			// setTimeout으로 이벤트 루프 빠져나가서 안전하게 대입
			setTimeout(function () {
				$(that).val(formatted);
			}, 0);
		});
		// 위치정보 동의 체크
		const locAgree = document.getElementById("locationAgreement");
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
	});

</script>

</html>