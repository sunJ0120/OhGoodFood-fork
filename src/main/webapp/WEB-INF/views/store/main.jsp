<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">

<head>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<meta charset="utf-8" />

<link rel="stylesheet" href="../../../css/storemain.css" />
<title>Ohgoodfood</title>
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

					<span class="NumberIcon">
						<img src="${pageContext.request.contextPath}/img/store_number.png" alt="전화 아이콘">
					</span> 
					<span class="storeNumber">${store.store_telnumber}</span>
				</div>
			</div>
			 <!-- 이미지 슬라이더 -->
			<div class="store-image-slider">
				<div class="slider-track">
					<c:forEach var="img" items="${images}">
						<img
							src="https://ohgoodfood.s3.ap-northeast-2.amazonaws.com/${img.store_img}"
							alt="Store Image" class="slider-img">
					</c:forEach>
				</div>
				<div class="slider-indicators"></div>
			</div>
			<!-- 오픈/마감 버튼 -->
			<div class="sale-status">
			    <div class="view-toggle">
			        <button id="open" class="view-button <c:if test="${store.store_status == 'Y'}">active</c:if>">오픈하기</button>
			        <button id="close" class="view-button <c:if test="${store.store_status == 'N'}">active</c:if>">마감하기</button>
			    </div>
			</div>
			<!-- 판매 정보 영역 -->
			<div class="sale-info">
				<p>오굿백 구성 후에 오픈 버튼을 눌러주세요 ~</p>
				<div class="info-title">
					<img src="../../../img/store_bag.png" alt="오굿백 아이콘">
					<p>오굿백</p>
				</div>
				
				<!-- 상품 상세정보 폼 -->
				<div class="info-content">
					<p>${product.product_explain}</p>
					<form>
						<!-- 픽업 날짜 -->
						<div class="form-group">
							<label class="label">픽업 날짜</label> <span class="divider">|</span>
							<div class="btn-container">
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

							<img src="../../../img/store_time.png" alt="시계 아이콘" class="timer-icon" id="timer-icon">

							 <!-- 시간 설정 모달 -->
							<div id="time-modal" class="modal">
								<div class="modal-content">
									<span class="close-modal" id="close-modal">&times;</span>
									<h3>픽업 시간 선택</h3>

									<select id="pickup-time">
										<option value="09:00">09:00</option>
										<option value="09:30">09:30</option>
										<option value="10:00">10:00</option>
										<option value="10:30">10:30</option>
										<option value="11:00">11:00</option>
										<option value="11:30">11:30</option>
										<option value="12:00">12:00</option>
										<option value="12:30">12:30</option>
										<option value="13:00">13:00</option>
										<option value="13:30">13:30</option>
										<option value="14:00">14:00</option>
										<option value="14:30">14:30</option>
										<option value="15:00">15:00</option>
										<option value="15:30">15:30</option>
										<option value="16:00">16:00</option>
										<option value="16:30">16:30</option>
										<option value="17:00">17:00</option>
										<option value="17:30">17:30</option>
										<option value="18:00">18:00</option>
										<option value="18:30">18:30</option>
										<option value="19:00">19:00</option>
										<option value="19:30">19:30</option>
										<option value="20:00">20:00</option>
										<option value="20:30">20:30</option>
										<option value="21:00">21:00</option>
										<option value="21:30">21:30</option>
										<option value="22:00">22:00</option>
									</select>
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
								<img src="../../../img/store_minus.png" alt="빼기 아이콘" class="quantity-icon" id="minus-btn">
								<div class="count" id="count-value">${product.amount}개</div>
								<img src="../../../img/store_plus.png" alt="더하기 아이콘" class="quantity-icon" id="plus-btn">
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

     	// 오픈, 마감 버튼 클릭 이벤트
        $('.view-button').click(function () {
		    const buttonId = $(this).attr('id');
		
		    // 현재 상태와 같은 버튼 클릭시 무시
		    if ((storeStatus === 'Y' && buttonId === 'open') || 
		        (storeStatus === 'N' && buttonId === 'close')) {
		        // 이미 현재 상태이면 무시
		        return;
		    }
		
		    let message = (buttonId === 'open') ? '정말 오픈하시겠습니까?' : '정말 마감하시겠습니까?';
		    $('#confirmMessage').text(message);
		    $('#confirmModal').fadeIn(200);
		
		    $('#confirmYes').off('click').on('click', function () {
		        $.ajax({
		            url: '/store/updateStatus',
		            type: 'POST',
		            data: { status: (buttonId === 'open') ? 'Y' : 'N' },
		            success: function () {
		                $('.view-button').removeClass('active');
		                $('#' + buttonId).addClass('active');
		                
		                // 서버에서 상태 바꿨으니까 JS storeStatus 값도 변경
		                storeStatus = (buttonId === 'open') ? 'Y' : 'N';
		             	
		                // 마감시 필드 초기화
		                if (buttonId === 'close') {
		                    $('input[type="number"]').val('');
		                    $('#pickup-time-input').val('');
		                    $('.pickup-btn').removeClass('active');
		                    count = 1;
		                    $('#count-value').text(count + '개');
		                }
		                
		                $('#confirmModal').fadeOut(200);
		            },
		            error: function () {
		                alert('서버 오류가 발생했습니다.');
		            }
		        });
		    });
		
		    $('#confirmNo').off('click').on('click', function () {
		        $('#confirmModal').fadeOut(200);
		    });
		});

        // 픽업 날짜 버튼 이벤트
        $('.pickup-btn').click(function () {
            $('.pickup-btn').removeClass('active');
            $(this).addClass('active');
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
            const start = $('#pickup-time').val(); // 예: "09:30"
            if (start) {
                // 시간 계산
                const [h, m] = start.split(':').map(Number);
                let endH = h + 1;
                let endM = m;
                if (endH > 23) endH = endH - 24; // 24시 넘어가면 0시로
                // 두 자리수로 포맷
                const end = `\${String(endH).padStart(2, '0')}:\${String(endM).padStart(2, '0')}`;
                
                $('#pickup-time-input').val(`${start} ~ ${end}`);
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

        $('#timer-icon').click(function () {
            $('#time-modal').css('display', 'flex');
        });

        $('#closeTimeModal').click(function () {
            $('#time-modal').css('display', 'none');
        });
        
    	// 페이지 로드할 때 마감상태(N)이면 필드 초기화
        if (storeStatus === 'N') {
            $('input[type="number"]').val('');
            $('#pickup-time-input').val('');
            $('.pickup-btn').removeClass('active');
            count = 1;
            $('#count-value').text(count + '개');
        }

    });
</script>

</html>