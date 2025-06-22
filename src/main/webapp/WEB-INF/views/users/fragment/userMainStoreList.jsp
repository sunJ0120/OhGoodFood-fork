<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="productWrapper">
  <section class="productList">
    <c:forEach var="mainStore" items = "${mainStoreList}" >
      <article class="productCard">
        <div class="cardImage">
          <img src="${pageContext.request.contextPath}/img/user_usermain_img.png" alt="상품 이미지" class="storeImage">
          <div class="cardLabel">
            <div class="productNameWrapper">
              <div class="productName">
                  ${mainStore.store_name}
              </div>
              <div class="badge">
                <span class="statusText">${mainStore.pickup_date}</span>
                <span class="timeText">(${mainStore.amount_time_tag})</span>
              </div>
            </div>
          </div>
        </div>

        <div class="cardInfo">
          <div class="productTexts">
            <p class="productDesc">${mainStore.category_name}</p>
            <p class="productDesc">${mainStore.store_menu}</p>
            <p class="pickupTime">픽업 시간 |
              <strong>
                <span class="pickupStartText">
                  <fmt:parseDate value="${mainStore.pickup_start}" var="pickup_start" pattern="yyyy-MM-dd'T'HH:mm"/>
                  <fmt:formatDate value="${pickup_start}" pattern="HH:mm"/>
                </span>
                ~
                <span class="pickupEndText">
                  <fmt:parseDate value="${mainStore.pickup_end}" var="pickup_end" pattern="yyyy-MM-dd'T'HH:mm"/>
                  <fmt:formatDate value="${pickup_end}" pattern="HH:mm"/>
                </span>
              </strong>
            </p>
          </div>
          <div class="priceBox">
            <del class="originalPrice">
              <fmt:formatNumber value="${mainStore.origin_price}" pattern="#,###" />₩
            </del>
            <span class="salePrice">
              <fmt:formatNumber value="${mainStore.sale_price}" pattern="#,###" />₩
            </span>
          </div>
        </div>
      </article>
    </c:forEach>
  </section>
</div>
