<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Ohgoodfood</title>
  <link rel="icon" type="image/jpeg" href="https://ohgoodfood.s3.ap-northeast-2.amazonaws.com/shinhanmoilicon32x32.jpg">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/userbookmark.css">
</head>
<body>
  <div id="wrapper">
    <%-- header include --%>
    <%@ include file="/WEB-INF/views/users/header.jsp" %>

    <main>
      <%-- topWrapper로 한 번더 감싸서 스크롤 적용 --%>
      <div class="topWrapper">
        <div class="productWrapper">
          <c:choose>
            <c:when test="${empty bookmarkList}">
              <div class="emptyModal">
                <div class="modalWrapper">
                  <img src="${pageContext.request.contextPath}/img/user_cat.png" alt="고양이" class="emptyModalEmoji"/>
                  <div class="modalBox">
                    <div class="modalContent">
                      즐겨찾기한 가게가 없습니다.<br>
                      선호하는 가게를 추가해보세요!
                    </div>
                  </div>
                </div>
              </div>
            </c:when>
            <c:otherwise>
              <section class="productList">
                <c:forEach var="bookmark" items = "${bookmarkList}" varStatus="st">
                  <%-- store_status를 받아오기 위해 data-status를 지정 --%>
                  <article class="productCard"
                           data-status="${bookmark.store_status}"
                           data-bookmark-no="${bookmark.bookmark_no}"
                           data-product-no="${bookmark.product_no}"
                           data-store-id="${bookmark.store_id}">
                    <div class="productNameWrapper">
                      <div class="productBookmarkWrapper">
                        <div class="bookmarkWrapper">
                          <img src="${pageContext.request.contextPath}/img/user_bookmark.png" class="bookmarkImage">
                        </div>
                        <div class="productName">
                          <strong>${bookmark.store_name}</strong>
                        </div>
                      </div>
                      <div class="badge">
                    <span class="statusText">
                      <c:choose>
                        <c:when test="${bookmark.pickup_status.name() == 'SOLD_OUT'}">
                          매진
                        </c:when>

                        <c:when test="${bookmark.pickup_status.name() == 'CLOSED'}">
                          마감
                        </c:when>

                        <c:when test="${bookmark.pickup_status.name() == 'TOMORROW' or bookmark.pickup_status.name() == 'TODAY'}">
                          <c:if test="${bookmark.amount > 5}">+5개 남음</c:if>
                          <c:if test="${bookmark.amount <= 5}">${bookmark.amount}개 남음</c:if>
                        </c:when>

                      </c:choose>
                    </span>
                      </div>
                    </div>
                      <%-- 가게 상세 정보 --%>
                    <div class="cardInfo">
                      <div class="imgWrapper">
                        <img src="https://ohgoodfood.s3.ap-northeast-2.amazonaws.com/${bookmark.store_img}" alt="상품 이미지" class="storeImage"/>
                      </div>
                      <div class="productTextWrapper">
                        <div class="productTexts">

                          <p class="productDesc">
                            <c:forEach var="category" items="${bookmark.category_list}" varStatus="status">
                              ${category}<c:if test="${!status.last}"> | </c:if>
                            </c:forEach>
                          </p>

                          <p class="productDesc">
                            <c:if test="${not empty bookmark.mainmenu_list}">
                              <c:forEach var="mainmenu" items="${bookmark.mainmenu_list}" varStatus="status">
                                ${mainmenu}<c:if test="${!status.last}"> | </c:if>
                              </c:forEach>
                            </c:if>
                          </p>

                          <p class="pickupTime">
                              <span class="todayPickupText">
                                  <strong>${bookmark.pickup_status.displayName}
                                  </strong>
                              </span>
                            <span class="pickupStartText">
                            <c:if test="${not empty bookmark.pickup_start}">
                              <fmt:formatDate value="${bookmark.pickup_start}" pattern="HH:mm"/>
                              ~
                            </c:if>
                          </span>
                            <span class="pickupEndText">
                          <c:if test="${not empty bookmark.pickup_end}">
                            <fmt:formatDate value="${bookmark.pickup_end}" pattern="HH:mm"/>
                          </c:if>
                        </span>
                          </p>
                        </div>
                        <div class="priceBox">

                          <c:if test="${bookmark.origin_price != null}">
                            <del class="originalPrice">
                              <fmt:formatNumber value="${bookmark.origin_price}" pattern="#,###" />₩
                            </del>
                          </c:if>

                          <c:if test="${bookmark.sale_price != null}">
                        <span class="salePrice">
                          <strong><fmt:formatNumber value="${bookmark.sale_price}" pattern="#,###" />₩</strong>
                        </span>
                          </c:if>

                        </div>
                      </div>
                    </div>
                  </article>
                </c:forEach>
              </section>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
    </main>
    <%-- footer include --%>
    <%@ include file="/WEB-INF/views/users/footer.jsp" %>
  </div>
  <%-- JQuery CDN --%>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <%-- data-status 정보 받아서 컬러를 변경하기 위한 js --%>
  <script>
    // 렌더 타임에 EL로 채워진 data-status 읽는다.
    $(function(){
      $('.productCard').each(function(){
        const $card = $(this);
        const status = $card.data('status');    // data-status 읽기
        if (status === 'N') {
          $card.find('.badge').addClass('soldout');
        }
      });
  });
  </script>
  <%-- bookmark 해제시 ui 변경을 위한 js --%>
  <script>
    //북마크 AJAX시 사용할 값들
    let bookmarkParams = {};

    $('.productCard').on('click', function(){
      const store_status = $(this).data('status');
      const no = $(this).data('product-no');

      if (store_status === 'N') {
        alert('아직 오픈 전입니다!');
        return;  // 클릭 처리 종료
      }
      const ctx = '${pageContext.request.contextPath}';
      // 북마크 클릭시 상품 상세로 이동
      window.location.href = ctx + '/user/productDetail?product_no=' + no;
    });

    $('.bookmarkImage').on('click', function(e) {
      e.stopPropagation();  // 부모로의 이벤트 전파(=카드 클릭) 차단
      var $icon = $(this);
      var $card = $icon.closest('.productCard');
      // bookmark no로 삭제할 경우, 더하고 삭제하면 이 no가 바뀌어서, bookmark_no로 지우고 하면 안된다. store_id, user_id 조합으로 구성한다.
      var store_id = $card.data('storeId'); //store_id 가져오기
      bookmarkParams['store_id'] = store_id;

      // 이미 삭제(unbookmarked) 상태일 경우에 insert 기능 추가
      if ($card.hasClass('unbookmarked')) {
        $.ajax({
          url: '${pageContext.request.contextPath}/user/bookmark/insert',
          type: 'POST',
          contentType: 'application/json',
          dataType: 'json',          // 응답을 JSON 으로 파싱
          data: JSON.stringify(bookmarkParams),
          success: function(data) {
            if (data.code === 500) {
              return alert('요청에 실패했습니다.');
            }
            //이미지 상태 변경
            $icon.attr('src', '/img/user_bookmark.png');
            $card.removeClass('unbookmarked');
          },
          error: function() {
            alert('[AJAX 오류] 북마크 추가 중, 서버 통신 중 오류가 발생했습니다.');
          }
        });
      }else{
        // 해당하는 유저의 해당하는 bookmark를 지워야 한다. 해당하는 json을 만들어서 ajax로 요청한다.
        $.ajax({
          url: '${pageContext.request.contextPath}/user/bookmark/delete',
          type: 'POST',
          contentType: 'application/json',
          dataType: 'json',          // 응답을 JSON 으로 파싱
          data: JSON.stringify(bookmarkParams),
          success: function(data) {
            if (data.code === 500) {
              return alert('요청에 실패했습니다.');
            }
            //이미지 상태 변경 및 오퍼시티 설정
            $icon.attr('src', '/img/user_empty_bookmark.png');
            $card.addClass('unbookmarked');
          },
          error: function() {
            alert('[AJAX 오류] 북마크 삭제 중, 서버 통신 중 오류가 발생했습니다.');
          }
        });
      }
    });
  </script>
</body>
</html>
