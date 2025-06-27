<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:choose>
  <c:when test="${empty mainStoreList}">
    <div class="emptyModal">
      <div class="modalWrapper">
        <img src="${pageContext.request.contextPath}/img/user_cat.png" alt="고양이" class="emptyModalEmoji"/>
        <div class="modalBox">
          <div class="modalContent">
            검색 결과가 없습니다.
          </div>
        </div>
      </div>
    </div>
  </c:when>
  <c:otherwise>
    <section class="productList">
      <c:forEach var="mainStore" items = "${mainStoreList}" >
        <article class="productCard" data-product-no="${mainStore.product_no}">
          <div class="cardImage">
            <img src="https://ohgoodfood.s3.ap-northeast-2.amazonaws.com/${mainStore.store_img}" alt="상품 이미지" class="storeImage" />
            <div class="cardLabel">
              <div class="productNameWrapper">
                <div class="productName">
                    ${mainStore.store_name}
                </div>
                <div class="badge">
                  <span class="statusText">${mainStore.pickup_status.displayName}</span>
                  <span class="timeText">
                <c:choose>
                  <c:when test="${mainStore.pickup_status.name() == 'SOLD_OUT'}">
                    (<fmt:formatDate value="${mainStore.closed_at}" pattern="HH:mm" type="time"/>)
                  </c:when>

                  <c:when test="${mainStore.pickup_status.name() == 'CLOSED'}">
                    (<fmt:formatDate value="${mainStore.closed_at}" pattern="HH:mm" type="time"/>)
                  </c:when>

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
              <fmt:formatNumber value="${mainStore.sale_price}" pattern="#,###" />₩
            </span>
              </c:if>
            </div>
          </div>
        </article>
      </c:forEach>
    </section>
  </c:otherwise>
</c:choose>
