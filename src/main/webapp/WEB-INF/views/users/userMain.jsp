<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>OhGoodFood</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/usermain.css">
</head>
<body>
<div id="wrapper">

  <header>
    <div class="header-container">
      <img src="${pageContext.request.contextPath}/img/ohgoodfood_logo.png" alt="Logo Image">
      <div class="icon-container">
        <img src="${pageContext.request.contextPath}/img/alarm_active.png" alt="알람" class="icon">
        <img src="${pageContext.request.contextPath}/img/bookmark.png" alt="즐겨찾기" class="icon">
        <img src="${pageContext.request.contextPath}/img/logout.png" alt="로그아웃" class="icon">
      </div>
    </div>
  </header>

  <main>
    <!-- 검색바 -->
    <section class="searchBar">
      <div class="searchWrapper">
        <input type="text" placeholder="검색어를 입력하세요." class="searchInput">
        <button class="searchBtn">
          <img src="${pageContext.request.contextPath}/img/search_icon.png" alt="검색">
        </button>
      </div>
    </section>

    <!-- 필터 버튼 -->
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
      <button class="filterBtn">오늘 픽업</button>
      <button class="filterBtn">내일 픽업</button>
    </section>

    <!-- 상품 리스트 -->
    <div class="tabBoxWrapper">
      <div class="tabSelector">
        <button class="tabBtn active">리스트</button>
        <button class="tabBtn">지도</button>
      </div>
      <!-- topWrapper로 한 번더 감싸서 스크롤 적용 -->
      <div class="topWrapper">
        <div class="productWrapper">
          <section class="productList">
            <c:forEach var="mainStore" items = "${mainStoreList}" >
              <article class="productCard">
                <div class="cardImage">
                  <img src="${pageContext.request.contextPath}/img/user_usermain_img.png" alt="상품 이미지" class="storeImage">
                  <div class="cardLabel">
                    <div class="productNameWrapper">
                      <div class="productName">
                          ${mainStore.store_name}
                      </div>
                      <div class="badge">
                        <!-- 이거 store_status, reservation_end는 프론트단에서 처리 해야 해서 가장 나중에 하기로 한다. -->
                        <span class="statusText">${mainStore.pickup_date}</span>
                        <span class="timeText">(${mainStore.amount_time_tag})</span>
                      </div>
                    </div>
                  </div>
                </div>

                <div class="cardInfo">
                  <div class="productTexts">
                    <p class="productDesc">${mainStore.category_name}</p>
                    <p class="productDesc">${mainStore.store_menu}</p>
                    <p class="pickupTime">픽업 시간 |
                      <strong>
                        <!-- 이거 today_fickup도 프론트단에서 처리 해야 해서 가장 나중에 하기로 한다. -->
                        <span class="todayPickupText">${mainStore.pickup_date}</span>
                        <span class="pickupStartText">
                        <fmt:formatDate value="${mainStore.pickup_start}" pattern="HH:mm" />
                      </span>
                        ~
                        <span class="pickupEndText">
                        <fmt:formatDate value="${mainStore.pickup_end}" pattern="HH:mm" />
                      </span>
                      </strong>
                    </p>
                  </div>
                  <div class="priceBox">
                    <del class="originalPrice">
                      <fmt:formatNumber value="${mainStore.origin_price}" pattern="#,###" />₩
                    </del>
                    <span class="salePrice">
                    <fmt:formatNumber value="${mainStore.sale_price}" pattern="#,###" />₩
                  </span>
                  </div>
                </div>
              </article>
            </c:forEach>
          </section>
        </div>
          <!-- 지도 api 영역 -->
          <div class="mapWrapper" style="display: none;">
              <p>여기에 지도 들어갈 예정입니다~</p>
          </div>
      </div>
    </div>
  </main>

  <footer>
    <div class="footer-container">
      <div class="menu-container">
        <div class="menu-item">
          <img src="${pageContext.request.contextPath}/img/home.png" data-name="home" alt="홈" class="menu-icon">
        </div>
        <div class="menu-item">
          <img src="${pageContext.request.contextPath}/img/review.png" data-name="review" alt="리뷰" class="menu-icon">
        </div>
        <div class="menu-item">
          <img src="${pageContext.request.contextPath}/img/order.png" data-name="order" alt="주문" class="menu-icon">
        </div>
        <div class="menu-item">
          <img src="${pageContext.request.contextPath}/img/mypage.png" data-name="mypage" alt="마이페이지" class="menu-icon">
        </div>
      </div>
    </div>
  </footer>
</div>
</body>
<!-- JQuery CDN -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- [layout] bottom navigation js -->
<script>
  $(document).ready(function () {
    $('.menu-item').on('click', function () {
      $('.menu-item').each(function () {
        $(this).removeClass('active');
        const $img = $(this).find('img');
        // 기본 이미지로 복원
        const name = $img.attr('data-name');
        $img.attr('src', `../../../img/${"${name}"}.png`); //jsp 랑 js 문법이 겹쳐서 이렇게 두번 감싸야 한다.
      });
      $(this).addClass('active');
      const $img = $(this).find('img');
      // active 이미지로 변경
      const name = $img.attr('data-name');
      // log 찍어보기
      console.log("data-name:", $img.attr('data-name'));

      $img.attr('src', `../../../img/${"${name}"}_active.png`);
    });
  });
</script>
<!-- [filter] category filter modal toggle js -->
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
        $dropdownToggle.attr("src", "${contextPath}/img/user_arrow_down_icon_active.png"); //이미지 흰색 토글로 변경
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
<!-- [filter] atc filter js -->
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
<!-- [main] main map 화면 전환 js -->
<script>
  $(document).ready(function () {
    const $tabBtn = $(".tabBtn");
    const $productWrapper = $(".productWrapper");
    const $mapWrapper = $(".mapWrapper");

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
        }
      });
    });
  });
</script>
<!--[main] 픽업 상태에 따라 뱃지 색상 변경 & 카드 오퍼시티 변경 -->
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
<!--[main] filterBtn에 따라 필터링 적용, ajax 적용 -->
<script>
  let filterParams = {}; // 최종적으로 전송할 JSON 객체

  $(document).ready(function() {
    //검색바 입력시
    $('.searchBtn').on('click', function () {
      const keyword = $('.searchInput').val().trim(); // 검색어 가져오기
      const key = 'search';
      filterParams[key] = keyword; //search : 라는 이름으로 저장

      sendFilterRequest(); // AJAX 호출
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

      // 기존 category_* 키 제거
      Object.keys(filterParams).forEach(k => {
        if (k.startsWith('category_')) delete filterParams[k];
      });

      // 새 카테고리 설정
      filterParams[key] = 'Y';
      $('#btnText').text(selectedCategory);

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
          $this.addClass('active');
        }
      }
      sendFilterRequest(); // AJAX 요청
    });

    // 공통 AJAX 요청 함수
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
</html>
