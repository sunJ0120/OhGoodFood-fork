<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="../../../css/reset.css" />
    <link rel="stylesheet" href="../../../css/adminlayout.css" />
    <link rel="stylesheet" href="../../../css/adminsendalarm.css" />
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
                    <p class="menuName">알람 보내기</p>
                    <div class="recieveIdDiv">
                        <label for="receive_id">받는 유저 ID</label>
                        <input id="receive_id" type="text" name="receive_id">
                        <input id="checkId" type="button" value="조회">
                    </div>
                    <div class="alarmTitleDiv">
                        <label for="receive_id">알람 제목</label>
                        <input id="alarm_title" type="text" name="alarm_title">
                    </div>
                    <div class="alarmContentsDiv">
                        <label for="receive_id">알람 내용</label>
                        <textarea id="alarm_contents" maxlength="100" name="alarm_contents">내용을 입력하세요</textarea>
                    </div>
                    <div class="sendButtonDiv">
                        <input id="sendButton" type="button" value="보내기">
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