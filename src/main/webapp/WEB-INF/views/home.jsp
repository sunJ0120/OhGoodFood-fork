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
				successUrl: "http://localhost:8090/payment/success",
				failUrl: "http://localhost:8090/payment/fail"
			});
			},
			error: function(xhr, status, error) {
			alert("결제 준비 중 오류 발생: " + error);
			}
		});
	});
</script>
</body>
</html>
