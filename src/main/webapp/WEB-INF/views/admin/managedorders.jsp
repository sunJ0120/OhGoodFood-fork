<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
   if (session.getAttribute("admin") == null) {
         response.sendRedirect("login");
         return;
   }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ohgoodfood</title>
    <link rel="stylesheet" href="../../../css/reset.css" />
    <link rel="stylesheet" href="../../../css/adminlayout.css" />
    <link rel="stylesheet" href="../../../css/adminsearchlayout.css" />
    <link rel="stylesheet" href="../../../css/adminmanagedorders.css" />
    <link rel="stylesheet" href="../../../css/adminpagelayout.css" />
</head>
<body>
    <div class="wrapper">
        <div class="menu">
            <div class="toHome">
                <a href="main">5조은푸드</a>
            </div>
            <ul class="menuUl">
                <li class="userseMenu menuList">
                    <div class="menuImg">
                        <img src="../../../img/usersManagementIconWhite.png"></imh>
                    </div>
                    <div class="menuText">
                        <a>회원 관리</a>
                    </div>
                    <div class="submenu">
                        <ul>
                            <li><div class="menuImg"></div><a href="searchusers">회원 조회</a></li>
                            <li><div class="menuImg"></div><a href="managedusers">회원 정보 수정</a></li>
                        </ul>
                    </div>
                </li>
                <li class="storeMenu menuList">
                    <div class="menuImg">
                        <img src="../../../img/storeManagementIconWhite.png"></imh>
                    </div>
                    <div class="menuText">
                        <a>가게 관리</a>
                    </div>
                    <div class="submenu">
                        <ul>
                            <li><div class="menuImg"></div><a href="searchstores">가게 조회</a></li>
                            <li><div class="menuImg"></div><a href="managedstore">가게 승인</a></li>
                            <li><div class="menuImg"></div><a href="storesales">가게 매출 조회</a></li>
                        </ul>
                    </div>
                </li>
                <li class="historyMenu menuList">
                    <div class="menuImg">
                        <img src="../../../img/historyManagementIconWhite.png"></imh>
                    </div>
                    <div class="menuText">
                        <a>주문 내역 관리</a>
                    </div>
                    <div class="submenu">
                        <ul>
                            <li><div class="menuImg"></div><a href="managedorders">주문 내역 조회</a></li>
                            <li><div class="menuImg"></div><a href="managedpaids">결제 내역 조회</a></li>
                        </ul>
                    </div>
                </li>
                <li class="alarmMenu menuList">
                    <div class="menuImg">
                        <img src="../../../img/alarmManagementIconWhite.png"></imh>
                    </div>
                    <div class="menuText">
                        <a>알람 관리</a>
                    </div>
                    <div class="submenu">
                        <ul>
                            <li><div class="menuImg"></div><a href="managedalarm">알람 조회</a></li>
                            <li><div class="menuImg"></div><a href="sendalarm">알람 보내기</a></li>
                        </ul>
                    </div>
                </li>
                <li class="reviewMenu menuList">
                    <div class="menuImg">
                        <img src="../../../img/reviewManagementIconWhite.png"></imh>
                    </div>
                    <div class="menuText">
                        <a>리뷰 관리</a>
                    </div>
                    <div class="submenu">
                        <ul>
                            <li><div class="menuImg"></div><a href="managedreviews">리뷰 조회</a></li>
                        </ul>
                    </div>
                </li>
            </ul>
        </div>
        <div class="main">
            <div>
                <div class="header">
                    <p>주문/결제 내역 관리</p>
                </div>
                <div class="content">
                    <p class="menuName">주문 내역 관리</p>
                    <form method="get" action="<c:url value='/admin/managedorders'/>">
                    <div class="usersFilter">
                        <select class="selectBox" name="s_type">
                            <option value="user_id" ${orders.s_type == 'user_id' ? 'selected' : ''}>고객 ID</option>
                            <option value="store_id" ${orders.s_type == 'store_id' ? 'selected' : ''}>가게 ID</option>
                            <option value="order_no" ${orders.s_type == 'order_no' ? 'selected' : ''}>주문 번호</option>
                        </select>
                    </div>
                    <div class="filterValue">
                        <input class="searchBox" type="text" name="s_value" value="${orders.s_value != null ? orders.s_value : ''}">
                        <div class="magnifying">
                            <input class="magnifyingButton" type="submit" value=""> 
                        </div>
                    </div>
                    </form>
                    <form method="post" action="<c:url value='/admin/updateorders'/>">
                    <div class="updateDiv">
                        <input class="updateButton" type="submit" value="저장">
                    </div>
                    <div class="searchTable">
                        <table border="1">
                            <tr style="background-color:#E8E8E8">
                                <th>주문 번호</th>
                                <th>고객 ID</th>
                                <th>가게 ID</th>
                                <th>구매 수량</th>
                                <th>결제액</th>
                                <th>확정 시각</th>
                                <th>픽업 시간</th>
                                <th>주문 상태</th>
                            </tr>
                            <c:forEach var="vo" items="${map.list}">
                                <tr>
                                    <td>${vo.order_no}</td>
                                    <td>${vo.user_id}</td>
                                    <td>${vo.store_id}</td>
                                    <td>${vo.quantity}</td>
                                    <td>${vo.s_price}</td>
                                    <td><fmt:formatDate value="${vo.ordered_at}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                                    <td><fmt:formatDate value="${vo.picked_at}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                                    <td>
                                        <input type="hidden" name="order_no" value="${vo.order_no}">
                                        <select name="order_status">
                                            <option value="reservation" ${vo.order_status == 'reservation' ? 'selected' : ''}>예약</option>
                                            <option value="confirmed" ${vo.order_status == 'confirmed' ? 'selected' : ''}>확정</option>
                                            <option value="pickup" ${vo.order_status == 'pickup' ? 'selected' : ''}>픽업</option>
                                            <option value="cancel" ${vo.order_status == 'cancel' ? 'selected' : ''}>취소</option>
                                        </select>
                                    </td>
                                </tr>
                            </c:forEach>
                        </table>
                    </div>
                    </form>
                    <div class="page">
                        <ul class='paging'>
                            <c:if test="${map.isPrev }">
                                <li><a href="managedorders?page=${map.startPage-1 }&s_type=${orders.s_type}&s_value=${orders.s_value}"> << </a></li>
                            </c:if>
                            <c:forEach var="p" begin="${map.startPage}" end="${map.endPage}">
                                <c:if test="${p == orders.page}">
                                <li><a href='#;' class='current'>${p}</a></li>
                                </c:if>
                                <c:if test="${p != orders.page}">
                                <li><a href='managedorders?page=${p}&s_type=${orders.s_type}&s_value=${orders.s_value}'>${p}</a></li>
                                </c:if>
                            </c:forEach>
                            <c:if test="${map.isNext }">
                                <li><a href="managedorders?page=${map.endPage+1 }&s_type=${orders.s_type}&s_value=${orders.s_value}"> >> </a></li>
                            </c:if>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script>
        $(".menuList").hover(
            function() {
                // 마우스 올렸을 때
                // 글자 색상 변경
                $(this).find(".menuText").css("color", "black");
                // 이미지 src 변경 (white → black)
                let $img = $(this).find(".menuImg img");
                let src = $img.attr("src");
                $img.attr("src", src.replace("White", "Black"));
                // 배경색 변경
                $(this).css("background-color", "#E5E5E5");
                // 서브 메뉴 표시
                $(this).find(".submenu").css("display", "flex");
            },
            function() {
                // 마우스 뗐을 때
                // 글자 색상 원래대로
                $(this).find(".menuText").css("color", "white");
                // 이미지 src 원래대로 (black → white)
                let $img = $(this).find(".menuImg img");
                let src = $img.attr("src");
                $img.attr("src", src.replace("Black", "White"));
                // 배경색 원래대로
                $(this).css("background-color", "#99A99B");
                // 서브 메뉴 표시
                $(this).find(".submenu").css("display", "none");
            }
        );
    </script>
</body>
</html>