<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:forEach var="vo" items="${order}">
	<div class="order-card" data-order-no="${vo.order_no}">
        <div class="order-card-header">
            <span class="order-card-title">오굿백 ${vo.quantity}개 예약</span>
            <div class="order-card-button">
            	<c:set var="btnStatus" value="${vo.canceld_from eq 'user' ? 'user' : 'store'}" />
                <button class="order-card-btn" data-status="${btnStatus}">
                 <c:choose>
                 	<c:when test="${vo.canceld_from eq 'user' }">구매자 취소</c:when>
                 	<c:otherwise>가게 취소</c:otherwise>
                 </c:choose>
               </button>
                
            </div>
            <span class="order-card-date">
            	<fmt:formatDate value="${vo.ordered_at}" pattern="yyyy.MM.dd"/>
            </span>
        </div>
        <hr class="order-card-divider">
        <div class="order-card-body">
            <img src="${pageContext.request.contextPath}/img/${vo.store_img}" alt="오굿백" class="order-card-img">
            <div class="order-card-info">
                <div class="order-card-info-person"><b>예약자 :</b> ${vo.user_id}</div>
                <div class="order-card-info-time"><b>픽업 시간 :</b>
                	<fmt:formatDate value="${vo.pickup_start}" pattern="HH:mm" />
						~
					<fmt:formatDate value="${vo.pickup_end}" pattern="HH:mm" />
                </div>
                <div class="order-card-info-ctime"><b>결제 금액 :</b> ${vo.quantity * vo.sale_price}₩</div>
                
            </div>
        </div>
    </div>
</c:forEach>

    
    
