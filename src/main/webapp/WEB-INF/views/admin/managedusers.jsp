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
    <link rel="stylesheet" href="../../../css/adminmanagedusers.css" />
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
                    <p>회원 관리</p>
                </div>
                <div class="content">
                    <p class="menuName">회원 정보 수정</p>
                    <form method="get" action="<c:url value='/admin/managedusers'/>">
                    <div class="usersFilter">
                        <select class="selectBox" name="s_type">
                            <option value="user_id">ID</option>
                        </select>
                    </div>
                    <div class="filterValue">
                        <input class="searchBox" type="text" name="s_value" value="${account.s_value != null ? account.s_value : ''}">
                        <div class="magnifying">
                            <input class="magnifyingButton" type="submit" value=""> 
                        </div>
                    </div>
                    </form>
                    <form method="post" action="<c:url value='/admin/updateuser'/>">
                    <div class="userInfo">
                        <div class="userId userInfoBox">
                            ID : 
                            <input id="updateUserId" class="userInputBox" type="text" name="user_id" value="${account.user_id}" disabled>
                        </div>
                        <div class="userName userInfoBox">
                            이름 :
                            <input class="userInputBox" type="text" name="user_name" value="${account.user_name}">
                        </div>
                        <div class="userNickname userInfoBox">
                            닉네임 :
                            <input class="userInputBox" type="text" name="user_nickname" value="${account.user_nickname}" disabled>
                        </div>
                        <div class="userPhoneNumber userInfoBox">
                            전화번호 :
                            <input class="userInputBox" type="text" name="phone_number" value="${account.phone_number}">
                        </div>
                        <div class="userJoindate userInfoBox">
                            가입일 :
                            <input class="userInputBox" type="text" name="join_date" value="${account.join_date}" disabled>
                        </div>
                        <div class="userStatus userInfoBox">
                            계정 활성화 :
                            <select name="user_status">
                                <option value="Y" ${account.user_status == 'Y' ? 'selected' : ''}>Y</option>
                                <option value="N" ${account.user_status == 'N' ? 'selected' : ''}>N</option>
                            </select>
                        </div>
                        <div class="userLoaction userInfoBox">
                            위치 정보 동의 : 
                            <select name="location_agreement">
                                <option value="Y" ${account.location_agreement == 'Y' ? 'selected' : ''}>Y</option>
                                <option value="N" ${account.location_agreement == 'N' ? 'selected' : ''}>N</option>
                            </select>
                        </div>
                    </div>
                    <div class="updateButtonDiv">
                        <input type="hidden" name="user_id" value="${account.user_id}">
                        <input id="updateButton" type="submit" value="저장" disabled>
                    </div>
                    </form>
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

        $(document).ready(function(){
            if ($("#updateUserId").val() != null && $("#updateUserId").val() != ""){
                $('#updateButton').prop('disabled', false);
            }
        });
    </script>
</body>
</html>