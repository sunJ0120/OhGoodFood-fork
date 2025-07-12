<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ohgoodfood</title>
    <link rel="icon" type="image/jpeg" href="https://ohgoodfood.s3.ap-northeast-2.amazonaws.com/shinhanmoilicon32x32.jpg">
    <link rel="stylesheet" href="../../../css/reset.css" />
    <link rel="stylesheet" href="../../../css/userPaid.css" />
</head>
<body>
    <div class="wrapper">
        <div class="header">
            <img id="goBackIcon" src="../../../img/user_GoBackIcon.png" onclick="location.href='/user/productDetail?product_no='+'${productDetail.product_no}'">
            <p>예약하기</p>
        </div>
        <div class="content">
            <div class="productDiv">
                <div class="productWrapper">
                    <div class="productInfo">
                        <img id=storeImg src="https://ohgoodfood.s3.ap-northeast-2.amazonaws.com/${productDetail.store_img}">
                        <div class="productInfoSub">
                            <p id="storeName">${productDetail.store_name}</p>
                            <p id="productPriceEtc">개당 가격 ${productDetail.sale_price} &#8361;</p>
                            <div class="pickupTimeDiv">
                                <p id="pickupTimeText">픽업 시간</p>
                                <p id="pickupTime">
                                    <fmt:formatDate value="${productDetail.pickup_start}"
                                        pattern="HH:mm" /> ~
                                    <fmt:formatDate value="${productDetail.pickup_end}"
                                        pattern="HH:mm" />
                                </p>
                            </div>
                            <div class="confirmedTimeDiv">
                                 <p id="confirmedTimeText">확정 시간</p>
                                <p id="confirmedTime">
                                    <fmt:formatDate value="${productDetail.reservation_end}"
                                        pattern="HH:mm" />
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="productAmount">
                        <p class="productAmountText">
                            &ensp;&ensp;수량&ensp;( 최대 : ${productDetail.amount} )
                        </p>
                        <div class="productAmountSub">
                            <img id="amountMinus"" src="../../../img/user_minusButton.png">
                            <p class="productQuantity">
                                
                            </p>
                            <img id="amountPlus" src="../../../img/user_plusButton.png">
                            <input id="totalQuantity" type="hidden" name="quantity" value="1">
                        </div>
                    </div>
                    <div class="userPointDiv">
                        <p>&ensp;&ensp;포인트 (보유: ${userPoint} p)</p>&ensp;&ensp;&ensp;
                        <input class="userPoint" type="text" name="user_point" oninput="this.value = this.value.replace(/[^0-9]/g, '')" value="0">
                    </div>
                    <div class="productPrice">
                        <p class="productPriceText">
                            &ensp;&ensp;결제 금액 
                        </p>
                        <div class="productPriceSub">
                            <p class="productTotalPrice">
                                
                            </p>
                            <input id="totalPrice" type="hidden" name="paid_price" value="${productDetail.sale_price}">
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
                $(".productTotalPrice").html((parseInt("${productDetail.sale_price}")*$("#totalQuantity").val()-$(".userPoint").val()).toLocaleString('ko-KR') + " 원");
                $('#totalPrice').val(parseInt("${productDetail.sale_price}")*$("#totalQuantity").val()-parseInt($(".userPoint").val()));
                if (parseInt($(".userPoint").val()) >= parseInt("${productDetail.sale_price}")*$("#totalQuantity").val()){
                    $(".userPoint").val(0);
                    $(".productTotalPrice").html((parseInt("${productDetail.sale_price}")*$("#totalQuantity").val()-$(".userPoint").val()).toLocaleString('ko-KR') + " 원");
                    $('#totalPrice').val(parseInt("${productDetail.sale_price}")*$("#totalQuantity").val()-parseInt($(".userPoint").val()));
                }
            }
        })

        $("#amountPlus").click(function(){
            if($("#totalQuantity").val() < "${productDetail.amount}" ){
                $("#totalQuantity").val(parseInt($("#totalQuantity").val())+1);
                $(".productQuantity").html($("#totalQuantity").val());
                $(".productTotalPrice").html((parseInt("${productDetail.sale_price}")*$("#totalQuantity").val()-$(".userPoint").val()).toLocaleString('ko-KR') + " 원");
                $('#totalPrice').val(parseInt("${productDetail.sale_price}")*$("#totalQuantity").val()-parseInt($(".userPoint").val()));
                if (parseInt($(".userPoint").val()) >= parseInt("${productDetail.sale_price}")*$("#totalQuantity").val()){
                    $(".userPoint").val(0);
                    $(".productTotalPrice").html((parseInt("${productDetail.sale_price}")*$("#totalQuantity").val()-$(".userPoint").val()).toLocaleString('ko-KR') + " 원");
                    $('#totalPrice').val(parseInt("${productDetail.sale_price}")*$("#totalQuantity").val()-parseInt($(".userPoint").val()));
                }
            }
        })

        $(".userPoint").on("input",function(){
            $(".productTotalPrice").html((parseInt("${productDetail.sale_price}")*$("#totalQuantity").val()-$(".userPoint").val()).toLocaleString('ko-KR') + " 원");
            $('#totalPrice').val(parseInt("${productDetail.sale_price}")*$("#totalQuantity").val()-parseInt($(".userPoint").val()));
            if (parseInt($(".userPoint").val()) >= parseInt("${productDetail.sale_price}")*$("#totalQuantity").val()){
                $(".userPoint").val(0);
                $(".productTotalPrice").html((parseInt("${productDetail.sale_price}")*$("#totalQuantity").val()-$(".userPoint").val()).toLocaleString('ko-KR') + " 원");
                $('#totalPrice').val(parseInt("${productDetail.sale_price}")*$("#totalQuantity").val()-parseInt($(".userPoint").val()));
            }
            if(parseInt($(".userPoint").val()) > parseInt("${userPoint}")){
                $(".userPoint").val(0);
                $(".productTotalPrice").html((parseInt("${productDetail.sale_price}")*$("#totalQuantity").val()-$(".userPoint").val()).toLocaleString('ko-KR') + " 원");
                $('#totalPrice').val(parseInt("${productDetail.sale_price}")*$("#totalQuantity").val()-parseInt($(".userPoint").val()));
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
            } else {
                alert("주의 사항을 모두 체크해주세요.")
                return;
            }

            $("#payButton").prop('disabled', true).text('결제 중...');

            $.ajax({
                type: "POST",
                url: "/payment/insert",
                data: {
                    user_id: "${user.user_id}",
                    store_id: "${productDetail.store_id}",
                    quantity: $("#totalQuantity").val(),
                    product_no: "${productDetail.product_no}",
                    paid_price: $("#totalPrice").val(),
                    paid_point: $(".userPoint").val()
                },
                dataType: "json",
                success: function(res){
                    if (res.result === "success" || res.result == "success") {
                        const tossPayments = TossPayments(res.clientKey);
                        tossPayments.requestPayment("카드", {
                            amount: res.amount,
                            orderId: res.orderId,
                            orderName: "오굿백 테스트 상품",
                            successUrl: "https://ohgoodfood.com/payment/success",
                            failUrl: "https://ohgoodfood.com/payment/fail"
                        });
                    } else {
                        alert("주문이 불가능합니다. 뒤로 돌아주세요");
                        $("#payButton").text('결제 실패');
                    }
                },
                error: function(){
                    return;
                }
            })
        });

    </script>
</body>
</html>