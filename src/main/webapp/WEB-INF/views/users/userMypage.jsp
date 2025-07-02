<%@ page contentType="text/html; charset=UTF-8" language="java" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
                  <img src="${pageContext.request.contextPath}/img/user_user.png" alt="내 정보 아이콘" class="infoIcon" />
                  내 정보
                  <span class="actionButtons">
                    <img src="${pageContext.request.contextPath}/img/user_refactor.png" alt="수정하기 아이콘"
                      class="modifyIcon" />
                    <button type="button" class="modifyBtn">수정하기</button>
                    <img src="${pageContext.request.contextPath}/img/user_refactor.png" alt="탈퇴하기 아이콘"
                      class="outIcon" />
                    <button type="button" class="outBtn">탈퇴하기</button>
                  </span>
                </h2>
                <div class="infoForm">
                  <div class="infoItem">
                    <span id="user_id" class="valueText">${userMypage.user_id}</span>
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
                  <img src="${pageContext.request.contextPath}/img/user_Vector.png" alt="내 리뷰 모음 아이콘"
                    class="infoIcon" />
                  내 리뷰 모음
                </h2>

                <div class="reviewContainer">
                  <div class="reviewList">
                    <c:choose>
                      <c:when test="${empty userMypage.reviews}">
                          <div class="modalWrapper">
                            <img src="${pageContext.request.contextPath}/img/user_noreview.png" alt="리뷰없는고양이"
                              class="emptyModalEmoji" />
                          </div>
                      </c:when>
                      <c:otherwise>
                        <c:forEach var="review" items="${userMypage.reviews}">
                          <div class="reviewCard">
                            <div class="reviewImageArea">
                              <img class="reviewImage"
                                src="https://ohgoodfood.s3.ap-northeast-2.amazonaws.com/${review.review_img}"
                                alt="리뷰 이미지" />
                            </div>
                            <div class="reviewHeaderBox">
                              <div class="reviewHeader">
                                <span class="reviewerName">${userMypage.user_nickname}</span>
                                <time class="reviewDate">
                                  <fmt:formatDate value="${review.writed_at}" pattern="yyyy.MM.dd" />
                                </time>
                              </div>
                              <hr class="line" />
                              <p class="reviewContent">${review.review_content}</p>
                            </div>
                            <div class="storeInfo">
                              <img class="storeImage"
                                src="https://ohgoodfood.s3.ap-northeast-2.amazonaws.com/${review.store_img}"
                                alt="매장 이미지" />
                              <div class="storeDetail">
                                <span class="storeName">${review.store_name}</span>
                                <span class="storeMenu">${review.store_menu}</span>
                              </div>
                              <div class="priceArea">
                                <span class="originPrice">
                                  <fmt:formatNumber value="${review.origin_price}" type="number" />원
                                </span>
                                <span class="salePrice">
                                  <fmt:formatNumber value="${review.sale_price}" type="number" />원
                                </span>
                              </div>
                            </div>
                          </div>
                          </c:forEach>
                      </c:otherwise>
                      </c:choose>
                  </div>

                  <div id="reviewLoader" class="loader" style="display:none">
                    로딩 중…
                  </div>
                </div>
              </section>
            </main>

            <%@ include file="/WEB-INF/views/users/footer.jsp" %>
        </div>

        <script>
          window.addEventListener('DOMContentLoaded', function () {
            const userIdSpan = document.getElementById('user_id');
            if (!userIdSpan) return;

            const rawId = userIdSpan.textContent.trim();

            if (rawId.startsWith('naver_id')) {
              userIdSpan.textContent = 'NAVER 로그인';
            } else if (rawId.startsWith('kakao_id')) {
              userIdSpan.textContent = 'KAKAO 로그인';
            } else {
              // 아무것도 안 함 → 기존 아이디 그대로 표시
            }
          });
        </script>
      </body>
      </html>