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
            <a href="${pageContext.request.contextPath}/user/main">
                <div class="menuItem">
                    <img src="${pageContext.request.contextPath}/img/user_home.png" data-name="user_home" alt="홈" class="menuIcon">
                </div>
            </a>
            <a href="${pageContext.request.contextPath}/user/reviewList">
                <div class="menuItem">
                    <img src="${pageContext.request.contextPath}/img/user_review.png" data-name="user_review" alt="리뷰" class="menuIcon">
                </div>
            </a>
            <a href="${pageContext.request.contextPath}/user/orderList">
                <div class="menuItem">
                    <img src="${pageContext.request.contextPath}/img/user_order.png" data-name="user_order" alt="주문" class="menuIcon">
                </div>
            </a>
            <a href="${pageContext.request.contextPath}/user/mypage">
                <div class="menuItem">
                    <img src="${pageContext.request.contextPath}/img/user_mypage.png" data-name="user_mypage" alt="마이페이지" class="menuIcon">
                </div>
            </a>
        </div>
    </div>
</footer>
<%-- [layout] bottom navigation js --%>
<script>
    const contextPath = '${pageContext.request.contextPath}';
    // 현재 페이지
    const curr = window.location.pathname.replace(contextPath, '').replace(/\/$/, '');

    // 1) 로드 시: <a> 기준으로 active 세팅
    $('.menuContainer a').each(function() {
        const linkPath = this.pathname
            .replace(contextPath, '')
            .replace(/\/$/, '');
        if (linkPath === curr) {
            $(this).addClass('active');
            const $img = $(this).find('img.menuIcon');
            const name = $img.data('name');
            var src = contextPath + '/img/' + name + '_active.png';
            $img.attr('src', src);
        }
    });

    // 2) 클릭 시: 역시 <a>에 active 주고 이미지 교체
    $('.menuContainer').on('click', 'a.menuLink', function(e) {
        // 이미 내가 보는 페이지 링크면 이동 막기
        const linkPath = this.pathname.replace(/\/$/, '');
        if (linkPath === curr) {
            e.preventDefault();
            return;
        }

        // 나머지 active 비활성화
        $('.menuContainer a.menuLink').each(function() {
            $(this).removeClass('active');
            const $img = $(this).find('img.menuIcon');
            const name = $img.data('name');
            var src = contextPath + '/img/' + name + '.png';
            $img.attr('src', src);
        });

        // 클릭한 애만 활성화
        $(this).addClass('active');
        const $img = $(this).find('img.menuIcon');
        const name = $img.data('name');
        var src = contextPath + '/img/' + name + '_active.png';
        $img.attr('src', src);
    });

    //헤더에 있는 요소들 같은 경우도 현재 위치면 클릭 방지
    $('.iconContainer a').on('click', function(e){
        const linkPath = this.pathname.replace(/\/$/, '');               // 끝의 / 제거
        console.log({ linkPath, contextPath });
        if (linkPath === contextPath) {
            e.preventDefault();
        }
    });
</script>