<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="en">

	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>Ohgoodfood</title>
		<link rel="icon" type="image/jpeg" href="https://ohgoodfood.s3.ap-northeast-2.amazonaws.com/shinhanmoilicon32x32.jpg">
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/storesignup.css">
		<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
		<!-- 카카오 주소검색 (우편번호) -->
		<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	</head>

	<body>
		<div id="wrapper">
			<header>
				<div class="header-container">
					<img src="${pageContext.request.contextPath}/img/store_ohgoodfood_logo.png" alt="Logo Image">
					<div class="icon-container">
						<a href="${pageContext.request.contextPath}/login">
							<img src="${pageContext.request.contextPath}/img/store_login.png" alt="로그인" class="icon">
						</a>
					</div>
				</div>
			</header>
			<main>
				<div class="signup-container">
					<div class="signup-title">
						<div class="title">회원가입</div>
					</div>
					<div class="signup-form">
						<form id="signupForm" action="/store/signup" method="post" enctype="multipart/form-data">
							<p>id <span id="idCheckMessage" style="font-size:14px; margin-left:10px; color:red;"></span>
							</p>
							<div class="idGroup">
								<input type="text" id="store_id" name="store_id" placeholder="아이디를 입력하세요" required>
								<button id="checkIdButton" class="check-button" type="button">중복확인</button>
							</div>

							<p>password <span id="pwCheckMessage"
									style="font-size:14px; margin-left:10px; color:red;"></span></p>
							<div class="inputGroup">
								<input type="password" id="store_pwd" name="store_pwd" placeholder="비밀번호를 입력하세요"
									required>
								<input type="password" id="confirmPassword" name="confirmPassword"
									placeholder="비밀번호 확인하세요" required>
							</div>

							<p>이름</p>
							<input type="text" id="owner_name" name="owner_name" placeholder="이름을 입력하세요" maxlength="20" required>

							<p>전화번호</p>
							<input type="text" id="store_telnumber" name="store_telnumber" placeholder="전화번호를 입력하세요"
								required>

							<p>가게이름</p>
							<p style="font-size:13px; margin-top:-10px;">(체인점일 경우 , 지점명까지 입력)</p>
							<input type="text" id="store_name" name="store_name" maxlength="15" placeholder="가게이름을 입력하세요" required>

							<p>가게주소</p>
							<p style="font-size:13px; margin-top:-10px;">(가게 주소를 정확하게 작성해주세요)</p>

							<div class="inputGroup">
								<div class="idGroup" style="display:flex">
									<input type="text" id="store_address" name="store_address" placeholder="주소검색을 입력하세요"
										readonly>
									<button type="button" id="searchAddressBtn" class="check-button">주소검색</button>
								</div>
								<input type="text" id="storeAddressDetail" name="storeAddressDetail"
									placeholder="상세주소를 입력하세요" maxlength="100" required readonly>
								<input type="hidden" id="latitude" name="latitude" readonly>
								<input type="hidden" id="longitude" name="longitude" readonly>
							</div>
							<div class="mb-2 row">
							</div>
							<p>가게 이미지</p>
							<p style="font-size:13px; margin-top:-10px;">(1~5개 등록 가능 | 권장 사이즈: 200*100)</p>
							<div class="input-box">
								<input type="file" id="storeImage" class="file-input" name="storeImage" accept="image/*"
									multiple style="font-size:15px">
							</div>

							<p>사업자 등록 번호</p>
							<p style="font-size:13px; margin-top:-10px;">(사장님인지 확인하기 위해 필요해요)</p>
							<input type="text" id="business_number" name="business_number"
								placeholder="사업자 등록 번호를 입력하세요" required>

							<p>가게 카테고리</p>
							<div class="input-box">
								<div class="category-group">
									<label>
										<input type="checkbox" class="category-checkbox" name="category_bakery"
											value="Y" style="display:none;">
										<img src="${pageContext.request.contextPath}/img/store_checkbox.png" class="checkbox-img" alt="체크박스">
										빵 & 디저트
									</label>
									<label>
										<input type="checkbox" class="category-checkbox" name="category_salad" value="Y"
											style="display:none;">
										<img src="${pageContext.request.contextPath}/img/store_checkbox.png" class="checkbox-img" alt="체크박스">
										샐러드
									</label>
									<label>
										<input type="checkbox" class="category-checkbox" name="category_fruit" value="Y"
											style="display:none;">
										<img src="${pageContext.request.contextPath}/img/store_checkbox.png" class="checkbox-img" alt="체크박스">
										과일
									</label>
									<label>
										<input type="checkbox" class="category-checkbox" name="category_others"
											value="Y" style="display:none;">
										<img src="${pageContext.request.contextPath}/img/store_checkbox.png" class="checkbox-img" alt="체크박스">
										그외
									</label>
								</div>
							</div>
							<p>가게 설명</p>
							<p style="font-size:13px; margin-top:-10px;">(가게에 대한 설명을 작성해주세요.)</p>
							<input type="text" id="store_explain" name="store_explain" maxlength="50" placeholder="가게설명을 입력하세요"
								required>

							<p>가게 대표 메뉴</p>
							<p style="font-size:13px; margin-top:-10px;">(가게를 대표메뉴를 1개 이상 작성해 주세요)</p>
							<input type="text" id="store_menu" name="store_menu" placeholder="첫 번째 대표메뉴를 입력하세요" maxlength="6" required>
							<input type="text" id="store_menu" name="store_menu2" placeholder="두 번째 대표메뉴를 입력하세요" maxlength="6" style="margin-top: 10px;">
							<input type="text" id="store_menu" name="store_menu3" placeholder="세 번째 대표메뉴를 입력하세요" maxlength="6" style="margin-top: 10px;">

							<p>영업시간</p>
							<div class="business-hours-group">
								<input type="time" id="opened_at" name="opened_at" required>
								<span class="time-divider">~</span>
								<input type="time" id="closed_at" name="closed_at" required>
							</div>

							<div class="signup-buttons">
								<p> * 승인은 최대 3일 걸려요</p>
								<p> * 승인 받은 후에 판매를 시작할 수 있어요</p>
								<button type="submit" class="submit-button">회원가입</button>
							</div>
						</form>
					</div>
				</div>
			</main>

		</div>
		<script>
			$(function () {
				//체크박스 
				$('.category-checkbox').change(function () {
					const $img = $(this).next('img');
					const $label = $(this).parent();
					if ($(this).is(':checked')) {
						$img.attr('src', '${pageContext.request.contextPath}/img/store_checkbox_active.png');
						$label.css('font-weight', 'bold');
					} else {
						$img.attr('src', '${pageContext.request.contextPath}/img/store_checkbox.png');
						$label.css('font-weight', 'normal');
					}
				});
				let isIdChecked = false;
				let isPwMatched = false;


				// 아이디 유효성 검사
				$("#store_id").on("input", function () {
					const storeId = $(this).val();
					const idRegex = /^[a-z0-9]{8,15}$/;

					isIdChecked = false; // 중복확인 무효화!

					if (storeId === "") {
						$("#idCheckMessage").css("color", "red").text("* 아이디를 입력하세요.");
						return;
					}
					if (!idRegex.test(storeId)) {
						$("#idCheckMessage").css("color", "red").text("* 영어 소문자, 숫자 8~15자만 가능합니다.");
						return;
					}

					$("#idCheckMessage").css("color", "red").text("* 중복확인을 해주세요.");
				});
				// 아이디 중복확인 버튼 클릭
				$("#checkIdButton").click(function () {
					const storeId = $("#store_id").val();
					if (storeId === "") {
						$("#idCheckMessage").css("color", "red").text("* 아이디를 입력하세요.");
						isIdChecked = false;
						return;
					}

					$.ajax({
						url: "/store/checkId",
						type: "GET",
						data: { store_id: storeId },
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
				$("#store_pwd").on("input", function () {
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
					const pw = $("#store_pwd").val();
					const pwConfirm = $("#confirmPassword").val();

					if (pw !== pwConfirm) { // 비밀번호 일치 x
						$("#pwCheckMessage").css("color", "red").text("* 비밀번호가 일치하지 않습니다.");
						isPwMatched = false;
					} else { // 비밀번호 일치 o
						$("#pwCheckMessage").css("color", "green").text("* 비밀번호가 일치합니다.");
						isPwMatched = true;
					}
				});

				// 이미지 선택시 최대 5개 제한
				$("#storeImage").on("change", function () {
					if (this.files.length > 5) {
						alert("최대 5개의 이미지만 선택할 수 있습니다.");
						this.value = "";
					}
				});

				// 사업자 등록번호 유효성 검사
				$("#business_number").on("input", function () {
					// 숫자만 입력되게 처리
					let value = $(this).val().replace(/[^0-9]/g, "");
					if (value.length > 10) value = value.slice(0, 10); // 10자리 제한
					$(this).val(value);

					if (value.length !== 10) {
						$(this).css("border-color", "red");
					} else {
						$(this).css("border-color", "");
					}
				});

				// 전화번호 하이픈 자동포맷
				$("#store_telnumber").on("input", function () {
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

				// 주소
				let isSearching = false;

				$("#searchAddressBtn").click(function () {
					new daum.Postcode({
						oncomplete: function (data) {
							$("#store_address").val(data.address);
							$("#storeAddressDetail").removeAttr("readonly").focus();
							getCoordinates(data.address);
						}
					}).open();
				});

				function getCoordinates(fullAddress) {
					$.ajax({
						url: "https://dapi.kakao.com/v2/local/search/address.json",
						type: "GET",
						data: { query: fullAddress },
						headers: {
							Authorization: "KakaoAK 0f1a7e3a49ac979863779a853f2033d7"
						},
						success: function (res) {
							if (res.documents.length > 0) {
								const x = res.documents[0].x;
								const y = res.documents[0].y;
								// input에 값 넣기
								$("#longitude").val(x);
								$("#latitude").val(y);
							} else {
								$("#longitude").val("");
								$("#latitude").val("");
							}
						},
						error: function () {
							$("#longitude").val("");
							$("#latitude").val("");
						}
					});
				}
				// 파일 선택시 최대 5개 제한
				$("#storeImage").on("change", function () {
					if (this.files.length > 5) {
						alert("최대 5개의 파일만 선택할 수 있습니다.");
						this.value = "";
					}
				});

				// 최종 submit 시 확인(아이디, 비밀번호, 이미지, 체크박스, 사업자 등록번호)
				$("#signupForm").submit(function (e) {
					// 아이디 유효성 검사
					const storeId = $("#store_id").val();
					const idRegex = /^[a-z0-9]{8,15}$/;
					if (storeId === "") {
						$("#idCheckMessage").css("color", "red").text("* 아이디를 입력하세요.");
						$("#store_id").focus();
						e.preventDefault();
						return;
					}
					if (!idRegex.test(storeId)) {
						$("#idCheckMessage").css("color", "red").text("* 영어 소문자, 숫자 8~15자만 가능합니다.");
						$("#store_id").focus();
						e.preventDefault();
						return;
					}

					// 비밀번호 유효성 검사
					const pw = $("#store_pwd").val();
					const pwRegex = /^[a-zA-Z0-9?!@.]+$/;
					if (pw === "") {
						$("#pwCheckMessage").css("color", "red").text("* 비밀번호를 입력하세요.");
						$("#store_pwd").focus();
						e.preventDefault();
						return;
					}
					if (!pwRegex.test(pw)) {
						$("#pwCheckMessage").css("color", "red").text("* 영어, 숫자, ?, !, @, .만 사용 가능합니다.");
						$("#store_pwd").focus();
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

					// 기존 검사(중복확인, 이미지, 카테고리, 사업자등록번호 등)
					if (!isIdChecked) {
						alert("아이디 중복확인을 진행해주세요.");
						e.preventDefault();
						$("#store_id").focus();
						return;
					}
					if (!isPwMatched) {
						alert("비밀번호가 일치하지 않습니다.");
						e.preventDefault();
						$("#confirmPassword").focus();
						return;
					}
					const files = $("#storeImage")[0].files;
					if (files.length === 0) {
						alert("가게 이미지를 업로드해주세요.");
						$("#storeImage").focus();
						e.preventDefault();
						return;
					}
					let checkedCount = $(".category-checkbox:checked").length;
					if (checkedCount === 0) {
						alert("카테고리를 선택하세요.");
						e.preventDefault();
						$(".category-checkbox").first().next('img')[0].scrollIntoView({ behavior: "smooth", block: "center" });
						return;
					}
					const businessNumber = $("#business_number").val();
					if (businessNumber.length !== 10) {
						alert("사업자 등록번호는 숫자 10자리여야 합니다.");
						$("#business_number").focus();
						e.preventDefault();
						return;
					}
				});
			});

		</script>
	</body>



	</html>