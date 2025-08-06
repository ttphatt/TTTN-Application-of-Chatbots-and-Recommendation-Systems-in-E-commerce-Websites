<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Shopping Cart</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=yes">

    <!-- jQuery và jQuery Validate CDN -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/jquery.validation/1.19.5/jquery.validate.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- CSS custom -->
    <link rel="stylesheet" type="text/css" href="css/search_button_template.css"/>
    <link rel="stylesheet" type="text/css" href="css/table_product_template.css"/>
    <link rel="stylesheet" type="text/css" href="css/custom_background_template.css"/>
    <link rel="stylesheet" type="text/css" href="css/custom_row_template.css"/>
    <link rel="stylesheet" type="text/css" href="css/custom_border_template.css"/>
</head>
<body>
<jsp:include page="header.jsp"/>

<div class="background-div-content">
    <div class="container">
        <c:if test="${message != null}">
            <div class="row justify-content-center text-danger">
                <h4>${message}</h4>
            </div>
        </c:if>

        <c:set var="cart" value="${sessionScope['cart']}" />

        <c:if test="${cart == null || cart.totalItems == 0}">
            <div class="row justify-content-center">
                <div class="row custom-row w-50 mb-5 mt-5 text-center">
                    <h2>There is nothing in your cart</h2>
                </div>
            </div>
        </c:if>

        <c:if test="${cart != null && cart.totalItems > 0}">
            <form action="${pageContext.request.contextPath}/update_cart" method="post" id="cartForm">
                <div class="table-responsive">
                    <table class="table table-bordered table-hover table-product-custom text-center align-middle">
                        <thead class="table-dark">
                        <tr>
                            <th>No</th>
                            <th colspan="2">Product</th>
                            <th>Color</th>
                            <th>Size</th>
                            <th>Material</th>
                            <th>Quantity</th>
                            <th>Price</th>
                            <th>Subtotal</th>
                            <th>Action</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="item" items="${cart.carts}" varStatus="status">
                            <tr>
                                <td>${status.index + 1}</td>

                                <td><img src="${item.productVariant.image}" class="img-fluid" style="width: 150px;"></td>

                                <td>${item.productVariant.productId} - ${item.productVariant.productName}</td>

                                <td>${item.productVariant.colorName}</td>

                                <td>${item.productVariant.sizeName}</td>

                                <td>${item.productVariant.materialName}</td>

                                <td>
                                    <input type="hidden" name="productVariantId" value="${item.productVariant.id}"/>
                                    <input type="number" name="quantity" value="${item.quantity}" min="1" class="form-control"/>
                                </td>

                                <td><fmt:formatNumber value="${item.productVariant.price}" type="currency"/></td>

                                <td><fmt:formatNumber value="${item.quantity * item.productVariant.price}" type="currency"/></td>

                                <td>
                                    <button type="button"
                                            class="btn custom-btn-delete btn-sm btn-remove"
                                            data-variant-id="${item.productVariant.id}">
                                        Remove
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>

                        <tr>
                            <td colspan="6"></td>
                            <td><b>${cart.totalQuantity} products</b></td>
                            <td><b>Total</b></td>
                            <td colspan="2"><b><fmt:formatNumber value="${cart.totalAmount}" type="currency"/></b></td>
                        </tr>
                        </tbody>
                    </table>
                </div>

                <div class="row mb-5 mt-4 justify-content-center">
                    <div class="col-auto">
                        <a href="${pageContext.request.contextPath}/" class="btn custom-btn-return me-md-2">Continue Shopping</a>
                        <button type="submit" class="btn custom-btn-submit me-md-2">Update</button>
                        <button type="button" id="clearCart" class="btn custom-btn-delete me-md-2">Clear Cart</button>
                        <a href="${pageContext.request.contextPath}/checkout" class="btn custom-btn-cart">Check Out</a>
                    </div>
                </div>
            </form>

            <script type="text/javascript">
                $(document).ready(function () {
                    // Remove item
                    $(".btn-remove").click(function () {
                        const variantId = $(this).data("variant-id")

                        window.location.href = 'remove_from_cart?productVariantId=' + variantId;
                    });

                    // Clear cart
                    $("#clearCart").click(function () {
                        window.location.href = 'clear_cart';
                    });
                });
            </script>
        </c:if>
    </div>
</div>

<jsp:include page="footer.jsp"/>
</body>
</html>
