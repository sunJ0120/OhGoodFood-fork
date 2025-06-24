<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- 상품 상세 전용 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/productDetail.css" />

    <title>상품 상세</title>
</head>
<body>
    <%@ include file="/WEB-INF/views/users/header.jsp" %>

    <main class="productDetail storeDetailInfo">
        <!-- 이미지 슬라이더 -->
        <div class="storeDetailImg">
            <div class="storeImgSlider">
                <div class="sliderTrack">
                    <c:forEach var="imgUrl" items="${productDetail.images}">
                        <img src="${pageContext.request.contextPath}/upload/store/${imgUrl}"
                             alt="상품 이미지" class="sliderImg" />
                    </c:forEach>
                </div>
                <div class="sliderIndicators"></div>
            </div>

            <!-- 제품명/가격/상태 -->
            <div class="storeHeader">
                <h2 class="storeName">${productDetail.store_name}</h2>
                <c:choose>
                    <c:when test="${productDetail.amount == 0}">
                        <div class="statusBadge soldout">매진</div>
                    </c:when>
                    <c:otherwise>
                        <div class="statusBadge available">판매중</div>
                    </c:otherwise>
                </c:choose>
                <div class="productPrice">
                    <span class="original">
                        <fmt:formatNumber value="${productDetail.origin_price}" type="number"/> ₩
                    </span>
                    <span class="discounted">
                        <fmt:formatNumber value="${productDetail.sale_price}" type="number"/> ₩
                    </span>
                </div>
            </div>
        </div>

        <!-- 상세 정보 & 리뷰 탭 -->
        <div class="storeDetailInfo">
            <div class="productInfo">
                <div class="tabs">
                    <button class="tab active">제품 정보</button>
                    <button class="tab">리뷰 (<c:out value='${productDetail.reviewCount}'/>)</button>
                </div>

                <!-- 제품 정보 -->
                <div class="infoContent">
                    <div class="infoRow">
                        <span class="pickup">픽업 시간</span><span>|</span>
                        <span class="pickupTime">
                            <fmt:parseDate value="${productDetail.pickup_start}" var="pickup_start" pattern="yyyy-MM-dd'T'HH:mm"/>
                            <fmt:formatDate value="${pickup_start}" pattern="HH:mm"/> ~
                            <fmt:parseDate value="${productDetail.pickup_end}" var="pickup_end" pattern="yyyy-MM-dd'T'HH:mm"/>
                            <fmt:formatDate value="${pickup_end}" pattern="HH:mm"/>
                        </span>
                        <span class="confirm">예약 마감</span><span>|</span>
                        <span class="confirmTime">
                            <fmt:parseDate value="${productDetail.reservation_end}" var="reservation_end" pattern="yyyy-MM-dd'T'HH:mm"/>
                            <fmt:formatDate value="${reservation_end}" pattern="HH:mm"/>
                        </span>
                    </div>
                    <div class="note">
                    * 픽업시간 이전/이후에 방문하는 건 사장님을 힘들게해요<br>
                    * 확정시간 전에는 가게 상황에 따라, 예약이 취소될 수 있어요.<br>
                    * 취소시, 100% 환불이 가능해요
                    </div>

                    <ul class="categorySection">
                        <li>
                            <span class="infoLabel">카테고리</span><span>|</span>
                            <span class="infoValue">
                                <c:if test="${productDetail.category_bakery=='Y'}">베이커리 </c:if>
                                <c:if test="${productDetail.category_fruit=='Y'}">과일 </c:if>
                                <c:if test="${productDetail.category_salad=='Y'}">샐러드 </c:if>
                                <c:if test="${productDetail.category_others=='Y'}">기타</c:if>
                            </span>
                        </li>
                        <li>
                            <span class="infoLabel">대표메뉴</span><span>|</span>
                            <span class="infoValue">${productDetail.store_menu}</span>
                        </li>
                        <li>
                            <span class="infoLabel">영업시간</span><span>|</span>
                            <span class="infoValue">
                                <fmt:formatDate value="${productDetail.opened_at}" pattern="HH:mm"/> ~
                                <fmt:formatDate value="${productDetail.closed_at}" pattern="HH:mm"/>
                            </span>
                        </li>
                        <li class="addRow">
                            <span class="addLabel">📍</span>
                            <span class="addValue">${productDetail.store_address}</span>
                            <span class="addLabel">📞</span>
                            <span class="addValue">${productDetail.store_telnumber}</span>
                        </li>
                            <div class="note2">
                                다음 사안 해당시 이용이 제한될 수 있어요.<br>
                                1. 확정 시간 전 취소에 대한 항의 2. 픽업 시간 외 방문 요구<br>
                            </div>
                    </ul>

                    <div id="orderArea">
                        <c:choose>
                            <c:when test="${productDetail.amount == 0}">
                                <div class="orderSoldout">마감</div>
                            </c:when>
                            <c:otherwise>
                                <form action="${pageContext.request.contextPath}/user/productdetail" method="post">
                                    <input type="hidden" name="product_no" value="${productDetail.product_no}" />
                                    <button type="submit" class="orderButton">
                                        구매하기 (${productDetail.amount}개 남음)
                                    </button>
                                </form>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- 리뷰 -->
                <div class="reviewSection" style="display:none;">
                    <c:if test="${empty productDetail.reviews}">
                        <p>등록된 리뷰가 없습니다.</p>
                    </c:if>
                    <c:forEach var="r" items="${productDetail.reviews}">
                        <div class="reviewCard">
                            <p class="review-meta">
                                <strong>${r.user_nickname}</strong>
                                <span>
                                <fmt:formatDate value="${r.writed_at}"  pattern="yyyy-MM-dd"/>
                                </span>
                            </p>
                            <p class="review-content">${r.review_content}</p>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </main>

    <%@ include file="/WEB-INF/views/users/footer.jsp" %>

    <script>
        $(function () {
            // 탭 전환
            $('.tabs .tab').click(function () {
                var idx = $(this).index();
                $('.tabs .tab').removeClass('active').eq(idx).addClass('active');
                if (idx === 0) {
                    $('.infoContent').show();
                    $('.reviewSection').hide();
                } else {
                    $('.infoContent').hide();
                    $('.reviewSection').show();
                }
            });

            // 간단 슬라이더 (버튼 없이 페이드)
            let imgs = $('.sliderImg'), idx = 0;
            imgs.hide().eq(0).show();
            setInterval(() => {
                imgs.eq(idx).fadeOut(300);
                idx = (idx + 1) % imgs.length;
                imgs.eq(idx).fadeIn(300);
            }, 3000);
        });
    </script>
</body>
</html>
