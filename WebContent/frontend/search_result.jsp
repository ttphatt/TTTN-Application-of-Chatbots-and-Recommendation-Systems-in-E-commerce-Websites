<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fnc" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>Search results for ${keyword} - PHK Shirt Store</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=yes">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <script type="text/javascript" src="js/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" type="text/css" href="css/card_template.css"/>
    <link rel="stylesheet" type="text/css" href="css/heart_rating.css"/>
    <link rel="stylesheet" type="text/css" href="css/for_product.css"/>
    <link rel="stylesheet" type="text/css" href="css/custom_background_template.css"/>
    <link rel="stylesheet" type="text/css" href="css/custom_row_template.css"/>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&family=Open+Sans:wght@400;600&display=swap">

    <jsp:include page="pageLoadCustomer.jsp"/>
    <link rel="stylesheet" type="text/css" href="css/pageLoadCustomer.css"/>
</head>
<body>
<jsp:directive.include file="header.jsp"/>
<div class="background-div-content">
    <div class="container mt-5">
        <div class="row justify-content-center text-center">
            <c:if test="${fnc:length(result) == 0}">
                <div class="row custom-row mb-5">
                    <h2 style="font-family: 'Merriweather', serif">We are sorry but there is nothing for the keyword "${keyword}"</h2>
                </div>
            </c:if>

            <c:if test="${fnc:length(result) > 0}">
                <div>
                    <div class="row custom-row">
                        <h2 class="display-4" style="font-family: 'Merriweather', serif">Results for "${keyword}"</h2>
                    </div>
                    <br><br><br>
                    <div class="row justify-content-center mb-5 pd-5">
                        <c:forEach var="shirt" items="${result}">
                            <div class="col-md-4 mb-5" style="font-family: 'Roboto', sans-serif">
                                <div class="card">
                                    <div class="content">
                                        <a href="view_shirt?id=${shirt.shirtId}">
                                            <img class="image-product" src="${shirt.shirtImage}" alt="${shirt.shirtName}">
                                        </a>
                                    </div>

                                    <div class="content">
                                        <a href="view_shirt?id=${shirt.shirtId}" class="text-dark" style="text-decoration: none">
                                            <b style="color: #FFFFFF">${shirt.shirtName}</b>
                                        </a>
                                    </div>

                                    <div class="content">
                                        <jsp:directive.include file="product_rating.jsp"/>
                                    </div>

                                    <div class="content">
                                        <p class="card-text">From: ${shirt.brand}</p>
                                    </div>

                                    <div class="content">
                                        <p class="card-text"><b>Price: $${shirt.shirtPrice}</b></p>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:if>
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
