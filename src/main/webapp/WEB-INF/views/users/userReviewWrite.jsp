<%@ page contentType="text/html; charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Ohgoodfood</title>
                <link rel="icon" type="image/jpeg" href="https://ohgoodfood.s3.ap-northeast-2.amazonaws.com/shinhanmoilicon32x32.jpg">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/userReviewWrite.css">
            </head>

            <body>
                <div id="wrapper">
                    <header>
                        <div class="headerContainer">
                            <a href="javascript:history.back()">
                                <img src="${pageContext.request.contextPath}/img/user_backdo.png" alt="뒤로가기"
                                    class="icon" />
                            </a>
                        </div>
                    </header>
                    <main class="content">
                        <h2 class="review">리뷰 작성</h2>
                        <div class="reviewContainer">
                            <!-- 상품 정보 카드 -->
                            <div class="productCard">
                                <img class="storeImg"
                                    src="https://ohgoodfood.s3.ap-northeast-2.amazonaws.com/${reviewForm.store_img}"
                                    alt="가게이미지" />
                                <div class="details">
                                    <p class="name">${reviewForm.store_name}</p>
                                    <p><span class="storeName" style="font-weight:bold;">구매자 :</span>
                                        <span>${reviewForm.user_nickname}</span>
                                    </p>
                                    <p><span class="productCount" style="font-weight:bold;">수량 :</span>
                                        <span>${reviewForm.quantity}</span>개
                                    </p>
                                    <p><span class="productPrice" style="font-weight:bold;">결제 금액 :</span>
                                        <span>
                                            <fmt:formatNumber value="${reviewForm.sale_price * reviewForm.quantity}"
                                                type="number" groupingUsed="true" />원
                                        </span>
                                    </p>
                                </div>
                            </div>
                            <hr class="line" />
                            <!-- 리뷰 입력 폼 -->
                            <form action="${pageContext.request.contextPath}/user/review/submit" method="post"
                                enctype="multipart/form-data" class="reviewForm">
                                <!-- 숨겨진 필드 -->
                                <input type="hidden" name="order_no" value="${reviewForm.order_no}" />
                                <input type="hidden" name="store_id" value="${reviewForm.store_id}" />
                                <input type="hidden" name="product_no" value="${reviewForm.product_no}" />
                                <input type="hidden" name="user_id" value="${reviewForm.user_id}" />

                                <!-- 리뷰 텍스트 -->
                                <span class="reviewInfo">
                                    <strong class="reviewInfo__title">리뷰</strong>
                                    <span class="reviewInfo__desc">80자 이내로 작성해주세요.</span>
                                </span>
                                <textarea id="reviewText" class="reviewText" placeholder="리뷰는 80자 이내로 작성해주세요."
                                    name="review_content" maxlength="80"
                                    rows="6">${reviewForm.review_content}</textarea>
                                <div class="charCount"><span id="currentCount"></span>/80</div>


                                <!-- 사진 업로드 -->
                                <div class="reviewPhoto">
                                    <span class="photoLabel">
                                        <span class="photoLabel__title">사진</span>
                                        <span class="photoLabel__desc">사진은 필수로 첨부해주세요.</span>
                                    </span>
                                    <div class="photoInput">
                                        <input type="file" id="photoFile" name="imageFile" accept="image/*" hidden />
                                        <button type="button" id="btnAddPhoto" class="btnAddPhoto">
                                            <img src="${pageContext.request.contextPath}/img/user_plusbtn.png"
                                                alt="사진 추가" />
                                        </button>
                                        <div id="photoPreview" class="photoPreview"></div>
                                    </div>
                                </div>
                        </div>

                        <!-- 등록 버튼 -->
                        <button type="submit" id="btnSubmit" class="btnSubmit" disabled>리뷰 등록하기</button>
                        </form>
                    </main>

                </div>
                <!-- Modal bottom sheet -->
                <div id="modalOverlay" class="modal-overlay">
                    <div class="modal-sheet">
                        <button id="btnCamera">카메라</button>
                        <button id="btnGallery">갤러리에서 가져오기</button>
                        <button id="btnCancel">취소</button>
                    </div>
                </div>

                <script>
                    $(function () {
                        // 토글에 필요한 jQuery 변수 선언
                        const $textarea = $('#reviewText');
                        const $fileInput = $('#photoFile');
                        const $btnSubmit = $('#btnSubmit');
                        const $btnAdd = $('#btnAddPhoto');
                        const $modal = $('#modalOverlay');
                        $modal.hide();
                        const $preview = $('#photoPreview');

                        // 글자수
                        $('#reviewText').on('input', function () {
                            $('#currentCount').text(this.value.length);
                            updateSubmitState();
                        });

                        const modal = $('#modalOverlay');
                        const fileInput = $('#photoFile');
                        const previewBox = $('#photoPreview');

                        // 사진 추가 모달 보이기
                        $('#btnAddPhoto').on('click', function () {
                            modal.fadeIn(200).css('display', 'flex');
                        });
                        // 사진 추가 모달 숨기기
                        $('#btnCancel').on('click', () => modal.fadeOut(200));
                        modal.on('click', e => { if (e.target === modal[0]) modal.hide(); });

                        // 카메라
                        $('#btnCamera').on('click', function () {
                            fileInput.attr('capture', 'environment').click();
                            modal.hide();
                        });
                        // 갤러리
                        $('#btnGallery').on('click', function () {
                            fileInput.removeAttr('capture').click();
                            modal.hide();
                        });
                        // 파일 선택 및 미리보기
                        $fileInput.on('change', function () {
                            const allowedTypes = ['image/jpeg', 'image/png', 'image/jpg'];

                            const file = this.files[0];
                            if (!file) return;

                            if (!allowedTypes.includes(file.type)) {
                                alert("JPEG 또는 PNG 형식의 이미지 파일만 업로드 가능합니다.");
                                this.value = ""; // 전체 파일 초기화
                                return;
						    }

                            const reader = new FileReader();
                            reader.onload = e => {
                                $preview.empty();
                                const wrapper = $('<div>').addClass('photoPreview-wrapper');
                                const img = $('<img>').attr('src', e.target.result);
                                const btn = $('<button>').addClass('remove-btn').text('×');

                                btn.on('click', () => {
                                    $preview.empty();
                                    $fileInput.val(''); // 빈 문자열 -> 초기화
                                    $btnAdd.show();
                                    updateSubmitState();
                                });
                                wrapper.append(img).append(btn);
                                $preview.append(wrapper);

                                $btnAdd.hide();
                                updateSubmitState();
                            };
                            reader.readAsDataURL(file);
                        });

                        // 최종 제출 리뷰 버튼 전환
                        function updateSubmitState() {
                            const hasText = $textarea.val().trim().length > 0;
                            const hasPhoto = $fileInput[0].files.length > 0;
                            if (hasText && hasPhoto) {
                                $btnSubmit.prop('disabled', false).addClass('active');
                            } else {
                                $btnSubmit.prop('disabled', true).removeClass('active');
                            }
                        }

                        // 버튼 중복 방지 이벤트

                        let isSubmitting = false;

                        $('.reviewForm').on('submit', function (e) {
                            if (isSubmitting) {
                                e.preventDefault(); // 중복 제출 차단
                                return;
                            }

                            isSubmitting = true;
                            $btnSubmit.prop('disabled', true).text('등록 중...');

                            // 실패 대비 fallback (3초 후 다시 활성화)
                            setTimeout(() => {
                                isSubmitting = false;
                                $btnSubmit.prop('disabled', false).text('리뷰 등록하기');
                            }, 3000);
                        });

                        // 초기 상태 체크
                        updateSubmitState();

                    });
                </script>
            </body>

            </html>