<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fnc" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>My Orders History</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=yes">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <script type="text/javascript" src="js/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" type="text/css" href="css/table_list_template.css"/>
    <link rel="stylesheet" type="text/css" href="css/custom_row_template.css"/>
    <link rel="stylesheet" type="text/css" href="css/underscore_template.css"/>
    <link rel="stylesheet" type="text/css" href="css/custom_background_template.css"/>
    <link rel="stylesheet" type="text/css" href="css/search_button_template.css"/>
    <link href="css/temp.css" rel="stylesheet" type="text/css" />

    <jsp:include page="pageLoadCustomer.jsp"/>
    <link rel="stylesheet" type="text/css" href="css/pageLoadCustomer.css"/>
</head>
<body>
<jsp:directive.include file="header.jsp"/>

<div class="background-div-content">
    <div class="container">
        <div class="row justify-content-center text-center">
            <div class="row custom-row w-50 mb-5 mt-5">
                <h1>Orders History</h1>
            </div>
        </div>

        <br>

        <c:if test="${fnc:length(orderList) == 0}">
            <div class="row justify-content-center">
                <h2>You don't have any orders yet</h2>
            </div>
        </c:if>

        <c:if test="${fnc:length(orderList) > 0}">
            <div class="row justify-content-center">
                <div class="">
                    <table class="table table-striped table-hover table-list-custom">
                        <thead class="thead-dark">
                        <tr>
                            <th>Index</th>
                            <th>Order's ID</th>
                            <th>Total Price</th>
                            <th>Order Date</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody id="tableBody">
                        <c:forEach var="order" items="${orderList}" varStatus="status">
                            <tr>
                                <td>${status.index + 1}</td>
                                <td>${order.id}</td>
                                <td><fmt:formatNumber type="currency" value="${order.orderSum}"/></td>
                                    <%-----------------------------%>
                                <td><fmt:formatDate value="${order.date}" pattern="dd/MM/yyyy HH:mm:ss"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${order.status == 'Processing'}">
                                            <button class="btn btn-primary" disabled>${order.status}</button>
                                        </c:when>

                                        <c:when test="${order.status == 'Shipping'}">
                                            <button class="btn btn-info" disabled>${order.status}</button>
                                        </c:when>

                                        <c:when test="${order.status == 'Delivered'}">
                                            <button class="btn btn-warning" disabled>${order.status}</button>
                                        </c:when>

                                        <c:when test="${order.status == 'Cancelled'}">
                                            <button class="btn btn-danger" disabled>${order.status}</button>
                                        </c:when>

                                        <c:when test="${order.status == 'Completed'}">
                                            <button class="btn btn-success" disabled>${order.status}</button>
                                        </c:when>

                                        <c:when test="${order.status == 'Returned'}">
                                            <button class="btn btn-dark" disabled>${order.status}</button>
                                        </c:when>

                                    </c:choose>

                                </td>
                                <td>
                                    <a href="show_order_detail?orderId=${order.id}" class="btn custom-btn-details"><b>View Details</b></a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:if>
        <div class="row justify-content-center">
            <div class="pagination-wrapper">
                <a href="#" class="paginationButton custom-btn-submit fs-5" id="prevPage" style="text-decoration: none">Previous</a>
                <a href="#" class="paginationButton custom-btn-submit fs-5" id="nextPage" style="text-decoration: none" >Next</a>
            </div>
        </div>
    </div>
</div>



<script>
    let curPage = 1
    let recordsPerPage = 10;
    let products = onload();
    document.getElementById("prevPage").addEventListener("click", prevPage);
    document.getElementById("nextPage").addEventListener("click", nextPage);
    changePage(1);

    function onload() {
        return document.getElementById("tableBody").getElementsByTagName("tr");
    }

    function prevPage(event) {
        if (curPage > 1) {
            curPage--;
            changePage(curPage);
            event.preventDefault();
        }
    }

    function nextPage(event) {
        if (curPage < numPages()) {
            curPage++;
            changePage(curPage);
            event.preventDefault();
        }
    }

    function changePage(page) {
        for (let i = 0; i < products.length; i++) {
            products[i].style.display = "none";
        }

        for (let i = (page - 1) * recordsPerPage; i < products.length && i < (page * recordsPerPage); i++) {
            products[i].style.display = "table-row";
        }
    }

    function numPages() {
        return Math.ceil(products.length / recordsPerPage);
    }
</script>

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
