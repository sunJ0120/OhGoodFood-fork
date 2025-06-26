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
        <%@ include file="/WEB-INF/views/store/header.jsp"%>
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
                            <li class="active" data-status="reservation">미확정 주문</li>
                            <li data-status="confirmed">확정 주문</li>
                            <li data-status="cancel">취소한 주문</li>
                        </ul>
                    </div>
                </div>
                <div class="order-section-title">
                    <span class="section-title"></span>&nbsp;
                    <span class="section-desc"></span>
                </div>
                <div class="order-list-area">
                	
                </div>
            </div>
        </main>
        <%@ include file="/WEB-INF/views/store/footer.jsp"%>
    </div>
    
    <script>
    	const contextPath = "<c:out value='${pageContext.request.contextPath}'/>";
	</script>
	
    <script>
        

        // 드롭다운 메뉴
        const statusBtn = document.querySelector('.order-status-btn');
        const statusList = document.querySelector('.order-status-list');
        const statusText = document.querySelector('.section-title');
        const statusSubText = document.querySelector('.section-desc')
        let sectionTitle = document.querySelector('.section-title');
        let sectionDesc = document.querySelector('.section-desc');
        
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
                    const status = this.getAttribute('data-status'); // 추가
                    statusBtn.innerHTML = this.textContent+`<img src="${contextPath}/img/storearrow.png" class="dropdown-arrow" alt="아래화살표">`;
                    statusList.classList.remove('show');
                    loadOrders(status); // data-status 클릭시 ajax 연동
                    e.stopPropagation();
                });
            });
        }
        
        function loadOrders(status) {
            let url = contextPath + "/store/order/" + status;
            const now = new Date();
            const month = now.getMonth() + 1;
            $.post(url, function (html) {
            	//console.log(html);
                $('.order-list-area').html(html);
                $('#dynamic-css').remove();
                let cssPath = '';
                if (status === 'reservation') {
                	console.log('order.jsp 에서 reservation 들어옴');
                    cssPath = contextPath + '/css/storeunconfirmedorder2.css';
                	
                	statusText.textContent = month + "월 미확정 주문내역";
                	sectionDesc.textContent = '| 주문을 확정해 주세요';
                } else if (status === 'confirmed') {
                	console.log('order.jsp 에서 confirm 들어옴');
                    cssPath = contextPath + '/css/storeconfirmedorder.css';
                    
                    statusText.textContent = month + "월 확정 주문내역";
                	sectionDesc.textContent = '| 픽업 확정 표시를 꼭 해주세요';
                } else if (status === 'cancel') {
                	console.log('order.jsp 에서 cancel 들어옴');
                    cssPath = contextPath + '/css/storecancledorder.css';
                    
                    statusText.textContent = month + "월 취소한 주문내역";
                	sectionDesc.textContent = '| 취소한 주문기록';
                }
                if (cssPath !== '') {
                    $('head').append('<link id="dynamic-css" rel="stylesheet" type="text/css" href="' + cssPath + '">');
                }
            }).fail(function (xhr, status, error) {
                console.error("❌ AJAX 실패");
                console.error("Status:", status);
                console.error("Error:", error);
                console.error("Response Text:", xhr.responseText);
            });
        }
        $(document).ready(function () {
            loadOrders('reservation'); 
        });
    </script>
</body>

</html>