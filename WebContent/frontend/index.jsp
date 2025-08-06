<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>PHK Shirts Store</title>
    <jsp:include page="pagehead.jsp"></jsp:include>
    <link rel="stylesheet" type="text/css" href="css/heart_rating.css"/>
    <link rel="stylesheet" type="text/css" href="css/for_product.css"/>
    <link rel="stylesheet" type="text/css" href="css/custom_row_template.css"/>
    <link rel="stylesheet" type="text/css" href="css/custom_border_template.css"/>
    <link rel="stylesheet" type="text/css" href="css/underscore_template.css"/>
    <link rel="stylesheet" type="text/css" href="css/custom_background_template.css"/>

    <jsp:include page="pageLoadCustomer.jsp"/>
    <jsp:include page="chat.jsp"/>
    <link rel="stylesheet" type="text/css" href="css/pageLoadCustomer.css"/>
</head>
<body>
<jsp:directive.include file="header.jsp"/>

<!-- Main Container -->
<div class="background-div-content">
    <div class="container mb-5">
        <!-- New Shoes Section -->
        <div class="row custom-row mb-5 w-auto justify-content-center mt-5" style="width: max-content">
            <div class="col text-center">
                <h2 class="display-4 custom-underscore" style="font-family: 'Merriweather', serif"><b>New Collections</b></h2>
            </div>
        </div>
        <div class="row justify-content-center mb-5 border custom-border">
            <c:forEach var="product" items="${listNewShirts}">
                <div class="col-md-4 mt-5">
                    <jsp:directive.include file="product_group.jsp"/>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<div class="background-div-content">
    <div class="container mb-5">
        <!-- Top-Selling Shirts Section -->
        <div class="row custom-row-1 mb-5">
            <div class="col text-center">
                <h2 class="display-4 custom-underscore" style="font-family: 'Merriweather', serif"><b>Top-Selling Products</b></h2>
            </div>
        </div>
        <div class="row justify-content-center mb-5 border custom-border">
            <c:forEach var="product" items="${listBestSellingProducts}">
                <div class="col-md-4 mt-5">
                    <jsp:directive.include file="product_group.jsp"/>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<div class="background-div-content">
    <div class="container">
        <!-- Most-Favorite Shirts Section -->
        <div class="row custom-row mb-5">
            <div class="col text-center">
                <h2 class="display-4 custom-underscore" style="font-family: 'Merriweather', serif"><b>Most-Favorite Products</b></h2>
            </div>
        </div>
        <div class="row justify-content-center mb-5 border custom-border">
            <c:forEach var="product" items="${listMostFavoredProducts}">
                <div class="col-md-4 mt-5">
                    <jsp:directive.include file="product_group.jsp"/>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<%--    <br><br><br><br>--%>
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
</html>
