<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
	
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="utf-8" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/storemypage.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/storeupdate.css" />

    <title>Ohgoodfood</title>
</head>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<body>
    <div id="wrapper">
        <!-- 헤더 -->
        <%@ include file="/WEB-INF/views/store/header.jsp" %>
        <main>
            <!-- 내 정보 헤더 -->
            <div class="myInfo-header">
                <div class="myInfo-group">
                    <img src="${pageContext.request.contextPath}/img/store_person.png" alt="마이페이지" class="personIcon">
                    <div class="myInfo">내 정보</div>
                </div>
            </div>

            <!-- 아이디, 사업자등록번호 -->
            <div class="myInfo-content">
                <input type="text" id="id" name="id" value="${store.store_id}" readonly>
                <input type="text" id="business_number" name="business_number" value="${store.business_number}" readonly>
            </div>

            <!-- 가게 정보-->
            <div class="main-content">
                <div class="storeInfo-header">
                    <div class="storeInfo-group">
                        <img src="${pageContext.request.contextPath}/img/store_mystore.png" alt="내 가게" class="myStoreIcon">
                        <div class="myInfo">내 가게</div>
                    </div>
                    <div class="viewSales-group">
                        <img src="${pageContext.request.contextPath}/img/store_sales.png" alt="매출확인" class="viewSalesIcon">
                        <button class="viewSales">매출확인</button>
                    </div>
                </div>

                <!-- 가게 이름, 주소, 전화번호 -->
                <div class="name-group">
                    <div class="name-container">
                        <div class="storeName">${store.store_name}</div>
                        <div class="info-container">
                            <img src="${pageContext.request.contextPath}/img/store_loaction.png" alt="위치" class="storeIcon">
                            <span class="storeAddress" id="address-short">${store.store_address}</span>
                            <!-- 주소 상세 팝업 모달 -->
							<div class="address-modal" id="addressModal">
								<div class="address-modal-content">
									<div class="address-modal-header">
										<span>상세 주소</span>
										<button type="button" class="aclose-modal" id="closeAddressModal">&times;</button>
									</div>
									<div class="address-modal-body">
										<p id="fullAddress"></p>
									</div>
								</div>
							</div>
                            <img src="${pageContext.request.contextPath}/img/store_number.png" alt="전화" class="storeIcon">
                            <div class="number">${store.store_telnumber}</div>
                        </div>
                    </div>
                    <!-- 수정 버튼 -->
                    <button class="updateBtn">수정</button>
                </div>

                <!-- 가게 이미지 슬라이더 -->
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

                <!-- 상세 정보 (영업시간, 카테고리, 대표메뉴, 설명) -->
                <div class="details-container">
                    <form>
                        <div class="form-group">
                            <label class="label">영업 시간</label>
                            <span class="divider">|</span>
							<div class="details-content" style="color:#8B6D5C; font-weight:bold">
							    ${openedTime} ~ ${closedTime}
							</div>

                        </div>
                    </form>
                    <form>
                        <div class="form-group">
                            <label class="label">카테고리</label>
                            <span class="divider">|</span>
							<div class="details-content">
							  <c:forEach var="category" items="${categories}">
							    ${category}
							  </c:forEach>
							</div>
                        </div>
                    </form>
                    <form>
                        <div class="form-group">
                            <label class="label">대표 메뉴</label>
                            <span class="divider">|</span>
                            <div class="details-content">${store.store_menu}</div>
                        </div>
                    </form>
                    <form>
                        <div class="form-group" id="bag-container">
                            <img src="${pageContext.request.contextPath}/img/store_bag.png" alt="오굿백" class="bagIcon">
                            <label class="label">가게설명</label>
                            <span class="divider">|</span>
                            <div class="details-content" style="line-height: 1.5; font-size:15px;">${store.store_explain}
                            </div>
                        </div>
                    </form>


                </div>
            </div>
        </main>
        <!-- 푸터 -->
        <%@ include file="/WEB-INF/views/store/footer.jsp" %>
    </div>
</body>
<script>
    // 슬라이더 초기화 함수
    function initSlider() {
        var $track = $('.slider-track');
        var $images = $('.slider-img');
        var $indicatorContainer = $('.slider-indicators');
        var currentIndex = 0;
        var startX = 0;
        var currentX = 0;
        var isDragging = false;
        var imgWidth = $images[0] ? $images[0].clientWidth : 400;

        // 인디케이터(점) 생성
        function createIndicators() {
            $indicatorContainer.empty();
            for (var i = 0; i < $images.length; i++) {
                var dot = $('<div>').addClass('slider-indicator' + (i === currentIndex ? ' active' : ''));
                $indicatorContainer.append(dot);
            }
        }
        // 인디케이터 상태 갱신
        function updateIndicators() {
            $indicatorContainer.find('.slider-indicator').each(function (i) {
                $(this).toggleClass('active', i === currentIndex);
            });
        }

        // 슬라이더 위치 갱신
        function updateSlider(instant) {
            $track.css('transition', instant ? 'none' : 'transform 0.3s');
            $track.css('transform', 'translateX(0px)');
        }

        // 왼쪽으로 슬라이드 시 첫 이미지 뒤로 이동
        function rotateLeft() {
            $track.append($track.children().first());
            $images = $track.children();
            currentIndex = (currentIndex + 1) % $images.length;
            updateSlider(true);
            updateIndicators();
        }

        // 오른쪽으로 슬라이드 시 마지막 이미지 앞으로 이동
        function rotateRight() {
            $track.prepend($track.children().last());
            $images = $track.children();
            currentIndex = (currentIndex - 1 + $images.length) % $images.length;
            updateSlider(true);
            updateIndicators();
        }

        // 기존 이벤트 제거 후 재바인딩
        $track.off();

        // 모바일 터치 이벤트
        $track.on('touchstart', function (e) {
            isDragging = true;
            startX = e.originalEvent.touches[0].clientX;
            currentX = startX;
            imgWidth = $images[0] ? $images[0].clientWidth : 400;
            $track.css('transition', 'none');
        });
        $track.on('touchmove', function (e) {
            if (!isDragging) return;
            currentX = e.originalEvent.touches[0].clientX;
            var diff = currentX - startX;
            $track.css('transform', 'translateX(' + diff + 'px)');
        });
        $track.on('touchend', function (e) {
            if (!isDragging) return;
            isDragging = false;
            var diff = currentX - startX;
            if (diff < -50) {
                $track.css('transition', 'transform 0.3s');
                $track.css('transform', 'translateX(-' + imgWidth + 'px)');
                $track.one('transitionend', rotateLeft);
            } else if (diff > 50) {
                rotateRight();
                $track.css('transition', 'none');
                $track.css('transform', 'translateX(-' + imgWidth + 'px)');
                setTimeout(function () {
                    $track.css('transition', 'transform 0.3s');
                    $track.css('transform', 'translateX(0px)');
                }, 10);
            } else {
                updateSlider();
            }
        });

        // PC 마우스 이벤트
        $track.on('mousedown', function (e) {
            isDragging = true;
            startX = e.clientX;
            currentX = startX;
            imgWidth = $images[0] ? $images[0].clientWidth : 400;
            $track.css('transition', 'none');
            $('body').css('user-select', 'none');
        });
        $(window).on('mousemove.slider', function (e) {
            if (!isDragging) return;
            currentX = e.clientX;
            var diff = currentX - startX;
            $track.css('transform', 'translateX(' + diff + 'px)');
        });
        $(window).on('mouseup.slider', function (e) {
            if (!isDragging) return;
            isDragging = false;
            var diff = currentX - startX;
            if (diff < -50) {
                $track.css('transition', 'transform 0.3s');
                $track.css('transform', 'translateX(-' + imgWidth + 'px)');
                $track.one('transitionend', rotateLeft);
            } else if (diff > 50) {
                rotateRight();
                $track.css('transition', 'none');
                $track.css('transform', 'translateX(-' + imgWidth + 'px)');
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
    }

    $(function () {
        initSlider();
        // 수정 버튼 클릭 시 update 페이지 내용 load
        $(document).on('click', '.updateBtn', function () {
            $('.main-content').load('/store/updatemypage .main-content > *', function () {
                $('#wrapper').addClass('update-page');
                initSlider();
            });
        });

        // 취소 버튼 클릭 시 마이페이지로 복귀
        $(document).on('click', '.cancleBtn', function () {
            $('.main-content').load('/store/mypage .main-content > *', function () {
                $('#wrapper').removeClass('update-page');
                initSlider();
            });
        });

    });
    
 	// 상세주소 팝업 열기
    $(document).on('click', '#address-short', function() {
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
    
    // 매출확인 버튼 이동
    $(document).on('click', '.viewSales', function () {
        window.location.href = '/store/viewsales';
    });
    
    
    // updatemypage
    // 카테고리 체크박스 스타일 변경(active)
    $(document).on('change', '.category-checkbox', function () {
        const img = $(this).next('.checkbox-img')[0];
        const label = $(this).parent()[0];
        if (this.checked) {
            img.src = '../../../img/store_checkbox_active.png';
            label.style.fontWeight = "bold";
        } else {
            img.src = '../../../img/store_checkbox.png';
            label.style.fontWeight = "normal";
        }
    });

    $(document).on('click', '#closeAddressModal', function () {
        $('#addressModal').fadeOut(200);
    });
    
 // 1. 카테고리 체크박스 스타일 토글 및 최소 1개 이상 체크 확인
    $(document).on('change', '.category-checkbox', function () {
        const img = $(this).next('.checkbox-img')[0];
        const label = $(this).parent()[0];
        if (this.checked) {
            img.src = '../../../img/store_checkbox_active.png';
            label.style.fontWeight = "bold";
        } else {
            img.src = '../../../img/store_checkbox.png';
            label.style.fontWeight = "normal";
        }
    });

    // 2. 대표메뉴 입력: 각 항목은 최대 6글자, 자동 구분자 " | " 삽입
    $(document).on('input', 'input[name="store_menu"]', function () {
        const raw = $(this).val().replace(/\s*\|\s*/g, '|'); // 양쪽 공백 제거
        const items = raw.split('|').filter(Boolean); // 빈 항목 제거
        const trimmedItems = items.map(item => item.slice(0, 6)); // 각 항목 최대 6글자
        $(this).val(trimmedItems.join(' | '));
    });


    // 3. submit 시 카테고리 최소 1개 이상 체크 확인
    $(document).on('submit', 'form[action="/store/updatemypage"]', function (e) {
        const checkedCount = $('.category-checkbox:checked').length;
        if (checkedCount === 0) {
            alert('카테고리는 최소 1개 이상 선택해야 합니다.');
            e.preventDefault();
        }
    });
    
    // 대표 메뉴 결합
    $(document).on('submit', 'form[action="/store/updatemypage"]', function (e) {
        // 카테고리 체크 확인
        if ($('.category-checkbox:checked').length === 0) {
            alert('카테고리는 최소 1개 이상 선택해야 합니다.');
            e.preventDefault();
            return;
        }

        // 대표메뉴 3개 합쳐서 첫 번째 hidden input에 저장
        const menu1 = $('#menu1').val().trim();
        const menu2 = $('#menu2').val().trim();
        const menu3 = $('#menu3').val().trim();
        const combinedMenu = [menu1, menu2, menu3].filter(Boolean).join(' | ');

        // store_menu 필드에 합친 값 반영
        $('#menu1').val(combinedMenu);
        $('#menu2').remove();  // 제거하지 않으면 서버에 불필요하게 전송됨
        $('#menu3').remove();
    });

</script>

</html>