<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<c:choose>
	<c:when test="${empty order}">
		<div class="empty-order">
         <img src="${pageContext.request.contextPath}/img/storegroup33801.png" alt="empty" class="empty-img">
     </div>
	</c:when>
	<c:otherwise>
		<c:forEach var="vo" items="${order}">
			<div class="order-card"
				<c:if test="${not empty vo.order_no}"> data-order-no="${vo.order_no}"</c:if>
				<c:if test="${not empty vo.reservation_end}">
					data-res-end="<fmt:formatDate value='${vo.reservation_end}' pattern='yyyy-MM-dd\'T\'HH:mm:ss' />"
				</c:if>
				<c:if test="${not empty vo.pickup_start}">
					data-pickup-start="<fmt:formatDate value='${vo.pickup_start}' pattern='yyyy-MM-dd\'T\'HH:mm:ss' />"
				</c:if>>		
          <div class="order-card-header">
              <span class="order-card-title">오굿백 ${vo.quantity}개 예약</span>
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
                  	<fmt:formatDate value="${vo.pickup_start}" pattern="HH:mm" /> ~ 
                           	<fmt:formatDate value="${vo.pickup_end}" pattern="HH:mm" />	
                  </div>
                  <div class="order-card-info-ctime"><b>확정 시간 :</b> 
                  	<fmt:formatDate value="${vo.reservation_start}" pattern="HH:mm" /> ~ 
                           	<fmt:formatDate value="${vo.reservation_end}" pattern="HH:mm" />
                  </div>
                  <div class="order-card-btns" >
                      <button class="order-btn confirm">확정</button>
                      <button class="order-btn cancel">취소</button>
                  </div>
              </div>
          </div>
      </div>
	</c:forEach>
 </c:otherwise>
</c:choose>

<script>
	/* 
	픽업시간이 오늘인 경우 : pickup_start = 2025.06.27 17:00:00 , pickup_end = 2025.06.27 19:00:00, 
	reservation_end = pickup_start - 1 hour = 2025.06.27 16:00:00
	-확정 클릭 가능시간 : 2025.06.27 14:59~16:01
	-취소 클릭 가능시간 : 2025.06.27 14:59~17:01
	*/
	function buttonAbled() {
		
	    $('.order-card').each(function () {
	        const resEndStr = $(this).data('res-end'); 
			const pickupStartStr = $(this).data('pickup-start');
			if (!resEndStr || !pickupStartStr) return; // 값이 없으면 리턴

	        let resEnd = new Date(resEndStr);
	        let resEndPlusOneMinute = new Date(resEnd.getTime() + 60 * 1000); // 확정 마감시간 + 1분
	        let now = new Date(); // 지금시간
			let pickupStart = new Date(pickupStartStr); // 픽업시작시간
	        let oneHourBeforeResEnd = new Date(resEnd.getTime() - 60 * 60 * 1000); // 확정 시작시간
			let oneHourBeforeResEndMinus = oneHourBeforeResEnd.getTime() - 60 * 1000; // 확정 시작시간 -1분

			//확정 버튼 클릭 조건 : 확정시작시간 - 1분 ~ 확정마감시간 + 1분
			if(now >= oneHourBeforeResEndMinus && now <= resEndPlusOneMinute) {
				$(this).find('.order-btn.confirm').addClass('active');
			}else {
				$(this).find('.order-btn.confirm').removeClass('active');
			}

			//취소 버튼 클릭 조건 : 확정시작시간 - 1분 ~ 픽업시작시간 + 1분
			if(now >= oneHourBeforeResEndMinus && now <= pickupStart.getTime() + 60 * 1000) {
				$(this).find('.order-btn.cancel').addClass('active');
			}else {
				$(this).find('.order-btn.cancel').removeClass('active');
			}

			/*
	        if (now >= oneHourBefore && now <= resEnd) {
	            $(this).find('.order-btn.confirm').prop('disabled', false);
	            $(this).find('.order-btn.cancel').prop('disabled', false);
	            
	        } else {
	            $(this).find('.order-btn.confirm').prop('disabled', true);
	            $(this).find('.order-btn.cancel').prop('disabled', true);
	        } 이전코드 일단 남겨둠
			*/
	    });
	};
	$(function () {
	    $('.order-btn.confirm').on('click', function () {
			//확정 시간이 아닐때 alert창 띄우기 위해
			const $card = $(this).closest('.order-card');
			const resEndStr = $card.data('res-end');
			if (!resEndStr) return;
			const now = new Date();
			const resEnd = new Date(resEndStr);
			const confirmStart = new Date(resEnd.getTime() - 61 * 60 * 1000); // 확정마감시간 -1시간 -1분
			const confirmEnd = new Date(resEnd.getTime() + 60 * 1000); // 확정마감시간 + 1분
			console.log("확정시작시간 : " + confirmStart);
			console.log("확정종료시간 : " + confirmEnd);
			if (now < confirmStart || now > confirmEnd) {
				alert('확정 버튼을 클릭할 수 있는 시간이 아닙니다');
				return;
			}     
	        const orderNo = $(this).closest('.order-card').data('order-no');
	        console.log("확정 주문번호:", orderNo);
	        console.log("contextPath :", contextPath);
	        var url = contextPath + "/store/reservation/" + orderNo + "/confirm";
	        $.post(url, function (res) {
	            if (res === 'success') {
	            	alert('확정 완료');
	            	loadOrders('reservation');
	            }
	            else alert('확정 실패');
	        });
	    });
	
	    $('.order-btn.cancel').on('click', function () {
			const $card = $(this).closest('.order-card');
			const resEndStr = $card.data('res-end');
			const pickupStartStr = $card.data('pickup-start');
			if (!resEndStr || !pickupStartStr) return;
			const now = new Date();
			const resEnd = new Date(resEndStr);
			const pickupStart = new Date(pickupStartStr);
			const cancelStart = new Date(resEnd.getTime() - 61 * 60 * 1000); // 확정마감시간 -1시간 -1분
			const cancelEnd = new Date(pickupStart.getTime() + 60 * 1000);   // 픽업시작시간 + 1분
			console.log("취소시작시간 : " + cancelStart);
			console.log("취소종료시간 : " + cancelEnd);
			if (now < cancelStart || now > cancelEnd) {
				alert('취소 버튼을 클릭할 수 있는 시간이 아닙니다');
				return;
			}
	        const orderNo = $(this).closest('.order-card').data('order-no');
	        var url = contextPath + "/store/reservation/" + orderNo + "/cancel";
	        $.post(url, function (res) {
	            if (res === 'success'){
	            	alert('취소 완료');
	            	loadOrders('reservation');
	            }
	            else alert('취소 실패');
	        });
	    });
	});
	
	$(document).ready(function() {
		buttonAbled();
	});
</script>