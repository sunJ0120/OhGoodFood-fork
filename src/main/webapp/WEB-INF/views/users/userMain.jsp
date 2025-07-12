<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>OhGoodFood</title>
  <link rel="icon" type="image/jpeg" href="https://ohgoodfood.s3.ap-northeast-2.amazonaws.com/shinhanmoilicon32x32.jpg">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/usermain.css">
</head>
<body>
  <div id="wrapper">
    <%-- header include --%>
    <%@ include file="/WEB-INF/views/users/header.jsp" %>

    <%-- 내 위치 말풍선 윈도우 --%>
    <template class="myLocationTemplate">
      <div class="myLocationTemplateWindow">
        <strong>📌내 위치</strong>
      </div>
    </template>

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
        <button class="filterBtn reservationPossible">예약 가능만</button>
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
              <div class="modalWrapper">
                  <img src="${pageContext.request.contextPath}/img/user_locationCatModal.png" alt="고양이" class="catModal"/>
              </div>
          </div>
          <%-- 지도 api 영역 --%>
          <div class="mapWrapper" style="display: none;">
            <%-- 지도 안에 있는 modal --%>
            <div class="storePinModalWrapper"></div>
            <%-- 이 위치에서 검색 버튼 --%>
              <button class="btnSetCenter">
                <span class="btnText">이 위치에서 검색</span>
                <span class="btnIcon">
                  <img src="${pageContext.request.contextPath}/img/user_location_icon.png" alt="내 위치 아이콘">
                </span>
              </button>
          </div>
        </div>
      </div>
    </main>
    <%-- footer include --%>
    <%@ include file="/WEB-INF/views/users/footer.jsp" %>
  </div>
  <%-- JQuery CDN --%>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoMapAppKey}&libraries=clusterer"></script>
  <%-- filter 이벤트 --%>
  <script>
    let $dropdownModal = $("#dropdownModal");
    let isVisible = $dropdownModal.css("display") === "block";
    let $dropdownToggle = $(".dropdownToggle");

    // toggle로 모달 열기
    function openDropdown() {
      $dropdownModal.css("display", "block");
    }
    // toggle로 모달 닫기
    function closeDropdown() {
      $dropdownModal.css("display", "none");
    }

    // toggle open 상태에 따라 화살표 변경하기
    function toggleDropDownArrow($categoryFilterBtn){
      let iconPath;

      // 아이콘 결정, 현재 modal이 보이는 상태일 경우 up으로
      if (isVisible) {
        iconPath = $categoryFilterBtn.hasClass("active")
                ? "/img/user_arrow_up_icon_active.png"
                : "/img/user_arrow_up_icon.png";
      } else {
        // 현재 modal이 보이지 않는 상태일 경우 down
        iconPath = $categoryFilterBtn.hasClass("active")
                ? "/img/user_arrow_down_icon_active.png"
                : "/img/user_arrow_down_icon.png";
      }

      $dropdownToggle.attr("src", '${pageContext.request.contextPath}' + iconPath);
    }

    $(document).ready(function () {
      const $btnText = $("#btnText");
      const $categoryFilterBtn = $(".categoryFilterBtn");
      const $filterButtons = $(".filterBtn");

      $categoryFilterBtn.on("click", function (e) {
        e.stopPropagation(); // 부모 클릭 방지
        if(!isVisible){
          openDropdown();
        }else{ //열려있음
          closeDropdown();
        }
        isVisible = !isVisible; //반대로 바꾸기
        toggleDropDownArrow($categoryFilterBtn); //모달 상태에 따라 토글 이미지 변경
      });

      // 필터링 항목 클릭 시, 버튼 텍스트 및 컬러 상태 바꾸기
      $dropdownModal.find('.item').each(function () {
        $(this).on("click", function () {
          $dropdownModal.find('.item').removeClass("active");
          $(this).addClass("active");

          $categoryFilterBtn.addClass("active");
          $btnText.text($(this).text());

          toggleDropDownArrow($categoryFilterBtn);  //모달 상태에 따라 토글 이미지 변경
        });
      });

      $filterButtons.each(function () {
        $(this).on("click", function () {
          //현재 클릭된 버튼 active 추가, toggle 방식으로 두번 누르면 active 없게끔 한다.
          $(this).toggleClass("active");
        });
      });
    });

    // 모달 내부 클릭 시 전파 차단
    $dropdownModal.on("click", function(e){
      e.stopPropagation();
    });

    // 문서 어디든 클릭했을 때
    $(document).on("click", function () {
      if (isVisible) {
        closeDropdown();
        isVisible = false;
        toggleDropDownArrow($categoryFilterBtn);
      }
    });
  </script>
  <%-- kakao 지도 호출 --%>
  <%-- [main] main map 화면 전환 js --%>
  <script>
    //지도가 처음 뜬건지 확인하기 위한 init 변수
    let isInit = false;
    //지도
    let map;
    //카카오 지도에서 받아온 위도, 경도 담긴 변수
    let coords;
    //위치 정보 허용 안할 경우, 우리 사업장 위치로 지정되도록 변수 지정 (ANT 빌딩)
    let staticLatitude  = 37.5593799298988;
    let staticLongitude = 126.922667641634;

    //내 현재 위치 (위도, 경도)
    let myLatitude;
    let myLongitude;

    //현재 띄워진 마커를 담는 전역 리스트
    let storeMarkers = [];
    // 필터링 적용시 최종적으로 전송할 JSON 객체
    let filterParams = {};

    // 이전에 클릭된 마커 참조
    let selectedMarker = null;
    // 이전에 클릭된 마커의 pos 정보
    let selectedMarkerPos = null;

    // 매진, 마감 가게 핀 (갈색)
    let closePin = "${pageContext.request.contextPath}/img/user_close_pin.png";
    // 오늘픽업, 내일픽업 핀 (핑크색)
    let openPin  = "${pageContext.request.contextPath}/img/user_open_pin.png";
    // cluster 처리를 위한 전역변수, 전역으로 선언만 해둔다.
    let clusterer = null;
    let $categoryFilterBtn = $(".categoryFilterBtn");

    //center 위치 변경 되었을때 사용할 마커 초기화 함수
    function clearStoreMarkers() {
      if (clusterer) {
        clusterer.clear();    // 클러스터안의 모든 마커를 비워야 한다.
      }
      storeMarkers.forEach(m => m.setMap(null));  // 지도에서 제거
      storeMarkers = []; // 마커 초기화
    }

    //1km반경 가게 위도, 경도 정보를 이용해서 마커 그리는 함수
    function drawStoreMarkers() {
      const positions = getProductListLatLong(); //위도 경도, storeId, storeStatus, amount 정보가 담김
      positions.forEach(pos => {
        const imageSize  = new kakao.maps.Size(30, 30); //기본 pin 크기는 30 * 30
        const imgSrc     = (pos.store_status === 'Y' && pos.amount > 0) ? openPin : closePin;
        const markerImg  = new kakao.maps.MarkerImage(imgSrc, imageSize);
        const marker     = new kakao.maps.Marker({ //marker 생성을 위해서는, map 정보와 latlng객체와 마커 이미지가 필요하다.
          map:      map,
          position: pos.latlng,
          image:    markerImg
        });
        storeMarkers.push(marker); //marker를 전역으로 저장해두는 storeMarkers에 만들어진 marker 객체들 전부 담는다.
        markerClickEventSetter(marker,pos); //marker를 그린 다음에 마커에 이벤트를 setting 하기 위함이다.
      });
      // 마커 생성이 끝난 뒤에 한 번 호출해서 클러스터에 담기 위함이다.
      // clusterer 가 준비된 경우에만 실행하도록 한다.
      if (clusterer) {
        clusterer.addMarkers(storeMarkers); //cluster 객체에 담아뒀던 marker 모음을 넣어서 클러스터 생성
      }
    }

    //마커 크기 원래대로 reset 하는 함수, 다른 marker를 눌러서 reset해야 할 경우 동작
    function resetSelectedMarker(){
      // 현재 클릭된 마커 크기를 원래대로 되돌린다.
      const imgSrc = (selectedMarkerPos.store_status === 'Y' && selectedMarkerPos.amount > 0) ? openPin : closePin;
      selectedMarker.setImage(new kakao.maps.MarkerImage(imgSrc, new kakao.maps.Size(30, 30)));

      // 기존에 선택된 마커들 없애기, 이제 선택됐던 마커가 없어야 하므로 초기화한다.
      selectedMarker = null;
      selectedMarkerPos = null;
    }

    //마커에 클릭 이벤트 주입, 리스트 요소를 주입
    function markerClickEventSetter(marker,pos){
      // 클릭 이벤트 등록
      kakao.maps.event.addListener(marker, 'click', function() {

        //기존에 클릭한 마커가 있을 경우, 상태 reset
        if (selectedMarker) {
          resetSelectedMarker();
        }

        //현재 클릭된 마커 크기를 키운다. 큰 마커는 40 * 40
        const newSrc = (pos.store_status === 'Y' && pos.amount > 0) ? openPin : closePin;
        marker.setImage(new kakao.maps.MarkerImage(newSrc, new kakao.maps.Size(40, 40)));

        //현재 선택된 마커로 선택 마커를 업데이트 한다.
        selectedMarker = marker;
        selectedMarkerPos = pos;

        //pin을 클릭했을때 가게 정보카드에 들어갈 정보를 가져오기 위한 ajax
        $.ajax({
          url: '${pageContext.request.contextPath}/user/map/pin',
          type: 'GET',
          data: { store_id : pos.store_id },
          success: function(html) {
            $('.storePinModalWrapper').html(html);
            //ajax로 fragment 변경할 경우, 기존에 사용하던 이벤트들을 한 번 더 불러와야 한다.
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

    // 현재 1km 방면의 전체 가게 리스트의 위도 경도, storeId, storeStatus, amount를 담아서 positions객체를 생성하기 위한 함수
    function getProductListLatLong(){
      let positions = [];

      $('.productWrapper .productCard').each(function() {
        let $productCard = $(this);

        let latitude = parseFloat($productCard.data('latitude'));
        let longitude = parseFloat($productCard.data('longitude'));

        let storeId = $productCard.data('storeId');
        let storeStatus = $productCard.data('storeStatus'); //JQuery는 camelCase로 매핑한다.
        let amount = $productCard.data('amount');

        //위도, 경도가 있을 경우 진행한다.
        if (!isNaN(latitude) && !isNaN(longitude)){
          positions.push({
            store_id : storeId,
            store_status : storeStatus,
            amount : amount,
            latlng: new kakao.maps.LatLng(latitude, longitude) //카카오 맵을 사용하기 위해서는 latlng 객체로 위도 경도를 감싸야 한다.
          });
        }
      });
      return positions;
    }
    // 내 위치 마커를 표시하기 위한 함수
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
      marker.setMap(map); //내 위치 마커를 map에 setting

      //내 위치 마커에 마우스 호버 이벤트 (추가기능)
      let myLocationTemplate = document.querySelector('.myLocationTemplate');
      let iwContent = myLocationTemplate.innerHTML;

      //인포 윈도우를 생성한다.
      let infowindow = new kakao.maps.InfoWindow({
        content : iwContent
      });

      // 마커에 마우스오버 이벤트를 등록
      kakao.maps.event.addListener(marker, 'mouseover', function() {
        infowindow.open(map, marker);
      });

      // 마커에 마우스아웃 이벤트를 등록
      kakao.maps.event.addListener(marker, 'mouseout', function() {
        // 마우스 아웃시 인포 윈도우를 제거
        infowindow.close();
      });
    }

    // 브라우저에서 위치를 가져오는 Promise 래퍼
    // navigator.geolocation를 이용해서 내 WIFI 정보로 내위치를 가져온다.
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

    // 카카오 맵 초기에 한 번 그리기 위함이다.
    function initDrawMap(latitude, longitude) {
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
        minLevel: 5, //클러스터 생성 기준 레벨은 5
        disableClickZoom: true // 클러스터 마커를 클릭했을 때 지도가 확대되지 않도록 설정 (1레벨씩 확대하는 기능을 클릭 이벤트로 등록하기 위함이다.)
      });

      // 클러스터 클릭 이벤트를 등록한다.
      kakao.maps.event.addListener(clusterer, 'clusterclick', function(cluster) {
        // 현 지도 레벨보다 1단계 확대한 레벨
        const level = map.getLevel() - 1;
        // 클러스터 중심을 앵커로 삼아 레벨을 조정
        map.setLevel(level, { anchor: cluster.getCenter() });
      });

      // 초기화 완료이므로, 초기화 판별 여부 변수를 true로 지정
      isInit = true;
    }

    // filterBtn에 따라 필터링 적용, ajax 적용
    $(function() {
      // 검색 버튼을 클릭할시, 검색어를 filterParams에 추가
      $('.searchBtn').on('click', function () {
        const keyword = $('.searchInput').val().trim();
        const prev = filterParams.search || '';
        if (keyword === prev) { //이전에 검색했던 키워드이거나, 빈칸일 경우 초기화
          return;
        }

        if (keyword) {
          filterParams.search = keyword;
        } else {
          delete filterParams.search;
        }

        sendFilterRequest();
      });

      // 엔터 키로 검색이 가능하도록 설정
      $('.searchInput').on('keydown', function(e) {
        if (e.key === 'Enter' || e.keyCode === 13) {
          e.preventDefault();
          $('.searchBtn').click();
        }
      });

      // 토글 필터링 공용 함수, filterParams에 담는 기능과 두 번 클릭시 filter에서 remove 하는 기능을 담고 있다.
      // groupToggle의 경우, 오늘 픽업과 내일 픽업은 같은 그룹이라 동시 선택을 하지 못하도록 + category는 하나만 선택할 수 있도록 하기 위함이다.
      function toggleCommonFilter(key, val, $btn, groupToggle = null){

        // 단일 케이스와 복수 케이스를 통일된 배열로 변환한다.
        const keys = Array.isArray(key) ? key : [key];
        const vals = Array.isArray(val) ? val : [val];

        // 현재 filterParams 에 해당 키 & 값이 모두 적용돼 있는지 체크한다.
        const allOn = keys.every((k, i) => filterParams[k] === vals[i]);

        if (allOn) {
          // 모두 적용중 일경우 한꺼번에 해제한다.
          keys.forEach(k => delete filterParams[k]);
          $btn.removeClass('active');
        }else {
          // 동시 선택을 막아야 하는 경우, 그룹의 active를 지운다.
          if (groupToggle) {
            // 그룹에 해당하는 버튼들의 .active 전부 해제
            $(groupToggle).removeClass('active');
            // filterParams 중 같은 key 그룹(접두사)인 항목들을 삭제해서 동시 선택 방지, 배열값을 처리하도록 구성한다.
            const prefix = keys[0].split('_')[0];
            Object.keys(filterParams)
                    .filter(k => k.split('_')[0] === prefix)
                    .forEach(k => delete filterParams[k]);
          }
          //선택된 filterParams에 key + val들을 추가한다.
          keys.forEach((k, i) => { filterParams[k] = vals[i]; });
          //선택된 $btn에 active 추가
          $btn.addClass('active');
        }
      }

      // 카테고리 토글 검색
      $('.dropdownModal .item').on('click', function() {
        const $this    = $(this);
        const selected = $this.text().trim();
        const mapKey   = {
          '빵 & 디저트':'category_bakery',
          '샐러드':'category_salad',
          '과일':'category_fruit',
          '그 외':'category_etc'
        }[selected];

        //카테고리의 경우, 하나만 선택하도록 구성
        toggleCommonFilter(mapKey, 'Y', $this, '.dropdownModal .item');

        const isActive = !!filterParams[mapKey];
        $('#btnText').text(isActive ? selected : '음식 종류'); //active 아니면 음식 종류로 변경

        //active 상태에 따라 .active class 해제
        if (isActive) {
          $('.categoryFilterBtn').addClass('active');
        } else {
          $('.categoryFilterBtn').removeClass('active');
        }

        toggleDropDownArrow($categoryFilterBtn);
        sendFilterRequest(); //검색 AJAX로 연결
      });

      // 예약 가능, 오늘 & 내일 픽업 필터 클릭
      $('.filterBtn').on('click', function () {
        const $this = $(this);
        const txt = $this.text().trim();
        if (txt === '예약 가능만') {
          //예약 가능만의 경우는 두 가지 조건이 다 들어갸아 하므로 배열로 정의한다.
          const keys = ['store_status', 'amount'];
          const vals = ['Y', 1];

          toggleCommonFilter(keys, vals, $this,'.filterBtn.reservationPossible');

        } else if (txt === '오늘 픽업' || txt === '내일 픽업') {
          const key = 'pickup_start';
          const d = new Date();
          if (txt === '내일 픽업') {
            d.setDate(d.getDate() + 1);
          }
          const val = d.toISOString().slice(0, 10); //내일 픽업 값을 먼저 조정한 다음에 slice

          toggleCommonFilter(key, val, $this,'.filterBtn.pickup');
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
      const $storePinModalWrapper = $('.storePinModalWrapper'); // center 변경 버튼 눌렀을때 modal 닫기 위함이다.

      //위치 정보 허용에 따른 위도 경도값 지정
      try {
        coords = await getCurrentLocation();   // 위치 허용 다이얼로그 뜸
        myLatitude = coords.latitude;
        myLongitude = coords.longitude;
      } catch (e) {
        console.warn('위치 정보 로드 실패:', e.message);
        myLatitude  = staticLatitude;
        myLongitude = staticLongitude;
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
          if (!isInit) {
            initDrawMap(myLatitude, myLongitude);
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

          //이 위치에서 검색 버튼 클릭 했을때, center를 변경하기 위함이다.
          $('.btnSetCenter').on('click', function(){
            //현재 지도의 바뀐 중심 좌표 가져오기
            const center = map.getCenter();

            const changeLatitude = center.getLat();
            const changeLongitude = center.getLng();

            // 현재 filterParams에 들어가는 latitude 덮어쓰기.
            filterParams.latitude  = changeLatitude;
            filterParams.longitude = changeLongitude;

            $storePinModalWrapper.addClass('hidden'); // center 바뀌면, 열려있던 modal을 닫는다.
            $mapWrapper.removeClass('modalOpen'); // 버튼 다시 아래로 내리기
            sendFilterRequest();
          });
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
        const ctx = '${pageContext.request.contextPath}';
        window.location.href = ctx + '/user/productDetail?product_no=' + no;
      });

      //모달 내부 클릭 전파 방지
      $modal.off('click.modalInside').on('click.modalInside', function(e){
        e.stopPropagation();
      });
    }
  </script>
</body>
</html>
