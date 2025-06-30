<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>OhGoodFood</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/userorder.css">
</head>
<body>
<div id="wrapper">
  <%-- header include --%>
  <%@ include file="/WEB-INF/views/users/header.jsp" %>
  <main>
    <%-- main의 헤더 부분 --%>
    <section class="orderHeaderWrapper">
      <div class="orderHeaderText">
        <span class="title">
          <div class="orderStatusTitle">
            전체
          </div>
           주문 내역
        </span>
        <span class="subtitle"> | 지난 주문 기록</span>
      </div>

      <%-- 필터 버튼 --%>
      <div class="filterDropdown">
        <button class="categoryFilterBtn">
          <span id="btnText">전체 주문</span>
          <img src="${pageContext.request.contextPath}/img/user_arrow_down_icon.png" alt="드롭다운" class="dropdownToggle">
        </button>
        <div class="dropdownModal" id="dropdownModal" style="display: none;">
          <ul>
            <li><div class="item">미확정 주문</div></li>
            <li><div class="item">확정 주문</div></li>
            <li><div class="item">취소한 주문</div></li>
            <li><div class="item">전체 주문</div></li>
          </ul>
        </div>
      </div>
    </section>

    <%-- 상품 리스트 --%>
    <div class="tabBoxWrapper">
      <%-- topWrapper로 한 번더 감싸서 스크롤 적용 --%>
      <div class="topWrapper">
        <div class="productWrapper">
          <c:choose>
            <c:when test="${empty userOrderList}">
              <div class="emptyModal">
                <div class="modalWrapper">
                  <img src="${pageContext.request.contextPath}/img/user_cat.png" alt="고양이" class="emptyModalEmoji"/>
                  <div class="modalBox">
                    <div class="modalContent">
                      <div class="orderStatusModal">전체</div> 주문내역<br>검색 결과가 없습니다.
                    </div>
                  </div>
                </div>
              </div>
            </c:when>
            <c:otherwise>
              <section class="productList">
                <c:forEach var="userOrder" items = "${userOrderList}" >
                  <article class="productCard"
                           data-order-no="${userOrder.order_no}"
                           data-order-status="${userOrder.order_status}"
                           data-canceld-from="${userOrder.canceld_from}"
                           data-block-cancel="${userOrder.block_cancel}">
                    <div class="orderTop">
                      <div class="storeName">${userOrder.store_name}</div>
                      <div class="headerLeftWrapper">
                        <div class="orderStatus">
                          <c:choose>
                            <c:when test="${userOrder.order_status eq 'reservation'}">
                              확정 진행중
                            </c:when>

                            <c:when test="${userOrder.order_status eq 'cancel'}">
                              <c:choose>
                                <c:when test="${userOrder.canceld_from eq 'user'}">
                                  구매자 취소
                                </c:when>
                                <c:when test="${userOrder.canceld_from eq 'store'}">
                                  가게 취소
                                </c:when>
                                <%-- 임시이다. 차피 데이터 수정되면 cancel에 @@취소 이게 안 붙어 있을리가 없어서 사라질 부분임 --%>
                                <c:otherwise>
                                  취소
                                </c:otherwise>
                              </c:choose>
                            </c:when>

                            <c:when test="${userOrder.order_status eq 'pickup'}">
                              픽업 완료
                            </c:when>

                            <%-- 오늘 픽업, 내일 픽업은 확정일시 말한다. --%>
                            <c:when test="${userOrder.order_status eq 'confirmed'}">
                              ${userOrder.pickup_status.displayName}
                            </c:when>
                          </c:choose>
                        </div>
                        <div class="orderDate">
                          <c:if test="${not empty userOrder.ordered_at}">
                            <fmt:formatDate value="${userOrder.ordered_at}" pattern="yyyy.MM.dd"/>
                          </c:if>
                        </div>
                      </div>
                    </div>
                    <hr>

                    <div class="orderMiddle">
                      <img src="https://ohgoodfood.s3.ap-northeast-2.amazonaws.com/${userOrder.store_img}" alt="상품 이미지" class="productImg" />
                      <div class="orderInfoWrapper">
                        <div class="orderInfo">
                          <div class="orderInfoSub"><div class="orderAmount">수량 : </div><span class="orderAmountValue">${userOrder.quantity}개</span></div>
                          <div class="orderInfoSub"><div class="orderTime">픽업 시간 : </div>
                            <span class="orderTimeValue">
                        <span class="pickupStartText">
                        <c:if test="${not empty userOrder.pickup_start}">
                          <fmt:formatDate value="${userOrder.pickup_start}" pattern="HH:mm"/>
                          ~
                        </c:if>
                      </span>
                      <span class="pickupEndText">
                        <c:if test="${not empty userOrder.pickup_end}">
                          <fmt:formatDate value="${userOrder.pickup_end}" pattern="HH:mm"/>
                        </c:if>
                      </span>
                      </span>
                          </div>
                          <div class="orderInfoSub"><div class="orderPaid">결제 금액 : </div>
                            <span class="orderPaidValue">
                        <fmt:formatNumber value="${userOrder.paid_price}" pattern="#,###" />₩
                      </span>
                          </div>
                        </div>
                      </div>
                    </div>
                      <%-- 버튼 --%>
                    <div class="orderNoticeWrapper">
                      <div class="orderNoticeBlockCancel hidden">
                        * 확정 한 시간 전부터 주문 취소가 불가능합니다.
                      </div>

                      <button type="button" class="orderBrown hidden orderReview"
                              onclick="location.href='${pageContext.request.contextPath}/user/reviewWrite?order_no=${userOrder.order_no}'">
                        리뷰 쓰기
                      </button>

                      <div class="orderWhite hidden orderPickupCode">
                        픽업 코드 : ${userOrder.order_code}
                      </div>

                      <form action="/user/order/cancel" method="post" class="postStyle hidden" onsubmit="return confirm('정말 주문을 취소하시겠습니까?');">
                        <input type="hidden" name="order_no" value="${userOrder.order_no}" />
                        <button type="submit"  class="orderWhite hidden orderCancel" data-order-no="${userOrder.order_no}">
                          주문 취소
                        </button>
                      </form>
                    </div>
                  </article>
                </c:forEach>
              </section>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>
  </main>

  <%-- footer include --%>
  <%@ include file="/WEB-INF/views/users/footer.jsp" %>
</div>
<%-- JQuery CDN --%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<c:if test="${not empty msg}">
  <script>
    alert('${msg}');
  </script>
</c:if>
<c:if test="${not empty errorMsg}">
  <script>
    alert('${errorMsg}');
  </script>
</c:if>

<%--[main] filterBtn에 따라 필터링 적용, ajax 적용 --%>
<script>
  let filterParams = {}; // 최종적으로 전송할 JSON 객체
  $(function(){
    // 초기 페이지 로드 때 버튼 hidden 조정
    adjustOrderButtons();
    // 초기 페이지 로드 때 버튼 컬러 설정
    changeOrderButtonsColors()
    // 카테고리 클릭 시
    $('.dropdownModal .item').on('click', function () {
      const selectedCategory = $(this).text().trim();
      const key = 'order_status';   // 사용할 파라미터 키

      // 카테고리 키
      const categoryMap = {
        '미확정 주문':    ['reservation'],
        '확정 주문':      ['confirmed', 'pickup'],  // 확정 주문에 두 가지 상태를 배열로 묶음
        '취소한 주문':    ['cancel']
      };

      // 선택된 카테고리에 대응하는 상태코드들
      const statuses = categoryMap[selectedCategory] || [];

      // 이전 order_status 삭제
      delete filterParams[key];

      // 항상 배열로 할당, 전체 주문일때는 할당하지 않는다.
      if (statuses.length > 0) {
        // 상태 배열이 비어 있지 않을 때만 필터 추가
        filterParams[key] = statuses;
      }

      // 버튼 텍스트 갱신
      $('#btnText').text(selectedCategory);

      // AJAX 호출
      sendFilterRequest();
    });
  });

  // JSON BODY가 들어가야 하기 때문에 POST로 요청한다.
  function sendFilterRequest() {
    $.ajax({
      url: '${pageContext.request.contextPath}/user/filter/order',
      type: 'POST',
      contentType: 'application/json',
      data: JSON.stringify(filterParams),
      success: function (responseHtml) {
        //로그 찍기
        console.log("[AJAX 응답] 서버에서 받은 HTML:", responseHtml);
        $('.productWrapper').html(responseHtml);
        //프레그먼트에 버튼 hidden 설정
        adjustOrderButtons();
        changeOrderButtonsColors();

        //modal안의 text 변경
        const $categoryFilterBtn = $(".categoryFilterBtn");
        const $orderStatusModal = $(".orderStatusModal");
        const text = $categoryFilterBtn.text().trim().replace(/주문$/, '');
        $orderStatusModal.text(text);

      },
      error: function (xhr, status, error) {
        console.error("[AJAX 오류 발생]");
        console.error("status:", status);
        console.error("HTTP 상태 코드:", xhr.status);
        console.error("응답 텍스트:", xhr.responseText);
        console.error("error 객체:", error);
      }
    });
  }
</script>
<%-- 버튼 hidden 조정 --%>
<script>
  function adjustOrderButtons() {
    $('.productCard').each(function(){
      const $card    = $(this);
      const status   = $card.data('orderStatus');        // reservation, confirmed, pickup, cancel
      const blockStatus = $card.data('blockCancel');

      const $wrapper = $card.find('.orderNoticeWrapper');

      const $notice  = $wrapper.find('.orderNoticeBlockCancel');
      const $review  = $wrapper.find('.orderReview');
      const $pickupCode  = $wrapper.find('.orderPickupCode');
      const $cancel  = $wrapper.find('.orderCancel');
      const $cancelPost  = $wrapper.find('form.postStyle');

      $notice.addClass('hidden');
      $review.addClass('hidden');
      $pickupCode.addClass('hidden');
      $cancel.addClass('hidden');
      $cancelPost.addClass('hidden');

      // 상태별로 필요한 요소만 보이게 한다.
      if(blockStatus){ //확정 한시간 전 & 내일 픽업일 경우, 11시 일 경우 (자정-1)
        $card.addClass('blockCancel');
        $notice.removeClass('hidden');
      }else{
        $card.removeClass('blockCancel'); //blockCancel 아니므로 class 추가
        if (status === 'reservation') { //확정 진행중
          $cancel.removeClass('hidden');
          $cancelPost.removeClass('hidden');
        } else if (status === 'confirmed') { //확정
          $pickupCode.removeClass('hidden');
        } else if (status === 'pickup') { //픽업 완료
          $review.removeClass('hidden');
        }
      }
    });
  }
</script>
<%-- [filter] category filter modal toggle js --%>
<script>
  $(document).ready(function () {
    const contextPath = "${pageContext.request.contextPath}";
    const $dropdownToggle = $(".dropdownToggle");
    const $dropdownModal = $("#dropdownModal");
    const $btnText = $("#btnText");
    const $categoryFilterBtn = $(".categoryFilterBtn");
    const $orderStatusTitle = $(".orderStatusTitle");

    $dropdownToggle.on("click", function (e) {
      e.stopPropagation(); // 부모 클릭 방지
      const isVisible = $dropdownModal.css("display") === "block";
      $dropdownModal.css("display", isVisible ? "none" : "block");
    });

    // 항목 클릭 시 버튼 텍스트 바꾸고 닫기
    $dropdownModal.find('.item').each(function () {
      $(this).on("click", function () {
        $dropdownModal.find('.item').removeClass("active");
        $(this).addClass("active");

        $categoryFilterBtn.addClass("active");
        $dropdownToggle.attr("src", contextPath + "/img/user_arrow_down_icon_active.png"); //이미지 흰색 토글로 변경
        console.log("클릭됨:", $(this).text());
        $btnText.text($(this).text());

        const text = $(this).text().trim().replace(/주문$/, '');
        $orderStatusTitle.text(text);
      });
    });

    //이벤트 전이 방지
    $dropdownModal.on("click", function (e) {
      e.stopPropagation();
    });

    // document 클릭하면 모달 닫기
    // 필터 선택 상태는 그대로 유지하게끔 .active는 남게 구성
    $(document).on("click", function () {
      $dropdownModal.css("display", "none");
    });
  });
</script>
<%-- orderStatus and canceldFrom에 따라서 뱃지 색상 바꾸기 --%>
<script>
function changeOrderButtonsColors() {
  $('.productCard').each(function(){
    const $card   = $(this);
    const $status = $card.find('.orderStatus');

    const orderStatus  = $card.data('orderStatus');   // reservation, cancel, pickup, confirmed
    const canceldFrom  = $card.data('canceldFrom');   // user, store

    if (orderStatus === 'cancel') {
      if (canceldFrom === 'user')  {
        $status.addClass('brownBadge');
      }
    } else if (orderStatus === 'pickup'){
      $status.addClass('brownBadge');
    } else{
      $status.removeClass('brownBadge');
    }
  });
}
</script>
</body>
</html>