<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>

<head>
    <jsp:include page="pagehead.jsp"></jsp:include>
    <jsp:include page="pageLoad.jsp"/>

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

                    <h1 class="heading-h2">Import Receipt Detail</h1>
                </div>

                <div class="form-wrapper w-form border custom-border">
                    <form id="email-form" name="email-form" data-name="Email Form" method="get" class="form" action="#">
                        <div class="fields-wrapper">
                            <label for="name" class="field-label">Staff&#x27;s Name</label>
                            <input class="text-field w-input" maxlength="256" name="name" data-name="Name" placeholder=""
                                   type="text" id="name" value="${importInfo.userId} - ${importInfo.userName}" readonly />
                        </div>

                        <div class="fields-wrapper">
                            <label for="name-2" class="field-label">Import&#x27;s ID</label>
                            <input class="text-field w-input" maxlength="256" name="name-2" data-name="Name 2" placeholder=""
                                   type="text" id="name-2" value="${importInfo.id}" readonly/>
                        </div>

                        <div class="fields-wrapper">
                            <label for="name-2" class="field-label">Total price</label>
                            <input class="text-field w-input" maxlength="256" name="name-2" data-name="Name 2" placeholder=""
                                   type="text" id="name-2" value="${importInfo.totalPrice}" readonly />
                        </div>

                        <div class="fields-wrapper is-contains-datefield">
                            <label for="name-3" class="field-label">Created Date</label>
                            <input type="text" class="input" value="${importInfo.date}" readonly/>
                        </div>
                    </form>
                </div>

                <table class="table-wrapper">
                    <thead class="table_head">
                    <tr class="table_row">
                        <th class="table_header align-middle text-center">Index</th>
                        <th class="table_header align-middle text-center">Product&#x27;s Name</th>
                        <th class="table_header align-middle text-center">Color</th>
                        <th class="table_header align-middle text-center">Size</th>
                        <th class="table_header align-middle text-center">Material</th>
                        <th class="table_header align-middle text-center">Quantity</th>
                        <th class="table_header align-middle text-center">Price</th>
                        <th class="table_header align-middle text-center">Total</th>
                    </tr>
                    </thead>
                    <tbody class="table_body">
                    <c:forEach var="import_detail" items="${importDetailList}" varStatus="status">
                        <tr class="table_row">
                            <td class="table_cell align-middle text-center">${status.index + 1}</td>
                            <td class="table_cell align-middle text-center">${import_detail.productVariant.productId} - ${import_detail.productVariant.productName}</td>
                            <td class="table_cell align-middle text-center">${import_detail.productVariant.colorName}</td>
                            <td class="table_cell align-middle text-center">${import_detail.productVariant.sizeName}</td>
                            <td class="table_cell align-middle text-center">${import_detail.productVariant.materialName}</td>
                            <td class="table_cell align-middle text-center">${import_detail.quantity}</td>
                            <td class="table_cell align-middle text-center">${import_detail.price}</td>
                            <td class="table_cell align-middle text-center">${import_detail.price * import_detail.quantity}</td>
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