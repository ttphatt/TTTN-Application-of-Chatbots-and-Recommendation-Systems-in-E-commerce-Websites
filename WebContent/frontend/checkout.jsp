<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Check out</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=yes">
    <%--    <script type="text/javascript" src="js/jquery-3.7.1.min.js"></script>--%>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script type="text/javascript" src="js/jquery.validate.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" type="text/css" href="css/table_product_template.css"/>

    <link rel="stylesheet" type="text/css" href="css/custom_background_template.css"/>
    <link rel="stylesheet" type="text/css" href="css/custom_row_template.css"/>
    <link rel="stylesheet" type="text/css" href="css/custom_border_template.css"/>
    <link rel="stylesheet" type="text/css" href="css/form_check_input_template.css"/>

    <style>
        .error {
            color: red;
            font-size: 0.875em; /* Adjust font size if needed */
        }
    </style>
</head>
<body>
<jsp:directive.include file="header.jsp"/>

<div class="background-div-content">
    <div class="container">
        <c:if test="${message != null}">
            <div class="row justify-content-center">
                <div class="alert alert-danger" role="alert">
                        ${message}
                </div>
            </div>
        </c:if>

        <c:set var="cart" value="${sessionScope['cart']}" />

        <c:if test="${cart.totalItems == 0}">
            <div class="row justify-content-center">
                <h2>There is nothing in your cart</h2>
            </div>
        </c:if>

        <c:if test="${cart.totalItems > 0}">
            <div class="row justify-content-start mt-5">
                <h2>Review your order details <a href="view_cart" class="btn custom-btn-details btn-lg" style="font-size: large">Edit</a></h2>
            </div>

            <br>

            <div class="row justify-content-end">
                <table class="table table-bordered table-hover table-product-custom">
                    <thead class="table-dark">
                    <tr>
                        <th class="text-center">No</th>
                        <th colspan="2" class="text-center">Product</th>
                        <th class="text-center">Color</th>
                        <th class="text-center">Size</th>
                        <th class="text-center">Material</th>
                        <th class="text-center">Brand</th>
                        <th class="text-center">Price</th>
                        <th class="text-center">Quantity</th>
                        <th class="text-center">Subtotal</th>
                    </tr>
                    </thead>

                    <tbody>
                    <c:forEach var="item" items="${cart.carts}" varStatus="status">
                        <tr align="center">
                            <td class="text-center">${status.index + 1}</td>
                            <td class="text-center">
                                <img src="${item.productVariant.image}" class="img-fluid" style="width: 150px; height: auto;" />
                            </td>

                            <td class="text-center">
                                    ${item.productVariant.productName}
                            </td>

                            <td class="text-center">
                                    ${item.productVariant.colorName}
                            </td>

                            <td class="text-center">
                                    ${item.productVariant.sizeName}
                            </td>

                            <td class="text-center">
                                    ${item.productVariant.materialName}
                            </td>

                            <td class="text-center">${item.productVariant.brand}</td>

                            <td class="text-center"><fmt:formatNumber value="${item.productVariant.price}" type="currency"></fmt:formatNumber></td>

                            <td class="text-center">
                                <input type="text" name="quantity${status.index + 1}" value="${item.quantity}" class="form-control text-center" size="5" readonly="readonly"/>
                            </td>

                            <td class="text-center"><fmt:formatNumber value="${item.quantity * item.productVariant.price}" type="currency"></fmt:formatNumber></td>
                        </tr>
                    </c:forEach>

                    <tr>
                        <td colspan="10" class="text-end">
                            <p><b>Number of Products:</b> ${cart.totalQuantity}</p>
                            <p><b>Subtotal: </b><fmt:formatNumber value="${cart.totalAmount}" type="currency" /></p>
                            <p><b>Tax: </b><fmt:formatNumber value="${tax}" type="currency" /></p>
                            <p><b>Shipping fee: </b><fmt:formatNumber value="${shippingFee}" type="currency" /></p>

                                <%--Discount Display Section--%>
                            <p><b>Shipping Discount: </b>
                                <span id="shippingDiscountPrice"><fmt:formatNumber value="0" type="currency"/></span>
                            </p>

                            <p><b>Order's Discount: </b>
                                <span id="orderDiscountPrice"><fmt:formatNumber value="0" type="currency"/></span>
                            </p>

                                <%--Order sum or total price display section--%>
                            <p><b>Total price: </b>
                                <span id="spanTotalPrice"><fmt:formatNumber value="${totalPrice}" type="currency" /></span>
                            </p>

                            <div align="right">
                                <form id="orderPromoForm">
                                    <div class="input-group w-50">
                                        <c:if test="${orderPromotionId eq null}">
                                            <input id="orderPromotionId" type="text" class="form-control" placeholder="Enter your order promotion code here">
                                            <button id="orderPromoSubmit" type="submit" class="btn custom-btn-cart" style="font-size: large">Enter</button>
                                            &nbsp;
                                            <!--Order Promotion Dropdown list-->
                                            <div class="btn-group custom-dropdown">
                                                <button id="dropdownOrderPromotions" type="button" class="btn btn-danger dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false" style="font-size: large">
                                                    Show promotion code
                                                </button>
                                                <ul class="dropdown-menu">
                                                    <c:forEach items="${orderPromotions}" var="orderPromotion">
                                                        <li><a class="orderPromoId dropdown-item" id="${orderPromotion.key}" style="font-size: large">${orderPromotion.value}</a></li>
                                                        <li><hr class="dropdown-divider"></li>
                                                    </c:forEach>
                                                </ul>
                                            </div>
                                            <%---------------------------------%>

                                        </c:if>
                                    </div>
                                </form>
                            </div>

                            <br>

                            <div align="right">
                                <form id="shippingPromoForm">
                                    <div class="input-group w-50" align="right">
                                        <c:if test="${shippingPromotionId eq null}">
                                            <input id="shippingPromotionId" type="text" class="form-control" placeholder="Enter your shipping promotion code here">
                                            <button id="shippingPromoSubmit" type="submit" class="btn custom-btn-cart" style="font-size: large">Enter</button>
                                            &nbsp;
                                            <!-- Example single danger button -->
                                            <div class="btn-group custom-dropdown">
                                                <button id="dropdownShippingPromotions" type="button" class="btn btn-danger dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false" style="font-size: large">
                                                    Show shipping promotion code
                                                </button>
                                                <ul class="dropdown-menu">
                                                    <c:forEach items="${shippingPromotions}" var="shippingPromotion">
                                                        <li><a class="shippingPromoId dropdown-item" id="${shippingPromotion.key}" style="font-size: large">${shippingPromotion.value}</a></li>
                                                        <li><hr class="dropdown-divider"></li>
                                                    </c:forEach>
                                                </ul>
                                            </div>
                                        </c:if>
                                    </div>
                                </form>
                            </div>


                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>

            <div class="row justify-content-center mt-5">
                <div class="row custom-row-1 w-50 text-center">
                    <h2>Recipient's information</h2>
                </div>
            </div>

            <br>

            <form id="orderForm" action="place_order" method="post">
                <div class="row justify-content-center">
                    <div class="col-md-8">
                        <div class="mb-3">
                            <label for="firstname" class="form-label">Recipient's first name</label>
                            <input type="text" class="form-control" id="firstname" name="firstname" value="${customer.firstname}" required="required">
                        </div>

                        <div class="mb-3">
                            <label for="lastname" class="form-label">Recipient's last name</label>
                            <input type="text" class="form-control" id="lastname" name="lastname" value="${customer.lastname}" required="required">
                        </div>

                        <div class="mb-3">
                            <label for="phoneNumber" class="form-label">Recipient's phone</label>
                            <input type="text" class="form-control" id="phoneNumber" name="phoneNumber" value="${customer.phoneNumber}" required="required">
                        </div>

                        <div class="mb-3">
                            <label for="addressLine1" class="form-label">Address 1</label>
                            <input type="text" class="form-control" id="addressLine1" name="addressLine1" value="${customer.addressLine1}" required="required">
                        </div>

                        <div class="mb-3">
                            <label for="addressLine2" class="form-label">Address 2</label>
                            <input type="text" class="form-control" id="addressLine2" name="addressLine2" value="${customer.addressLine2}" required="required">
                        </div>

                        <div class="mb-3">
                            <label for="city" class="form-label">City</label>
                            <input type="text" class="form-control" id="city" name="city" value="${customer.city}" required="required">
                        </div>

                        <div class="mb-3">
                            <label for="state" class="form-label">State</label>
                            <input type="text" class="form-control" id="state" name="state" value="${customer.state}" required="required">
                        </div>

                        <div class="mb-3">
                            <label for="zip" class="form-label">Zip Code</label>
                            <input type="text" class="form-control" id="zip" name="zip" value="${customer.zipcode}" required="required">
                        </div>

                        <div class="mb-3">
                            <label for="country" class="form-label">Country</label>
                            <select class="form-select" id="country" name="country">
                                <c:forEach items="${mapCountries}" var="country">
                                    <option value="${country.value}" <c:if test='${customer.country eq country.value}'>selected='selected'</c:if>>${country.key}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="row mb-1 mt-5 justify-content-center">
                            <div class="col text-center">
                                <button type="button" class="btn custom-btn-cart" style="max-width: 200px;" onclick="updateAddress();">Update Address</button>
                            </div>
                        </div>
                    </div>
                </div>

                    <%--Payment method display section--%>
                <div class="row justify-content-center">
                    <div class="row custom-row w-25 mt-5 text-center">
                        <h2>Payment method</h2>
                    </div>
                </div>

                <br>

                <div class="row justify-content-center mb-5">
                    <div class="row w-25 border custom-border" style="border-radius: 30px">
                        <div class="form-check mb-5">
                            <input class="form-check-input fs-5" type="radio" name="payment" id="radioButtonCOD" value="COD" checked>
                            <label class="form-check-label fs-5" for="radioButtonCOD">
                                <img src="images/cash-on-delivery.png" style="max-width: 40px; max-height: 40px">
                                &nbsp;&nbsp;
                                COD
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input fs-5" type="radio" name="payment" id="radioButtonPaypal" value="PAYPAL">
                            <label class="form-check-label fs-5" for="radioButtonPaypal">
                                <img src="images/paypal.png" style="max-width: 40px; max-height: 40px">
                                &nbsp;&nbsp;
                                Paypal
                            </label>
                        </div>
                    </div>
                </div>



                    <%----------------------------------------------------------%>


                <div class="row justify-content-center mb-3">
                    <div class="col-md-8 d-grid gap-2 d-md-flex justify-content-md-end">
                        <button type="submit" class="btn custom-btn-cart" style="font-size: large">Place Your Order</button>
                        <a href="${pageContext.request.contextPath}/" class="btn custom-btn-return" style="font-size: large">Continue Shopping</a>
                    </div>
                </div>
            </form>
        </c:if>
    </div>
</div>

<jsp:directive.include file="footer.jsp"/>
</body>
<script type="text/javascript">
    $(document).ready(function(){
        $(".orderPromoId").each(function (){
            $(this).on("click",function (event){
                event.preventDefault();
                $("#orderPromotionId").val($(this).attr("id"));
            })
        });

        $('.shippingPromoId').each(function (){
            $(this).on("click", function (event){
                event.preventDefault();
                $("#shippingPromotionId").val($(this).attr("id"));
            })
        });

        $("#orderPromoForm").submit(function (event){
            event.preventDefault();
            var orderPromotionId = $("#orderPromotionId").val();
            var subTotal = "${cart.totalAmount}";

            if(orderPromotionId.trim() === ""){
                getMessageContent("NOT_NULL_ORDER_PROMOTION_CODE", event)
            }
            else{
                $.ajax({
                    url: "check_order_promotion",
                    type: "POST",
                    data:{
                        orderPromotionId: orderPromotionId,
                        subTotal: subTotal
                        // totalPrice: totalPrice
                    },
                    success: function (response){
                        if(response.valid){
                            Swal.fire({
                                title: 'Are you sure you want to apply this promotion? Please remind yourself that you cannot change this',
                                text: "You will get " + response.discountPrice + " discount of your order",
                                icon: 'question',
                                showCancelButton: true,
                                confirmButtonColor: '#3085d6',
                                cancelButtonColor: '#d33',
                                confirmButtonText: 'Yes, certainly!',
                                cancelButtonText: 'No, I change my mind'
                            }).then((result) => {
                                if (result.isConfirmed) {
                                    $("#orderDiscountPrice").text(formatCurrency(response.discountPrice));
                                    $("#orderPromotionId").prop('readonly', true);
                                    $("#orderPromoSubmit").prop('disabled', true)
                                    $("#dropdownOrderPromotions").prop('disabled', true);
                                    $("#spanTotalPrice").text(formatCurrency(response.newTotalPrice));

                                    $.ajax({
                                        url: "update_order_sum_after_promotion",
                                        type: "POST",
                                        data:{
                                            updateTotalPrice: response.newTotalPrice
                                        },
                                        success: function (){
                                            getMessageContent("SUCCESS_APPLY_PROMOTION", event);
                                        },
                                        error: function (){
                                            getMessageContent("FAIL_APPLY_PROMOTION", event)
                                        }
                                    })
                                }
                            });
                        }
                        else{
                            Swal.fire("Invalid: " + response.message);
                            $("#orderDiscountPrice").text(formatCurrency(0));
                        }
                    },
                    error: function (){
                        Swal.fire("Error !!!");
                    }
                });
            }
        });

        $("#shippingPromoForm").submit(function (event){
            event.preventDefault();
            var shippingPromotionId = $("#shippingPromotionId").val();
            var subTotal = "${cart.totalAmount}";
            <%--var totalPrice = "${totalPrice}";--%>

            if(shippingPromotionId === ""){
                getMessageContent("NOT_NULL_SHIPPING_PROMOTION_CODE", event)
            }
            else{
                $.ajax({
                    url: "check_shipping_promotion",
                    type: "POST",
                    data: {
                        shippingPromotionId: shippingPromotionId,
                        subTotal: subTotal
                    },
                    success: function(response){
                        if(response.valid){
                            Swal.fire({
                                title: 'Are you sure you want to apply this promotion? Please remind yourself that you cannot change this',
                                text: "You will get " + response.discountPrice + " discount of your shipping fee",
                                icon: 'question',
                                showCancelButton: true,
                                confirmButtonColor: '#3085d6',
                                cancelButtonColor: '#d33',
                                confirmButtonText: 'Yes, certainly!',
                                cancelButtonText: 'No, I change my mind'
                            }).then((result) => {
                                if (result.isConfirmed) {
                                    $("#shippingDiscountPrice").text(formatCurrency(response.discountPrice));
                                    $("#shippingPromotionId").prop('readonly', true);
                                    $("#shippingPromoSubmit").prop('disabled', true)
                                    $("#dropdownShippingPromotions").prop('disabled', true);
                                    $("#spanTotalPrice").text(formatCurrency(response.newTotalPrice));

                                    $.ajax({
                                        url: "update_order_sum_after_promotion",
                                        type: "POST",
                                        data:{
                                            updateTotalPrice: response.newTotalPrice
                                        },
                                        success: function (){
                                            getMessageContent("SUCCESS_APPLY_PROMOTION", event);
                                        },
                                        error: function (){
                                            getMessageContent("FAIL_APPLY_PROMOTION", event)
                                        }
                                    })
                                }
                            });
                        }
                        else{
                            Swal.fire("Invalid: " + response.message);
                        }
                    },
                    error: function (){
                        Swal.fire("Error!!!!!");
                    }
                })
            }
        });

        $("#testButton").on("click", function (event){
            var promoId = $("#orderPromotionId").val();
            if(promoId.trim() === ""){
                Swal.fire("Empty promo id");
            }
            else{
                Swal.fire("Invalid: " + response.message);
            }
        });

        function formatCurrency(amount){
            return new Intl.NumberFormat('en-US', {style: 'currency', currency: 'USD'}).format(amount);
        }

        function getMessageContent(messageId, event){
            fetch('csvdata?id=' + messageId)
                .then(response => response.json())
                .then(data =>{
                    if(data.message){
                        Swal.fire({
                            title: data.message,
                            icon: "info",
                            html: `
                        <p>${data.message}</p>
                    `,
                            showCloseButton: true,
                            confirmButtonText: "OK",
                            focusConfirm: false
                        });
                        event.preventDefault();
                    }
                    else{
                        Swal.fire("Message not found");
                        event.preventDefault();
                    }
                })
                .catch(error => console.error("Error: ", error));
        }

        $("#orderForm").submit(function (event){
            var firstname = $("#firstname").val();
            var lastname = $("#lastname").val();
            var phoneNumber = $("#phoneNumber").val();
            var addressLine1 = $("#addressLine1").val();
            var addressLine2 = $("#addressLine2").val();
            var city = $("#city").val();
            var state = $("#state").val();
            var zip = $("#zip").val();
            var phoneRegex = /^[0-9]{7,10}$/;
            // var phoneRegex = /^[+]?[(]?[0-9]{1,4}[)]?[-\s./0-9]*$/;
            var specialSymbolsAndNumbersRegex = /[0-9!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]+/;


            if(firstname.trim() === ""){
                getMessageContent("NOT_NULL_FIRSTNAME", event);
            }
            else if(specialSymbolsAndNumbersRegex.test(firstname)){
                getMessageContent("SPECIAL_CHARACTER_NUMBER_IN_FIRSTNAME", event)
                event.preventDefault();
            }
            else if(lastname.trim() === ""){
                getMessageContent("NOT_NULL_LASTNAME", event);
            }
            else if(specialSymbolsAndNumbersRegex.test(lastname)){
                getMessageContent("SPECIAL_CHARACTER_NUMBER_IN_LASTNAME", event)
                event.preventDefault();
            }
            else if(phoneNumber.trim() === ""){
                getMessageContent("NOT_NULL_NUMBER_PHONE", event);
            }
            else if(!phoneRegex.test(phoneNumber)){
                getMessageContent("INVALID_NUMBER_PHONE", event);
                event.preventDefault();
            }
            else if(addressLine1.trim() === ""){
                getMessageContent("NOT_NULL_ADDRESS_LINE_1", event);
            }
            else if(addressLine2.trim() === ""){
                getMessageContent("NOT_NULL_ADDRESS_LINE_2", event);
            }
            else if(city.trim() === ""){
                getMessageContent("NOT_NULL_CITY", event);
            }
            else if(state.trim() === ""){
                getMessageContent("NOT_NULL_STATE", event);
            }
            else if(zip.trim() === ""){
                getMessageContent("NOT_NULL_ZIP_CODE", event);
            }
            else if(zip.length > 9 || zip.length < 5){
                getMessageContent("INVALID_LENGTH_ZIP_CODE", event);
                event.preventDefault();
            }
            else if(!$("#radioButtonCOD").is(":checked") && !$("#radioButtonPaypal").is(":checked")){
                getMessageContent("NOT_NULL_PAYMENT_METHOD", event);
                event.preventDefault();
            }
        });

        $("#orderForm").validate({
            rules:{
                firstname: "required",
                lastname: "required",
                phoneNumber: "required",
                addressLine1: "required",
                addressLine2: "required",
                city: "required",
                state: "required",
                zip: "required",
                country: "required",
            },

            messages:{
                firstname: "",
                lastname: "",
                phoneNumber: "",
                addressLine1: "",
                addressLine2: "",
                city: "",
                state: "",
                zip: "",
                country: "",
            }
        });
    });
</script>
<script>
    function updateAddress(event) {
        // Lấy dữ liệu từ các trường trong form
        let firstname = document.getElementById('firstname').value.trim();
        let lastname = document.getElementById('lastname').value.trim();
        let phoneNumber = document.getElementById('phoneNumber').value.trim();
        let addressLine1 = document.getElementById('addressLine1').value.trim();
        let addressLine2 = document.getElementById('addressLine2').value.trim();
        let city = document.getElementById('city').value.trim();
        let state = document.getElementById('state').value.trim();
        let zip = document.getElementById('zip').value.trim();
        let country = document.getElementById('country').value.trim();
        let phoneRegex = /^[0-9]{7,10}$/;
        var specialSymbolsAndNumbersRegex = /[0-9!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]+/;

        // Kiểm tra từng trường hợp lỗi
        if (firstname === "") {
            getMessageContent("NOT_NULL_FIRSTNAME", event);
        }
        else if(specialSymbolsAndNumbersRegex.test(firstname)){
            getMessageContent("SPECIAL_CHARACTER_NUMBER_IN_FIRSTNAME", event)
            event.preventDefault();
        }
        else if (lastname === "") {
            getMessageContent("NOT_NULL_LASTNAME", event);
        }
        else if(specialSymbolsAndNumbersRegex.test(lastname)){
            getMessageContent("SPECIAL_CHARACTER_NUMBER_IN_LASTNAME", event)
            event.preventDefault();
        }
        else if (phoneNumber === "") {
            getMessageContent("NOT_NULL_NUMBER_PHONE", event);
        }
        else if (!phoneRegex.test(phoneNumber)) {
            getMessageContent("INVALID_NUMBER_PHONE", event);
        }
        else if (addressLine1 === "") {
            getMessageContent("NOT_NULL_ADDRESS_LINE_1", event);
        }
        else if (addressLine2 === "") {
            getMessageContent("NOT_NULL_ADDRESS_LINE_2", event);
        }
        else if (city === "") {
            getMessageContent("NOT_NULL_CITY", event);
        }
        else if (state === "") {
            getMessageContent("NOT_NULL_STATE", event);
        }
        else if (zip === "") {
            getMessageContent("NOT_NULL_ZIP_CODE", event);
        }
        else if(zip.length > 9 || zip.length < 5){
            getMessageContent("INVALID_LENGTH_ZIP_CODE", event);
            event.preventDefault();
        }
        else {
            // Nếu tất cả dữ liệu hợp lệ, thực hiện chuyển hướng
            window.location.href = "updateAddress?firstname=" + firstname + "&lastname=" + lastname + "&phoneNumber=" + phoneNumber + "&addressLine1=" + addressLine1 + "&addressLine2=" + addressLine2 + "&city=" + city + "&state=" + state + "&zip=" + zip + "&country=" + country;
        }
    }

    function getMessageContent(messageId, event) {
        // Sử dụng fetch để lấy thông báo lỗi từ server
        fetch('csvdata?id=' + messageId)
            .then(response => response.json())
            .then(data => {
                if (data.message) {
                    Swal.fire({
                        title: data.message,
                        icon: "info",
                        showCloseButton: true,
                        confirmButtonText: "OK",
                        focusConfirm: false
                    });
                    if (event) event.preventDefault();
                } else {
                    Swal.fire("Message not found");
                    if (event) event.preventDefault();
                }
            })
            .catch(error => console.error("Error: ", error));
    }
</script>
</html>
