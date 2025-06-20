<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
        <%@ include file="/WEB-INF/views/store/header.jsp" %>
        <main>
            <div class="main-header">
                <div class="storeName">러프도우</div>
                <div class="storeInfo">
                    <span class="addressIcon">
                        <img src="../../../img/store_address.png" alt="위치 아이콘">
                    </span>
                    <span class="storeAddress">서울시 강남구</span>
                    <span class="NumberIcon">
                        <img src="../../../img/store_number.png" alt="전화 아이콘">
                    </span>
                    <span class="storeNumber">02-1234-5678</span>
                </div>
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
            <div class="sale-status">
                <div class="view-toggle">
                    <button id="open" class="view-button">오픈하기</button>
                    <button id="close" class="view-button">마감하기</button>
                </div>
            </div>
            <div class="sale-info">
                <p>오굿백 구성 후에 오픈 버튼을 눌러주세요 ~</p>
                <div class="info-title">
                    <img src="../../../img/store_bag.png" alt="오굿백 아이콘">
                    <p>오굿백</p>
                </div>
                <div class="info-content">
                    <p>러프도우의 직접만든 바게뜨, 소금빵이 들어가요.
                    <form>
                        <div class="form-group">
                            <label class="label">픽업 날짜</label>
                            <span class="divider">|</span>
                            <div class="btn-container">
                                <button type="button" class="pickup-btn " data-value="today">오늘</button>
                                <button type="button" class="pickup-btn" data-value="tomorrow">내일</button>
                            </div>

                        </div>
                        <div class="form-group">
                            <label class="label">픽업 시간</label>
                            <span class="divider">|</span>
                            <input type="text" id="pickup-time-input" class="time-input" placeholder="픽업시간을 선택하세요"
                                readonly>
                            <img src="../../../img/store_time.png" alt="시계 아이콘" class="timer-icon" id="timer-icon">

                            <!-- 모달 -->
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
                        <div class="form-group">
                            <label class="label">원래 가격</label>
                            <span class="divider">|</span>
                            <input type="number" class="time-input" placeholder="가격을 입력하세요" min="0" step="100">
                        </div>
                        <div class="form-group">
                            <label class="label">오굿백 가격</label>
                            <span class="divider">|</span>
                            <input type="number" class="time-input" placeholder="가격을 입력하세요" min="0" step="100">
                        </div>
                        <div class="form-group">
                            <label class="label">오굿백 수량</label>
                            <span class="divider">|</span>
                            <div class="quantity-container">
                                <img src="../../../img/store_minus.png" alt="빼기 아이콘" class="quantity-icon"
                                    id="minus-btn">
                                <div class="count" id="count-value">1개</div>
                                <img src="../../../img/store_plus.png" alt="더하기 아이콘" class="quantity-icon"
                                    id="plus-btn">
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
    $(function () {
        // 슬라이더
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

        // 오픈, 마감 버튼 이벤트
        $('.view-button').click(function () {
            $('.view-button').removeClass('active');
            $(this).addClass('active');
        });

        // 픽업 날짜 버튼 이벤트
        $('.pickup-btn').click(function () {
            $('.pickup-btn').removeClass('active');
            $(this).addClass('active');
        });

        // 오굿백 수량
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
    });
</script>

</html>