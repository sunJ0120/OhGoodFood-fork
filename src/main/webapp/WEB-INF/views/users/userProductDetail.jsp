<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="ko">

            <head>
                <meta charset="utf-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1" />

                <!-- jQuery CDN -->
                <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/userProductDetail.css" />

                <title>productDetail</title>
            </head>

            <body>
                <!-- 레이아웃 템플릿-->
                <div id="wrapper">
                    <%@ include file="/WEB-INF/views/users/header.jsp" %>
                        <main>
                            <!-- 이미지 영역 -->
                            <div class="storeDetailImg">
                                <div class="storeImgSlider">
                                    <div class="sliderTrack">
                                        <c:forEach var="imgUrl" items="${productDetail.images}">
                                            <img src="https://ohgoodfood.s3.ap-northeast-2.amazonaws.com/${productDetail.store_img}"
                                                alt="상품 이미지" class="sliderImg" />
                                        </c:forEach>
                                    </div>
                                    <div class="sliderIndicators"></div>
                                </div>

                                <!-- 제품명/가격 헤더 -->
                                <div class="storeHeader">
                                    <div class="storeName">${productDetail.store_name}</div>
                                    <div class="statusBadge" data-status="soldout">매진(17:30)</div> <!--상태 업데이트-->
                                    <div class="productPrice">
                                        <span class="original">${productDetail.origin_price} ₩</span>
                                        <span class="discounted">${productDetail.sale_price} ₩</span>
                                    </div>
                                </div>
                            </div>

                            <!-- 상세 정보 영역 -->
                            <div class="storeDetailInfo">
                                <div class="productInfo">

                                    <!-- 탭 메뉴 -->
                                    <div class="tabs">
                                        <button class="tab active">오굿백 정보</button>
                                        <button class="tab">리뷰 (
                                            <c:out value='${productDetail.reviewCount}'/>)
                                        </button>
                                    </div>

                                    <div class="infoContent">
                                        <!-- 매장 정보 -->
                                        <div class="storeInfo">
                                            <div class="infoRow">
                                                <span class="pickup">픽업 시간</span>
                                                <span class="pickupdiv">|</span>
                                                <span class="pickupTime">
                                                    <fmt:formatDate value="${productDetail.pickup_start}"
                                                        pattern="HH:mm" /> ~
                                                    <fmt:formatDate value="${productDetail.pickup_end}"
                                                        pattern="HH:mm" />
                                                </span>
                                                <span class="confirm">확정 시간</span>
                                                <span class="confirmdiv">|</span>
                                                <span class="confirmTime">
                                                    <fmt:formatDate value="${productDetail.reservation_end}"
                                                        pattern="HH:mm" />
                                                </span>
                                            </div>
                                            <div class="note">
                                                <span>${productDetail.product_explain}</span>
                                            </div>
                                        </div>

                                        <!-- 카테고리 정보 -->
                                        <div class="categorySection">
                                            <li class="infoRow">
                                                <span class="infoLabel">카테고리</span>
                                                <span class="pickupdiv">|</span>
                                                <span class="infoValue">
                                                    <c:if test="${productDetail.category_bakery=='Y'}">베이커리 </c:if>
                                                    <c:if test="${productDetail.category_fruit=='Y'}">과일 </c:if>
                                                    <c:if test="${productDetail.category_salad=='Y'}">샐러드 </c:if>
                                                    <c:if test="${productDetail.category_others=='Y'}">기타</c:if>
                                                </span>
                                            </li>
                                            <li class="infoRow">
                                                <span class="infoLabel">대표메뉴</span>
                                                <span class="pickupdiv">|</span>
                                                <span class="infoValue">${productDetail.store_menu}</span>
                                            </li>
                                            <li class="infoRow">
                                                <span class="infoLabel">영업시간</span>
                                                <span class="pickupdiv">|</span>
                                                <span class="infoValue">
                                                    <fmt:formatDate value="${productDetail.opened_at}"   pattern="HH:mm" /> ~
                                                    <fmt:formatDate value="${productDetail.closed_at}"   pattern="HH:mm" />
                                                </span>
                                            </li>
                                            <div class="addRow">
                                                <span class="addLabel">📍</span>
                                                <span class="addValue">${productDetail.store_address}</span>
                                                <span class="addLabel">📞</span>
                                                <span class="addValue">${productDetail.store_telnumber}</span>
                                            </div>
                                            <div >
                                                  <span class="note2">${productDetail.store_explain}</span>
                                            </div>
                                        </div>

                                        <!-- 주문 버튼 -->
                                        <div id="orderArea">

                                            <div class="orderSoldout">마감</div>
                                        </div>

                                    </div>
                                    <!-- /infoContent 끝 -->

                                    <!--  리뷰 리스트 (기본 숨김) -->
                                    <div class="reviewSection">
                                        <c:choose>
                                            <c:when test="${empty reviews}">
                                                <p style="text-align:center; padding:20px;">등록된 리뷰가 없습니다.</p>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="r" items="${reviews}">
                                                    <div class="overlap">
                                                        <img class="reviewImage"
                                                            src="https://ohgoodfood.s3.ap-northeast-2.amazonaws.com/${r.review_img}"
                                                            alt="리뷰 이미지" />
                                                        <div class="reviewerName">${r.user_nickname}</div>
                                                        <div class="reviewedDate">
                                                            <fmt:formatDate value="${r.writed_at}"  pattern="yyyy.MM.dd" />
                                                        </div>
                                                        <hr class="line" />
                                                        <p class="reviewContent">${r.review_content}</p>
                                                    </div>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                </div>
                            </div>

                        </main>
                        <%@ include file="/WEB-INF/views/users/footer.jsp" %>
                </div>


                <script>
                    $(function () {
                        // 1) 상태 배지 셋업
                        var $badge = $(".statusBadge");
                        var status = $badge.data("status"); // "soldout" or "available"
                        var $orderArea = $("#orderArea");

                        if (status === "soldout") {
                            $badge.removeClass("available").addClass("soldout")
                                .text("매진(" + $badge.text().match(/\d{2}:\d{2}/)[0] + ")");
                            $orderArea.html('<div class="orderSoldout">마감</div>');
                        } else {
                            $badge.removeClass("soldout").addClass("available").text("판매중");
                            $orderArea.html('<button class="orderButton">구매하기(' +
                                $(".statusBadge").data("remaining") + '개 남음)</button>');
                        }

                        // 초기 상태
                        $('.infoContent').removeClass('hidden');
                        $('.reviewSection').addClass('hidden');

                        // 탭 클릭 토글
                        $('.tabs .tab').on('click', function () {
                            var idx = $(this).index();
                            $('.tabs .tab').removeClass('active').eq(idx).addClass('active');
                            if (idx === 0) {
                                $('.infoContent').removeClass('hidden');
                                $('.reviewSection').addClass('hidden');
                            } else {
                                $('.infoContent').addClass('hidden');
                                $('.reviewSection').removeClass('hidden');
                            }
                        });

                        // 슬라이더 초기화
                        initSlider();

                        // --- 슬라이더 함수들 ---
                        var track, images, indicators, currentIndex = 0;
                        function initSlider() {
                            track = document.querySelector('.sliderTrack');
                            images = document.querySelectorAll('.sliderTrack .sliderImg');
                            indicators = document.querySelector('.sliderIndicators');
                            createIndicators();
                            showSlide(0);
                        }

                        function createIndicators() {
                            indicators.innerHTML = '';
                            images.forEach((_, i) => {
                                var $dot = $('<div class="sliderIndicator"></div>')
                                    .on('click', function () { showSlide(i); });
                                $(indicators).append($dot);
                            });
                        }

                        function showSlide(idx) {
                            currentIndex = (idx + images.length) % images.length;
                            track.style.transition = 'transform 0.3s ease';
                            track.style.transform = 'translateX(-' + (currentIndex * 100) + '%)';
                            $(indicators).children().removeClass('active')
                                .eq(currentIndex).addClass('active');
                        }

                        // 4) 리뷰 무한 스크롤 함수
                        function setupReviewInfiniteScroll() {
                            var reviewPage = 1, reviewLoading = false, reviewEnd = false;
                            var $sec = $(".reviewSection"), $list = $sec.find(".reviewList");
                            var $loader = $('<div id="reviewLoader" style="text-align:center;padding:12px;">로딩 중…</div>')
                                .appendTo($sec).hide();

                            $sec.on('scroll', function () {
                                if (reviewLoading || reviewEnd) return;
                                if ($sec.scrollTop() + $sec.innerHeight() >= $sec[0].scrollHeight - 50) {
                                    loadReviews();
                                }
                            });
                        }
                    });
                </script>
            </body>

            </html>