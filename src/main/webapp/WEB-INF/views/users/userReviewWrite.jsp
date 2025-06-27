<%@ page contentType="text/html; charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>reviewWrite</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/userReviewWrite.css">
            </head>

            <body>
                <div id="wrapper">
                    <header>
                        <div class="headerContainer">
                            <img src="${pageContext.request.contextPath}/img/user_backdo.png" alt="뒤로가기" class="icon">
                            <div class="iconContainer">
                                <img src="${pageContext.request.contextPath}/img/user_alarm_active.png" alt="알람"
                                    class="icon">
                                <img src="${pageContext.request.contextPath}/img/user_logout.png" alt="로그아웃"
                                    class="icon">
                            </div>
                        </div>
                    </header>
                    <main class="content">
                        <h2 class="review">리뷰 작성</h2>
                        <div class="reviewContainer">
                            <!-- 상품 정보 카드 -->
                            <div class="productCard">
                                <img class="storeImg" src="../../../img/user_pain.png" alt="가게이미지" />
                                <div class="details">
                                    <p class="name">${reviewForm.store_name}</p>
                                    <p><span class="storeName" style="font-weight:bold;">구매자 :</span>
                                        <span>"${reviewForm.user_nickname}" </span>
                                    </p>
                                    <p><span class="productCount" style="font-weight:bold;">수량 :</span>
                                        <span>"${reviewForm.quantity}"</span>개
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
                            <form action="${pageContext.request.contextPath}/review/submit" method="post"
                                enctype="multipart/form-data" class="reviewForm">
                                <!-- 숨겨진 필드 -->
                                <input type="hidden" name="order_no" value="${reviewForm.order_no}" />
                                <input type="hidden" name="store_id" value="${reviewForm.store_id}" />
                                <input type="hidden" name="product_no" value="${reviewForm.product_no}" />

                                <!-- 리뷰 텍스트 -->
                                <span class="reviewInfo">
                                    <strong class="reviewInfo__title">리뷰</strong>
                                    <span class="reviewInfo__desc">100자 이내로 작성해주세요.</span>
                                </span>
                                <textarea id="reviewText" class="reviewText" placeholder="리뷰는 100자 이내로 작성해주세요."
                                    maxlength="100" rows="6">${reviewForm.review_content}</textarea>
                                <div class="charCount"><span id="currentCount"></span>/100</div>


                                <!-- 사진 업로드 -->
                                <div class="reviewPhoto">
                                    <span class="photoLabel">
                                        <span class="photoLabel__title">사진</span>
                                        <span class="photoLabel__desc">사진은 필수로 첨부해주세요.</span>
                                    </span>
                                    <div class="photoInput">
                                        <input type="file" id="photoFile" name="image" accept="image/*" hidden />
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
                        // ① 토글에 필요한 jQuery 변수 선언
                        const $textarea = $('#reviewText');
                        const $fileInput = $('#photoFile');
                        const $btnSubmit = $('#btnSubmit');
                        const $btnAdd = $('#btnAddPhoto');
                        const $modal = $('#modalOverlay');
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
                            const file = this.files[0];
                            if (!file) return;

                            const reader = new FileReader();
                            reader.onload = e => {
                                $preview.empty();
                                const wrapper = $('<div>').addClass('photoPreview-wrapper');
                                const img = $('<img>').attr('src', e.target.result);
                                const btn = $('<button>').addClass('remove-btn').text('×');

                                btn.on('click', () => {
                                    $preview.empty();
                                    $fileInput.val('');
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

                        // 초기 상태 체크
                        updateSubmitState();

                    });
                </script>
            </body>

            </html>