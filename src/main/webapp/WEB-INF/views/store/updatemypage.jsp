<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="../../../css/storemypage.css" />
    <link rel="stylesheet" href="../../../css/storeupdate.css" />
    <title>가게 정보 수정</title>

</head>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<body>
    <div class="main-content">
        <div class="storeInfo-header">
            <div class="storeInfo-group">
                <img src="../../../img/store_mystore.png" alt="내 가게" class="myStoreIcon">
                <div class="myInfo">내 가게 정보 수정</div>
            </div>

        </div>
        <div class="name-group">
            <div class="name-container">
                <div class="storeName">러프도우</div>
                <div class="info-container">
                    <img src="../../../img/store_loaction.png" alt="위치" class="storeIcon">
                    <div class="address">서울 노원구 공릉동 670-20</div>
                    <img src="../../../img/store_number.png" alt="전화" class="storeIcon">
                    <div class="number">02-1234-5678</div>
                </div>
            </div>
            <button class="cancleBtn">취소</button>
            <button class="saveBtn">저장</button>
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
                    <div class="business-hours-group">
                        <input type="time" id="businessHoursStart" name="businessHoursStart" required>
                        <span class="time-divider">~</span>
                        <input type="time" id="businessHoursEnd" name="businessHoursEnd" required>
                    </div>

                </div>
                <div class="form-group">
                    <label class="label">픽업 시간</label>
                    <span class="divider">|</span>
                    <input type="text" id="pickup-time-input" class="time-input" placeholder="픽업시간을 선택하세요" readonly>
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
            </form>
            <form>
                <div class="form-group">
                    <label class="label">카테고리</label>
                    <span class="divider">|</span>
                    <div class="input-box">
                        <div class="category-group">
                            <label>
                                <input type="checkbox" class="category-checkbox" style="display:none;">
                                <img src="../../../img/store_checkbox.png" class="checkbox-img" alt="체크박스">
                                빵 & 디저트
                            </label>
                            <label>
                                <input type="checkbox" class="category-checkbox" style="display:none;">
                                <img src="../../../img/store_checkbox.png" class="checkbox-img" alt="체크박스">
                                샐러드
                            </label>
                            <label>
                                <input type="checkbox" class="category-checkbox" style="display:none;">
                                <img src="../../../img/store_checkbox.png" class="checkbox-img" alt="체크박스">
                                과일
                            </label>
                            <label>
                                <input type="checkbox" class="category-checkbox" style="display:none;">
                                <img src="../../../img/store_checkbox.png" class="checkbox-img" alt="체크박스">
                                그외
                            </label>
                        </div>
                    </div>
                </div>
            </form>
            <form>
                <div class="form-group">
                    <label class="label">대표 메뉴</label>
                    <span class="divider">|</span>
                    <input type="text" placeholder="대표메뉴를 작성해주세요">
                </div>
            </form>
            <form>
                <div class="form-group" id="bag-container">
                    <img src="../../../img/store_bag.png" alt="오굿백" class="bagIcon">
                    <label class="label">오굿백</label>
                    <span class="divider">|</span>
                    <textarea id="bag-desc" placeholder="오굿백 설명을 작성해주세요"></textarea>
                </div>
        </div>
        </form>
    </div>
    </div>
</body>
<script>

</script>

</html>