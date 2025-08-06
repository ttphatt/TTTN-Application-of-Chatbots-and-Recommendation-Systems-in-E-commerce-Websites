<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Shirts of ${type.typeName} - The Shirt Store</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <script type="text/javascript" src="js/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" type="text/css" href="css/card_template.css"/>
    <link rel="stylesheet" type="text/css" href="css/heart_rating.css"/>
    <link rel="stylesheet" type="text/css" href="css/for_product.css"/>
    <link rel="stylesheet" type="text/css" href="css/custom_background_template.css"/>
    <link rel="stylesheet" type="text/css" href="css/custom_row_template.css"/>

    <jsp:include page="pageLoadCustomer.jsp"/>
    <link rel="stylesheet" type="text/css" href="css/pageLoadCustomer.css"/>
    <style>
        .shirt-card img {
            max-height: 240px;
            max-weidth: 250px;
            object-fit: cover;
        }
        .shirt-card {
            transition: transform 0.2s;
        }
        .shirt-card:hover {
            transform: scale(1.05);
        }
    </style>
</head>
<body>
<jsp:directive.include file="header.jsp"/>
<div class="background-div-content">
    <div class="container mt-5">
        <div class="row justify-content-center custom-row">
            <h2 class="text-center display-4" style="font-family: 'Merriweather', serif">${category.name}</h2>
        </div>

        <br><br><br><br>


        <div class="row justify-content-center text-center mb-5">
            <c:forEach var="product" items="${productList}">
                <div class="col-md-4 mb-4" style="font-family: 'Roboto', sans-serif;">
                    <div class="card">
                        <a href="view_product?id=${product.id}">
                            <div class="content">
                                <img class="image-product" src="${product.image}"/>
                            </div>
                        </a>

                        <a href="view_product?id=${product.id}" style="text-decoration: none">
                            <div class="content">
                                <div style="font-size: 25px">
                                    <b style="color: #FFFFFF">${product.name}</b>
                                </div>
                            </div>
                        </a>

<%--                        <a href="view_shirt?id=${product.id}" style="text-decoration: none">--%>
<%--                            <div class="content">--%>
<%--                                <jsp:directive.include file="product_rating.jsp"/>--%>
<%--                            </div>--%>
<%--                        </a>--%>

                        <a href="view_product?id=${product.id}" style="text-decoration: none">
                            <div class="content" style="font-size: 25px; color: #FFFFFF">
                                <b>From: ${product.brand}</b>
                            </div>
                        </a>

                        <a href="view_product?id=${product.id}" style="text-decoration: none">
                            <div class="content" style="font-size: 25px; color: #FFFFFF">
                                <b>Price: $${product.price}</b>
                            </div>
                        </a>
                    </div>
                </div>
            </c:forEach>
        </div>
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
</html>
