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
    <link rel="icon" type="image/jpeg" href="https://ohgoodfood.s3.ap-northeast-2.amazonaws.com/shinhanmoilicon32x32.jpg">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/litepicker/dist/litepicker.js"></script>
    <style>
     /* litepicker의 라이브러리 안에 속성 변경*/
	  :root {
	    --litepicker-day-width: 53px !important;
	    --litepicker-is-end-color-bg: #99A99B;
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
                <div class="storeName">${store.store_name }</div>
                <div class="headerBox">
	                <div class="storeInfoContent">
	                    <div class="monthlySales"></div>
	                    <div class="contentGroup">
	                        <img src="${pageContext.request.contextPath}/img/store_bag_white.png" alt="오굿백" class="whiteBagIcon">
	                        <div class="monthlySalesCount"></div>
	                        <div class="monthlySalesAccount"></div>
	                    </div>
	                </div>
	            </div>
                <div class="calendarContainer">
                	<div id="datepicker"></div>
                </div>
                <div class="salesBox">
                	<div class="salesContainer" id="dailySales"></div>
               	</div>
            </div>
        </main>
        <%@ include file="/WEB-INF/views/store/footer.jsp" %>
    </div>
    <script>
    	const contextPath = '${pageContext.request.contextPath}';
    </script>
    
    <script>
    // 동적으로 달력 생성하는 로직
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
       		        if (!monthElem || !yearElem) return;
       		       
       		        if (yearElem.textContent.includes('.')) { // 날짜 클릭때마다 중복으로 00 붙는거 방지. 즉, 1번만 포맷변경
       		            return; 
       		        }
       		        let year = yearElem.textContent || '';
       		        let month = monthElem.textContent || '';
       		        month = month.replace(/[^\d]/g, '');
       		        let url = contextPath + "/store" +"/monthsales";
                    // 컨트롤러에 년, 월 보내고 매출, 판매갯수, 월 받아옴
       		        $.post(url, {
       		        	year : year,
       		        	month : month
       		        }, function(response) {
       		        	const sale2 = response.sales;
       		        	const count2 = response.count;
       		        	const month2 = response.start_date.substring(5,7);
       		        	
       		        	let monthlysales = document.querySelector('.monthlySales');
       		        	let monthlysalescount = document.querySelector('.monthlySalesCount');
       		        	let monthlysalesaccount = document.querySelector('.monthlySalesAccount');
       		        	
       		        	monthlysales.textContent = month2 + '월 오굿백 매출';
       		        	monthlysalescount.textContent = count2 + '개';
       		        	monthlysalesaccount.textContent = sale2 + '원';
       		        })
       		        monthElem.textContent = '';
       		        yearElem.textContent = '';
       		        yearElem.textContent = year + '.' + month.padStart(2, '0');
       		    }, 10);
             });

        	 //날짜 선택시
            picker.on('selected', (date) => {
                const selectedDate = date.format('YYYY-MM-DD');
                $.ajax({
                    url: contextPath + '/store/viewsales/' + selectedDate,
                    method: 'POST',
                    success: function(data) {
                    	const formatData =  data.start_date.replace(/-/g, '.'); // -를 . 으로 교체 (날짜)
                    	const $box = $('<div>').addClass('dailyBox');
                        const $date = $('<h4>').text(formatData).css({
                        	'font-size': '18px',
                            'font-weight': 'bold',
                            'color' : '#4E4E4E',
                            'font-family' : 'nanumesquareneo_b',
                            'margin-left': '25px',
                        })
                        $box.append($date); // 여기까지 날짜
                        const formatCount = '오굿백 판매 개수 : ' + data.count + '개';
                        const $countContainer = $('<div>').css({ // 이미지는 자식태그 못가져서 감싸는 태그 필요
                            'display': 'flex',
                            'align-items': 'center',
                            'margin-left': '25px',
                            'margin-top' : '-20px',
                        });
                        //이미지 붙이기
                        const $countImg = $('<img>').attr('src', contextPath + '/img/storemypagecount.png').css({
						    'width': '18px',
						    'height': '18px',
						    'margin-right': '10px',
						});
                        
                        //판매 갯수
                        const $countText = $('<h4>').text(formatCount).css({
                            'font-size': '18px',
                            'color': '#000000',
                            'font-family': 'nanumesquareneo'
                        });
                        $countContainer.append($countImg, $countText);
                        $box.append($countContainer);
                        
                        // 판매 매출 div 구조
                        const formatSales = '오굿백 판매 매출 : ' + Number(data.sales).toLocaleString() + '₩';
                       	const $salesContainer = $('<div>').css({
                       		'display': 'flex',
                            'align-items': 'center',
                            'margin-left': '25px',
                            'margin-top' : '-20px',
                       	});
                       	
                       	// 판매 매출 옆 이미지
                       	const $salesImg = $('<img>').attr('src', contextPath + '/img/storecoinhand.png').css({
						    'width': '18px',
						    'height': '18px',
						    'margin-right': '10px',
						});
                       	
                       	// 판매 매출 css 및 붙이기 
                       	const $salesText = $('<h4>').text(formatSales).css({
                            'font-size': '18px',
                            'color': '#000000',
                            'font-family': 'nanumesquareneo'
                        });
                       	$salesContainer.append($salesImg, $salesText);
                       	$box.append($salesContainer);
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