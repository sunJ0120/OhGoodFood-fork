<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.net.URLDecoder" %>
<%
    String address = request.getParameter("addr");
    if (address != null) {
        address = URLDecoder.decode(address, "UTF-8");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ohgoodfood</title>
    <link rel="icon" type="image/jpeg" href="https://ohgoodfood.s3.ap-northeast-2.amazonaws.com/shinhanmoilicon32x32.jpg">
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=390425b8fc20d1d5e18621db85fd5551&libraries=services"></script>
    <style>
        body { margin: 0; font-family: Arial; }
        .info { padding: 10px; font-size: 16px; background: #f1f1f1; }
        #map { width: 100%; height: 400px; }
    </style>
</head>
<body>
    <div class="info">
        <strong>📍 주소:</strong> <%= address %>
    </div>
    <div id="map"></div>

    <script>
        const address = "<%= address %>";

        const mapContainer = document.getElementById('map');
        const mapOption = {
            center: new kakao.maps.LatLng(37.5665, 126.9780), // 기본 위치 (서울)
            level: 3
        };

        const map = new kakao.maps.Map(mapContainer, mapOption);
        const geocoder = new kakao.maps.services.Geocoder();

        geocoder.addressSearch(address, function(result, status) {
            if (status === kakao.maps.services.Status.OK) {
                const coords = new kakao.maps.LatLng(result[0].y, result[0].x);

                // 마커 표시
                const marker = new kakao.maps.Marker({
                    map: map,
                    position: coords
                });

                // 지도 중심 이동
                map.setCenter(coords);
            } else {
                alert("지도를 불러올 수 없습니다. 주소를 다시 확인해주세요.");
            }
        });
    </script>
</body>
</html>