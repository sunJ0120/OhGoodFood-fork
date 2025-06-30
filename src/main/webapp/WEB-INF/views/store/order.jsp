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
                        <span class="shop-name">${store.store_name}</span>&nbsp;&nbsp;
                    </div>
                    <div class="dropdown-wrapper">
                        <div class="custom-filter">
					        <div class="custom-dropdown year-dropdown">
					            <button class="dropdown-btn" data-type="year">
					                <span class="selected-text">2025</span>
					                <img src="${pageContext.request.contextPath}/img/storearrow.png" class="arrow-icon" />
					            </button>
					            <ul class="dropdown-list year-list"></ul>
					        </div>
					        <div class="custom-dropdown month-dropdown">
					            <button class="dropdown-btn" data-type="month">
					                <span class="selected-text">6월</span>
					                <img src="${pageContext.request.contextPath}/img/storearrow.png" class="arrow-icon" />
					            </button>
					            <ul class="dropdown-list month-list">
					                <li data-value="01">1월</li>
					                <li data-value="02">2월</li>
					                <li data-value="03">3월</li>
					                <li data-value="04">4월</li>
					                <li data-value="05">5월</li>
					                <li data-value="06">6월</li>
					                <li data-value="07">7월</li>
					                <li data-value="08">8월</li>
					                <li data-value="09">9월</li>
					                <li data-value="10">10월</li>
					                <li data-value="11">11월</li>
					                <li data-value="12">12월</li>
					            </ul>
					        </div>
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
                </div>
                <div class="order-section-title">
                    <span class="section-title"></span>&nbsp;
                    <span class="section-desc"></span>
                </div>
                <div class="order-list-area"></div>
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
        
        //const statusSubText = document.querySelector('.section-desc')
   
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
        	let year = $('.year-dropdown .dropdown-btn').attr('data-selected'); // 선택된 연도
            let month = $('.month-dropdown .dropdown-btn').attr('data-selected'); // 선택된 월
            let url = contextPath + "/store/order/" + status;

            $.post(url, {
            	year : year,
            	month : month
            },function (html) {
                $('.order-list-area').html(html);
                $('#dynamic-css').remove();
                let cssPath = '';
                month = parseInt(month, 10);
                let statusText = $('.section-title');
                let sectionDesc = $('.section-desc');
               
                if (status === 'reservation') {
                	console.log('order.jsp 에서 reservation 들어옴');
                    cssPath = contextPath + '/css/storeunconfirmedorder2.css';  	
                    statusText.text(month + "월 미확정 주문내역");
                    sectionDesc.text('| 주문을 확정해 주세요');
                } else if (status === 'confirmed') {
                	console.log('order.jsp 에서 confirm 들어옴');
                    cssPath = contextPath + '/css/storeconfirmedorder.css';
                    statusText.text(month + '월 확정 주문내역');
                    sectionDesc.text('| 픽업 확정 표시를 꼭 해주세요');
                } else if (status === 'cancel') {
                	console.log('order.jsp 에서 cancel 들어옴');
                    cssPath = contextPath + '/css/storecancledorder.css';
                    statusText.text(month + '월 취소한 주문내역');
                    sectionDesc.text('| 취소한 주문기록');
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
            const now = new Date();
            const curYear = now.getFullYear();
            const curMonth = String(now.getMonth() + 1).padStart(2, '0');
            const $yearList = $('.year-list');

            for (let y = curYear; y >= curYear - 5; y--) {
                $yearList.append('<li data-value="' + y + '">' + y + '년</li>');
            }

            $('.year-dropdown .dropdown-btn')
                .attr('data-selected', curYear)
                .find('.selected-text').text(curYear + '년');

            $('.month-dropdown .dropdown-btn')
                .attr('data-selected', curMonth)
                .find('.selected-text').text(parseInt(curMonth, 10) + '월');

            loadOrders('reservation');

            $('.dropdown-list li').on('click', function () {
                const value = $(this).data('value');
                const text = $(this).text();
                const $dropdown = $(this).closest('.custom-dropdown');
                $dropdown.find('.dropdown-btn')
                    .attr('data-selected', value)
                    .find('.selected-text').text(text);
                $('.dropdown-list').hide();

                const status = $('.order-status-list li.active').data('status');
                loadOrders(status);
            });

            $('.dropdown-btn').on('click', function (e) {
                e.stopPropagation();
                $(this).siblings('.dropdown-list').toggle();
                $('.dropdown-list').not($(this).siblings()).hide();
            });

            $(document).on('click', function () {
                $('.dropdown-list').hide();
            });
        });


    </script>
</body>

</html>