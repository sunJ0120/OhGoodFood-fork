<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">

<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />

  <!-- jQuery CDN -->
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

  <!-- 리뷰 리스트 전용 CSS -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/userReviewList.css" />

  <title>Review List</title>
</head>

<body>
  <!-- 레이아웃 템플릿-->
  <div id="wrapper">
      <%@ include file="/WEB-INF/views/users/header.jsp" %>
  <!-- 리뷰 리스트 템플릿 -->
  <div type="text/template" id="static-template">
    <div class="reviewList">
        <div class="overlap">
        <c:forEach var="review" items="${reviews}">
          <div class="reviewBox">
            <div class="reviewerName">${review.user_nickname}</div>
            <div class="reviewedDate">
              <fmt:formatDate value="${review.writed_at}" pattern="yyyy.MM.dd"/> 
            </div>
            <img class="reviewImage" src="https://ohgoodfood.s3.ap-northeast-2.amazonaws.com/${review.review_img}" alt="리뷰 이미지" />
            <hr class="line" />
            <p class="reviewContent">
              ${review.review_content}
            </p>
            <div class="storeBox"></div>
            <div class="storeName">${review.store_name}</div>
            <img class="storeImage" src="https://ohgoodfood.s3.ap-northeast-2.amazonaws.com/${review.store_img}" alt="리뷰 이미지" />
            <p class="storeMenu">
              <span class="span">${review.store_menu}</span>
            </p>
            <div class="price">
              <span class="originPrice">${review.origin_price} ₩</span>
              <span class="salePrice">${review.sale_price} ₩</span>
            </div>
          </div>
          </c:forEach>
        </div>
    </div>
    </div>
        <%@ include file="/WEB-INF/views/users/footer.jsp" %>
	
  </div>
  </main>



</body>

</html>