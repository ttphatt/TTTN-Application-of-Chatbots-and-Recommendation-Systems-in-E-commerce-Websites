<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
		<title>Managing Orders</title>
		<jsp:include page="pagehead.jsp"></jsp:include>
		<jsp:include page="pageLoad.jsp"/>
		<link href="../css/temp.css" rel="stylesheet" type="text/css" />

	<link rel="stylesheet" type="text/css" href="../css/custom_background_template.css"/>
	<link rel="stylesheet" type="text/css" href="../css/custom_row_template.css"/>
	<link rel="stylesheet" type="text/css" href="../css/table_list_admin_template.css"/>
	<link rel="stylesheet" type="text/css" href="../css/search_button_template.css"/>
</head>
<body>
	<jsp:directive.include file="header.jsp"/>
	
	<div class="background-div-content">
		<div class="container mb-5 mt-5">
			<div class="row justify-content-center mb-5">
				<div class="row custom-row text-center" style="width: fit-content">
					<h1>Order Management</h1>
				</div>
			</div>

			<br>

			<c:if test="${message != null}">
				<c:choose>
					<c:when test="${message.contains('successfully')}">
						<div align="center" class="alert alert-info" role="alert">
							<h4>${message}</h4>
						</div>
					</c:when>
					<c:otherwise>
						<div align="center" class="alert alert-danger" role="alert">
							<h4>${message}</h4>
						</div>
					</c:otherwise>
				</c:choose>
			</c:if>

			<br>

			<div class="row justify-content-center">
				<table  class="table table-striped table-bordered table-hover table-list-admin-custom" style="width: 1400px">
					<thead class="table-dark">
					<tr>
						<th class="align-middle justify-content-center text-center">Index</th>
						<th class="align-middle justify-content-center text-center">Order's ID</th>
						<th class="align-middle justify-content-center text-center">Ordered by</th>
						<th class="align-middle justify-content-center text-center">Total</th>
						<th class="align-middle justify-content-center text-center">Payment Method</th>
						<th class="align-middle justify-content-center text-center">Status</th>
						<th class="align-middle justify-content-center text-center">Order Date</th>
						<th class="align-middle justify-content-center text-center">Actions</th>
					</tr>
					</thead>

					<tbody id="tableBody">
					<c:forEach var="order" items="${orderList}" varStatus="status">
						<tr>
							<td class="align-middle justify-content-center text-center">${status.index + 1}</td>
							<td class="align-middle justify-content-center text-center">${order.id}</td>
							<td class="align-middle justify-content-center text-center">${order.customerId} - ${order.customerName}</td>
							<td class="align-middle justify-content-center text-center"><fmt:formatNumber type="currency" value="${order.orderSum}"/></td>
							<td class="align-middle justify-content-center text-center">${order.payment}</td>
							<td class="align-middle justify-content-center text-center">
								<c:choose>
									<c:when test="${order.status eq 'Processing'}">
										<button class="btn btn-primary" disabled>${order.status}</button>
									</c:when>

									<c:when test="${order.status eq 'Shipping'}">
										<button class="btn btn-info" disabled>${order.status}</button>
									</c:when>

									<c:when test="${order.status eq 'Delivered'}">
										<button class="btn btn-warning" disabled>${order.status}</button>
									</c:when>

									<c:when test="${order.status eq 'Cancelled'}">
										<button class="btn btn-danger" disabled>${order.status}</button>
									</c:when>

									<c:when test="${order.status eq 'Completed'}">
										<button class="btn btn-success" disabled>${order.status}</button>
									</c:when>

									<c:when test="${order.status eq 'Returned'}">
										<button class="btn btn-dark" disabled>${order.status}</button>
									</c:when>

								</c:choose>
							</td>
							<td class="align-middle justify-content-center text-center">${order.date}</td>

							<td class="align-middle justify-content-center text-center">
								<a href="order_edit?orderId=${order.id}" class="btn custom-btn-details">
									<c:choose>
										<c:when test="${order.status == 'Cancelled'}">Detail</c:when>
										<c:when test="${order.status == 'Completed'}">Detail</c:when>
										<c:when test="${order.status == 'Returned'}">Detail</c:when>
										<c:when test="${order.status == 'Delivered'}">Detail</c:when>
										<c:otherwise>Edit</c:otherwise>
									</c:choose>
								</a>	&nbsp;
							</td>
						</tr>
					</c:forEach>
					</tbody>

				</table>
			</div>

			<div class="row justify-content-center mt-5">
				<div class="pagination-wrapper">
					<a href="#" class="paginationButton is-medium-button w-button" id="prevPage" >Previous</a>
					<a href="#" class="paginationButton is-medium-button w-button" id="nextPage" >Next</a>
				</div>
			</div>
		</div>
	</div>

	<script>
		let curPage = 1
		let recordsPerPage = 20;
		let products = onload();
		document.getElementById("prevPage").addEventListener("click", prevPage);
		document.getElementById("nextPage").addEventListener("click", nextPage);
		changePage(1);

		function onload() {
			return document.getElementById("tableBody").getElementsByTagName("tr");
		}

		function prevPage() {
			if (curPage > 1) {
				curPage--;
				changePage(curPage);
			}
		}

		function nextPage() {
			if (curPage < numPages()) {
				curPage++;
				changePage(curPage);
			}
		}

		function changePage(page) {
			for (let i = 0; i < products.length; i++) {
				products[i].style.display = "none";
			}

			for (let i = (page - 1) * recordsPerPage; i < products.length && i < (page * recordsPerPage); i++) {
				products[i].style.display = "table-row";
			}
		}

		function numPages() {
			return Math.ceil(products.length / recordsPerPage);
		}
	</script>

	<jsp:directive.include file="footer.jsp"/>
</body>
<script>
	$(document).ready(function(){
		$(".deleteLink").each(function(){
			$(this).on("click", function(){
				var orderId = $(this).attr("id");
				Swal.fire({
					title: "Are your sure?",
					text: "Do you want to"
				})
			})
		});
	});
</script>
<script>
	window.addEventListener("load", () => {
		const loader = document.querySelector(".loader_wrapper");

		setTimeout(() => {
			loader.classList.add("loader-hidden");

			loader.addEventListener("transitionend", () => {
				document.body.removeChild(loader);
			});
		}, 500);
	});
</script>
</html>