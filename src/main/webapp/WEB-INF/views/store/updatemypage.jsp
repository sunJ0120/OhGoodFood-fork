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
		<form action="/store/updatemypage" method="post">
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
            <button type="button" class="cancleBtn">취소</button>
            <button type="submit" class="saveBtn">저장</button>
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
            <form action="/store/updatemypage" method="post">
                <div class="form-group">
                    <label class="label">영업 시간</label>
                    <span class="divider">|</span>
                    <div class="business-hours-group">
                        <input type="time" id="openedTime" name="opened_at" value="${openedTime}">
                        <span class="time-divider">~</span>
                        <input type="time" id="closedTime" name="closed_at" value="${closedTime}">
                    </div>

                </div>
            
				<div class="form-group">
				    <label class="label">카테고리</label>
				    <span class="divider">|</span>
				    <div class="input-box">
				        <div class="category-group">
				            <label style="${store.category_bakery == 'Y' ? 'font-weight:bold;' : ''}">
				                <input type="checkbox" class="category-checkbox" name="category_bakery" value="Y" 
				                    ${store.category_bakery == 'Y' ? 'checked' : ''} style="display:none;">
				                <img src="../../../img/${store.category_bakery == 'Y' ? 'store_checkbox_active.png' : 'store_checkbox.png'}" 
				                     class="checkbox-img" alt="체크박스">
				                빵 & 디저트
				            </label>

				            <label style="${store.category_salad == 'Y' ? 'font-weight:bold;' : ''}">
				                <input type="checkbox" class="category-checkbox" name="category_salad" value="Y" 
				                    ${store.category_salad == 'Y' ? 'checked' : ''} style="display:none;">
				                <img src="../../../img/${store.category_salad == 'Y' ? 'store_checkbox_active.png' : 'store_checkbox.png'}" 
				                     class="checkbox-img" alt="체크박스">
				                샐러드
				            </label>

				            <label style="${store.category_fruit == 'Y' ? 'font-weight:bold;' : ''}">
				                <input type="checkbox" class="category-checkbox" name="category_fruit" value="Y" 
				                    ${store.category_fruit == 'Y' ? 'checked' : ''} style="display:none;">
				                <img src="../../../img/${store.category_fruit == 'Y' ? 'store_checkbox_active.png' : 'store_checkbox.png'}" 
				                     class="checkbox-img" alt="체크박스">
				               과일 
				            </label>

				            <label style="${store.category_others == 'Y' ? 'font-weight:bold;' : ''}">
				                <input type="checkbox" class="category-checkbox" name="category_others" value="Y" 
				                    ${store.category_others == 'Y' ? 'checked' : ''} style="display:none;">
				                <img src="../../../img/${store.category_others == 'Y' ? 'store_checkbox_active.png' : 'store_checkbox.png'}" 
				                     class="checkbox-img" alt="체크박스">
				                그 외
				            </label>
				        </div>
				    </div>
				</div>

                <div class="form-group">
                    <label class="label">대표 메뉴</label>
                    <span class="divider">|</span>
					<input type="text" placeholder="대표메뉴를 작성해주세요" name="store_menu" value="${store.store_menu}">
                </div>
                <div class="form-group" id="bag-container">
                    <img src="../../../img/store_bag.png" alt="오굿백" class="bagIcon">
                    <label class="label">오굿백</label>
                    <span class="divider">|</span>
                    <textarea name="store_explain" placeholder="오굿백 설명을 작성해주세요" style="line-height: 1.5; font-size:14px;" >${store.store_explain}</textarea>
                </div>
       </div>

	</form>
</body>
<script>

</script>

</html>