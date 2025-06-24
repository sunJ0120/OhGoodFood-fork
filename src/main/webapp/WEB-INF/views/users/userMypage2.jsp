<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<%@ include file="header.jsp" %>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/userpypage.css">

<main class="mypage">
  <!-- 1. 내 정보 -->
  <section class="infoSection">
    <h2 class="sectionTitle">
      <img src="${pageContext.request.contextPath}/img/user_user.png" class="infoIcon" alt="내 정보 아이콘"/>
      내 정보
      <span class="actionButtons">
        <img src="${pageContext.request.contextPath}/img/user_refactor.png" class="modifyIcon" alt="수정"/>
        <button type="button" class="modifyBtn">수정하기</button>
        <img src="${pageContext.request.contextPath}/img/user_refactor.png" class="outIcon" alt="탈퇴"/>
        <button type="button" class="outBtn">탈퇴하기</button>
      </span>
    </h2>
    <div class="infoForm">
      <div class="infoItem"><span class="valueText">${mypage.user_id}</span></div>
      <div class="infoItem"><span class="valueText">${mypage.user_nickname}</span></div>
    </div>
  </section>
  <hr class="infoLine"/>

  <!-- 2. 내가 쓴 리뷰 모음 -->
  <section class="reviewSection">
    <h2 class="sectionTitle">
      <img src="${pageContext.request.contextPath}/img/user_vector.png" class="infoIcon" alt="리뷰 모음"/>
      내 리뷰 모음
    </h2>

    <c:if test="${empty mypage.reviews}">
      <p class="no-data">작성한 리뷰가 없습니다.</p>
    </c:if>

    <div class="reviewContainer">
      <div class="reviewList">
        <c:forEach var="r" items="${mypage.reviews}">
          <div class="reviewCard">
            <div class="reviewImageArea">
              <img class="reviewImage" src="${r.review_img}" alt="리뷰 이미지"/>
            </div>
            <div class="reviewHeader">
              <span class="reviewerName">${mypage.user_nickname}</span>
              <time class="reviewDate">${r.writed_at}</time>
            </div>
            <hr class="line"/>
            <p class="reviewContent">${r.review_content}</p>
            <div class="storeInfo">
              <img class="storeImage" src="${r.store_img}" alt="매장 이미지"/>
              <div class="storeDetail">
                <span class="storeName">${r.store_name}</span>
                <span class="storeMenu">${r.store_menu}</span>
              </div>
              <div class="priceArea">
                <span class="originPrice">${r.origin_price}원</span>
                <span class="salePrice">${r.sale_price}원</span>
              </div>
            </div>
          </div>
        </c:forEach>
      </div>
      <div id="reviewLoader" class="loader" style="display:none">로딩 중…</div>
    </div>
  </section>
</main>

<script>
$(function(){
  // 사용자 정보 AJAX 로드
  $.get('/api/user', function(user){
    $('.infoForm .valueText').eq(0).text(user.id);
    $('.infoForm .valueText').eq(1).text(user.nickname);
  });
  // 리뷰 무한 스크롤 함수 호출…
  setupReviewInfiniteScroll();
});
</script>

<%@ include file="footer.jsp" %>
