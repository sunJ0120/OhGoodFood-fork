<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ohgoodfood</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/storereview.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<link rel="icon" type="image/jpeg" href="https://ohgoodfood.s3.ap-northeast-2.amazonaws.com/shinhanmoilicon32x32.jpg">
</head>
<body>
<div id="wrapper">
    <%@ include file="/WEB-INF/views/store/header.jsp"%>
    <main>
        <div class="review-section">
			<div class="reviewHeader">
            	<div class="review-title">${store.store_name}</div>
            	<div class="review-subtitle">| 구매자들의 오굿백 리뷰를 확인해보세요~</div>
			</div>
			<div class="reviewListBox"></div>
            <div class="review-list">
            	<c:choose>
            		<c:when test="${empty reviews}">
						<div class="empty-reviews">
				         <img src="${pageContext.request.contextPath}/img/storeemptyreview.png" alt="empty" class="empty-img">
				     </div>
					</c:when>
					<c:otherwise>
						<c:forEach var="vo" items="${reviews}">
		                    <div class="review-card">
		                    	<c:choose>
		                    		<c:when test="${not empty vo.review_img}">
		                    			<img src="https://ohgoodfood.s3.ap-northeast-2.amazonaws.com/${vo.review_img}" alt="${vo.user_id}" class="review-img">
		                    		</c:when>
		                    		<c:otherwise>
		                    			 <img src="${pageContext.request.contextPath}/upload/storebread2.png" alt="${vo.user_id}" class="review-img">
		                    		</c:otherwise>
		                    	</c:choose>
		                        <div class="review-content">
		                            <div class="review-header">
		                                <span class="review-date">
		                                	<fmt:formatDate value="${vo.writed_at}" pattern="yyyy.MM.dd" />
		                                </span>
		                            </div>
									<span class="review-name">${vo.user_nickname}</span>
		                            <div class="review-text">
		                                ${vo.review_content}
		                            </div>
		                        </div>
		                    </div>
		                </c:forEach>
					</c:otherwise>
            	</c:choose>
            </div>
        </div>
    </main>
    <%@ include file="/WEB-INF/views/store/footer.jsp"%>
</div>

</body>
</html>