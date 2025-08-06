<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=yes">
	<title>Managing Order Details</title>
	<script type="text/javascript" src="../js/jquery-3.7.1.min.js"></script>

	<jsp:include page="pagehead.jsp"></jsp:include>

	<link rel="stylesheet" type="text/css" href="../css/custom_background_template.css"/>
	<link rel="stylesheet" type="text/css" href="../css/custom_row_template.css"/>
	<link rel="stylesheet" type="text/css" href="../css/table_list_admin_template.css"/>
	<link rel="stylesheet" type="text/css" href="../css/search_button_template.css"/>
	<link rel="stylesheet" type="text/css" href="../css/custom_border_template.css"/>

	<link rel="stylesheet" type="text/css" href="../css/table_template.css"/>
</head>
<body>
	<jsp:directive.include file="header.jsp"/>
	<jsp:include page="pageLoad.jsp"/>

	<div class="background-div-content">
		<div class="container mb-5 mt-5">
			<div class="row justify-content-center">
				<div class="row custom-row-1 text-center" style="width: fit-content">
					<h1>Details of Order with ID: ${order.id}</h1>
				</div>
			</div>

			<c:if test="${message != null}">
				<div align="center" style="color: red;">
					<h4>${message}</h4>
				</div>
			</c:if>

			<form action="order_update" method="post">
				<div class="container">
					<div class="row justify-content-center mb-3 mt-5">
						<div class="row custom-row text-center" style="width: fit-content">
							<h2>Order Overview</h2>
						</div>
					</div>

					<div class="row justify-content-center">
						<table border="1" cellpadding="10" style="text-align: left; width: 500px" class="table table-striped table-bordered table-hover table-custom">
							<tr>
								<td><b>Ordered by</b></td>
								<td>${order.customerId} - ${order.customerName}</td>
							</tr>

							<tr>
								<td><b>Order date</b></td>
								<td>${order.date}</td>
							</tr>

							<tr>
								<td><b>Payment method</b></td>
								<td>
									${order.payment}
								</td>
							</tr>

							<tr>
								<td><b>Order status</b></td>
								<td>
									${order.status}
								</td>
							</tr>
						</table>
					</div>

					<div class="row justify-content-center mb-3 mt-5">
						<div class="row custom-row-1 text-center" style="width: fit-content">
							<h2>Recipient's Information</h2>
						</div>
					</div>

					<div class="row justify-content-center">
						<table border="1" cellpadding="10" style="text-align: left; width: 700px" class="table table-striped table-bordered table-hover table-custom">
							<tr>
								<td><b>Recipient' first name</b></td>
								<td>${order.firstname}</td>
							</tr>
							<tr>
								<td><b>Recipient' last name</b></td>
								<td>${order.lastname}</td>
							</tr>

							<tr>
								<td><b>Recipient's phone</b></td>
								<td>${order.phone}</td>
							</tr>

							<tr>
								<td><b>Address line 1</b></td>
								<td>${order.addressLine1}</td>
							</tr>

							<tr>
								<td><b>Address line 2</b></td>
								<td>${order.addressLine2}</td>
							</tr>

							<tr>
								<td><b>City</b></td>
								<td>${order.city}</td>
							</tr>

							<tr>
								<td><b>State</b></td>
								<td>${order.state}</td>
							</tr>

							<tr>
								<td><b>Country</b></td>
								<td>
									${order.country}
								</td>
							</tr>

							<tr>
								<td><b>Zip code</b></td>
								<td>${order.zipcode}</td>
							</tr>
						</table>
					</div>
				</div>

				<div class="row justify-content-center mb-3 mt-5">

					<div class="row custom-row mb-4" style="width: fit-content">
						<h2>Ordered Products</h2>
					</div>

					<table border="1" cellpadding="10" style="text-align: center; width: 1200px" class="table table-striped table-bordered table-hover table-custom">
						<thead class="thead-dark">
						<tr>
							<th class="align-middle justify-content-center text-center">Index</th>
							<th colspan="2" class="align-middle justify-content-center text-center">Product</th>
							<th class="align-middle justify-content-center text-center">Brand</th>
							<th class="align-middle justify-content-center text-center">Color</th>
							<th class="align-middle justify-content-center text-center">Size</th>
							<th class="align-middle justify-content-center text-center">Material</th>
							<th class="align-middle justify-content-center text-center">Price</th>
							<th class="align-middle justify-content-center text-center">Quantity</th>
							<th class="align-middle justify-content-center text-center">Sub total</th>
						</tr>
						</thead>

						<tbody>
						<c:forEach items="${orderDetailList}" var="orderDetail" varStatus="status">
							<tr>
								<td class="align-middle justify-content-center text-center">${status.index + 1}</td>
								<td class="align-middle justify-content-center text-center">
									<img src="${orderDetail.productVariant.image}" width="150" height="140"/>
								</td>

								<td class="align-middle justify-content-center text-center">
										${orderDetail.productVariant.productId} - ${orderDetail.productVariant.productName}
								</td>
								<td class="align-middle justify-content-center text-center">${orderDetail.productVariant.brand}</td>
								<td class="align-middle justify-content-center text-center">${orderDetail.productVariant.colorName}</td>
								<td class="align-middle justify-content-center text-center">${orderDetail.productVariant.sizeName}</td>
								<td class="align-middle justify-content-center text-center">${orderDetail.productVariant.materialName}</td>
								<td class="align-middle justify-content-center text-center">
									<input type="hidden" name="shirtPrice" value="${orderDetail.productVariant.price}"/>
									<fmt:formatNumber type="currency" value="${orderDetail.productVariant.price}"/>
								</td>
								<td class="align-middle justify-content-center text-center">
									<input type="hidden" name="shirtId" value="${orderDetail.productVariant.productId}"/>
										${orderDetail.quantity}
								</td>
								<td class="align-middle justify-content-center text-center"><fmt:formatNumber type="currency" value="${orderDetail.subTotal}"/></td>
							</tr>
						</c:forEach>

						<tr >
							<td colspan="10" class="text-end">
								<p>Subtotal: <fmt:formatNumber type="currency" value="${order.subtotal}"/></p>
								<p>Tax: <fmt:formatNumber type="currency" value="${order.tax}"/></p>
								<p>Shipping fee: <fmt:formatNumber type="currency" value="${order.shippingFee}"/></p>

								<%--Promotion Display Section--%>
								<c:if test="${fn:length(orderPromotions) > 0}">
									<c:forEach items="${orderPromotions}" var="orderPromotion">
										<c:choose>
											<c:when test="${orderPromotion.promotionType eq 'shipping_discount'}">
												<p><b>Shipping Discount: </b><fmt:formatNumber type="currency" value="-${orderPromotion.discountPrice}"/></p>
												<c:if test="${fn:length(orderPromotions) == 1}">
													<p><b>Order Discount: </b><fmt:formatNumber type="currency" value="0"/></p>
												</c:if>
											</c:when>

											<c:otherwise>
												<c:if test="${fn:length(orderPromotions) == 1}">
													<p><b>Shipping Discount: </b><fmt:formatNumber type="currency" value="0"/></p>
												</c:if>
												<p><b>Order Discount: </b><fmt:formatNumber type="currency" value="-${orderPromotion.discountPrice}"/></p>
											</c:otherwise>
										</c:choose>
									</c:forEach>
								</c:if>

								<c:if test="${fn:length(orderPromotions) == 0}">
									<p><b>Shipping Discount: </b><fmt:formatNumber type="currency" value="0"/></p>
									<p><b>Order Discount: </b><fmt:formatNumber type="currency" value="0"/></p>
								</c:if>

								<%--Order sum display section--%>
								<p>Total: <fmt:formatNumber type="currency" value="${order.orderSum}"/></p>
							</td>
						</tr>
						</tbody>
					</table>
				</div>

				<br><br>
				<div align="center">
					<button type="button" class="btn custom-btn-return" onclick="javascript:window.location.href='list_orders';">Back</button>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<c:if test="${order.status == 'Processing'}">
						<a href="#" class="btn custom-btn-submit" onclick="checkStock(${order.id})">Shipping</a>
					</c:if>

					<c:if test="${order.status == 'Shipping'}">
						<a href="order_delivered?orderId=${order.id}" class="btn custom-btn-cart">Delivered</a>
					</c:if>

					<c:if test="${order.status == 'Delivered'}">
						<a href="order_completed?orderId=${order.id}" class="btn custom-btn-cart">Completed</a>
					</c:if>

					<c:if test="${order.status == 'Delivered'}">
						<a href="order_returned?orderId=${order.id}" class="btn custom-btn-cart">Returned</a>
					</c:if>
				</div>
			</form>
		</div>
	</div>

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
	function checkStock(orderId) {
		fetch('/StoreWebsite/api/order_shipping_check', {
			method: 'POST',
			headers: {
				'Content-Type': 'application/x-www-form-urlencoded',
			},
			body: 'orderId=' + orderId
		})
				.then(response => response.json())
				.then(data => {
					if (data.success) {
						window.location.href = 'order_shipping?orderId=' + orderId;
					} else {
						alert(data.message || 'Not Enough Stock.');
					}
				})
				.catch(error => {
					console.error('Lỗi:', error);
					alert('Error.');
				});
	}
</script>

</html>