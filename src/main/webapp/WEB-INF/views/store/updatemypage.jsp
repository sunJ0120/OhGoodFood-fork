<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    String[] menus = request.getAttribute("store") != null && ((kr.co.ohgoodfood.dto.Store) request.getAttribute("store")).getStore_menu() != null
        ? ((kr.co.ohgoodfood.dto.Store) request.getAttribute("store")).getStore_menu().split(" \\| ")
        : new String[] {"", "", ""};
%>
<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/storemypage.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/storeupdate.css" />
<title>Ohgoodfood</title>
<link rel="icon" type="image/jpeg" href="https://ohgoodfood.s3.ap-northeast-2.amazonaws.com/shinhanmoilicon32x32.jpg">
</head>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<body>
	<div class="main-content">
		<div class="storeInfo-header">
			<div class="storeInfo-group">
				<img src="${pageContext.request.contextPath}/img/store_mystore.png" alt="내 가게"
					class="myStoreIcon">
				<div class="myInfo">내 가게 정보 수정</div>
			</div>

		</div>
		<form action="/store/updatemypage" method="post">
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
						<img src="${pageContext.request.contextPath}/img/store_number.png" alt="전화"
							class="storeIcon">
						<div class="number">${store.store_telnumber}</div>
					</div>
				</div>
				<button type="button" class="cancleBtn">취소</button>
				<button type="submit" class="saveBtn">저장</button>
			</div>

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
			<div class="updateDetails-container">
				<form action="/store/updatemypage" method="post">
					<div class="form-group">
						<label class="updateLabel">영업 시간</label> <span class="divider" id="hoursDivider">|</span>
						<div class="business-hours-group">
							<input type="time" id="openedTime" name="opened_at" 
								value="${openedTime}" required> <span class="time-divider">~</span>
							<input type="time" id="closedTime" name="closed_at"
								value="${closedTime}" required> 
						</div>

					</div>

					<div class="form-group">
						<label class="updateLabel">카테고리</label> <span class="divider">|</span>
						<div class="input-box">
							<div class="category-group">
								<label
									style="${store.category_bakery == 'Y' ? 'font-weight:bold;' : ''}">
									<input type="checkbox" class="category-checkbox"
									name="category_bakery" value="Y"
									${store.category_bakery == 'Y' ? 'checked' : ''}
									style="display: none;"> <img
									src="${pageContext.request.contextPath}/img/${store.category_bakery == 'Y' ? 'store_checkbox_active.png' : 'store_checkbox.png'}"
									class="checkbox-img" alt="체크박스"> 빵 & 디저트
								</label> <label
									style="${store.category_salad == 'Y' ? 'font-weight:bold;' : ''}">
									<input type="checkbox" class="category-checkbox"
									name="category_salad" value="Y"
									${store.category_salad == 'Y' ? 'checked' : ''}
									style="display: none;"> <img
									src="${pageContext.request.contextPath}/img/${store.category_salad == 'Y' ? 'store_checkbox_active.png' : 'store_checkbox.png'}"
									class="checkbox-img" alt="체크박스"> 샐러드
								</label> <label
									style="${store.category_fruit == 'Y' ? 'font-weight:bold;' : ''}">
									<input type="checkbox" class="category-checkbox"
									name="category_fruit" value="Y"
									${store.category_fruit == 'Y' ? 'checked' : ''}
									style="display: none;"> <img
									src="${pageContext.request.contextPath}/img/${store.category_fruit == 'Y' ? 'store_checkbox_active.png' : 'store_checkbox.png'}"
									class="checkbox-img" alt="체크박스"> 과일
								</label> <label
									style="${store.category_others == 'Y' ? 'font-weight:bold;' : ''}">
									<input type="checkbox" class="category-checkbox"
									name="category_others" value="Y"
									${store.category_others == 'Y' ? 'checked' : ''}
									style="display: none;"> <img
									src="${pageContext.request.contextPath}/img/${store.category_others == 'Y' ? 'store_checkbox_active.png' : 'store_checkbox.png'}"
									class="checkbox-img" alt="체크박스"> 그 외
								</label>
							</div>
						</div>
					</div>

					<div class="form-group">
					    <label class="updateLabel">대표 메뉴</label>
					    <span class="updateDivider">|</span>
					    <div class="menu-group">
					        <input type="text" name="store_menu" maxlength="6" value="<%= menus.length > 0 ? menus[0].trim() : "" %>" placeholder="첫 번째 대표메뉴를 입력하세요" required/>
							<input type="text" name="store_menu2" maxlength="6" value="<%= menus.length > 1 ? menus[1].trim() : "" %>" placeholder="두 번째 대표메뉴를 입력하세요" />
							<input type="text" name="store_menu3" maxlength="6" value="<%= menus.length > 2 ? menus[2].trim() : "" %>" placeholder="세 번째 대표메뉴를 입력하세요"/>
					    </div>
					</div>
					<div class="form-group" id="bag-container">
						<img src="${pageContext.request.contextPath}/img/store_bag.png" alt="오굿백" class="bagIcon">
						<label class="updateLabel">가게설명</label> <span class="divider">|</span>
						<textarea name="store_explain" placeholder="가게설명을 작성해주세요" maxlength="50"
							style="line-height: 1.5; font-size: 14px;">${store.store_explain}</textarea>
					</div>
			</div>

		</form>
</body>
<script>
	
</script>

</html>