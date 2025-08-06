<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" type="text/css" href="../css/search_button_template.css"/>
<link rel="stylesheet" type="text/css" href="../css/custom_background_template.css"/>

<div class="background-div-header">
	<div class="container">
		<div class="row">
			<div class="col">
				<table>
					<tr>
						<td>
							<a href="${pageContext.request.contextPath}/admin/">
								<img src="../images/Privacy_private_security-512.png" class="logo-size">
							</a>
						</td>
						<td>
							<h1>
								<a href="${pageContext.request.contextPath}/admin/" class="text-dark" style="text-decoration: none">
									The Shirt Store Administration
								</a>
							</h1>
						</td>
					</tr>
				</table>
			</div>

			<div class="col justify-content-end align-self-center text-end">
				<h3 class="mb-0 me-3">
					Hi there, ${sessionScope.userFullName}
					<a href="logout" class="btn custom-btn-cart fs-5 ms-2">Logout</a>
				</h3>
			</div>
		</div>

		<!-- Start of logo rows -->
		<div class="container text-center">
			<div class="row justify-content-start mb-3">
				<c:if test="${userRole != 'staff'}">
					<div class="col-2">
						<a href="list_users" class="btn custom-btn-admin-header">
							<img src="../images/profile.png" class="logo-size">
							<div class="mt-2">Staffs</div>
						</a>
					</div>
				</c:if>

				<div class="col-2">
					<a href="list_category" class="btn custom-btn-admin-header">
						<img src="../images/app.png" class="logo-size">
						<div class="mt-2">Category</div>
					</a>
				</div>

				<div class="col-2">
					<a href="list_attributes" class="btn custom-btn-admin-header">
						<img src="../images/app.png" class="logo-size">
						<div class="mt-2">Attribute</div>
					</a>
				</div>

				<div class="col-2">
					<a href="list_tags" class="btn custom-btn-admin-header">
						<img src="../images/app.png" class="logo-size">
						<div class="mt-2">Tag</div>
					</a>
				</div>

				<div class="col-2">
					<a href="list_products" class="btn custom-btn-admin-header">
						<img src="../images/shirt.png" class="logo-size">
						<div class="mt-2">Products</div>
					</a>
				</div>

				<div class="col-2">
					<a href="list_product_variants" class="btn custom-btn-admin-header">
						<img src="../images/service.png" class="logo-size">
						<div class="mt-2">Variants</div>
					</a>
				</div>
			</div>

			<div class="row justify-content-start mb-3">
				<div class="col-2">
					<a href="list_rates" class="btn custom-btn-admin-header">
						<img src="../images/Rate.png" class="logo-size">
						<div class="mt-2">Rate</div>
					</a>
				</div>

				<div class="col-2">
					<a href="list_orders" class="btn custom-btn-admin-header">
						<img src="../images/shopping-cart.png" class="logo-size">
						<div class="mt-2">Order</div>
					</a>
				</div>

				<div class="col-2">
					<a href="list_warehouses" class="btn custom-btn-admin-header">
						<img src="../images/warehouse.png" class="logo-size">
						<div class="mt-2">Warehouse</div>
					</a>
				</div>

				<c:if test="${userRole != 'staff'}">
					<div class="col-2">
						<a href="list_promotions" class="btn custom-btn-admin-header">
							<img src="../images/promotion.png" class="logo-size">
							<div class="mt-2">Promotion</div>
						</a>
					</div>
				</c:if>

				<div class="col-2">
					<a href="chat" class="btn custom-btn-admin-header">
						<img src="../images/messenger.png" class="logo-size">
						<div class="mt-2">Messenger</div>
					</a>
				</div>

				<div class="col-2">
					<a href="list_customer" class="btn custom-btn-admin-header">
						<img src="../images/service.png" class="logo-size">
						<div class="mt-2">Customer</div>
					</a>
				</div>
			</div>
		</div>
		<!-- End of logo rows -->
	</div>
</div>
