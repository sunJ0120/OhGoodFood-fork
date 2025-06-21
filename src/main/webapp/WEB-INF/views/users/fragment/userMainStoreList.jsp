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
                <!-- 이거 store_status, reservation_end는 프론트단에서 처리 해야 해서 가장 나중에 하기로 한다. -->
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
                <!-- 이거 today_fickup도 프론트단에서 처리 해야 해서 가장 나중에 하기로 한다. -->
                <span class="todayPickupText">${mainStore.pickup_date}</span>
                <span class="pickupStartText">
                        <fmt:formatDate value="${mainStore.pickup_start}" pattern="HH:mm" />
                      </span>
                ~
                <span class="pickupEndText">
                        <fmt:formatDate value="${mainStore.pickup_end}" pattern="HH:mm" />
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
