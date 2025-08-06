<c:forTokens items="${shirt.ratingStars}" delims="," var="star">
	<div class="image-container">
		<c:if test="${star eq 'on'}">
			<img class="image-heart" src="images/NewWholeStar.png">
		</c:if>

		<c:if test="${star eq 'half'}">
			<img class="image-heart" src="images/NewHalfStar.png">
		</c:if>

		<c:if test="${star eq 'off'}">
			<img class="image-heart" src="images/NewHollowStar.png">
		</c:if>
	</div>
</c:forTokens>