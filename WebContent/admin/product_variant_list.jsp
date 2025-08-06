<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
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
			<div class="row justify-content-center">
				<div class="row custom-row text-center" style="width: fit-content">
					<h1>Product Variant Management</h1>
				</div>
			</div>

			<div class="row justify-content-center text-center mb-5 mt-4">
				<h3><a href="show_product_variant_form" class="btn custom-btn-cart fs-4">Create new Product Variant</a></h3>
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
						<th class="align-middle justify-content-center text-center">ID</th>
						<th class="align-middle justify-content-center text-center">Image</th>
						<th class="align-middle justify-content-center text-center">Name</th>
						<th class="align-middle justify-content-center text-center">Color</th>
						<th class="align-middle justify-content-center text-center">Size</th>
						<th class="align-middle justify-content-center text-center">Material</th>
						<th class="align-middle justify-content-center text-center">Price</th>
						<th class="align-middle justify-content-center text-center">Actions</th>
					</tr>
					</thead>

					<tbody id="tableBody">
					<c:forEach var="variant" items="${productVariantList}" varStatus="status">
						<tr>
							<td class="align-middle justify-content-center text-center">${variant.id}</td>
							<td>
								<img src="${variant.image}" width="250" height="240"/>
							</td>

							<td class="align-middle justify-content-center text-center">${variant.productId} - ${variant.productName}</td>
							<td class="align-middle justify-content-center text-center">${variant.colorName}</td>
							<td class="align-middle justify-content-center text-center">${variant.sizeName}</td>
							<td class="align-middle justify-content-center text-center">${variant.materialName}</td>
							<td class="align-middle justify-content-center text-center">${variant.price}</td>

							<td class="align-middle justify-content-center text-center">
								<a href="show_product_variant_form?id=${variant.id}" class="btn custom-btn-details">Edit</a>	&nbsp;
								<a href="javascript:void(0)" class="deleteLink btn custom-btn-delete" id="${variant.id}">Delete</a> &nbsp;
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
	$(document).ready(function(){
		$(".deleteLink").each(function(){
			$(this).on("click", function(){
				var productVariantId = $(this).attr("id");
				if(confirm("Are you sure you want to delete the product variant with id: " + productVariantId + " ?")){
					window.location = "product_variant_delete?id=" + productVariantId;
				}
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