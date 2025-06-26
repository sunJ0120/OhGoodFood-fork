<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<!DOCTYPE html>
<html lang="ko">

<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="utf-8" />
    <title>Ohgoodfood</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/storeviewsales.css" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/litepicker/dist/litepicker.css"/>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/litepicker/dist/litepicker.js"></script>
    <style>
	  :root {
	    --litepicker-day-width: 53px !important;
	  }
	</style>
</head>
<body>
    <div id="wrapper">
        <%@ include file="/WEB-INF/views/store/header.jsp" %>
        <main>
            <div class="storeInfoHeader">
                <div class="storeInfoGroup">
                    <img src="${pageContext.request.contextPath}/img/store_mystore.png" alt="마이페이지" class="myStoreIcon">
                    <div class="storeInfo">매출 확인</div>
                </div>
                <div class="storeName">러프도우</div>
                <div class="storeInfoContent">
                    <div class="monthlySales">
                        <p>${month}월 오굿백 매출</p>
                    </div>
                    <div class="contentGroup">
                        <img src="${pageContext.request.contextPath}/img/store_bag_white.png" alt="오굿백" class="whiteBagIcon">
                        <div class="monthlySalesCount">
                            <p>${vo.count}개</p>
                        </div>
                        <div class="monthlySalesAccount">
                            <p>${vo.sales }원</p>
                        </div>
                    </div>
                </div>
                <div class="calendarContainer">
                	<div id="datepicker"></div>
                </div>
                <div class="salesContainer" id="dailySales">
                
                </div>
            </div>
        </main>
        <%@ include file="/WEB-INF/views/store/footer.jsp" %>
    </div>
    <script>
    
    const contextPath = '${pageContext.request.contextPath}';
    const picker = new Litepicker({
        element: document.getElementById('datepicker'),
        inlineMode: true,
        format: 'YYYY-MM-DD',
        lang: 'ko-KR',
        singleMode: true,
        parentEl: '#datepicker',
        setup: (picker) => {
        	 picker.on('render', () => {
             	setTimeout(() => {
             	    const monthElem = document.querySelector('.month-item-name');
                     const yearElem = document.querySelector('.month-item-year');
                     if (!monthElem || !yearElem) {
                         console.warn("달력 요소를 찾지 못했습니다.");
                         return;
                     }

                     let month = monthElem.textContent || '';
                     let year = yearElem.textContent || '';

                     month = month.replace(/[^\d]/g, '');
                     //year = year + '.';

                     monthElem.textContent = '';
                     yearElem.textContent = year + '.' + month;
 					
                     forceChangeWeekdays(); // ✅ 요일도 강제 덮어쓰기
                 }, 1);
             });

            picker.on('selected', (date) => {
                const selectedDate = date.format('YYYY-MM-DD');
                $.ajax({
                    url: contextPath + '/store/viewsales/' + selectedDate,
                    method: 'POST',
                    success: function(data) {
                    	console.log(data);
                        const $box = $('<div>').addClass('dailyBox');
                        $box.append($('<h4>').text(data.start_date));
                        $box.append($('<p>').text('오굿백 판매 개수 : ' + data.count + '개'));
                        $box.append($('<p>').text('오굿백 판매 매출 : ' + Number(data.sales).toLocaleString() + '원'));
                        $('#dailySales').empty().append($box);
                    },
                    error: function() {
                        $('#dailySales').html('<p> 오류 </p>');
                    }
                });
            });
        }
    });
    </script>
</body>

</html>