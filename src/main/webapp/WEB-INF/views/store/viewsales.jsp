<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="utf-8" />
    <title>Ohgoodfood</title>
    <link rel="stylesheet" href="../../../css/storeviewsales.css" />
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>

<body>
    <div id="wrapper">
        <%@ include file="/WEB-INF/views/store/header.jsp" %>
        <main>
            <div class="storeInfoHeader">
                <div class="storeInfoGroup">
                    <img src="../../../img/store_mystore.png" alt="마이페이지" class="myStoreIcon">
                    <div class="storeInfo">매출 확인</div>
                </div>
                <div class="storeName">러프도우</div>
                <div class="storeInfoContent">
                    <div class="monthlySales">
                        <p>6월 오굿백 매출</p>
                    </div>
                    <div class="contentGroup">
                        <img src="../../../img/store_bag_white.png" alt="오굿백" class="whiteBagIcon">
                        <div class="monthlySalesCount">
                            <p>45개</p>
                        </div>
                        <div class="monthlySalesAccount">
                            <p>310,500원</p>
                        </div>
                    </div>
                </div>
                <div class="calendarContainer"></div>
                <div class="salesContainer"></div>
            </div>
        </main>
        <%@ include file="/WEB-INF/views/store/footer.jsp" %>
    </div>
    
</body>

</html>