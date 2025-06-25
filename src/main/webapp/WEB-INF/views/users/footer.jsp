<!DOCTYPE html>
<html lang="ko">

<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="utf-8" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/userfooter.css" />
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<footer>
    <div class="footerContainer">
        <div class="menuContainer">
            <div class="menuItem">
                <a href="${pageContext.request.contextPath}/user/main">
                    <img src="${pageContext.request.contextPath}/img/user_home.png" data-name="home" alt="홈" class="menu-icon">
                </a>
            </div>
            <div class="menuItem">
                <a href="${pageContext.request.contextPath}/user/reviewList">
                    <img src="${pageContext.request.contextPath}/img/user_review.png" data-name="review" alt="리뷰" class="menu-icon">
                </a>
            </div>
            <div class="menuItem">
                <a href="${pageContext.request.contextPath}/user/orderList">
                    <img src="${pageContext.request.contextPath}/img/user_order.png" data-name="order" alt="주문" class="menu-icon">
                </a>
            </div>
            <div class="menuItem">
                <a href="${pageContext.request.contextPath}/user/mypage">
                    <img src="${pageContext.request.contextPath}/img/user_mypage.png" data-name="mypage" alt="마이페이지" class="menu-icon">
                </a>
            </div>
        </div>
    </div>
</footer>
<%-- [layout] bottom navigation js --%>
<script>
    // 1) 로드 시: 현재 페이지와 링크 비교해서 active 세팅
    const contextPath = '${pageContext.request.contextPath}';

    const curr = window.location.pathname.replace(contextPath, '').replace(/\/$/, '');
    $('.menuItem').each(function(){
        const $a = $(this).find('a');
        if (!$a.length) return;  // <a> 없는 아이템 패스 (링크 없으므로)
        // a 태그의 pathname 만 뽑아서 비교
        const link = this.querySelector('a').pathname
            .replace(contextPath, '').replace(/\/$/, '');
        if (link === curr) {
            $(this).addClass('active');
            const $img = $(this).find('img');
            const name = $img.data('name');
            $img.attr('src', `${contextPath}/img/${"${name}"}_active.png`);
        }
    });

    // 2) 클릭시에는 기존 로직
    $(document).ready(function () {
        $('.menuItem').on('click', function () {
            $('.menuItem').each(function () {
                $(this).removeClass('active');
                const $img = $(this).find('img');
                // 기본 이미지로 복원
                const name = $img.attr('data-name');
                $img.attr('src', `${contextPath}/img/${"${name}"}.png`);
            });
            $(this).addClass('active');
            const $img = $(this).find('img');
            // active 이미지로 변경
            const name = $img.attr('data-name');
            // log 찍어보기
            console.log("data-name:", $img.attr('data-name'));

            $img.attr('src', `${contextPath}/img/${"${name}"}_active.png`);
        });
    });

    //bottom-naviagation 현재 context-path면 클릭 방지
    $(function(){
        const currentPath = window.location.pathname.replace(/\/$/, '');  // 끝의 / 제거
        $('.menuItem a').on('click', function(e){
            const linkPath = this.pathname.replace(/\/$/, '');               // 끝의 / 제거
            console.log({ linkPath, currentPath });
            if (linkPath === currentPath) {
                e.preventDefault();
            }
        });

        //헤더에 있는 요소들 같은 경우도 현재 위치면 클릭 방지
        $('.iconContainer a').on('click', function(e){
            const linkPath = this.pathname.replace(/\/$/, '');               // 끝의 / 제거
            console.log({ linkPath, currentPath });
            if (linkPath === currentPath) {
                e.preventDefault();
            }
        });
    });
</script>