<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>Review List</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/userReviewList.css"/>
</head>
<body>
  <div id="wrapper">
    <%@ include file="/WEB-INF/views/users/header.jsp" %>

    <main class="reviewList">
      <c:if test="${empty reviews}">
        <p class="noReviews">등록된 리뷰가 없습니다.</p>
      </c:if>

      <c:forEach var="r" items="${reviews}">
        <div class="overlap">
          <!-- 리뷰 박스 -->
          <div class="reviewBox">
            <div class="reviewerName">${r.user_nickname}</div>
            <div class="reviewedDate">
              <fmt:formatDate value="${r.writed_at}" pattern="yyyy.MM.dd"/>
            </div>
            <c:if test="${not empty r.review_img}">
              <img class="reviewImage"
                   src="${pageContext.request.contextPath}/resources/upload/${r.review_img}"
                   alt="리뷰 이미지"/>
            </c:if>
            <hr class="line"/>
            <p class="reviewContent">${r.review_content}</p>
          </div>
          <!-- 가게 정보 박스 -->
          <div class="storeBox">
            <div class="storeName">${r.store_name}</div>
            <c:if test="${not empty r.store_img}">
              <img class="storeImage"
                   src="${pageContext.request.contextPath}/resources/upload/${r.store_img}"
                   alt="가게 이미지"/>
            </c:if>
            <p class="storeMenu"><span>${r.store_menu}</span></p>
            <div class="price">
              <span class="originPrice">${r.origin_price} ₩</span>
              <span class="salePrice">${r.sale_price} ₩</span>
            </div>
          </div>
        </div>
      </c:forEach>
    </main>

    <%@ include file="/WEB-INF/views/users/footer.jsp" %>
  </div>
</body>
</html>
