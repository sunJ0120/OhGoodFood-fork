<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="../../../css/reset.css" />
    <link rel="stylesheet" href="../../../css/userPaid.css" />
</head>
<body>
    <div class="wrapper">
        <div class="header">
            <img src="../../../img/user_GoBackIcon.png">
            <p>예약하기</p>
        </div>
        <div class="content">
            <div class="productDiv">
                <div class="productWrapper">
                    <div class="productInfo">
                        <img id=storeImg src="https://ohgoodfood.s3.ap-northeast-2.amazonaws.com/init.jpg">
                        <div class="productInfoSub">
                            <p id="storeName">가게이름</p>
                            <p id="productPriceEtc">개당 가격 &#8361;</p>
                            <div class="pickupTimeDiv">
                                <p id="pickupTimeText">픽업 시간</p>
                                <p id="pickupTime">00:00 ~ 00:00</p>
                            </div>
                            <div class="confirmedTimeDiv">
                                 <p id="confirmedTimeText">확정 시간</p>
                                <p id="confirmedTime">00:00 ~ 00:00</p>
                            </div>
                        </div>
                    </div>
                    <div class="productAmount">
                        <p class="productAmountText">
                            &ensp;&ensp;수량&ensp;( 최대 : Amount )
                        </p>
                        <div class="productAmountSub">
                            <img id="amountMinus"" src="../../../img/user_minusButton.png">
                            <p class="productQuantity">
                                
                            </p>
                            <img id="amountPlus" src="../../../img/user_plusButton.png">
                            <input id="totalQuantity" type="hidden" name="quantity" value="1">
                        </div>
                    </div>
                    <div class="productPrice">
                        <p class="productPriceText">
                            &ensp;&ensp;결제 금액 
                        </p>
                        <div class="productPriceSub">
                            <p class="productTotalPrice">
                                
                            </p>
                            <input id="totalPrice" type="hidden" name="paid_price" value="1000">
                        </div>
                    </div>
                </div>
            </div>
            <div class="cautionDiv">
                <div class="cautionWrapper">
                    <div class="cautionTitle">
                        <p>주의 사항</p>
                    </div>
                    <div class="caution caution1">
                        <label class="custom-checkbox">
                            <input id="check3" class="totalCheck" type="checkbox">
                            <span class="checkmark"></span>
                        </label>
                        <p>5조은 푸드는 랜덤 메뉴입니다.</p>
                        <img id="toggle1" src="../../../img/user_toggleDown.png">
                    </div>
                    <div class="cautionImg img1">
                        <img src="../../../img/user_cautionInfo1.png">
                    </div>
                    <div class="caution caution2">
                        <label class="custom-checkbox">
                            <input id="check2" class="totalCheck" type="checkbox">
                            <span class="checkmark"></span>
                        </label>
                        <p>예약은 가게 사정에 의해 취소될 수 있습니다.</p>
                        <img id="toggle2" src="../../../img/user_toggleDown.png">
                    </div>
                    <div class="cautionImg img2">
                        <img src="../../../img/user_cautionInfo2.png">
                    </div>
                    <div class="caution caution3">
                        <label class="custom-checkbox">
                            <input id="check3" class="totalCheck" type="checkbox">
                            <span class="checkmark"></span>
                        </label>
                        <p>픽업할 때 주문코드를 보여주세요.</p>
                        <img id="toggle3" src="../../../img/user_toggleDown.png">
                    </div>
                    <div class="cautionImg img3">
                        <img src="../../../img/user_cautionInfo3.png">
                    </div>
                </div>
            </div>
        </div>
        <div class="footer">
            <form>
                <button id="payButton">결제하기</button>
            </form>
        </div>
    </div>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://js.tosspayments.com/v1/payment"></script>
    <script>
        $("#toggle1").click(function() {
            let displayStatus = $('.img1').css('display');
            console.log(displayStatus);
            if (displayStatus === 'none') {
                $('.img1').css('display', 'flex');
                $('#toggle1').attr('src', '../../../img/user_toggleUp.png');
            } else {
                $('.img1').css('display', 'none');
                $('#toggle1').attr('src', '../../../img/user_toggleDown.png');
            }
        });

        $("#toggle2").click(function() {
            let displayStatus = $('.img2').css('display');
            console.log(displayStatus);
            if (displayStatus === 'none') {
                $('.img2').css('display', 'flex');
                $('#toggle2').attr('src', '../../../img/user_toggleUp.png');
            } else {
                $('.img2').css('display', 'none');
                $('#toggle2').attr('src', '../../../img/user_toggleDown.png');
            }
        });

        $("#toggle3").click(function() {
            let displayStatus = $('.img3').css('display');
            console.log(displayStatus);
            if (displayStatus === 'none') {
                $('.img3').css('display', 'flex');
                $('#toggle3').attr('src', '../../../img/user_toggleUp.png');
            } else {
                $('.img3').css('display', 'none');
                $('#toggle3').attr('src', '../../../img/user_toggleDown.png');
            }
        });

        $("#amountMinus").click(function(){
            if($("#totalQuantity").val() > 1 ){
                $("#totalQuantity").val($("#totalQuantity").val()-1);
                $(".productQuantity").html($("#totalQuantity").val());
                $(".productTotalPrice").html((parseInt($("#totalPrice").val())*$("#totalQuantity").val()).toLocaleString('ko-KR') + " 원");
            }
        })

        $("#amountPlus").click(function(){
            if($("#totalQuantity").val() < 5 ){
                $("#totalQuantity").val(parseInt($("#totalQuantity").val())+1);
                $(".productQuantity").html($("#totalQuantity").val());
                $(".productTotalPrice").html((parseInt($("#totalPrice").val())*$("#totalQuantity").val()).toLocaleString('ko-KR') + " 원");
            }
        })

        $(document).ready(function(){
            $(".productQuantity").html($("#totalQuantity").val());
        })

        $(document).ready(function(){
            $(".productTotalPrice").html(parseInt($("#totalPrice").val()).toLocaleString('ko-KR') + " 원");
        })

        $("#payButton").on("click", function(e) {
            e.preventDefault();

            if ($('.totalCheck:checked').length === $('.totalCheck').length) {
                console.log('모두 체크됨');
            } else {
                console.log('하나 이상 체크되지 않음');
                alert("주의 사항을 모두 체크해주세요.")
                return;
            }

            $.ajax({
                type: "POST",
                url: "/payment/insert",
                data: {
                    user_id: "u01",
                    store_id: "st01",
                    quantity: $("#totalQuantity").val(),
                    product_no: 1,
                    paid_price: $("#totalPrice").val()
                },
                dataType: "json",
                success: function(res){
                    if (res.result === "success" || res.result == "success") {
                        console.log(res);
                        const tossPayments = TossPayments(res.clientKey);
                        tossPayments.requestPayment("카드", {
                            amount: res.amount,
                            orderId: res.orderId,
                            orderName: "오굿백 테스트 상품",
                            successUrl: "http://localhost:8090/payment/success",
                            failUrl: "http://localhost:8090/payment/fail"
                        });
                    } else {
                        alert("주문이 불가능합니다. 메인으로 돌아주세요")
                    }
                },
                error: function(){
                    return;
                }
            })

            // $.ajax({
            //     type: "POST",
            //     url: "/payment/ready",
            //     data: {
            //         amount: 1000
            //     },
            //     dataType: "json",
            //     success: function(data) {
            //         const tossPayments = TossPayments(data.clientKey);
            //         tossPayments.requestPayment("카드", {
            //             amount: data.amount,
            //             orderId: data.orderId,
            //             orderName: "오굿백 테스트 상품",
            //             successUrl: "http://localhost:8090/payment/success",
            //             failUrl: "http://localhost:8090/payment/fail"
            //         });
            //     },
            //     error: function(xhr, status, error) {
            //         alert("결제 준비 중 오류 발생: " + error);
            //     }
            // });
        });
    </script>
</body>
</html>