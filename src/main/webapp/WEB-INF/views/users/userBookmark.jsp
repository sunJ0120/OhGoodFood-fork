<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Document</title>
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
        <%-- 북마크에도 상품 상세 기능 추가 --%>
        <section class="productList">
          <c:forEach var="bookmark" items = "${bookmarkList}" varStatus="st">
            <%-- store_status를 받아오기 위해 data-status를 지정 --%>
            <article class="productCard"
                     data-status="${bookmark.store_status}"
                     data-bookmark-no="${bookmark.bookmark_no}"
                     data-product-no="${bookmark.product_no}">

              <div class="productNameWrapper">
                <div class="productBookmarkWrapper">
                  <img src="${pageContext.request.contextPath}/img/bookmark.png" class="bookmarkImage">
                  <div class="productName">${bookmark.store_name}</div>
                </div>
                <div class="badge">
                  <span class="statusText">
                    <c:choose>
                      <c:when test="${bookmark.pickup_status.name() == 'SOLD_OUT'}">
                        매진 <fmt:formatDate value="${bookmark.closed_at}" pattern="HH:mm" type="time"/>
                      </c:when>

                      <c:when test="${bookmark.pickup_status.name() == 'CLOSED'}">
                        마감 <fmt:formatDate value="${bookmark.closed_at}" pattern="HH:mm" type="time"/>
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
                <img src="${pageContext.request.contextPath}/img/user_store3.jpg" alt="상품 이미지" class="storeImage"/>
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
                      <span class="todayPickupText">${bookmark.pickup_status.displayName}</span>
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
                        <fmt:formatNumber value="${bookmark.sale_price}" pattern="#,###" />₩
                      </span>
                    </c:if>

                  </div>
                </div>
              </div>
            </article>
          </c:forEach>
        </section>
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
  //dateset으로 읽기 위해서는 data-status 이거 처럼 하이픈으로 구별한다.
  $(function(){
    $('.productCard').each(function(){
      const $card = $(this);
      const status = $card.data('status');    // data-status 어트리뷰트 읽기
      console.log(status);                    // "Y" 혹은 "N"
      if (status === 'N') {
        $card.find('.badge').addClass('soldout');
      }
    });
});
</script>
<%-- bookmark 해제시 ui 변경을 위한 js --%>
<%-- ⭐ bookmark 삭제 후 다시 별을 누르면 북마크 재 추가 할 수 있도록 하는 기능 고민중입니다... --%>
<script>
  let bookmarkParams = {};

  $('.productCard').on('click', function(){
    const no = $(this).data('product-no');

    console.log("product-no : " + no);
    const ctx = '${pageContext.request.contextPath}';
    window.location.href = ctx + '/user/productDetail?product_no=' + no;
  });

  $('.bookmarkImage').on('click', function(e) {
    e.stopPropagation();  // 부모로의 이벤트 전파(=카드 클릭) 차단
    var $icon = $(this);
    var $card = $icon.closest('.productCard');

    // 이미 삭제(unbookmarked) 상태면 더 클릭하지 못하도록 alert 띄우기.
    if ($card.hasClass('unbookmarked')) {
      return alert('이미 삭제된 북마크입니다.');
    }

    // JQuery에서 data-bookmark-no 값을 가져올 땐 camelCase 키로 가져온다.
    var bookmark_no = $card.data('bookmarkNo'); //bookmark_no를 가져오기

    // 해당하는 유저의 해당하는 bookmark를 지워야 한다. 해당하는 json을 만들어서 ajax로 요청한다.
    bookmarkParams['bookmark_no'] = bookmark_no;

    $.ajax({
      url: '${pageContext.request.contextPath}/user/bookmark',
      type: 'POST',
      contentType: 'application/json',
      dataType: 'json',          // ← 응답을 JSON 으로 파싱
      data: JSON.stringify(bookmarkParams),
      success: function(data) {
        if (data.code === 500) {
          return alert('요청에 실패했습니다.');
        }
        //이미지 상태 변경 및 오퍼시티 설정
        $icon.attr('src', '/img/empty_bookmark.png');
        $card.addClass('unbookmarked');
      },
      error: function() {
        alert('서버 통신 중 오류가 발생했습니다.');
      }
    });
  });
</script>
</body>
</html>
