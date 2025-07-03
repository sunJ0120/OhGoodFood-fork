
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<article class="storePinModal"
         data-product-no="${mainStore.product_no}"
         data-store-status="${mainStore.store_status}"
         data-latitude="${mainStore.latitude}"
         data-longitude="${mainStore.longitude}"
         data-amount="${mainStore.amount}"
         data-store-id="${mainStore.store_id}">
  <div class="cardImage">
    <img src="https://ohgoodfood.s3.ap-northeast-2.amazonaws.com/${mainStore.store_img}" alt="상품 이미지" class="storeImage" />
    <div class="cardLabel">
      <div class="productNameWrapper">
        <div class="productName">
          <strong>${mainStore.store_name}</strong>
        </div>
        <div class="badge">
          <span class="statusText">${mainStore.pickup_status.displayName}</span>
          <span class="timeText">
            <c:choose>
              <c:when test="${mainStore.pickup_status.name() == 'TOMORROW'}">
                <c:if test="${mainStore.amount > 5}">(+5)</c:if>
                <c:if test="${mainStore.amount <= 5}">(${mainStore.amount})</c:if>
              </c:when>

              <c:when test="${mainStore.pickup_status.name() == 'TODAY'}">
                <c:if test="${mainStore.amount > 5}">(+5)</c:if>
                <c:if test="${mainStore.amount <= 5}">(${mainStore.amount})</c:if>
              </c:when>
            </c:choose>
          </span>
        </div>
      </div>
    </div>
  </div>

  <div class="cardInfo">
    <div class="productTexts">

      <p class="productDesc">
        <c:forEach var="category" items="${mainStore.category_list}" varStatus="status">
          ${category}<c:if test="${!status.last}"> | </c:if>
        </c:forEach>
      </p>

      <p class="productDesc">
        <c:if test="${not empty mainStore.mainmenu_list}">
          <c:forEach var="mainmenu" items="${mainStore.mainmenu_list}" varStatus="status">
            ${mainmenu}<c:if test="${!status.last}"> | </c:if>
          </c:forEach>
        </c:if>
      </p>

      <p class="pickupTime">픽업 시간 |
        <strong>
          <span class="todayPickupText">${mainStore.pickup_status.displayName}</span>
          <span class="pickupStartText">
            <c:if test="${not empty mainStore.pickup_start}">
              <fmt:formatDate value="${mainStore.pickup_start}" pattern="HH:mm"/>
              ~
            </c:if>
          </span>
          <span class="pickupEndText">
            <c:if test="${not empty mainStore.pickup_end}">
              <fmt:formatDate value="${mainStore.pickup_end}" pattern="HH:mm"/>
            </c:if>
          </span>
        </strong>
      </p>
    </div>
    <div class="priceBox">
      <c:if test="${mainStore.origin_price != null}">
        <del class="originalPrice">
          <fmt:formatNumber value="${mainStore.origin_price}" pattern="#,###" />₩
        </del>
      </c:if>

      <c:if test="${mainStore.sale_price != null}">
        <span class="salePrice">
          <strong><fmt:formatNumber value="${mainStore.sale_price}" pattern="#,###" />₩</strong>
        </span>
      </c:if>
    </div>
  </div>
</article>
