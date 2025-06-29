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
		
			<div class="order-card" <c:if test="${not empty vo.order_no}">data-order-no="${vo.order_no}"</c:if> 
									<c:if test="${not empty vo.reservation_end}">
  										data-res-end="<fmt:formatDate value='${vo.reservation_end}' pattern='yyyy-MM-dd\'T\'HH:mm:ss' />"
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
                  	<fmt:formatDate value="${vo.reservation_end}" pattern="HH:mm" /> ~ 
                           	<fmt:formatDate value="${vo.pickup_start}" pattern="HH:mm" />
                  </div>
                  <div class="order-card-btns" >
                      <button class="order-btn confirm" disabled>확정</button>
                      <button class="order-btn cancel" disabled>취소</button>
                  </div>
              </div>
          </div>
      </div>
	</c:forEach>
 </c:otherwise>
</c:choose>

<script>

	function buttonAbled() {
		// 확정시간 시작 1시간전 ~ 학정시간 시작 까지만 활성화
	    $('.order-card').each(function () {
	        const resEndStr = $(this).data('res-end'); 
	        console.log("resEndStr" + resEndStr);
	        let resEnd = new Date(resEndStr);
	        resEnd = new Date(resEnd.getTime()- 60 * 1000);
	        console.log("resEnd : " + resEnd);
	        const now = new Date();
	        console.log("now : " + now);
	        const oneHourBefore = new Date(resEnd.getTime() - 60 * 60 * 1000);
	        console.log("oneHourBefore : " + oneHourBefore);
	        if (now >= oneHourBefore && now <= resEnd) {
	            $(this).find('.order-btn.confirm').prop('disabled', false);
	            $(this).find('.order-btn.cancel').prop('disabled', false);
	            
	        } else {
	            $(this).find('.order-btn.confirm').prop('disabled', true);
	            $(this).find('.order-btn.cancel').prop('disabled', true);
	        }
	    });
	};
	$(function () {
	    $('.order-btn.confirm').on('click', function () {
	        const orderNo = $(this).closest('.order-card').data('order-no');
	        console.log("확정 주문번호:", orderNo);
	        console.log("contextPath :", contextPath);
	        var url = contextPath + "/store/reservation/" + orderNo + "/confirm";
	        console.log("최종 요청 url:", url);
	        
	        $.post(url, function (res) {
	            if (res === 'success') {
	            	alert('확정 완료');
	            	loadOrders('reservation');
	            }
	            else alert('확정 실패');
	        });
	    });
	
	    $('.order-btn.cancel').on('click', function () {
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
	})
</script>