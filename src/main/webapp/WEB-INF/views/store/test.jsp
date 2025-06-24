<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>주소 위경도</title>

        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

        <!-- 카카오 주소검색 (우편번호) -->
        <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    </head>

    <body>

        <!-- 주소 -->
        <div class="mb-2 row">
            <label for="userAddress">주소</label>
            <input type="text" id="userAddress" name="userAddress" readonly>
            <button type="button" id="searchAddressBtn">주소검색</button>
        </div>

        <!-- 상세주소 -->
        <div class="mb-2 row">
            <label for="userDtlAddress">상세주소</label>
            <input type="text" id="userDtlAddress" name="userDtlAddress" maxlength="100">
        </div>

        <!-- 위도, 경도 -->
        <div class="mb-2 row">
            <label for="latitude">위도</label>
            <input type="text" id="latitude" name="latitude" readonly>
        </div>

        <div class="mb-2 row">
            <label for="longitude">경도</label>
            <input type="text" id="longitude" name="longitude" readonly>
        </div>

        <!-- 위경도 조회 버튼 -->
        <div class="mb-2 row">
            <button type="button" id="getCoordBtn">위경도 조회</button>
        </div>

        <script>
            let isSearching = false;  // 중복 검색 방지 플래그

            $(document).ready(function () {

                // 카카오 주소 검색
                $("#searchAddressBtn").click(function () {
                    new daum.Postcode({
                        oncomplete: function (data) {
                            $("#userAddress").val(data.address);
                            $("#userDtlAddress").focus();
                        }
                    }).open();
                });

                // 수동 조회 버튼
                $("#getCoordBtn").click(function () {
                    searchCoordinates();
                });

                // 상세주소 입력 완료시 자동조회 (blur)
                $("#userDtlAddress").blur(function () {
                    setTimeout(function () {
                        searchCoordinates();
                    }, 200);
                });

                function searchCoordinates() {
                    if (isSearching) return; // 중복 검색 방지

                    const address = $("#userAddress").val();
                    const detailAddress = $("#userDtlAddress").val();
                    const fullAddress = address + " " + detailAddress;

                    if (!address) {
                        alert("먼저 주소를 검색해주세요.");
                        return;
                    }

                    if (!detailAddress) {
                        return;  // 상세주소가 비어있으면 조회하지 않음
                    }

                    isSearching = true;  // 검색 시작
                    getCoordinates(fullAddress);
                }
            });

            function getCoordinates(fullAddress) {
                $.ajax({
                    url: "https://dapi.kakao.com/v2/local/search/address.json",
                    type: "GET",
                    data: {
                        query: fullAddress
                    },
                    headers: {
                        Authorization: "KakaoAK 0f1a7e3a49ac979863779a853f2033d7"  // 본인의 Kakao REST API 키 사용
                    },
                    success: function (res) {
                        isSearching = false;  // 검색 종료

                        if (res.documents.length > 0) {
                            const x = res.documents[0].x;
                            const y = res.documents[0].y;
                            console.log("경도(lon):", x);
                            console.log("위도(lat):", y);
                            $("#longitude").val(x);
                            $("#latitude").val(y);
                        } else {
                            alert("해당 주소로 검색된 결과가 없습니다.");
                            setTimeout(function () {
                                $("#userDtlAddress").focus();
                            }, 100);
                        }
                    },
                    error: function (xhr, status, error) {
                        isSearching = false;  // 에러 발생시도 검색 종료
                        console.error("에러 발생:", status, error);
                        alert("API 요청 중 오류가 발생했습니다.");
                    }
                });
            }
        </script>

    </body>

    </html>