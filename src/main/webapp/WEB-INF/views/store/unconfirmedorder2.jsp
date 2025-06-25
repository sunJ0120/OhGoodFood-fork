<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=440, initial-scale=1.0">
    <title>미확정 주문내역</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/storeunconfirmedorder2.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
                        <button class="order-status-btn">미확정 주문 <img src="${pageContext.request.contextPath}/img/storearrow.png"
                                class="dropdown-arrow"></button>
                        <ul class="order-status-list">
                            <li class="active">미확정 주문</li>
                            <li><a href="${pageContext.request.contextPath}/store/confirmed">확정 주문</a></li>
                            <li><a href="${pageContext.request.contextPath}/store/cancled">취소한 주문</a></li>
                        </ul>
                    </div>
                </div>
                <div class="order-section-title">
                    <span class="section-title">미확정 주문내역</span>&nbsp;
                    <span class="section-desc">| 주문을 확정해 주세요</span>
                </div>
                <div class="order-list-area">
                	
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
        
        const menuItems = document.querySelectorAll('.menu-item');
        menuItems.forEach(item => {
            item.addEventListener('click', function () {
                menuItems.forEach(i => {
                    i.classList.remove('active');
                    const img = i.querySelector('img');
                    img.src = `${contextPath}/img/store${img.dataset.name}.png`;
                });
                this.classList.add('active');
                const img = this.querySelector('img');
                img.src = `${contextPath}/img/store${img.dataset.name}_active.png`;
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
                    statusBtn.innerHTML = this.textContent+`<img src="${contextPath}/img/storearrow.png" class="dropdown-arrow" alt="아래화살표">`;
                    statusList.classList.remove('show');
                    e.stopPropagation();
                });
            });
        }
        
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
                    	location.reload();
                    }
                    else alert('확정 실패');
                });
            });

            $('.order-btn.cancel').on('click', function () {
                const orderNo = $(this).closest('.order-card').data('order-no');
                var url = contextPath + "/store/reservation/" + orderNo + "/cancle";
                $.post(url, function (res) {
                    if (res === 'success'){
                    	alert('취소 완료');
                    	location.reload();
                    }
                    else alert('취소 실패');
                });
            });
        });
    </script>
</body>

</html>