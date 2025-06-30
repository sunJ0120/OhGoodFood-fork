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
            <div class="emptyModal">
                <div class="modalWrapper">
                    <img src="${pageContext.request.contextPath}/img/user_cat.png" alt="고양이" class="emptyModalEmoji"/>
                    <div class="modalBox">
                        <div class="modalContent">
                            위치 정보를 조회하고 있습니다...<br>
                            잠시만 기다려 주세요!
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <%-- 지도 api 영역 --%>
        <div class="mapWrapper" style="display: none;">
          <%-- 지도 안에 있는 modal --%>
          <div class="storePinModalWrapper"></div>
          <script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoMapAppKey}&libraries=clusterer"></script>
          <%-- 이 위치에서 검색 버튼 --%>
          <button class="btnSetCenter">이 위치에서 검색</button>
        </div>
      </div>
    </div>
  </main>

  <%-- footer include --%>
  <%@ include file="/WEB-INF/views/users/footer.jsp" %>

</div>
<%-- JQuery CDN --%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<%-- filter 이벤트 --%>
<script>
  $(document).ready(function () {
    const $dropdownToggle = $(".dropdownToggle");
    const $dropdownModal = $("#dropdownModal");
    const $btnText = $("#btnText");
    const $categoryFilterBtn = $(".categoryFilterBtn");
    const $filterButtons = $(".filterBtn");

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
  //위치 정보 허용 안할 경우, 우리 사업장 위치로 (ANT 빌딩)
  let staticLatitude  = 37.5593799298988;
  let staticLongitude = 126.922667641634;

  //현재 위치
  let myLatitude;
  let myLongitude;

  //현재 띄워진 마커를 담는 전역 리스트
  let storeMarkers = [];
  let filterParams = {}; // 최종적으로 전송할 JSON 객체

  let selectedMarker = null;         // 이전에 클릭된 마커 참조
  let selectedMarkerPos = null;      // 이전에 클릭된 마커의 pos 정보

  let closePin = "${pageContext.request.contextPath}/img/user_close_pin.png";
  let openPin  = "${pageContext.request.contextPath}/img/user_open_pin.png";

  // hover시 나타나는 window를 조정하기 위한 값들
  let pinHoverModal = document.querySelector('.mapPinHoverWrapper');
  // cluster 처리를 위한 전역변수, 전역으로 선언만 해둔다.
  let clusterer = null;

  //마커 초기화 함수
  function clearStoreMarkers() {
    if (clusterer) {
      clusterer.clear();    // 클러스터안의 모든 마커를 비워야 한다.
    }
    storeMarkers.forEach(m => m.setMap(null));  // 지도에서 제거
    storeMarkers = [];
  }

  //마커 그리는 함수
  function drawStoreMarkers() {
    const positions = getProductListLatLong();  // [{store_status, latlng}, …]
    positions.forEach(pos => {
      const imageSize  = new kakao.maps.Size(30, 30);
      const imgSrc     = (pos.store_status === 'Y' && pos.amount > 0) ? openPin : closePin;
      const markerImg  = new kakao.maps.MarkerImage(imgSrc, imageSize);
      const marker     = new kakao.maps.Marker({
        map:      map,
        position: pos.latlng,
        image:    markerImg
      });
      storeMarkers.push(marker);
      markerClickEventSetter(marker,pos,openPin,closePin);
    });
    // 마커 생성이 끝난 뒤에 한 번 호출해서 클러스터에 담기
    // clusterer 가 준비된 경우에만 실행
    if (clusterer) {
      clusterer.addMarkers(storeMarkers);
    }
  }

  //마커 크기 원래대로 reset 하는 함수, 외부를 눌러서 reset될 경우 진행한다.
  function resetSelectedMarker(){
    // 이전에 클릭된 마커가 없으면 return 한다.
    if (!selectedMarker) {
      return;
    }
    const imgSrc = (selectedMarkerPos.store_status === 'Y' && selectedMarkerPos.amount > 0) ? openPin : closePin;
    selectedMarker.setImage(new kakao.maps.MarkerImage(imgSrc, new kakao.maps.Size(30, 30)));

    // 기존에 선택된 마커들 없애기, 이제 선택됐던 마커가 없어야 하므로 초기화한다.
    selectedMarker = null;
    selectedMarkerPos = null;
  }

  //마커에 클릭 이벤트 주입, 리스트 요소를 주입
  function markerClickEventSetter(marker,pos,openPin,closePin){
    // 클릭 이벤트 등록
    kakao.maps.event.addListener(marker, 'click', function() {
      //새로운 마커를 클릭할 경우
      if(!selectedMarkerPos){
        //현재 클릭된 마커 크기를 키운다.
        const newSrc = (pos.store_status === 'Y' && pos.amount > 0) ? openPin : closePin;
        marker.setImage(new kakao.maps.MarkerImage(newSrc, new kakao.maps.Size(40, 40)));

        //현재 선택된 마커로 선택 마커를 업데이트 한다.
        selectedMarker = marker;
        selectedMarkerPos = pos;
      }else{
        // 기존에 선택된 마커가 있으면 종료
        if (selectedMarker) {
          resetSelectedMarker();
        }

        //현재 클릭된 마커 크기를 키운다.
        const newSrc = (pos.store_status === 'Y' && pos.amount > 0) ? openPin : closePin;
        marker.setImage(new kakao.maps.MarkerImage(newSrc, new kakao.maps.Size(40, 40)));

        //현재 선택된 마커로 선택 마커를 업데이트 한다.
        selectedMarker = marker;
        selectedMarkerPos = pos;
      }

      $.ajax({
        url: '${pageContext.request.contextPath}/user/map/pin',
        type: 'GET',
        data: { store_id : pos.store_id },
        success: function(html) {
          console.log("[AJAX 응답]", html);
          $('.storePinModalWrapper').html(html);
            //뱃지 상태 변경
            applyBadgeStyles();
            //모달 클릭 이벤트
            storePinModalClickEvent();
        },
        error: function(xhr, status, err) {
          console.error("AJAX 오류", status, err);
        }
      });
    });
  }

  // 전체 리스트의 위도 경도를 잡기 위함
  function getProductListLatLong(){
    let positions = [];

    $('.productWrapper .productCard').each(function() {
      let $productCard = $(this);

      let latitude = parseFloat($productCard.data('latitude'));
      let longitude = parseFloat($productCard.data('longitude'));

      let storeId = $productCard.data('storeId');
      let storeStatus = $productCard.data('storeStatus'); //JQuery는 camelCase 매핑
      let amount = $productCard.data('amount');

      if (!isNaN(latitude) && !isNaN(longitude)){
        positions.push({
          store_id : storeId,
          store_status : storeStatus,
          amount : amount,
          latlng: new kakao.maps.LatLng(latitude, longitude)
        });
      }
    });
    return positions;
  }
  // 내 위치 마커를 표시하는 함수
  function makeMyLocationMarker(latitude, longitude) {
    let imageSrc    = '${pageContext.request.contextPath}/img/user_my_pin.png',
            imageSize   = new kakao.maps.Size(50, 50),
            imageOption = { offset: new kakao.maps.Point(25, 50) },
            markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption),
            markerPosition = new kakao.maps.LatLng(latitude, longitude);

    let marker = new kakao.maps.Marker({
      position: markerPosition,
      image: markerImage
    });
    marker.setMap(map);
  }

  // 브라우저에서 위치를 가져오는 Promise 래퍼
  function getCurrentLocation() {
    return new Promise((resolve, reject) => {
      if (!navigator.geolocation) {
        return reject(new Error('Geolocation 미지원'));
      }
      navigator.geolocation.getCurrentPosition(
              pos => resolve(pos.coords),
              err => reject(err),
              { enableHighAccuracy: true, //GPS 우선 사용
                timeout: 5000
              }
      );
    });
  }

  // 카카오 맵 초기화
  function initMap(latitude, longitude) {
    const mapWrapper = document.querySelector('.mapWrapper');
    const center = new kakao.maps.LatLng(latitude, longitude);
    map = new kakao.maps.Map(mapWrapper, {
      center: center,
      level: 3
    });

    // map이 준비된 다음에, 클러스터러도 한 번만 생성하도록 한다.
    clusterer = new kakao.maps.MarkerClusterer({
      map: map,
      averageCenter: true,
      minLevel: 5, //일단 5로 잡아둔다.
      disableClickZoom: true // 클러스터 마커를 클릭했을 때 지도가 확대되지 않도록 설정
    });

    // 클러스터 클릭 이벤트를 등록한다.
    kakao.maps.event.addListener(clusterer, 'clusterclick', function(cluster) {
      // 현 지도 레벨보다 1단계 확대한 레벨
      const level = map.getLevel() - 1;
      // 클러스터 중심을 앵커로 삼아 레벨을 조정
      map.setLevel(level, { anchor: cluster.getCenter() });
    });

    init = true;
  }

  //[main] filterBtn에 따라 필터링 적용, ajax 적용
  $(function() {
    /* 검색 버튼 클릭 */
    $('.searchBtn').on('click', function () {
      const keyword = $('.searchInput').val().trim();
      const prev = filterParams.search || '';
      if (keyword === prev) return;
      if (keyword) filterParams.search = keyword;
      else delete filterParams.search;
      sendFilterRequest();
    });

    /* 엔터 키로 검색 */
    $('.searchInput').on('keydown', function(e) {
      if (e.key === 'Enter' || e.keyCode === 13) {
        e.preventDefault();
        $('.searchBtn').click();
      }
    });

    /* 카테고리 토글 */
    $('.dropdownModal .item').on('click', function() {
      const selected = $(this).text().trim(),
              mapKey = { '빵 & 디저트':'category_bakery', '샐러드':'category_salad', '과일':'category_fruit', '그 외':'category_etc' }[selected];

      if (filterParams[mapKey] === 'Y') {
        delete filterParams[mapKey];
        $('#btnText').text('음식 종류');
        $('.dropdownModal .item, .categoryFilterBtn').removeClass('active');
        $('.dropdownToggle').attr('src', `${pageContext.request.contextPath}/img/user_arrow_down_icon.png`);
      } else {
        Object.keys(filterParams).forEach(k => k.startsWith('category_') && delete filterParams[k]);
        filterParams[mapKey] = 'Y';
        $('#btnText').text(selected);
      }
      sendFilterRequest();
    });

    /* 예약 가능 / 오늘‧내일 픽업 필터 */
    $('.filterBtn').on('click', function () {
      const $this = $(this), txt = $this.text().trim();
      if (txt === '예약 가능만') {
        const key = 'store_status', val = 'Y';
        filterParams[key] === val ? (delete filterParams[key], $this.removeClass('active'))
                : (filterParams[key] = val, $this.addClass('active'));
      } else if (txt === '오늘 픽업' || txt === '내일 픽업') {
        const key = 'pickup_start', d = new Date();
        if (txt === '내일 픽업') d.setDate(d.getDate() + 1);
        const dateStr = d.toISOString().slice(0, 10);
        if (filterParams[key] === dateStr) {
          delete filterParams[key];
          $this.removeClass('active');
        } else {
          filterParams[key] = dateStr;
          $('.filterBtn.pickup').removeClass('active');
          $this.addClass('active');
        }
      }
      sendFilterRequest();
    });
  });

  // AJAX 요청 (fragment 방식)
  function sendFilterRequest() {
    $.ajax({
      url: '${pageContext.request.contextPath}/user/filter/store',
      type: 'POST',
      contentType: 'application/json',
      data: JSON.stringify(filterParams),
      success: function(html) {
        $('.productWrapper').html(html);

        //기존 마커 지우기
        clearStoreMarkers();
        //새 마커 추가
        drawStoreMarkers();
        //뱃지 상태 변경
        applyBadgeStyles();
        //카드 클릭 이벤트
        productCardClickEvent();
      },
      error: function(xhr, status, err) {
        console.error("AJAX 오류", status, err);
      }
    });
  }

  // 페이지 로드 시, 가장 먼저 위치 권한 요청 → fragment 교체
  $(document).ready(async function () {
    const $tabBtn         = $(".tabBtn");
    const $productWrapper = $(".productWrapper");
    const $mapWrapper     = $(".mapWrapper");

    //위치 정보 허용에 따른 위도 경도값 지정
    try {
      coords = await getCurrentLocation();   // 위치 허용 다이얼로그 뜸
      myLatitude = coords.latitude;
      myLongitude = coords.longitude;

      console.log("현재 내 위도 경도 위치 : ", coords.latitude + ", " + coords.longitude);
      console.log("offset 적용한 현재 내 위도 경도 위치 : ", myLatitude + ", " + myLongitude);
    } catch (e) {
      console.warn('위치 정보 로드 실패:', e.message);
      myLatitude  = staticLatitude;
      myLongitude = staticLongitude;

      console.log("[위치 정보 받기 실패!] 현재 내 위도 경도 위치 : ", myLatitude + ", " + myLongitude);
    }
    // 위치정보 세팅 후 최초 fragment 로드
    filterParams.latitude  = myLatitude;
    filterParams.longitude = myLongitude;

    sendFilterRequest();

    // 탭 전환 시
    $tabBtn.each(function () {
      $(this).on("click", function () {
        $tabBtn.removeClass("active");
        $(this).addClass("active");

        if ($(this).text() === "리스트") {
          $productWrapper.show();
          $mapWrapper.hide();
        } else {
          $productWrapper.hide();
          $mapWrapper.show();
        }

        // 맵은 최초 한 번만 초기화
        if (!init) {
          initMap(myLatitude, myLongitude);
          init = true;
          makeMyLocationMarker(myLatitude, myLongitude); //내 위치 마커

          //기존 마커 지우기
          clearStoreMarkers();
          //새 마커 추가
          drawStoreMarkers();
        } else {
          // 이후에는 레이아웃만 다시 그리기(relayout)
          map.relayout();
          map.setCenter(map.getCenter());
        }
      });
    });
  });
</script>
<%--[main] 픽업 상태에 따라 뱃지 색상 변경 & 카드 오퍼시티 변경 --%>
<script>
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
<%-- Product card 누르면 상세 이동 --%>
<script>
function productCardClickEvent() {
  $('.productCard').on('click', function(){
    const store_status = $(this).data('storeStatus');
    const no = $(this).data('productNo');

    if (store_status === 'N') {
      alert('아직 오픈 전입니다!');
      return;  // 클릭 처리 종료
    }

    console.log("product-no : " + no);
    const ctx = '${pageContext.request.contextPath}';
    window.location.href = ctx + '/user/productDetail?product_no=' + no;
  });
}
</script>
<%-- pin에 있는 storePinModal 누르면 상세 이동 --%>
<script>
    function storePinModalClickEvent() {
        const $mapWrapper = $('.mapWrapper');
        const $wrapper = $('.storePinModalWrapper');
        $wrapper.removeClass('hidden'); //새로운 핀 클리기 히든 해제
        const $modal = $wrapper.find('.storePinModal');

        $mapWrapper.addClass('modalOpen'); //modalOpen 후 높이 변경하는 이벤트 추가
        $modal.on('click', function(){
            const store_status = $(this).data('storeStatus');
            const no = $(this).data('productNo');

            if (store_status === 'N') {
                alert('아직 오픈 전입니다!');
                return;  // 클릭 처리 종료
            }

            console.log("product-no : " + no);
            const ctx = '${pageContext.request.contextPath}';
            window.location.href = ctx + '/user/productDetail?product_no=' + no;
        });

        //모달 내부 클릭 전파 방지
        $modal.off('click.modalInside').on('click.modalInside', function(e){
            e.stopPropagation();
        });

        // // 모달 외부 클릭시 모달 숨기기
        // $(document)
        // .off('click.modalOutside')
        // .on('click.modalOutside', function(e) {
        //     // 모달이 보이는 상태이고
        //     // 클릭한 요소가 wrapper 내부가 아니면
        //     if (
        //         $wrapper.is(':visible') &&
        //         $(e.target).closest('.storePinModalWrapper').length === 0
        //     ) {
        //         $wrapper.addClass('hidden');
        //         // 한 번 닫으면 리스너 해제
        //         $(document).off('click.modalOutside');
        //     }
        // });
    }
</script>
</body>
</html>
