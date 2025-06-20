<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/users/layout.html" %>

<main class="mypage">
  <!-- 1. 내 정보 -->
  <section class="infoSection">
    <h2 class="sectionTitle">
      <img src="<c:url value='/img/user.png'/>" class="infoIcon" alt="내 정보"/>
      내 정보
    </h2>
    <div class="infoForm">
      <div><span>${mypage.user_id}</span></div>
      <div><span>${mypage.user_nickname}</span></div>
    </div>
  </section>
  <hr class="infoLine"/>

  <!-- 2. 내가 쓴 리뷰 모음 -->
  <section class="reviewSection">
    <h2 class="sectionTitle">
      <img src="<c:url value='/img/vector.png'/>" class="infoIcon" alt="내 리뷰"/>
      내 리뷰 모음
    </h2>

    <c:if test="${empty mypage.reviews}">
      <p class="no-data">작성한 리뷰가 없습니다.</p>
    </c:if>

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
  </section>
</main>

<script>
  $(function () {
    // 메뉴바 활성화
    document.querySelectorAll('.menu-item').forEach(function(item) {
      item.addEventListener('click', function() {
        document.querySelectorAll('.menu-item').forEach(function(i) {
          i.classList.remove('active');
          var img = i.querySelector('img');
          var name = img.dataset.name;
          img.src = '/img/' + name + '.png';
        });
        this.classList.add('active');
        var img = this.querySelector('img');
        var name = img.dataset.name;
        img.src = '/img/' + name + '_active.png';
      });
    });

    // 사용자 정보 로드
    $.get('/api/user', function(user) {
      $('.infoForm span').eq(0).text(user.id);
      $('.infoForm span').eq(1).text(user.nickname);
    }).fail(function() {
      console.error('유저 정보 로드 실패');
    });

    // 무한 스크롤 초기화
    setupReviewInfiniteScroll();
  });

  function setupReviewInfiniteScroll() {
    var page = 1, loading = false, end = false;
    var $list = $('.reviewList'), $loader = $('#reviewLoader');

    loadReviews();
    $list.on('scroll', function() {
      if (!loading && !end &&
          this.scrollTop + this.clientHeight >= this.scrollHeight - 50) {
        loadReviews();
      }
    });

    function loadReviews() {
      loading = true; $loader.show();
      $.get('/api/reviews', { page: page }, function(res) {
        if (res.reviews && res.reviews.length) {
          res.reviews.forEach(function(r) {
            // 실제 리뷰 카드 마크업으로 교체하세요
            var card = ''
              + '<div class="reviewCard">'
              + '  <div class="reviewImageArea">'
              + '    <img class="reviewImage" src="' + r.image + '" alt="리뷰 이미지"/>'
              + '  </div>'
              + '  <div class="reviewHeader">'
              + '    <span class="reviewerName">' + r.author + '</span>'
              + '    <time class="reviewDate">' + r.date + '</time>'
              + '  </div>'
              + '  <hr class="line"/>'
              + '  <p class="reviewContent">' + r.text + '</p>'
              + '  <div class="storeInfo">'
              + '    <img class="storeImage" src="' + r.storeImage + '" alt="매장 이미지"/>'
              + '    <div class="storeDetail">'
              + '      <span class="storeName">' + r.storeName + '</span>'
              + '      <span class="storeMenu">' + r.menu + '</span>'
              + '    </div>'
              + '    <div class="priceArea">'
              + '      <span class="originPrice">' + r.originalPrice + '원</span>'
              + '      <span class="salePrice">' + r.salePrice + '원</span>'
              + '    </div>'
              + '  </div>'
              + '</div>';
            $list.append(card);
          });
          page++;
        } else {
          end = true; $loader.text('더 이상 리뷰가 없습니다');
        }
      }).fail(function() {
        $loader.text('리뷰 로드 실패');
      }).always(function() {
        loading = false;
        if (!end) $loader.hide();
      });
    }
  }
</script>
