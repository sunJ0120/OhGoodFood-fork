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
    <link rel="icon" type="image/jpeg" href="https://ohgoodfood.s3.ap-northeast-2.amazonaws.com/shinhanmoilicon32x32.jpg">
    <link rel="stylesheet" href="../../../css/reset.css" />
    <link rel="stylesheet" href="../../../css/adminlayout.css" />
    <link rel="stylesheet" href="../../../css/adminsearchlayout.css" />
    <link rel="stylesheet" href="../../../css/adminmanagedalarms.css" />
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
                    <p>알람 관리</p>
                </div>
                <div class="content">
                    <p class="menuName">알람 관리</p>
                    <form method="get" action="<c:url value='/admin/managedalarm'/>">
                    <div class="usersFilter">
                        <select class="selectBox" name="s_type">
                            <option value="receive_id">ID</option>
                        </select>
                    </div>
                    <div class="filterValue">
                        <input class="searchBox" type="text" name="s_value" value="${alarm.s_value != null ? alarm.s_value : ''}">
                        <div class="magnifying">
                            <input class="magnifyingButton" type="submit" value="">
                        </div>
                    </div>
                    </form>
                    <form method="post" action="<c:url value='/admin/updatealarm'/>">
                    <div class="updateDiv">
                        <input class="updateButton" type="submit" value="저장">
                    </div>
                    <div class="searchTable">
                        <table border="1">
                            <tr style="background-color:#E8E8E8">
                                <th>알람 번호</th>
                                <th>수신 ID</th>
                                <th>제목</th>
                                <th>내용</th>
                                <th>받은 시각</th>
                                <th>읽음 상태</th>
                                <th>알람 표시</th>
                            </tr>
                            <c:forEach var="vo" items="${map.list}">
                                <tr>
                                    <td>${vo.alarm_no}</td>
                                    <td>${vo.receive_id}</td>
                                    <td>${vo.alarm_title}</td>
                                    <td>${vo.alarm_contents}</td>
                                    <td><fmt:formatDate value="${vo.sended_at}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                                    <td>
                                        <input type="hidden" name="alarm_no" value="${vo.alarm_no}">
                                        <select name="alarm_read">
                                            <option value="Y" ${vo.alarm_read == 'Y' ? 'selected' : ''}>Y</option>
                                            <option value="N" ${vo.alarm_read == 'N' ? 'selected' : ''}>N</option>
                                        </select>
                                    </td>
                                    <td>
                                        <select name="alarm_displayed">
                                            <option value="Y" ${vo.alarm_displayed == 'Y' ? 'selected' : ''}>Y</option>
                                            <option value="N" ${vo.alarm_displayed == 'N' ? 'selected' : ''}>N</option>
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
                                <li><a href="managedalarm?page=${map.startPage-1 }&s_type=${alarm.s_type}&s_value=${alarm.s_value}"> << </a></li>
                            </c:if>
                            <c:forEach var="p" begin="${map.startPage}" end="${map.endPage}">
                                <c:if test="${p == alarm.page}">
                                <li><a href='#;' class='current'>${p}</a></li>
                                </c:if>
                                <c:if test="${p != alarm.page}">
                                <li><a href='managedalarm?page=${p}&s_type=${alarm.s_type}&s_value=${alarm.s_value}'>${p}</a></li>
                                </c:if>
                            </c:forEach>
                            <c:if test="${map.isNext }">
                                <li><a href="managedalarm?page=${map.endPage+1 }&s_type=${alarm.s_type}&s_value=${alarm.s_value}"> >> </a></li>
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

        $(document).ready(function() {
            <c:choose>
                <c:when test="${not empty error}">
                    alert("${error}");
                </c:when>
                <c:when test="${not empty success}">
                    alert("${success}"); 
                </c:when>
            </c:choose>
        });
    </script>
</body>
</html>