<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>${product.name} - PHK shirts store</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=yes">

    <script type="text/javascript" src="js/jquery-3.7.1.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>


    <link href="../css/radio_button.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" type="text/css" href="css/heart_rating.css"/>
    <link rel="stylesheet" type="text/css" href="css/for_product.css"/>
    <link rel="stylesheet" type="text/css" href="css/search_button_template.css">

    <link rel="stylesheet" type="text/css" href="css/custom_background_template.css"/>
    <link rel="stylesheet" type="text/css" href="css/custom_row_template.css"/>
    <link rel="stylesheet" type="text/css" href="css/custom_border_template.css"/>
    <link rel="stylesheet" type="text/css" href="css/table_template.css"/>

    <style>
        body {
            padding-top: 0;
        }
        .img-fluid {
            max-height: 240px;
            object-fit: cover;
        }
        .card-img-top {
            max-height: 240px;
            object-fit: cover;
        }
        .centered-button {
            display: flex;
            justify-content: center;
            align-items: center;
        }
    </style>
</head>
<body>
<jsp:directive.include file="header.jsp"/>

<div class="background-div-content">
    <div class="container mt-5">
        <!-- Shirt Details Section -->
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="mb-4" style="border:none">
                    <div class="row g-3">
                        <div class="col-md-4 d-flex justify-content-center align-items-center border custom-border">
                            <img src="${product.image}" class="image-product" alt="${product.name}">
                        </div>

                        <div class="col-md-4 d-flex justify-content-center align-items-center">
                            <div align="center">
                                <h2 class="card-title">${product.name}</h2>
                                <br>
                                <p class="card-text">From: ${product.brand}</p>
                                <h3 class="text-success">Price: $${product.price}</h3>
                            </div>
                        </div>

                        <div class="col-md-4 d-flex flex-column justify-content-center align-items-center gap-2">
                            <input type="hidden" id="productId" name="productId" value="${product.id}"/>

                            <div class="mb-3 w-100">
                                <label for="colorSelect" class="form-label">Color</label>
                                <select id="colorSelect" name="colorSelect" class="form-select">
                                    <option value="">Select a color...</option>
                                </select>
                            </div>

                            <div class="mb-3 w-100">
                                <label for="sizeSelect" class="form-label">Size</label>
                                <select id="sizeSelect" name="sizeSelect" class="form-select">
                                    <option value="">Select a size...</option>
                                </select>
                            </div>

                            <div class="mb-3 w-100">
                                <label for="materialSelect" class="form-label">Material</label>
                                <select id="materialSelect" name="materialSelect" class="form-select">
                                    <option value="">Select a material...</option>
                                </select>
                            </div>

                            <button id="buttonAddToCart" class="btn btn-success mt-3 w-100 fs-5">Add to Cart</button>
                        </div>

                    </div>
                </div>
            </div>
        </div>
        <br><br>
        <!-- Shirt Description Section -->
        <div class="row justify-content-center mb-5">
            <div class="col-lg-8">
                <div class="card border custom-border">
                    <div class="card-body text-center p-2">
                        <h2 class="card-title fs-2">Product' Description</h2>
                        <p class="card-text fs-5">${product.description}</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Customer Rates Section -->
        <div class="row justify-content-center mb-5">
            <div class="col-lg-8">
                <div class="card border custom-border">
                    <div class="card-body">
                        <h2 class="card-title text-center"><a id="rates">Customer's Rate</a></h2>
                        <div class="centered-button mb-3 mt-3">
                            <button id="buttonWriteRate" class="btn custom-btn-rate mb-3 fs-5">Rate our shirts</button>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-hover table-custom">
                                <tbody>
                                <c:forEach items="${rates}" var="rate">
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <c:forTokens items="${rate.stars}" delims="," var="star">
                                                    <c:if test="${star eq 'on'}">
                                                        <img src="images/NewWholeStar.png" class="me-1" style="max-width: 15px">
                                                    </c:if>
                                                    <c:if test="${star eq 'off'}">
                                                        <img src="images/NewHollowStar.png" class="me-1" style="max-width: 15px">
                                                    </c:if>
                                                </c:forTokens>

                                            </div>
                                            <div class="mt-2 fs-5">
                                                <b>${rate.headline}: </b>${rate.ratingDetail}
                                            </div>
                                            <div>(Rated by ${rate.customer.fullName} on ${rate.rateTime})</div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<jsp:directive.include file="footer.jsp"/>
</body>
<script type="text/javascript">
    function updateSelect(selector, list, label) {
        const select = $(selector);
        const currentValue = select.val();

        select.empty().append($('<option>', {
            value: "",
            text: "Select a " + label + "..."
        }));

        let found = false;
        list.forEach(p => {
            if (p && p.id && p.value) {
                const option = $('<option>', {
                    value: p.id,
                    text: p.value
                });
                if (p.id == currentValue) found = true;
                select.append(option);
            }
        });

        if (found) {
            select.val(currentValue);
        }
    }

    function onVariantFiltersChange() {
        const productId = $("#productId").val(); // ĐÚNG ID
        const colorId = $("#colorSelect").val();
        const sizeId = $("#sizeSelect").val();
        const materialId = $("#materialSelect").val();

        $.get("/StoreWebsite/api/import_options", {
            productId,
            sizeId,
            colorId,
            materialId
        }, function (data) {
            updateSelect("#colorSelect", data.colors, "color");
            updateSelect("#sizeSelect", data.sizes, "size");
            updateSelect("#materialSelect", data.materials, "material");
        });
    }

    $(document).ready(function () {
        // Load lần đầu khi trang vào
        onVariantFiltersChange();

        // Khi người dùng chọn lại
        $("#colorSelect, #sizeSelect, #materialSelect").on("change", onVariantFiltersChange);

        // Nút Rate
        $("#buttonWriteRate").click(function () {
            const productId = $("#productId").val();
            window.location.href = 'write_rate?productId=' + productId;
        });

        // Nút Add to Cart
        $("#buttonAddToCart").click(function () {
            const productId = $("#productId").val();
            const colorId = $("#colorSelect").val();
            const sizeId = $("#sizeSelect").val();
            const materialId = $("#materialSelect").val();

            if (!colorId || !sizeId || !materialId) {
                alert("Please select color, size, and material!");
                return;
            }

            window.location.href = 'add_to_cart?productId=' + productId +
                '&colorId=' + colorId + '&sizeId=' + sizeId + '&materialId=' + materialId;
        });
    });
</script>

</html>


