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
      <main class="reviewList">
      <c:forEach var="r" items="${review}">
        
        <div class="overlap">
          <div class="reviewBox">
          <!-- 작성자 & 날짜 -->
          <div class="reviewerName">${r.user_nickname}</div>
          <div class="reviewedDate">
            <fmt:formatDate value="${r.writed_at}" pattern="yyyy.MM.dd"/>
          </div>

          <!-- 리뷰 이미지 -->
          <c:if test="${not empty r.review_img}">
            <img class="reviewImage"
                 src="https://ohgoodfood.s3.ap-northeast-2.amazonaws.com/init.jpg"
                 alt="리뷰 이미지"/>
          </c:if>
          <hr class="line"/>

          <!-- 리뷰 내용 -->
          <p class="reviewContent">${r.review_content}</p>

          <!-- 가게 정보 -->
          <div class="storeBox">
            <div class="storeName">${r.store_name}</div>
            <c:if test="${not empty r.store_img}">
              <img class="storeImage"
                   src="https://ohgoodfood.s3.ap-northeast-2.amazonaws.com/init.jpg"
                   alt="가게 이미지"/>
            </c:if>
            <p class="storeMenu">
              <span>${r.store_menu}</span>
            </p>
            <div class="price">
              <span class="originPrice">${r.origin_price} ₩</span>
              <span class="salePrice">${r.sale_price} ₩</span>
            </div>
          </div>
        </div>
        </div>
      </c:forEach>

    </main>
        <%@ include file="/WEB-INF/views/users/footer.jsp" %>
    </div>
    <!-- 레이아웃 로드 + 템플릿 삽입 스크립트
    <script>
      $(function () {
        // layout.html에서 #wrapper 부분만 읽어와 현재 #wrapper에 덮어쓰기
        $("#wrapper").load("layout.html #wrapper", function (response, status, xhr) {
          if (status !== "success") {
            console.error("layout.html 로딩 실패:", xhr.status);
            return;
          }

          // 레이아웃 내부의 <main>을 찾아서 클래스 추가 및 내용 비우기
          var $main = $("#wrapper").find("main")
            .addClass("reviewList")
            .empty();

          // 템플릿에 담긴 정적 HTML(.food-item들)을 읽어와서 <main>에 삽입
          var staticHtml = $("#reviewList-template").html();
          $main.append(staticHtml);


        });
      });
    </script> -->

  </body>

  </html>