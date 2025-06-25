<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="utf-8" />

    <link rel="stylesheet" href="../../../css/storemypage.css" />
    <link rel="stylesheet" href="../../../css/storeupdate.css" />

    <title>Ohgoodfood</title>
</head>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<body>
    <div id="wrapper">
        <%@ include file="/WEB-INF/views/store/header.jsp" %>
        <main>
            <div class="myInfo-header">
                <div class="myInfo-group">
                    <img src="../../../img/store_person.png" alt="마이페이지" class="personIcon">
                    <div class="myInfo">내 정보</div>
                </div>
                <div class="deleteAccount-group">
                    <img src="../../../img/store_deleteAccount.png" alt="탈퇴하기" class="deleteAccountIcon">
                    <button class="deleteAccount">탈퇴하기</button>
                </div>
            </div>
            <div class="myInfo-content">
                <input type="text" id="id" name="id" value="${store.store_id}" readonly>
                <input type="password" id="pwd" name="pwd" value="${store.store_pwd}" readonly>
            </div>
            <div class="main-content">
                <div class="storeInfo-header">
                    <div class="storeInfo-group">
                        <img src="../../../img/store_mystore.png" alt="내 가게" class="myStoreIcon">
                        <div class="myInfo">내 가게</div>
                    </div>
                    <div class="viewSales-group">
                        <img src="../../../img/store_sales.png" alt="매출확인" class="viewSalesIcon">
                        <button class="viewSales">매출확인</button>
                    </div>
                </div>
                <div class="name-group">
                    <div class="name-container">
                        <div class="storeName">${store.store_name}</div>
                        <div class="info-container">
                            <img src="../../../img/store_loaction.png" alt="위치" class="storeIcon">
                            <div class="address">${store.store_address}</div>
                            <img src="../../../img/store_number.png" alt="전화" class="storeIcon">
                            <div class="number">${store.store_telnumber}</div>
                        </div>
                    </div>
                    <button class="updateBtn">수정</button>
                </div>

                <div class="store-image-slider">
                    <div class="slider-track">
                        <img src="../../../img/store_img1.png" alt="Store Image 1" class="slider-img">
                        <img src="../../../img/store_img2.png" alt="Store Image 2" class="slider-img">
                        <img src="../../../img/store_img3.png" alt="Store Image 3" class="slider-img">
                        <img src="../../../img/store_img1.png" alt="Store Image 1" class="slider-img">
                        <img src="../../../img/store_img2.png" alt="Store Image 2" class="slider-img">
                    </div>
                    <div class="slider-indicators"></div>
                </div>
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
                            <img src="../../../img/store_bag.png" alt="오굿백" class="bagIcon">
                            <label class="label">오굿백</label>
                            <span class="divider">|</span>
                            <div class="details-content" style="line-height: 1.5; font-size:15px;">${store.store_explain}
                            </div>
                        </div>
                    </form>


                </div>
            </div>


        </main>
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

        function createIndicators() {
            $indicatorContainer.empty();
            for (var i = 0; i < $images.length; i++) {
                var dot = $('<div>').addClass('slider-indicator' + (i === currentIndex ? ' active' : ''));
                $indicatorContainer.append(dot);
            }
        }

        function updateIndicators() {
            $indicatorContainer.find('.slider-indicator').each(function (i) {
                $(this).toggleClass('active', i === currentIndex);
            });
        }

        function updateSlider(instant) {
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

        // 기존 이벤트 제거 후 재바인딩
        $track.off();

        // 터치 이벤트
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

        // 마우스 이벤트
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

        $(document).on('click', '.updateBtn', function () {
            $('.main-content').load('/store/updatemypage .main-content > *', function () {
                $('#wrapper').addClass('update-page');
                initSlider();
            });
        });

        $(document).on('click', '.cancleBtn', function () {
            $('.main-content').load('/store/mypage .main-content > *', function () {
                $('#wrapper').removeClass('update-page');
                initSlider();
            });
        });

    });
    /* updatemypage.jsp 체크박스 */
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
    
</script>

</html>