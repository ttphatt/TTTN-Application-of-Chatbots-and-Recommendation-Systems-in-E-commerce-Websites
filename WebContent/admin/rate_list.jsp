<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
		<title>Managing Rates</title>
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
					<h1>Rate Management</h1>
				</div>
			</div>

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

			<div class="row justify-content-center">
				<table  class="table table-striped table-bordered table-hover table-list-admin-custom" style="width: 1400px">
					<thead class="table-dark">
					<tr>
						<th class="align-middle justify-content-center text-center">Index</th>
						<th class="align-middle justify-content-center text-center">ID</th>
						<th class="align-middle justify-content-center text-center">Product</th>
						<th class="align-middle justify-content-center text-center">Rating stars</th>
						<th class="align-middle justify-content-center text-center">Headline's rate</th>
						<th class="align-middle justify-content-center text-center">Customer's full name</th>
						<th class="align-middle justify-content-center text-center">Review date</th>
						<th class="align-middle justify-content-center text-center">Actions</th>
					</tr>
					</thead>

					<tbody id="tableBody">
					<c:forEach var="rate" items="${rateList}" varStatus="status">
						<tr>
							<td class="align-middle justify-content-center text-center">${status.index + 1}</td>
							<td class="align-middle justify-content-center text-center">${rate.id}</td>
							<td class="align-middle justify-content-center text-center">${rate.productId} - ${rate.productName}</td>
							<td class="align-middle justify-content-center text-center">
								<c:forEach begin="1" end="5" var="i">
									<c:choose>
										<c:when test="${i <= rate.stars}">
											<i class="bi bi-star-fill"></i>
										</c:when>
										<c:otherwise>
											<i class="bi bi-star"></i>
										</c:otherwise>
									</c:choose>
								</c:forEach>
							</td>
							<td class="align-middle justify-content-center text-center">${rate.headline}</td>
							<td class="align-middle justify-content-center text-center">${rate.customerName}</td>
							<td class="align-middle justify-content-center text-center">${rate.time}</td>
							<td class="align-middle justify-content-center text-center">
								<a href="rate_edit?id=${rate.id}" class="btn custom-btn-details">Detail</a>	&nbsp;
								<a href="#" id="${rate.id}" class="deleteLink btn custom-btn-delete">Delete</a>
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
		let recordsPerPage = 10;
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
<script>
	$(document).ready(function(){
		$(".deleteLink").each(function(){
			$(this).on("click", function(event){
				event.preventDefault();
				var rateId = $(this).attr("id");
				Swal.fire({
					title: 'Are you sure?',
					text: "Do you want to delete the rate with id: " + rateId + "?",
					icon: 'question',
					showCancelButton: true,
					confirmButtonColor: '#8BE867',
					cancelButtonColor: '#d33',
					confirmButtonText: 'Yes',
					cancelButtonText: 'No'
				}).then((result) => {
					if (result.isConfirmed) {
						window.location.href = "rate_delete?id=" + rateId;
					}
				});
			})
		});
	});
</script>
</html>