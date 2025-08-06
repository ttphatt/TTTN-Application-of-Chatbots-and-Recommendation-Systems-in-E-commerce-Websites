<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- Lấy phần nguyên và phần thập phân từ avgStars --%>
<c:set var="fullStars" value="${product.avgStars.intValue()}" />
<c:set var="decimalPart" value="${product.avgStars - fullStars}" />

<%-- Tính toán số sao nửa và sao rỗng --%>
<c:set var="hasHalfStar" value="${decimalPart >= 0.25 and decimalPart < 0.75}" />
<c:set var="emptyStars" value="${5 - fullStars - (hasHalfStar ? 1 : 0)}" />

<%-- Hiển thị sao đầy --%>
<c:forEach begin="1" end="${fullStars}" var="i">
	<img class="image-heart" src="images/NewWholeStar.png" />
</c:forEach>

<%-- Hiển thị sao nửa nếu có --%>
<c:if test="${hasHalfStar}">
	<img class="image-heart" src="images/NewHalfStar.png" />
</c:if>

<%-- Hiển thị sao rỗng còn lại --%>
<c:forEach begin="1" end="${emptyStars}" var="i">
	<img class="image-heart" src="images/NewHollowStar.png" />
</c:forEach>
