<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page session="false" %>
<html>
<head>
	<title>Home</title>
</head>
<body>
<h1>
	Hello world!  
</h1>

<P>  The time on the server is ${serverTime}. </P>
<button id="payBtn">결제하기</button>
<script src="https://js.tosspayments.com/v1/payment"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>
	$("#payBtn").on("click", function() {
		$.ajax({
			type: "POST",
			url: "/payment/ready",
			dataType: "json",
			success: function(data) {
			const tossPayments = TossPayments(data.clientKey);
			tossPayments.requestPayment("카드", {
				amount: data.amount,
				orderId: data.orderId,
				orderName: "오굿백 테스트 상품",
				successUrl: "http://www.ohgoodfood.com/payment/success",
				failUrl: "http://www.ohgoodfood.com/payment/fail"
			});
			},
			error: function(xhr, status, error) {
			alert("결제 준비 중 오류 발생: " + error);
			}
		});
	});
</script>
<img src="https://ohgoodfood.s3.ap-northeast-2.amazonaws.com/128bdfa2-5522-488f-a2d8-5aea0dc1ba4d_search.png">
<img src="https://ohgoodfood.s3.ap-northeast-2.amazonaws.com/3f94150d-e631-4cb2-93f5-fc4ba3e5e74b_store_bag_white.png">
<img src="https://ohgoodfood.s3.ap-northeast-2.amazonaws.com/83d5d08b-16c0-4abf-bbc2-9e50da62c0d7_store_loaction.png">
</body>
</html>
