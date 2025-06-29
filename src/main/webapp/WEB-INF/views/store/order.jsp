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
                        <!--  년, 월 선택 필터  / 년도는 동적 생성-->
                        <div class="orderFilter">
						  <select id="yearSelect"></select>
						  <select id="monthSelect">
						    <option value="01">1월</option>
						    <option value="02">2월</option>
						    <option value="03">3월</option>
						    <option value="04">4월</option>
						    <option value="05">5월</option>
						    <option value="06">6월</option>
						    <option value="07">7월</option>
						    <option value="08">8월</option>
						    <option value="09">9월</option>
						    <option value="10">10월</option>
						    <option value="11">11월</option>
						    <option value="12">12월</option>
						  </select>
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
        	const year = $('#yearSelect').val(); // select 에서 year값 가져옴
        	let month = $('#monthSelect').val(); // select 에서 month값 가져옴
            let url = contextPath + "/store/order/" + status;

            $.post(url, {
            	year : year,
            	month : month
            },function (html) {
                $('.order-list-area').html(html);
                $('#dynamic-css').remove();
                let cssPath = '';
                month = parseInt(month, 10);
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
        	// 년도 동적 생성
        	const now = new Date();
        	const curYear = now.getFullYear();
        	const curMonth = String(now.getMonth() + 1).padStart(2, '0');
        	const $yearSelect = $('#yearSelect');
        	$yearSelect.empty();
        	for (let y = curYear; y >= curYear - 5; y--) { // yearSelect의 option에 값 넣기
        		$yearSelect.append('<option value="' + y + '">' + y + '</option>');
            }
        	$yearSelect.val(curYear); // 현재 년도를 기본값
        	$('#monthSelect').val(curMonth); // 현재 월을 기본값
            loadOrders('reservation');
            $('#yearSelect, #monthSelect').on('change', function () {
                const status = $('.order-status-list li.active').data('status');
                loadOrders(status);
            });
        });
    </script>
</body>

</html>