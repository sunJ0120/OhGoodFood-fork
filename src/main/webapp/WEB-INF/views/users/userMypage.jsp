<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>마이페이지</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/usermypage.css" />
</head>
<body>
  <div id="wrapper">
    <%@ include file="/WEB-INF/views/users/header.jsp" %>

    <main class="mypage">
      <!-- 1. 내 정보 -->
      <section class="infoSection">
        <h2 class="sectionTitle">
          <img src="${pageContext.request.contextPath}/img/user_user.png"
               alt="내 정보 아이콘" class="infoIcon" />
          내 정보
          <span class="actionButtons">
            <img src="${pageContext.request.contextPath}/img/user_refactor.png"
                 alt="수정하기 아이콘" class="modifyIcon" />
            <button type="button" class="modifyBtn">수정하기</button>
            <img src="${pageContext.request.contextPath}/img/user_refactor.png"
                 alt="탈퇴하기 아이콘" class="outIcon" />
            <button type="button" class="outBtn">탈퇴하기</button>
          </span>
        </h2>
        <div class="infoForm">
          <div class="infoItem">
            <span class="valueText">${userMypage.user_id}</span>
          </div>
          <div class="infoItem">
            <span class="valueText">${userMypage.user_nickname}</span>
          </div>
        </div>
      </section>
      <hr class="infoLine" />

      <!-- 2. 내가 쓴 리뷰 모음 -->
      <section class="reviewSection">
        <h2 class="sectionTitle">
          <img src="${pageContext.request.contextPath}/img/user_Vector.png"
               alt="내 리뷰 모음 아이콘" class="infoIcon" />
          내 리뷰 모음
        </h2>

        <div class="reviewContainer">
          <div class="reviewList">
            <!-- 리뷰 카드 반복 시작 -->
            <c:forEach var="review" items="${userMypage.reviews}">
              <div class="reviewCard">
                <!-- 리뷰 이미지 -->
                <div class="reviewImageArea">
                  <img class="reviewImage"
                       src="${review.review_img}"
                       alt="리뷰 이미지" />
                </div>
                <div class="reviewHeaderBox">
                  <!-- 작성자와 날짜 -->
                  <div class="reviewHeader">
            <span class="reviewerName">${userMypage.user_nickname}</span>
                    <time class="reviewDate">
                      <fmt:formatDate value="${review.writed_at}" pattern="yyyy.MM.dd"/>  
                    </time>
                  </div>
                  <hr class="line" />
                  <!-- 리뷰 내용 -->
                  <p class="reviewContent">${review.review_content}</p>
                </div>
                <!-- 매장 정보 -->
                <div class="storeInfo">
                  <img class="storeImage"
                       src="${review.store_img}"
                       alt="매장 이미지" />
                  <div class="storeDetail">
                    <span class="storeName">${review.store_name}</span>
                    <span class="storeMenu">${review.store_menu}</span>
                  </div>
                  <div class="priceArea">
                    <span class="originPrice">
                      <fmt:formatNumber value="${review.origin_price}"
                                        type="number" />원
                    </span>
                    <span class="salePrice">
                      <fmt:formatNumber value="${review.sale_price}"
                                        type="number" />원
                    </span>
                  </div>
                </div>
              </div>
            </c:forEach>
            <!-- 리뷰 카드 반복 끝 -->
          </div>

          <div id="reviewLoader" class="loader" style="display:none">
            로딩 중…
          </div>
        </div>
      </section>
    </main>

    <%@ include file="/WEB-INF/views/users/footer.jsp" %>
  </div>
</body>
</html>
