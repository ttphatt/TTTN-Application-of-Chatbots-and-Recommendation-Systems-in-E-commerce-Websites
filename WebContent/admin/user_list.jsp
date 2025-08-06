<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<title>Managing Users</title>		
	<jsp:include page="pagehead.jsp"></jsp:include>

	<link rel="stylesheet" type="text/css" href="../css/custom_background_template.css"/>
	<link rel="stylesheet" type="text/css" href="../css/custom_row_template.css"/>
	<link rel="stylesheet" type="text/css" href="../css/table_list_admin_template.css"/>
	<link rel="stylesheet" type="text/css" href="../css/search_button_template.css"/>

	<jsp:include page="../admin/pageLoad.jsp"/>
	<link rel="stylesheet" type="text/css" href="../css/temp.css" />

</head>
<body>
	<jsp:directive.include file="header.jsp"/>

	<div class="background-div-content">
		<div class="container mb-5 mt-5">
			<div class="row justify-content-center text-center">
				<div class="row custom-row text-center w-50">
					<h1>Staff Management</h1>
				</div>
			</div>

			<div class="row justify-content-center text-center mb-5 mt-4">
				<h3><a href="user_form.jsp" class="btn custom-btn-cart fs-4">Create new Staff</a></h3>
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
				<table  class="table table-striped table-hover table-bordered table-list-admin-custom">
					<thead>
					<tr>
						<th class="align-middle justify-content-center text-center">ID</th>
						<th class="align-middle justify-content-center text-center">Email</th>
						<th class="align-middle justify-content-center text-center">Full Name</th>
						<th class="align-middle justify-content-center text-center">Actions</th>
					</tr>
					</thead>

					<tbody id="tableBody">
					<c:forEach var="user" items="${listUsers}">
						<tr>
							<td class="align-middle justify-content-center text-center">${user.id}</td>
							<td class="align-middle justify-content-center text-center">${user.email}</td>
							<td class="align-middle justify-content-center text-center">${user.fullName}</td>
							<td class="align-middle justify-content-center text-center">
								<c:if test="${sessionScope.userEmail eq user.email}">
									<a href="edit_user?id=${user.id}" class="btn custom-btn-details w-25">Edit</a>	&nbsp;
								</c:if>

								<c:if test="${sessionScope.userEmail ne user.email}">
									<a href="edit_user?id=${user.id}" class="btn custom-btn-details w-25">Edit</a>	&nbsp;
									<a href="javascript:void(0)" class="deleteLink btn custom-btn-delete w-25" id="${user.id}">Delete</a> &nbsp;
								</c:if>
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
		let recordsPerPage = 5;
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
			$(this).on("click", function(){
				var userId = $(this).attr("id");
				if(confirm("Are you sure you want to delete the user with user's id: " + userId + " ?")){
					window.location = "delete_user?id=" + userId;
				}
			})
		});
	});
</script>

</html>