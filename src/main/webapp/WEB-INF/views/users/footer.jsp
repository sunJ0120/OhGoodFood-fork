<!DOCTYPE html>
<html lang="ko">

<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="utf-8" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/userfooter.css" />
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<footer>
    <div class="footer-container">
        <div class="menu-container">
            <div class="menu-item active">
                <img src="${pageContext.request.contextPath}/img/user_home_active.png" data-name="home" alt="홈" class="menu-icon">
            </div>
            <div class="menu-item">
                <img src="${pageContext.request.contextPath}/img/user_review.png" data-name="review" alt="리뷰" class="menu-icon">
            </div>
            <div class="menu-item">
                <img src="${pageContext.request.contextPath}/img/user_order.png" data-name="order" alt="주문" class="menu-icon">
            </div>
            <div class="menu-item">
                <img src="${pageContext.request.contextPath}/img/user_mypage.png" data-name="mypage" alt="마이페이지" class="menu-icon">
            </div>
        </div>
    </div>
</footer>

<script>
    $(function () {
        $('.menu-item').click(function () {
            $('.menu-item').removeClass('active').each(function () {
                const img = $(this).find('img');
                img.attr('src', "${pageContext.request.contextPath}/img/user_"+img.data('name')+".png");
            });
            $(this).addClass('active');
            const img = $(this).find('img');
            img.attr('src', "${pageContext.request.contextPath}/img/user_"+img.data('name')+"_active.png");
        });
    });
</script>