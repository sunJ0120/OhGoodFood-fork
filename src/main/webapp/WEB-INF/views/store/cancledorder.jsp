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
    <title>취소 주문내역</title>
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
                        <button class="order-status-btn">취소한 주문 <img src="${pageContext.request.contextPath}/img/storearrow.png"
                                class="dropdown-arrow"></button>
                        <ul class="order-status-list">
                            <li><a href="${pageContext.request.contextPath}/store/reservation">미확정 주문</a></li>
                            <li><a href="${pageContext.request.contextPath}/store/confirmed">확정 주문</a></li>
                            <li class="active"><a href="${pageContext.request.contextPath}/store/cancled">취소한 주문</a></li>
                        </ul>
                    </div>
                </div>
                <div class="order-section-title">
                    <span class="section-title">취소한 주문내역</span>&nbsp;
                    <span class="section-desc">| 취소한 주문기록</span>
                </div>
                <div class="order-list-area">
                	<c:forEach var="vo" items="${order}">
                		<div class="order-card">
	                        <div class="order-card-header">
	                            <span class="order-card-title">오굿백 ${vo.quantity}개 예약</span>
	                            <div class="order-card-button">
	                            	<c:set var="btnStatus" value="${vo.cancled_from eq 'user' ? 'user' : 'store'}" />
	                                <button class="order-card-btn" data-status="${btnStatus}">
		                                <c:choose>
		                                	<c:when test="${vo.cancled_from eq 'user' }">구매자 취소</c:when>
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
    </script>
</body>
</html>