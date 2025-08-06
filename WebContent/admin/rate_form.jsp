<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<jsp:include page="pagehead.jsp"></jsp:include>

	<link rel="stylesheet" type="text/css" href="../css/custom_background_template.css"/>
	<link rel="stylesheet" type="text/css" href="../css/custom_row_template.css"/>
	<link rel="stylesheet" type="text/css" href="../css/table_list_admin_template.css"/>
	<link rel="stylesheet" type="text/css" href="../css/search_button_template.css"/>
	<link rel="stylesheet" type="text/css" href="../css/custom_border_template.css"/>
</head>
<body>
	<jsp:directive.include file="header.jsp"/>
	
	<div class="background-div-content">
		<div class="container mb-5 mt-5">
			<div class="row justify-content-center">
				<div class="row custom-row-1 text-center" style="width: fit-content">
					<h1>Rate's Detail</h1>
				</div>
			</div>

			<br>

			<div class="row justify-content-center mt-4">
				<div class="col-md-auto justify-content-center text-center border custom-border" style="border-radius: 20px; padding: 25px">
					<form action="rate_update" method="post" id="rateForm">
						<input type="hidden" name="rateId" value="${rate.id}">
						<table cellpadding="10px">
							<tr>
								<td align="right">Product' name:</td>
								<td align="left"><b>${rate.productId} - ${rate.productName}</b></td>
							</tr>

							<tr>
								<td align="right">Rating Stars:</td>
								<td align="left"><c:forEach begin="1" end="5" var="i">
									<c:choose>
										<c:when test="${i <= rate.stars}">
											<i class="bi bi-star-fill"></i>
										</c:when>
										<c:otherwise>
											<i class="bi bi-star"></i>
										</c:otherwise>
									</c:choose>
								</c:forEach></td>
							</tr>

							<tr>
								<td align="right">Customer's full name:</td>
								<td align="left"><b>${rate.customerId} - ${rate.customerName}</b></td>
							</tr>

							<tr>
								<td align="right">Rate's headline:</td>
								<td align="left">
									<input type="text" size="60" name="headline" value="${rate.headline}" required="required" minlength="5" maxlength="50" class="form-control" readonly>
								</td>
							</tr>

							<tr>
								<td align="right">Rate detail:</td>
								<td align="left">
									<textarea rows="5" cols="70" name="ratingDetail" required="required" minlength="1" maxlength="50" readonly>${rate.detail}</textarea>

								</td>
							</tr>

							<tr>
								<td colspan="2" align="center">
									<%--					<button type = "submit" class="btn btn-outline-success">Save</button>--%>
									<button type="button" class="btn custom-btn-return" onclick="history.go(-1);">Cancel</button>
								</td>
							</tr>
						</table>
					</form>
				</div>
			</div>
		</div>

	</div>
	
	

	<jsp:directive.include file="footer.jsp"/>
</body>
<script type="text/javascript">
	$(document).ready(function(){
		$("#buttonCancel").click(function(){
			history.go(-1);
		});
	});
</script>
</html>