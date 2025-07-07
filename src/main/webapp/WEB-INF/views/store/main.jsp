<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">

<head>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<meta charset="utf-8" />

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/storemain.css" />
<title>Ohgoodfood</title>
<link rel="icon" type="image/jpeg" href="https://ohgoodfood.s3.ap-northeast-2.amazonaws.com/shinhanmoilicon32x32.jpg">
</head>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<body>
	<div id="wrapper">
		<!-- 헤더 -->
		<%@ include file="/WEB-INF/views/store/header.jsp"%>
		<main>
			<!-- 가게 상단 정보 -->
			<div class="main-header">
				<div class="storeName">${store.store_name}</div>
				<div class="storeInfo">
					<!-- 주소, 전화번호 표시 -->
					<span class="addressIcon"> 
						<img src="${pageContext.request.contextPath}/img/store_address.png" alt="위치 아이콘">
					</span> 
					<span class="storeAddress" id="address-short">${store.store_address}</span>
					
					<!-- 주소 상세 팝업 모달 -->
					<div class="address-modal" id="addressModal">
						<div class="address-modal-content">
							<div class="address-modal-header">
								<span>상세 주소</span>
								<button class="close-modal" id="closeAddressModal">&times;</button>
							</div>
							<div class="address-modal-body">
								<p id="fullAddress"></p>
							</div>
						</div>
					</div>
					<!-- 전화번호 아이콘, 가게 전화번호 -->
					<span class="NumberIcon">
						<img src="${pageContext.request.contextPath}/img/store_number.png" alt="전화 아이콘">
					</span> 
					<span class="storeNumber">${store.store_telnumber}</span>
				</div>
			</div>
			 <!-- 이미지 슬라이더 영역 -->
			<div class="store-image-slider">
				<div class="slider-track">
					<!-- 가게 이미지 반복 출력 -->
					<c:forEach var="img" items="${images}">
						<img
							src="https://ohgoodfood.s3.ap-northeast-2.amazonaws.com/${img.store_img}"
							alt="Store Image" class="slider-img">
					</c:forEach>
				</div>
				<!-- 이미지 하단 인디케이터 -->
				<div class="slider-indicators"></div>
			</div>

			<!-- 오픈/마감 버튼 -->
			<div class="sale-status">
			    <div class="view-toggle">
					<!-- 현재 상태에 따라 active class 적용 -->
			        <button id="open" class="view-button <c:if test="${store.store_status == 'Y'}">active</c:if>">오픈하기</button>
			        <button id="close" class="view-button <c:if test="${store.store_status == 'N'}">active</c:if>">마감하기</button>
			    </div>
			</div>

			<!-- 판매 정보 영역 -->
			<div class="sale-info">
				<div class="saleHeaderBox">
					<p>오굿백 구성 후에 오픈 버튼을 눌러주세요 ~</p>
					<img src="${pageContext.request.contextPath}/img/store_explain.png" class= "explainIcon" alt="물음표 아이콘">
				</div>
				<!-- 설명 모달 -->
				<div id="explainModal" class="explain-modal" style="display:none;">
				<div class="explain-modal-content">
					<div class="explain-modal-header">
					<span>오굿백 설명</span>
					<button id="closeExplainModal" class="close-explain-modal">&times;</button>
					</div>
					<div class="modal-body">
						<div class="explainGroup">
							<div class="explainImg">
								<img src="${pageContext.request.contextPath}/img/store_bag.png" class="explainIcon2" alt="오굿백 아이콘" >
								<div class="explainTitle">오굿백이란?</div>
							</div>
							<div class="explainContent">
								오굿백은 가게에 남아 있는 재고 상품들을 <span class="highlight">랜덤박스</span> 형식으로 구성하여 판매하는 특별 상품입니다.
							</div>

							<div class="explainContent">
								남은 재고를 효율적으로 처리하면서도 고객에게는 다양한 상품을 합리적인 가격에 경험할 수 있는 기회를 제공합니다.
							</div>	
						</div>
						<div class="explainGroup">
							<div class="explainImg">
								<img src="${pageContext.request.contextPath}/img/store_explain2.png" class="explainIcon3" alt="모리 궁금 아이콘" >
								<div class="explainTitle">오굿백 설명은 어떻게 작성하나요?</div>
							</div>
							<div class="explainContent">
								오늘 오굿백에 <span class="highlight">어떤 상품</span>들이 포함되어 있는지, <span class="highlight">가게 대표 메뉴</span> 등에 대해서 작성하면 됩니다.
							</div>
						</div>
						<div class="explainGroup">
							<div class="explainImg">
								<img src="${pageContext.request.contextPath}/img/store_explain2.png" class="explainIcon3" alt="모리 궁금 아이콘" >
								<div class="explainTitle">픽업 날짜/시간은 무엇인가요?</div>
							</div>
							<div class="explainContent">
								<span style="font-weight: bold;">픽업 날짜:</span> 고객이 상품을 픽업할 날짜로, “오늘” 또는 “내일” 중 선택할 수 있습니다.
							</div>
							<div class="explainContent">
								<span style="font-weight: bold;">픽업 날짜가 “오늘”인 경우</span>
							</div>	
							<div class="explainContent">
								픽업 시작 시간은 현재 시간 기준 <span class="highlight">3시간 이후</span>부터 가능합니다.
							</div>
							<div class="explainContent">
								픽업 마감 시간은 픽업 시작 시간으로부터 <span class="highlight">최소 1시간 이후부터 최대 23:30</span>까지 설정할 수 있습니다.
							</div>
							<div class="explainContent">
								<span style="font-weight: bold;">확정 시간:</span> 픽업 시작 시간 2시간 전부터 주문 확정이 시작되며, 픽업 시작 1시간 전부터는 주문 취소만 가능합니다.
							</div>
							<div class="explainContent">
								<button type="button" class="toggleBtn">▶️</button>
								예시
							</div>
							<div class="toggleContent" style="display: none;">
								<span style="font-family: 'nanumesquareneo_b';">현재 시간이 오후 2시일 때</span>
								<span>- 픽업 시작 시간: 17:00 ~</span>
								<span>- 픽업 종료 시간: 18:00 ~ 23:30 선택 가능</span>
								<span>- 주문 확정 가능 시간: 15:00(픽업 시작 2시간 전) ~ 16:00</span>
								<span>- 주문 취소 가능 시간: 15:00 ~ 17:00</span>
							</div>
							<div class="explainContent">
								<span style="font-weight: bold;">픽업 날짜가 “내일”인 경우</span>
							</div>	
							<div class="explainContent">
								픽업 시작 시간은 <span class="highlight">오전 6시</span>부터 가능합니다.
							</div>
							<div class="explainContent">
								픽업 마감 시간은 <span class="highlight">최대 23:30</span>까지 설정할 수 있습니다.
							</div>
							<div class="explainContent">
								<span style="font-weight: bold;">확정 시간:</span> 가게 마감 1시간 전까지 주문 확정이 가능하며, 이후부터는 주문 취소만 가능합니다.
							</div>
							<div class="explainContent">
								<button type="button" class="toggleBtn">▶️</button>
								예시
							</div>
							<div class="toggleContent" style="display: none;">
								<span style="font-family: 'nanumesquareneo_b';">내일 픽업 시</span>
								<span>- 픽업 시작 시간: 06:00 ~</span>
								<span>- 픽업 종료 시간: 07:00 ~ 23:30 선택 가능</span>
								<span>- 마감 시간이 11:30인 경우</span>
								<span>- 주문 확정 가능 시간: 21:30 ~ 22:30</span>
								<span>- 주문 취소 가능 시간: 21:30 ~ 23:30</span>
							</div>
						</div>
						<div class="explainGroup">
							<div class="explainImg">
								<img src="${pageContext.request.contextPath}/img/store_explain2.png" class="explainIcon3" alt="모리 궁금 아이콘" >
								<div class="explainTitle">원래 가격이란?</div>
							</div>
							<div class="explainContent">
								원래 상품의 가격을 입력하시면 됩니다.
							</div>
						</div>
						<div class="explainGroup">
							<div class="explainImg">
								<img src="${pageContext.request.contextPath}/img/store_explain2.png" class="explainIcon3" alt="모리 궁금 아이콘" >
								<div class="explainTitle">오굿백 가격이란?</div>
							</div>
							<div class="explainContent">
								오굿백으로 판매할 가격을 입력하시면 됩니다.
							</div>
						</div>
						<div class="explainGroup">
							<div class="explainImg">
								<img src="${pageContext.request.contextPath}/img/store_explain2.png" class="explainIcon3" alt="모리 궁금 아이콘" >
								<div class="explainTitle">오굿백 수량이란?</div>
							</div>
							<div class="explainContent">
								판매할 오굿백 수량을 입력하시면 됩니다.
							</div>
						</div>
					</div>
				</div>
				</div>
				<div class="info-title">
					<img src="${pageContext.request.contextPath}/img/store_bag.png" alt="오굿백 아이콘">
					<p>오굿백</p>
				</div>
				
				<!-- 상품 상세정보 입력 -->
				<div class="info-content">
					<form>
						<!-- 상품 설명 -->
						<textarea class="product_explain" maxlength="50" placeholder="오굿백 설명을 작성해주세요">${product.product_explain}</textarea>

						<!-- 픽업 날짜 선택 -->
						<div class="form-group">
							<label class="label">픽업 날짜</label> <span class="divider">|</span>
							<div class="btn-container">
								<!-- 오늘/내일 버튼 -->
							    <button type="button" class="pickup-btn ${isToday ? 'active' : ''}" data-value="today">오늘</button>
							    <button type="button" class="pickup-btn ${!isToday ? 'active' : ''}" data-value="tomorrow">내일</button>
							</div>
						</div>
						<!-- 픽업 시간 -->
						<div class="form-group">
							<label class="label">픽업 시간</label> 
							<span class="divider">|</span>
							<input type="text" 
							       value="<fmt:formatDate value='${product.pickup_start}' pattern='HH:mm' /> ~ <fmt:formatDate value='${product.pickup_end}' pattern='HH:mm' />" 
							       id="pickup-time-input" 
							       class="time-input" readonly />

							<img src="${pageContext.request.contextPath}/img/store_time.png" alt="시계 아이콘" class="timer-icon" id="timer-icon">

							 <!-- 시간 설정 모달 -->
							<div id="time-modal" class="modal">
								<div class="modal-content">
									<span class="close-modal" id="close-modal">&times;</span>
									<h3>픽업 시간 선택</h3>

									<select id="pickup-time"> </select>
									<select id="pickup-end-time"></select>

									<button id="pickup-time-confirm" type="button">확인</button>
								</div>
							</div>
						</div>

						<!-- 원래 가격 -->
						<div class="form-group">
							<label class="label">원래 가격</label> <span class="divider">|</span>
							<input type="number" value="${product.origin_price}" class="time-input" placeholder="가격을 입력하세요" min="0" step="100">
						</div>

						<!-- 오굿백 가격 -->
						<div class="form-group">
							<label class="label">오굿백 가격</label> <span class="divider">|</span>
							<input type="number" value="${product.sale_price}" class="time-input" placeholder="가격을 입력하세요" min="0" step="100">
						</div>
						
						<!-- 오굿백 수량 -->
						<div class="form-group">
							<label class="label">오굿백 수량</label> <span class="divider">|</span>
							<div class="quantity-container">
								<img src="${pageContext.request.contextPath}/img/store_minus.png" alt="빼기 아이콘" class="quantity-icon" id="minus-btn">
								<div class="count" id="count-value">${product.amount}개</div>
								<img src="${pageContext.request.contextPath}/img/store_plus.png" alt="더하기 아이콘" class="quantity-icon" id="plus-btn">
							</div>
						</div>
					</form>
				</div>				
			</div>

			<!-- 오픈/마감 확인 모달 -->
			<div class="confirm-modal-container" id="confirmModal" style="display:none;">
				   <div class="confirm-modal-content">
				       <p id="confirmMessage"></p>
				       <div class="confirm-buttons">
				           <button id="confirmYes">확인</button>
				           <button id="confirmNo">취소</button>
				       </div>
				   </div>
			</div>
		</main>
		<!-- 푸터 -->
		<%@ include file="/WEB-INF/views/store/footer.jsp"%>
	</div>
</body>
<script>
	// storeStatus: 현재 가게 오픈/마감 상태
	let storeStatus = '${store.store_status}'; // 서버에서 store_status 값 가져옴
	
	$(window).on('load', function () {
        // 이미지 슬라이더(터치, 드래그)
        const $track = $('.slider-track');
        let $images = $('.slider-img');
        const $indicatorContainer = $('.slider-indicators');
        let currentIndex = 0;
        let startX = 0;
        let currentX = 0;
        let isDragging = false;
        let imgWidth = $images[0].clientWidth;

        function createIndicators() {
            $indicatorContainer.empty();
            for (let i = 0; i < $images.length; i++) {
                const dot = $('<div>').addClass('slider-indicator' + (i === currentIndex ? ' active' : ''));
                $indicatorContainer.append(dot);
            }
        }

        function updateIndicators() {
            $indicatorContainer.find('.slider-indicator').each(function (i) {
                $(this).toggleClass('active', i === currentIndex);
            });
        }

        function updateSlider(instant = false) {
            $track.css('transition', instant ? 'none' : 'transform 0.3s');
            $track.css('transform', 'translateX(0px)');
        }

        function rotateLeft() {
            $track.append($track.children().first());
            $images = $track.children();
            currentIndex = (currentIndex + 1) % $images.length;
            updateSlider(true);
            updateIndicators();
        }

        function rotateRight() {
            $track.prepend($track.children().last());
            $images = $track.children();
            currentIndex = (currentIndex - 1 + $images.length) % $images.length;
            updateSlider(true);
            updateIndicators();
        }

        // 터치 이벤트
        $track.on('touchstart', function (e) {
            isDragging = true;
            startX = e.originalEvent.touches[0].clientX;
            currentX = startX;
            imgWidth = $images[0].clientWidth;
            $track.css('transition', 'none');
        });
        $track.on('touchmove', function (e) {
            if (!isDragging) return;
            currentX = e.originalEvent.touches[0].clientX;
            const diff = currentX - startX;
            $track.css('transform', `translateX(${diff}px)`);
        });
        $track.on('touchend', function (e) {
            if (!isDragging) return;
            isDragging = false;
            const diff = currentX - startX;
            if (diff < -50) {
                $track.css('transition', 'transform 0.3s');
                $track.css('transform', `translateX(-${imgWidth}px)`);
                setTimeout(function () {
                    rotateLeft();
                }, 310); 
            } else if (diff > 50) {
                rotateRight();
                $track.css('transition', 'none');
                $track.css('transform', `translateX(-${imgWidth}px)`);
                setTimeout(function () {
                    $track.css('transition', 'transform 0.3s');
                    $track.css('transform', 'translateX(0px)');
                }, 10);
            } else {
                updateSlider();
            }
        });

        // 마우스 이벤트
        $track.on('mousedown', function (e) {
            isDragging = true;
            startX = e.clientX;
            currentX = startX;
            imgWidth = $images[0].clientWidth;
            $track.css('transition', 'none');
            $('body').css('user-select', 'none');
        });
        $(window).on('mousemove', function (e) {
            if (!isDragging) return;
            currentX = e.clientX;
            const diff = currentX - startX;
            $track.css('transform', `translateX(${diff}px)`);
        });
        $(window).on('mouseup', function (e) {
            if (!isDragging) return;
            isDragging = false;
            const diff = currentX - startX;
            if (diff < -50) {
                $track.css('transition', 'transform 0.3s');
                $track.css('transform', `translateX(-${imgWidth}px)`);
                setTimeout(function () {
                    rotateLeft();
                }, 310); 
            } else if (diff > 50) {
                rotateRight();
                $track.css('transition', 'none');
                $track.css('transform', `translateX(-${imgWidth}px)`);
                setTimeout(function () {
                    $track.css('transition', 'transform 0.3s');
                    $track.css('transform', 'translateX(0px)');
                }, 10);
            } else {
                updateSlider();
            }
            $('body').css('user-select', '');
        });

        // 초기화
        createIndicators();
        updateIndicators();
        updateSlider(true);

		// 오픈 버튼 클릭 시 상품 insert + 상태 변경 처리
		$('#open').click(function () {
		if (storeStatus === 'Y') return;

		// 상품 관련 필드들 추출
		const productExplain = $('textarea.product_explain').val().trim();
		const pickupDateType = $('.pickup-btn.active').data('value');
		const pickupTimeRange = $('#pickup-time-input').val();
		const originPrice = $('input').eq(1).val();
		const salePrice = $('input').eq(2).val();
		const amountText = $('#count-value').text();
		const amount = parseInt(amountText.replace('개', ''));

		const [startTime, endTime] = pickupTimeRange.split(' ~ ');

		if (!pickupDateType || !pickupTimeRange || !originPrice || !salePrice || !amount || !productExplain) {
			$('#confirmMessage').text("모든 필드를 입력해주세요.");
			$('#confirmNo').hide(); // 취소 버튼 숨김
			$('#confirmYes').off('click').on('click', function () {
				$('#confirmModal').fadeOut(200);
			});
			$('#confirmModal').fadeIn(200);
			return;
		}

		$('#confirmMessage').text("정말 오픈하시겠습니까?");
		$('#confirmModal').fadeIn(200);

		$('#confirmYes').off('click').on('click', function () {
			$.ajax({
				url: '/store/createProduct',
				type: 'POST',
				data: {
					productExplain,
					pickupDateType,
					pickupStartTime: $('#pickup-time').val(),
					pickupEndTime: $('#pickup-end-time').val(),
					originPrice,
					salePrice,
					amount
				},
				success: function (res) {
					if (res === 'closedToday') {
						// 오늘 이미 마감된 경우
						$('#confirmMessage').text("금일 마감되었습니다.");
						$('#confirmNo').hide();
						$('#confirmYes').off('click').on('click', function () {
							$('#confirmModal').fadeOut(200);
						});
						$('#confirmModal').fadeIn(200);
						return;
					}
					if (res === 'success') {
						storeStatus = 'Y';
						$('#open').addClass('active');
						$('#close').removeClass('active');

						// 즉시 비활성화
						$('textarea.product_explain').prop('readonly', true);
						$('input[type="number"]').prop('readonly', true);
						$('#pickup-time-input').prop('readonly', true);

						$('.pickup-btn').css({ 'opacity': '0.5', 'cursor': 'not-allowed' }).off('click');
						$('#minus-btn, #plus-btn').css({ 'opacity': '0.5', 'cursor': 'not-allowed' }).off('click');
						$('#timer-icon').css({ 'opacity': '0.5', 'cursor': 'not-allowed' }).off('click');

					} else {
						alert("오픈 중 오류가 발생했습니다.");
					}
					$('#confirmModal').fadeOut(200);
				},

			});
		});

		$('#confirmNo').off('click').on('click', function () {
			$('#confirmModal').fadeOut(200);
		});
	});


		// 마감 버튼 클릭 시 단순 상태 변경
	$('#close').click(function () {
		if (storeStatus === 'N') return;

		// 서버에 미확정 주문 있는지 조회
		$.ajax({
			url: '/store/checkOrderStatus', 
			type: 'GET',
			success: function (count) {
				if (count > 0) {
					// 모달 띄우기
					$('#confirmMessage').text("미확정 주문이 있습니다.");
					$('#confirmYes').text("주문내역").off('click').on('click', function () {
						window.location.href = '/store/reservation';
					});
					$('#confirmNo').text("닫기").show().off('click').on('click', function () {
						$('#confirmModal').fadeOut(200);
					});
					$('#confirmModal').fadeIn(200);
					return;
				}

				// 없으면 기존 마감하기 실행
				$('#confirmMessage').text("정말 마감하시겠습니까?");
				$('#confirmYes').text("확인").off('click').on('click', function () {
					$.ajax({
						url: '/store/updateStatus',
						type: 'POST',
						data: { status: 'N' },
						success: function () {
							storeStatus = 'N';
							$('#close').addClass('active');
							$('#open').removeClass('active');
							// 필드 초기화 
							$('textarea.product_explain').val('').prop('readonly', false);
							$('input[type="number"]').val('').prop('readonly', false);
							$('#pickup-time-input').val('').prop('readonly', false);
							$('.pickup-btn').removeClass('active').css('opacity', '').css('cursor', 'pointer');
							$('#minus-btn, #plus-btn').css('opacity', '').css('cursor', 'pointer');
							$('#timer-icon').css('opacity', '').css('cursor', 'pointer');
							count = 1;
							$('#count-value').text(count + '개');
							
							generatePickupOptions();
													
							$('#minus-btn').off('click').on('click', function () {
								if (count > 1) {
									count--;
									$('#count-value').text(count + '개');
								}
							});
							$('#plus-btn').off('click').on('click', function () {
								count++;
								$('#count-value').text(count + '개');
							});
							$('.pickup-btn').off('click').on('click', function () {
								$('.pickup-btn').removeClass('active');
								$(this).addClass('active');

								$('#pickup-time-input').val('');
  									generatePickupOptions();
							});
							$('#timer-icon').off('click').on('click', function () {
								$('#time-modal').css('display', 'flex');
							});
							$('#confirmModal').fadeOut(200);
							},
							error: function () {
								alert('서버 오류가 발생했습니다.');
								$('#confirmModal').fadeOut(200);
							}
						});
					});

					$('#confirmNo').text("취소").off('click').on('click', function () {
						$('#confirmModal').fadeOut(200);
					});

					$('#confirmModal').fadeIn(200);
				},
				error: function () {
					alert('주문 상태 확인 중 오류가 발생했습니다.');
				}
			});
		});

        // 픽업 날짜 버튼 이벤트
        $('.pickup-btn').click(function () {
            $('.pickup-btn').removeClass('active');
            $(this).addClass('active');

			//픽업 시간 필드 초기화
			$('#pickup-time-input').val('');
			generatePickupOptions();
        });

        // 오굿백 수량 증감 버튼
        let count = 1;
        function updateCount() {
            $('#count-value').text(count + '개');
        }
        $('#minus-btn').click(function () {
            if (count > 1) {
                count--;
                updateCount();
            }
        });
        $('#plus-btn').click(function () {
            count++;
            updateCount();
        });

        // 알람 모달
		$('#timer-icon').click(function () {
			// 픽업 날짜가 선택되어 있는지 확인
			const pickupDateType = $('.pickup-btn.active').data('value');
			if (!pickupDateType) {
				alert('먼저 픽업 날짜를 선택해주세요.');
				return;
			}
			// 모달 열 때 select 활성화
			$('#pickup-time').prop('disabled', false);
			$('#pickup-end-time').prop('disabled', false);
			generatePickupOptions();
			$('#time-modal').css('display', 'flex');
		});

        $('#close-modal').click(function () {
            $('#time-modal').css('display', 'none');
        });
        $('#time-modal').click(function (e) {
            if (e.target === this) {
                $(this).css('display', 'none');
            }
        });

        // 픽업 시간 모달
        $('#pickup-time-confirm').click(function () {
			const start = $('#pickup-time').val();
			const end = $('#pickup-end-time').val();
			if(start && end) {
				$('#pickup-time-input').val(start + ' ~ ' + end);
			}
			if (start && end) {
				$('#pickup-time-input').val(start + ' ~ ' + end);
			} else {
				alert("픽업 시작시간과 종료시간을 모두 선택해주세요.");
				return;
			}

			$('#time-modal').css('display', 'none');
		});

        
	     // 주소 팝업
        $('#address-short').click(function() {
            const fullAddress = '${store.store_address}';
            $('#fullAddress').text(fullAddress);
            $('#addressModal').fadeIn(200);
        });

        $('#closeAddressModal').click(function() {
            $('#addressModal').fadeOut(200);
        });

        $('#closeTimeModal').click(function () {
            $('#time-modal').css('display', 'none');
        });
        
    	// 페이지 로드할 때 마감상태(N)이면 필드 초기화
        if (storeStatus === 'N') {
        	$('textarea.product_explain').val('');
            $('input[type="number"]').val('');
            $('#pickup-time-input').val('');
            $('.pickup-btn').removeClass('active');
           
            count = 1;
            $('#count-value').text(count + '개');
        }

		if (storeStatus === 'Y') {
			// 설명 텍스트 비활성화
			$('textarea.product_explain').prop('readonly', true);

			// 숫자 입력 비활성화
			$('input[type="number"]').prop('readonly', true);

			// 픽업 시간 입력 비활성화
			$('#pickup-time-input').prop('readonly', true);

			// 픽업 날짜 버튼 비활성화
			$('.pickup-btn').css({ 'opacity': '0.5', 'cursor': 'not-allowed' }).off('click');

			// 수량 버튼 비활성화
			$('#minus-btn, #plus-btn').css({ 'opacity': '0.5', 'cursor': 'not-allowed' }).off('click');

			// 시계 아이콘 클릭 방지
			$('#timer-icon').css({ 'opacity': '0.5', 'cursor': 'not-allowed' }).off('click');
		}

		// 픽업 시작 시간 옵션 생성 함수
		function generatePickupOptions() {
			const pickupDateType = $('.pickup-btn.active').data('value');

			let now = new Date();
			let startHour, startMinute;

			if (pickupDateType === 'tomorrow') {
				// 내일이면 무조건 오픈시간 06:00부터
				startHour = 6;
				startMinute = 0;
			} else {
				// 오늘이면 현재 시간 기준 +3시간 후로 설정
				now.setMinutes(now.getMinutes() + 180);
				startHour = now.getHours();
				startMinute = now.getMinutes();

				// 30분 단위로 올림
				if (startMinute > 0 && startMinute < 30) startMinute = 30;
				else if (startMinute > 30) {
					startMinute = 0;
					startHour++;
					if (startHour > 23) startHour = 0;
				}
			}

			const pickupTimeSelect = $('#pickup-time');
			const pickupEndTimeSelect = $('#pickup-end-time');

			pickupTimeSelect.empty();
			pickupEndTimeSelect.empty();

            // 시작 시간: 06:00부터
            const openHour = 6;
            // 종료 시간: 23:30까지
            const closeHour = 23;
			const closeMinute = 30;

			for (let h = openHour; h <= 22; h++) {
				for (let m = 0; m < 60; m += 30) {
					if (h < startHour || (h === startHour && m < startMinute)) continue;
					const hourStr = String(h).padStart(2, '0');
					const minuteStr = String(m).padStart(2, '0');
					const optionValue = hourStr + ':' + minuteStr;
					pickupTimeSelect.append($('<option>').val(optionValue).text(optionValue));
				}
			}

			pickupTimeSelect.off('change').on('change', function () {
				generatePickupEndOptions($(this).val());
			});

			if (pickupTimeSelect.children().length > 0) {
				const firstStart = pickupTimeSelect.children().first().val();
				pickupTimeSelect.val(firstStart);
				generatePickupEndOptions(firstStart);
			} else {
				pickupTimeSelect.prop('disabled', true);
				pickupEndTimeSelect.prop('disabled', true);
			}
		}


		// 종료 시간 옵션 생성 함수
        function generatePickupEndOptions(startTime) {
            const [startH, startM] = startTime.split(':').map(Number);

            const pickupEndTimeSelect = $('#pickup-end-time');
            pickupEndTimeSelect.empty();

            // 시작 시간: 06:00, 종료 시간: 23:30
            const openHour = 6;
            const closeHour = 23;
            const closeMinute = 30; // 23:30까지

            // 종료 시간은 시작 시간 + 최소 60분 부터 시작
            let startMinutesTotal = startH * 60 + startM + 60;
            const endMinutesTotal = closeHour * 60 + closeMinute;

            for (let totalM = startMinutesTotal; totalM <= endMinutesTotal; totalM += 30) {
                let h = Math.floor(totalM / 60);
                let m = totalM % 60;

                if (h > closeHour || (h === closeHour && m > closeMinute)) break;

                const hourStr = String(h).padStart(2, '0');
                const minuteStr = String(m).padStart(2, '0');
                const optionValue = hourStr + ':' + minuteStr;

                pickupEndTimeSelect.append($('<option>').val(optionValue).text(optionValue));
            }
        }
				// 설명 아이콘 클릭 시 모달 열기
		$('.explainIcon').click(function () {
			$('#explainModal').fadeIn(200);
		});

		// 설명 모달 닫기 버튼 클릭 시 모달 닫기
		$('#closeExplainModal').click(function () {
			$('#explainModal').fadeOut(200);
		});
	});

	$(document).on('click', '.toggleBtn', function() {
		const $content = $(this).parent().next('.toggleContent');
		$content.toggle();
		$content.toggleClass('active');
	});
</script>

</html>