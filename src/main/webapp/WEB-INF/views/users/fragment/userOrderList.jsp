<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:choose>
    <c:when test="${empty userOrderList}">
        <div class="modalWrapper">
            <img src="${pageContext.request.contextPath}/img/user_emptyOrderListCatModal.png" alt="고양이" class="catModal"/>
        </div>
    </c:when>
    <c:otherwise>
        <section class="productList">
            <c:forEach var="userOrder" items = "${userOrderList}" >
                <article class="productCard"
                         data-order-no="${userOrder.order_no}"
                         data-order-status="${userOrder.order_status}"
                         data-canceld-from="${userOrder.canceld_from}"
                         data-block-cancel="${userOrder.block_cancel}"
                         data-has-review="${userOrder.has_review}">
                    <div class="orderTop">
                        <div class="storeName">
                            <strong>${userOrder.store_name}</strong>
                        </div>
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
                        <div class="imgWrapper">
                            <img src="https://ohgoodfood.s3.ap-northeast-2.amazonaws.com/${userOrder.store_img}" alt="상품 이미지" class="productImg" />
                        </div>
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
                                <div class="orderInfoSub"><div class="orderPaidPoint">사용 포인트 : </div>
                                    <span class="orderPaidPointValue">
                                      <fmt:formatNumber value="${userOrder.paid_point}" pattern="#,###" />P
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
                            리뷰 쓰기 (${userOrder.point}P)
                        </button>

                        <div class="orderBrown hidden orderReviewDone">
                            이미 리뷰를 작성했습니다.
                        </div>

                        <div class="orderWhite hidden orderPickupCode">
                            픽업 코드 : ${userOrder.order_code}
                        </div>

                        <form action="/user/order/cancel" method="post" class="postStyle hidden" onsubmit="return confirm('정말 주문을 취소하시겠습니까?');">
                            <input type="hidden" name="order_no" value="${userOrder.order_no}" />
                            <input type="hidden" name="quantity"   value="${userOrder.quantity}" />
                            <input type="hidden" name="product_no"   value="${userOrder.product_no}" />
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

