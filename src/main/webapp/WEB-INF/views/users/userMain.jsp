<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>OhGoodFood</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/usermain.css">
</head>
<body>
<div id="wrapper">
  <%-- header include --%>
  <%@ include file="/WEB-INF/views/users/header.jsp" %>

  <main>
    <%-- 검색바 --%>
    <section class="searchBar">
      <div class="searchWrapper">
        <input type="text" placeholder="검색어를 입력하세요." class="searchInput">
        <button class="searchBtn">
          <img src="${pageContext.request.contextPath}/img/search_icon.png" alt="검색">
        </button>
      </div>
    </section>

    <%-- 필터 버튼 --%>
    <section class="filterButtons">
      <div class="filterDropdown">
        <button class="categoryFilterBtn">
          <span id="btnText">음식 종류</span>
          <img src="${pageContext.request.contextPath}/img/user_arrow_down_icon.png" alt="드롭다운" class="dropdownToggle">
        </button>
        <div class="dropdownModal" id="dropdownModal" style="display: none;">
          <ul>
            <li><div class="item">빵 & 디저트</div></li>
            <li><div class="item">샐러드</div></li>
            <li><div class="item">과일</div></li>
            <li><div class="item">그 외</div></li>
          </ul>
        </div>
      </div>
      <button class="filterBtn">예약 가능만</button>
      <button class="filterBtn pickup">오늘 픽업</button>
      <button class="filterBtn pickup">내일 픽업</button>
    </section>

    <%-- 상품 리스트 --%>
    <div class="tabBoxWrapper">
      <div class="tabSelector">
        <button class="tabBtn active">리스트</button>
        <button class="tabBtn">지도</button>
      </div>
      <%-- topWrapper로 한 번더 감싸서 스크롤 적용 --%>
      <div class="topWrapper">
        <div class="productWrapper">
          <section class="productList">
            <c:forEach var="mainStore" items = "${mainStoreList}" >
              <article class="productCard"
                       data-product-no="${mainStore.product_no}"
                       data-store-status="${mainStore.store_status}">
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
        </div>
        <%-- 지도 api 영역 --%>
        <div class="mapWrapper" style="display: none;">
          <script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoMapAppKey}"></script>
        </div>
      </div>
    </div>
  </main>

  <%-- footer include --%>
  <%@ include file="/WEB-INF/views/users/footer.jsp" %>
</div>
<%-- JQuery CDN --%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
  $(document).ready(function () {
    const $dropdownToggle = $(".dropdownToggle");
    const $dropdownModal = $("#dropdownModal");
    const $btnText = $("#btnText");
    const $categoryFilterBtn = $(".categoryFilterBtn");

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
        $dropdownToggle.attr("src", "${pageContext.request.contextPath}/img/user_arrow_down_icon_active.png"); //이미지 흰색 토글로 변경
        console.log("클릭됨:", $(this).text());
        $btnText.text($(this).text());
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
<%-- [filter] atc filter js --%>
<script>
  $(document).ready(function () {
    const $filterButtons = $(".filterBtn");

    $filterButtons.each(function () {
      $(this).on("click", function () {
        //현재 클릭된 버튼 active 추가, toggle 방식으로 두번 누르면 active 없게끔 한다.
        $(this).toggleClass("active");
      });
    });
  });
</script>
<%-- kakao 지도 호출 --%>
<%-- [main] main map 화면 전환 js --%>
<script>
  let init = false;
  let map;
  let coords;

  // 내 위치 마커를 표시하는 함수, 차후 전체 마커 표시하는 함수로 확장 예정
  function makeMyLocationMarker(latitude, longitude) {
    var imageSrc = '${pageContext.request.contextPath}/img/user_my_pin.png', // 마커이미지의 주소
            imageSize = new kakao.maps.Size(50, 50), // 마커이미지의 크기
            imageOption = {offset: new kakao.maps.Point(25, 50)}; // 마커이미지의 옵션, 마커의 좌표와 일치시킬 이미지 안에서의 좌표를 설정

    var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption),
            markerPosition = new kakao.maps.LatLng(latitude, longitude);

    // 마커를 생성한다.
    var marker = new kakao.maps.Marker({
      position: markerPosition,
      image: markerImage // 마커이미지 설정
    });

    // 마커가 지도 위에 표시되도록 설정
    marker.setMap(map);
  }

  function getCurrentLocation() {
    return new Promise((resolve, reject) => {
      if (!navigator.geolocation) {
        return reject(new Error('Geolocation 미지원'));
      }
      navigator.geolocation.getCurrentPosition(
              pos  => resolve(pos.coords),
              err  => reject(err),
              { enableHighAccuracy: true, timeout: 5000 }
      );
    });
  }

  function initMap(latitude, longitude) {
    const mapWrapper = document.querySelector('.mapWrapper');
    // SDK 로드 이후에 동작하도록 한다.
    const center = new kakao.maps.LatLng(latitude, longitude);
    console.log("위도, 경도 : ", latitude, longitude);

    map = new kakao.maps.Map(mapWrapper, {
      center: center,
      level: 3
    });
    init = true;
  }

  $(document).ready(async function () {
    const $tabBtn = $(".tabBtn");
    const $productWrapper = $(".productWrapper");
    const $mapWrapper = $(".mapWrapper");
    // const $mapLoading  = $(".mapLoading");

    try {
      coords = await getCurrentLocation(); //현재 위치 받아오기
    } catch (e) {
      console.warn('위치 정보 로드 실패:', e.message);
      // 위치 정보 없을 경우 초기 위도 경도값 설정 가능
      initMap(33.450701, 126.570667);
    } finally {
      // 위도 경도 로딩 후 로딩창 숨기기
      // $mapLoading.addClass("hidden");
    }

    $tabBtn.each(function () {
      $(this).on("click", function () {
        $tabBtn.removeClass("active");
        $(this).addClass("active");

        // 어떤 버튼이 눌렸느냐에 따라 화면을 전환한다.
        if ($(this).text() === "리스트") {
          $productWrapper.show();
          $mapWrapper.hide();
        } else if ($(this).text() === "지도") {
          $productWrapper.hide();
          $mapWrapper.show();

          if (!init) {
            initMap(coords.latitude, coords.longitude);
            makeMyLocationMarker(coords.latitude, coords.longitude);
            init = true;
          } else {
            // relayout을 통해 css(display 상태 등)가 바뀌었을때도 동작하도록 한다.
            map.relayout();
            map.setCenter(map.getCenter());
            makeMyLocationMarker(coords.latitude,coords.longitude);
          }
        }
      });
    });
  });
</script>
<%--[main] 픽업 상태에 따라 뱃지 색상 변경 & 카드 오퍼시티 변경 --%>
<script>
  $(document).ready(function () {
    applyBadgeStyles(); // 페이지 처음 로드 시 적용
  });

  function applyBadgeStyles() {
    $(".statusText").each(function () {
      const text = $(this).text().trim();
      const badge = $(this).closest(".badge");
      const cardImage = $(this).closest(".cardImage");
      const storeImage = cardImage.find(".storeImage");

      if (text === "오늘픽업" || text === "내일픽업") {
        badge.css("background-color", "#D8A8AB");
        badge.css("color", "white");
        storeImage.removeClass("soldout");
      } else {
        badge.css("background-color", "#8B6D5C");
        badge.css("color", "white");
        storeImage.addClass("soldout");
      }
    });
  }
</script>
<%--[main] filterBtn에 따라 필터링 적용, ajax 적용 --%>
<script>
  let filterParams = {}; // 최종적으로 전송할 JSON 객체

  // 사용자 편의성을 위해, 검색시 enter도 가능하게 변경
  $(document).ready(function() {
    // 검색 버튼 클릭
    $('.searchBtn').on('click', function () {
      const keyword = $('.searchInput').val().trim();
      // 이전에 filterParams.search 에 저장된 값(없으면 빈 문자열)
      const prev = filterParams.search || '';

      // 변화가 없다면(둘 다 빈칸이거나, 둘 다 같은 키워드) 요청 차단
      if (keyword === prev) {
        return;
      }

      // 이전과 변화가 있을 경우에만 실행
      if (keyword) {
        // 키워드가 있으면 필터에 넣기
        filterParams.search = keyword;
      } else {
        delete filterParams.search;
      }
      sendFilterRequest();
    });

    // 입력창에서 엔터 키 눌렀을 때
    $('.searchInput').on('keydown', function(e) {
      if (e.key === 'Enter' || e.keyCode === 13) {
        e.preventDefault();            // 엔터로도 같은 로직
        $('.searchBtn').click();       // 클릭 이벤트 트리거, sendFilterRequest();로 이동
      }
    });

    // 카테고리 클릭 시
    $('.dropdownModal .item').on('click', function() {
      const selectedCategory = $(this).text().trim();

      // 카테고리 키
      const categoryMap = {
        '빵 & 디저트': 'category_bakery',
        '샐러드': 'category_salad',
        '과일': 'category_fruit',
        '그 외': 'category_etc'
      };

      //선택된 것을 Y로 매칭
      const key = categoryMap[selectedCategory];

      if (filterParams[key] === 'Y') {
        // 클릭한 걸 다시 누르면 전체 필터 해제 & 전체 보여주기 기능 추가
        delete filterParams[key];
        $('#btnText').text('음식 종류');       // 버튼 텍스트를 기본값인 음식 종류로 다시 변경
        $('.dropdownModal .item').removeClass('active'); // 모든 active 해제 (색상 해제를 위해)
        $('.categoryFilterBtn').removeClass('active'); // categoryFilterBtn (토글)의 active도 삭제
        $('.dropdownToggle').attr('src', `${pageContext.request.contextPath}/img/user_arrow_down_icon.png`); //toggle의 이미지 변경

      } else {
        // 기존 category_* 키 제거
        Object.keys(filterParams).forEach(k => {
          if (k.startsWith('category_')) delete filterParams[k];
        });

        // 새 카테고리 설정
        filterParams[key] = 'Y';
        $('#btnText').text(selectedCategory);
      }
      sendFilterRequest(); // AJAX 호출
    });

    // 필터 버튼 클릭 시
    $('.filterBtn').on('click', function () {
      const $this = $(this);
      const filterText = $this.text().trim();

      if (filterText === '예약 가능만') {
        const key = 'store_status';
        const value = 'Y';

        if (filterParams[key] === value) {
          delete filterParams[key];
          $this.removeClass('active');
        } else {
          filterParams[key] = value;
          $this.addClass('active');
        }
      } else if (filterText === '오늘 픽업' || filterText === '내일 픽업') {
        const key = 'pickup_start';
        const date = new Date();

        if (filterText === '내일 픽업') date.setDate(date.getDate() + 1);
        const formatted = date.toISOString().slice(0, 10);

        // 토글
        if (filterParams[key] === formatted) {
          // 이미 존재할 경우 삭제한다.
          delete filterParams[key];
          $this.removeClass('active');
        } else {
          filterParams[key] = formatted;
          $('.filterBtn.pickup').removeClass('active'); // 오늘/내일 둘 다 해제
          $this.addClass('active'); //현재 클릭한 버튼에 다시 active 추가
        }
      }
      sendFilterRequest(); // AJAX 요청
    });

    // 공통 AJAX 요청 함수
    // JSON BODY가 들어가야 하기 때문에 POST로 요청한다.
    function sendFilterRequest() {
      $.ajax({
        url: '${pageContext.request.contextPath}/user/filter/store',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(filterParams),
        //fragment 방식 사용, DOM을 다시 그리자니 너무 노가다라...
        success: function (responseHtml) {
          //로그 찍기
          console.log("[AJAX 응답] 서버에서 받은 HTML:", responseHtml);
          $('.productWrapper').html(responseHtml);
          applyBadgeStyles(); //오퍼시티 적용
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
  });
</script>
<%-- Product card 누르면 상세 이동 --%>
<script>
  $(function(){
    $('.productCard').on('click', function(){
      const store_status = $(this).data('store-status');
      const no = $(this).data('product-no');

      if (store_status === 'N') {
        alert('아직 오픈 전입니다!');
        return;  // 클릭 처리 종료
      }

      console.log("product-no : " + no);
      const ctx = '${pageContext.request.contextPath}';
      window.location.href = ctx + '/user/productDetail?product_no=' + no;
    });
  });
</script>
</body>
</html>
