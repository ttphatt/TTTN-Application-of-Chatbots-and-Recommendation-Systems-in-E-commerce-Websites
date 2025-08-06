<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
		<title>Categories Management</title>
		<jsp:include page="pagehead.jsp"></jsp:include>

		<link rel="stylesheet" type="text/css" href="../css/custom_background_template.css"/>
		<link rel="stylesheet" type="text/css" href="../css/custom_row_template.css"/>
		<link rel="stylesheet" type="text/css" href="../css/table_list_admin_template.css"/>
		<link rel="stylesheet" type="text/css" href="../css/search_button_template.css"/>
</head>
<body>
	<jsp:directive.include file="header.jsp"/>

	<jsp:include page="pageLoad.jsp"/>
	<link href="../css/temp.css" rel="stylesheet" type="text/css" />

	<div class="background-div-content">
		<div class="container mb-5 mt-5">
			<div class="row justify-content-center">
				<div class="row custom-row text-center" style="width: fit-content">
					<h1>Categories Management</h1>
				</div>
			</div>

			<div class="row text-center mt-5">
				<h3><a href="prepare_create_category" class="btn custom-btn-cart fs-4">Create new Category</a></h3>
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

			<br>

			<div class="row justify-content-center">
				<table  class="table table-striped table-bordered table-hover table-list-admin-custom" style="width: 1000px">
					<thead class="table-dark">
					<tr>
						<th class="align-middle justify-content-center text-center">ID</th>
						<th class="align-middle justify-content-center text-center">Category Name</th>
						<th class="align-middle justify-content-center text-center"> Group's Name</th>
						<th class="align-middle justify-content-center text-center">Actions</th>
					</tr>
					</thead>

					<tbody id="tableBody">
					<c:forEach var="category" items="${listCategory}">
						<tr>
							<td class="align-middle justify-content-center text-center">${category.id}</td>
							<td class="align-middle justify-content-center text-center">${category.name}</td>
							<td class="align-middle justify-content-center text-center">${category.parentName}</td>
							<td class="align-middle justify-content-center text-center">
								<a href="edit_category?id=${category.id}" class="btn custom-btn-details w-25">Edit</a>	&nbsp;
								<a href="javascript:void(0)" class="deleteLink btn custom-btn-delete w-25 text-center" id="${category.id}">Delete</a> &nbsp;
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
				var categoryId = $(this).attr("id");
				if(confirm("Are you sure you want to delete the category with id: " + categoryId + " ?")){
					window.location = "delete_category?id=" + categoryId;
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