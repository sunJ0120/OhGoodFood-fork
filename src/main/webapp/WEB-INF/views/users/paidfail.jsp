<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="../../../css/reset.css">
    <link rel="stylesheet" href="../../../css/userpiadfail.css">
</head>
<body>
    <div class="wrapper">
        <div class="content">
            <img src="../../../img/user_paidFailText.png">
            <div class="failReasonDiv">
                <div class="failReasonText">
                    <p class="constText">주문 실패 사유 :&nbsp;</p>
                    <p class="realFailReason">failReason</p>
                </div>
                <div class="orderNoDiv">
                    <p class="orderNoText">
                        주문 번호 : order_no
                    </p>
                </div>
            </div>
        </div>
        <div class="footer">
            <form method="get" action="<c:url value='/user/main'/>">
                <input type="submit" class="toMainButton" value="홈으로">
            </form>
        </div>
    </div>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>

    </script>
</body>
</html>