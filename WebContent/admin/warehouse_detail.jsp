<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>

<head>
    <jsp:include page="pagehead.jsp"></jsp:include>
    <jsp:include page="pageLoad.jsp"/>
    <title>Warehouse Detail</title>

    <link href="../css/warehouse-style.css" rel="stylesheet" type="text/css" />

    <link rel="stylesheet" type="text/css" href="../css/custom_background_template.css"/>
    <link rel="stylesheet" type="text/css" href="../css/custom_row_template.css"/>
    <link rel="stylesheet" type="text/css" href="../css/table_list_admin_template.css"/>
    <link rel="stylesheet" type="text/css" href="../css/search_button_template.css"/>
    <link rel="stylesheet" type="text/css" href="../css/custom_border_template.css"/>
</head>

<body class="body-2">

    <jsp:directive.include file="header.jsp" />

    <div class="background-div-content">
        <div class="container">
            <div class="w-layout-blockcontainer w-container">
                <div class="nav-wrapper">
                    <h1 class="heading-h1">Warehouse</h1>

                    <div class="nav-button-wrapper">
                        <a href="list_imports" class="button w-button">View Import Receipt</a>
                        <a href="show_import_form" class="button w-button">Create Import Receipt</a>
                        <a href="list_warehouses" class="button w-button">Stock Check</a>
                    </div>

                    <h1 class="heading-h2">Warehouse Detail</h1>
                </div>

                <div class="form-wrapper w-form border custom-border">
                    <form id="product-form" name="product-form" data-name="Product Form" method="get" class="form" action="#">
                        <div class="fields-wrapper">
                            <label for="productId" class="field-label">Product ID</label>
                            <input class="text-field w-input" maxlength="256" name="productId" data-name="Product Id" placeholder=""
                                   type="text" id="productId" value="${product.id}" readonly />
                        </div>
                        <div class="fields-wrapper">
                            <label for="productName" class="field-label">Product Name</label>
                            <input class="text-field w-input" maxlength="256" name="productName" data-name="Product Name" placeholder=""
                                   type="text" id="productName" value="${product.name}" readonly />
                        </div>
                    </form>
                </div>

                <table class="table-wrapper">
                    <thead class="table_head">
                    <tr class="table_row">
                        <th class="table_header align-middle text-center">ID</th>
                        <th class="table_header align-middle text-center">Color</th>
                        <th class="table_header align-middle text-center">Size</th>
                        <th class="table_header align-middle text-center">Material</th>
                        <th class="table_header align-middle text-center">Quantity</th>
                    </tr>
                    </thead>
                    <tbody class="table_body">
                    <c:forEach var="warehouse" items="${warehouseList}">
                        <tr class="table_row">
                            <td class="table_cell align-middle text-center">${warehouse.productVariantId}</td>
                            <td class="table_cell align-middle text-center">${warehouse.color}</td>
                            <td class="table_cell align-middle text-center">${warehouse.size}</td>
                            <td class="table_cell align-middle text-center">${warehouse.material}</td>
                            <td class="table_cell align-middle text-center">${warehouse.quantity}</td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script src="../js/warehouse-js.js" type="text/javascript"></script>
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

    <jsp:directive.include file="footer.jsp" />

</body>
</html>