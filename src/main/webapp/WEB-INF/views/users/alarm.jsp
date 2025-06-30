<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="utf-8" />

    <link rel="stylesheet" href="../../../css/storealarm.css" />
    <title>Ohgoodfood</title>
</head>
<body>
    <div id="wrapper">
        <%@ include file="/WEB-INF/views/users/header.jsp" %>
        <main>
            <div class="alarm-container" id="alarm-container">
                <c:forEach var="alarm" items="${alarms}">
                    <div class="alarm-item ${alarm.alarm_read == 'N' ? 'new-alarm' : ''}" data-alarm-no="${alarm.alarm_no}">
                        <div class="alarm-header">
                            <div class="alarm-date">
                                <fmt:formatDate value="${alarm.sended_at}" pattern="yyyy-MM-dd HH:mm:ss" />
                            </div>
                            <img src="../../../img/store_delete.png" alt="삭제 아이콘" class="delete-icon">
                        </div>
                        <div class="alarm-content">
                            <span class="alarm-status">${alarm.alarm_title}</span>
                            <span class="alarm-desc">| ${alarm.alarm_contents}</span>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </main>
        <%@ include file="/WEB-INF/views/users/footer.jsp" %>
    </div>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script>
        $(document).ready(function(){
            $.ajax({
                type: "POST",
                url: "/user/alarmread",
                success: function(res){
                    if(res == true || res==="true"){
                        console.log("alarm 읽음 처리")
                    }
                }
            })
        })

        // 삭제 아이콘 클릭 이벤트
        $(document).on('click', '.delete-icon', function(){
            var alarmItem = $(this).closest('.alarm-item');
            var alarmNo = alarmItem.data('alarm-no'); // alarm_no를 data 속성으로 저장해야 함
            
            if(confirm('이 알람을 삭제하시겠습니까?')) {
                $.ajax({
                    type: "POST",
                    url: "/user/alarmhide",
                    data: {
                        alarm_no: alarmNo
                    },
                    success: function(res){
                        if(res == true || res === "true"){
                            // 성공 시 해당 알람 아이템을 화면에서 제거
                            alarmItem.fadeOut(300, function(){
                                $(this).remove();
                            });
                        } else {
                            alert('삭제에 실패했습니다.');
                        }
                    },
                    error: function(){
                        alert('삭제 중 오류가 발생했습니다.');
                    }
                });
            }
        });
    </script>
</body>
</html>