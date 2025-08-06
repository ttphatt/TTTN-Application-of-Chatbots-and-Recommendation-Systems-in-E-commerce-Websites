<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
	<jsp:include page="pagehead.jsp"></jsp:include>
	<jsp:include page="pageLoad.jsp"/>
	<meta charset="UTF-8">
	<style>
        .error {
            color: red;
            font-size: 0.875em; /* Adjust font size if needed */
        }
    </style>

	<title>
		<c:if test="${customer != null}">
			Edit Customer
		</c:if>
			
		<c:if test="${customer == null}">
			Create New Customer
		</c:if>
	
	</title>

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
					<h1>
						<c:if test="${customer != null}">
							Edit Customer
						</c:if>

						<c:if test="${customer == null}">
							Create New Customer
						</c:if>
					</h1>
				</div>
			</div>

			<br>
			<br>

			<div class="row justify-content-center text-center">
				<div class="col-md-auto justify-content-center text-center border custom-border" style="border-radius: 20px; padding: 25px">
					<c:if test="${customer != null}">
						<form action="update_customer" method="post" id="customerForm">
						<input type="hidden" name="customerId" value="${customer.id}"/>
					</c:if>

					<c:if test="${customer == null}">
						<form action="create_customer" method="post" id="customerForm">
					</c:if>
					<jsp:directive.include file="../common/customer_form.jsp"/>
				</div>
			</div>
		</div>
	</div>

	<jsp:directive.include file="footer.jsp"/>
</body>
<script type="text/javascript" src="../js/customer-form.js">
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