<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=440, initial-scale=1.0">
    <title>확정 주문내역</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/storeconfirmedorder.css">
</head>

<body>
    <div id="wrapper">
        <header>
            <div class="header-container">
                <img src="${pageContext.request.contextPath}/img/storeohgoodfood_logo.png" alt="Logo Image">
                <div class="icon-container">
                    <img src="${pageContext.request.contextPath}/img/storealarm_active.png" alt="알람" class="icon">
                    <img src="${pageContext.request.contextPath}/img/storelogout.png" alt="로그아웃" class="icon">
                </div>
            </div>
        </header>
        <main>
            <div class="order-page-container">
                <div class="order-header">
                    <div class="order-title">
                        <span class="shop-name">러프도우</span>&nbsp;&nbsp;
                        <span class="order-desc">| 주문내역을 확인하세요</span>
                    </div>
                    <div class="order-status-dropdown">
                        <button class="order-status-btn">확정 주문 <img src="${pageContext.request.contextPath}/img/storearrow.png"
                                class="dropdown-arrow"></button>
                        <ul class="order-status-list">
                            <li><a href="${pageContext.request.contextPath}/store/reservation">미확정 주문</a></li>
                            <li class="active"><a href="${pageContext.request.contextPath}/store/confirmed">확정 주문</a></li>
                            <li><a href="${pageContext.request.contextPath}/store/cancled">취소한 주문</a></li>
                        </ul>
                    </div>
                </div>
                <div class="order-section-title">
                    <span class="section-title">확정 주문내역</span>&nbsp;
                    <span class="section-desc">| 픽업 확정 표시를 꼭 해주세요</span>
                </div>
                <div class="order-list-area">
                	<c:forEach var="vo" items="${order}">
                		<div class="order-card">
	                        <div class="order-card-header">
	                            <span class="order-card-title">오굿백 ${vo.quantity}개 예약</span>
	                            <div class="order-card-button">
	                            	<c:set var="btnStatus" value="${vo.order_status eq 'pickup' ? 'complete' : 'today'}" />
	                                <button class="order-card-btn" data-status="${btnStatus}">
		                                <c:choose>
		                                	<c:when test="${vo.order_status eq 'pickup' }">픽업완료</c:when>
		                                	<c:otherwise>오늘픽업</c:otherwise>
		                                </c:choose>
	                               </button>
	                                
	                            </div>
	                            <div class="order-group">
	                                <label>
	                                    <input type="checkbox" class="order-checkbox" data-order-no="${vo.order_no}" data-pickup-end="${vo.pickup_end}" <c:if test="${vo.order_status eq 'pickup'}">checked</c:if> style="display:none;">
	                                    <img class="checkbox-img" 
     										 src="${pageContext.request.contextPath}/img/${vo.order_status eq 'pickup' ? 'storerealnoncheck' : 'storenoncheck'}.png" />

	                                </label>
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
	                                <div class="order-card-btns">
	                                    <button class="order-btn-pickup">픽업코드 : ${vo.order_code}</button>
	                                    
	                                </div>
	                            </div>
	                        </div>
	                    </div>
                	</c:forEach>
        
                </div>
            </div>
        </main>
        <footer>
            <div class="footer-container">
                <div class="menu-container">
                    <div class="menu-item">
                        <img src="${pageContext.request.contextPath}/img/storehome.png" data-name="home" alt="홈" class="menu-icon">
                    </div>
                    <div class="menu-item">
                        <img src="${pageContext.request.contextPath}/img/storereview.png" data-name="review" alt="리뷰" class="menu-icon">
                    </div>
                    <div class="menu-item">
                        <img src="${pageContext.request.contextPath}/img/storeorder.png" data-name="order" alt="주문" class="menu-icon">
                    </div>
                    <div class="menu-item">
                        <img src="${pageContext.request.contextPath}/img/storemypage.png" data-name="mypage" alt="마이페이지" class="menu-icon">
                    </div>
                </div>
            </div>
        </footer>
    </div>
    <script>
    	const contextPath = "<c:out value='${pageContext.request.contextPath}'/>";
	</script>
    <script>
        // 하단 메뉴 active 처리
        const menuItems = document.querySelectorAll('.menu-item');
        menuItems.forEach(item => {
            item.addEventListener('click', function () {
                menuItems.forEach(i => {
                    i.classList.remove('active');
                    const img = i.querySelector('img');
                    img.src = `${contextPath}/img/${img.dataset.name}.png`;
                });
                this.classList.add('active');
                const img = this.querySelector('img');
                img.src = `${contextPath}/img/${img.dataset.name}_active.png`;
            });
        });

        // 드롭다운 메뉴
        const statusBtn = document.querySelector('.order-status-btn');
        const statusList = document.querySelector('.order-status-list');
        const statusText = document.querySelector('.section-title');
        const statusSubText = document.querySelector('.section-desc')
        if (statusBtn) {
            statusBtn.addEventListener('click', function (e) {
                e.stopPropagation();
                statusList.classList.toggle('show');
            });
            document.body.addEventListener('click', function () {
                statusList.classList.remove('show');
            });
            statusList.querySelectorAll('li').forEach(li => {
                li.addEventListener('click', function (e) {
                    statusList.querySelectorAll('li').forEach(i => i.classList.remove('active'));
                    this.classList.add('active');
                    if (this.textContent === '미확정 주문') {
                        statusText.textContent = '미확정 주문내역';
                        statusSubText.textContent = '| 주문을 확정해 주세요';
                    } else if (this.textContent === '확정 주문') {
                        statusText.textContent = '확정 주문내역';
                        statusSubText.textContent = '| 픽업 확정 표시를 꼭 해주세요';
                    } else if (this.textContent === '취소한 주문') {
                        statusText.textContent = '취소한 주문내역';
                        statusSubText.textContent = '| 취소한 주문기록';
                    }
                    statusBtn.innerHTML = this.textContent+`<img src="${contextPath}/img/storearrow.png" class="dropdown-arrow" alt="아래화살표">`;                    statusList.classList.remove('show');
                    e.stopPropagation();
                });
            });
        }
        document.querySelectorAll('.order-checkbox').forEach(function (checkbox) {
	         checkbox.addEventListener('change', function () {
	            const img = this.nextElementSibling;
	            const label = this.parentElement;
	            if (this.checked) {
	                img.src = '${contextPath}/img/storerealnoncheck.png';    
	                label.style.fontWeight = "normal";   
	            } else {
	                img.src = '${contextPath}/img/storenoncheck.png';
	                label.style.fontWeight = "normal"; 
	            }
	          });
        });
        $(document).ready(function () {
            $('.order-card').each(function () {
                const $orderBtn =$(this).find('.order-card-btn');
                const status = $orderBtn.data('status');
                const $pickupBtn = $(this).find('.order-btn-pickup');

                if (status === 'complete') {
                    
                    $pickupBtn.css({
                        'text-decoration': 'line-through',
                        'color': '#8B6D5C'
                    });
                    $orderBtn.css({
                        'background-color': '#8B6D5C',
                        'color': '#FFFFFF',
                        'border': '1px solid #8B6D5C'
                    });
                } else if (status === 'today') {
                    
                    $orderBtn.css({
                        'background-color': '#D8A8AB',
                        'color': '#FFFFFF',
                        'border': '1px solid #D8A8AB'
                    });
                }
            });
        });
		/*
        $(document).ready(function () {
            $('.order-card').each(function () {
                const status = $(this).find('.order-card-btn').data('status');
                const $pickupBtn = $(this).find('.order-btn-pickup');

                if (status === 'complete') {
                    $pickupBtn.css({
                        'text-decoration': 'line-through',
                        'color': '#8B6D5C' 
                    });
                }
            });
        });*/
        
        //db 연계시 '픽업완료' 상태이면 데이터를 불러올때 체크박스가 되어있어야 함 
        //그렇지 않으면 '오늘픽업' 이면 체크박스에 체크가 안되어 있는데 
        // '픽업완료' 상태일때 기본적으로 체크박스에 체크가 안되어 있는것과 로직이 꼬임

        $(document).ready(function() {
		    $('.order-checkbox').click(function() {
		        const orderNo = $(this).data('order-no');
		        const isChecked = $(this).is(':checked');
		        const pickupEnd = $(this).data('pickup-end'); 
		        const now = new Date();
		        const nowMinutes = now.getHours() * 60 + now.getMinutes();
		        const [hour, min] = pickupEnd.split(':').map(Number);
		        const pickupEndMinutes = hour * 60 + min;
		
		        const $parentCard = $(this).closest('.order-card');
		        const $btn = $parentCard.find('.order-card-btn');
		
		        if (isChecked) {
		            if (confirm('픽업 완료로 바꾸시겠습니까?')) {
		                const url = contextPath + "/store/confirmed/" + orderNo + "/pickup";
		                $.post(url, function (res) {
		                    if (res === 'success') {
		                        $btn.text('픽업 완료')
		                            .css({ 'background-color': '#8B6D5C', 'color': '#fff', 'border': '1px solid #8B6D5C' })
		                            .attr('data-status', 'complete');
		                        $parentCard.find('.order-btn-pickup').css({
		                            'text-decoration': 'line-through',
		                            'color': '#8B6D5C'
		                        });
		                    } else {
		                        alert('픽업 완료 처리 실패');
		                        $(this).prop('checked', false);
		                    }
		                }).fail(() => {
		                    alert('ajax 실패');
		                    $(this).prop('checked', false);
		                });
		            } else {
		                $(this).prop('checked', false);
		            }
		        } else {
		            
		            if (nowMinutes < pickupEndMinutes) {
		                if (confirm('오늘 픽업으로 바꾸시겠습니까?')) {
		                    const url = contextPath + "/store/confirmed/" + orderNo + "/confirmed";
		                    $.post(url, function (res) {
		                        if (res === 'success') {
		                            $btn.text('오늘 픽업')
		                                .css({ 'background-color': '#D8A8AB', 'color': '#fff', 'border': '1px solid #D8A8AB' })
		                                .attr('data-status', 'today');
		                            $parentCard.find('.order-btn-pickup').css({
		                                'text-decoration': 'none',
		                                'color': 'inherit'
		                            });
		                        } else {
		                            alert('오늘픽업으로 복귀 실패');
		                            $(this).prop('checked', true);
		                        }
		                    }).fail(() => {
		                        alert("ajax 실패");
		                        $(this).prop('checked', true);
		                    });
		                } else {
		                    $(this).prop('checked', true);
		                }
		            } else {
		                alert("픽업 마감 시간이 지나서 되돌릴 수 없습니다.");
		                $(this).prop('checked', true);
		            }
		        }
		    });
		});
        
        
        /*
        let $parentCard = '';
        $(document).ready(function() {
          $('.order-checkbox').click(function() {
            if($(this).is(':checked')) {
                if(confirm('픽업 완료로 바꾸시겠습니까?')) {
                    $parentCard = $(this).parents('.order-card');
                    $parentCard.find('.order-btn-pickup').css({
                    'text-decoration': 'line-through',
                    'color': '#8B6D5C'
                });
                    $parentCard.find('.order-card-btn[data-status="today"]').text('픽업 완료');
                    
                    $parentCard.find('.order-card-btn[data-status="today"]').css({
                        'background-color' : '#8B6D5C'
                    })
                    $parentCard.find('.order-card-btn[data-status="today"]').attr('data-status', 'complete');
                }
                
            }
            if($(this).is(':not(:checked)')) {
                if($(this).parents('.order-card').find('.order-card-btn[data-status="complete"]')) {
                    if(confirm('오늘 픽업으로 바꾸시겠습니까?')) {
                    $parentCard = $(this).parents('.order-card');
                    $parentCard.find('.order-btn-pickup').css({
                        'text-decoration': 'none'
                    })
                    $parentCard.find('.order-card-btn[data-status="complete"]').text('오늘 픽업');
                    
                    $parentCard.find('.order-card-btn[data-status="complete"]').css({
                        'background-color' : '#D8A8AB'
                    })
                    $parentCard.find('.order-card-btn[data-status="complete"]').attr('data-status', 'today');
                }
                
                }
                
                
            }
          })
        })
        */
        /*
        $(document).ready(function() {
            $('.order-checkbox').click(function() {
                const $parentCard = $(this).closest('.order-card');
                const $btn = $parentCard.find('.order-card-btn');
                const currentStatus = $btn.attr('data-status');

                if ($(this).is(':checked')) {
                // 체크 시: today → complete 로 바꿈
                if (currentStatus === 'today') {
                    if (confirm('픽업 완료로 바꾸시겠습니까?')) {
                    $parentCard.find('.order-btn-pickup').css({
                        'text-decoration': 'line-through',
                        'color': '#8B6D5C'
                    });
                    $btn.text('픽업 완료')
                        .css('background-color', '#8B6D5C')
                        .attr('data-status', 'complete');
                    } else {
                    $(this).prop('checked', false); // 사용자가 취소하면 체크 해제
                    }
                } else {
                    $(this).prop('checked', false); // complete 상태일 때 실수로 클릭하면 체크 되지 않게
                }
                } else {
                // 체크 해제 시: complete → today 로 바꿈
                if (currentStatus === 'complete') {
                    if (confirm('오늘 픽업으로 바꾸시겠습니까?')) {
                    $parentCard.find('.order-btn-pickup').css({
                        'text-decoration': 'none',
                        'color': 'inherit'
                    });
                    $btn.text('오늘 픽업')
                        .css('background-color', '#D8A8AB')
                        .attr('data-status', 'today');
                    } else {
                    $(this).prop('checked', true); // 사용자가 취소하면 다시 체크함
                    }
                }
                }
            });
            });*/
        /*
        const $specificPickUp = '';
        const $specificCheckBox = '';
        $(document).ready(function() {
            $('.order-checkbox').click(function() {
                if($(this).is(':checked')) {
                    $specificCheckBox = $(this);
                    $('.order-card-info').each(function() {
                        $($specificCheckBox).find('.order-btn-pickup').css({
                            'text-decoration': 'line-through',
                            'color': '#8B6D5C'
                        });
                    })
                    
                }
                if($(this).is(':not(:checked)')) {
                    const $checkBtn = $(this)

                    $('.order-card-info').each(function() {
                        $(this).find('.order-btn-pickup').css({
                            'text-decoration': 'none'
                            
                        });
                    })
                }
            })
        })*/
    </script>
</body>

</html>