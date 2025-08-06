<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
	<title>Shirt Store Administration</title>
	<jsp:include page="pagehead.jsp"></jsp:include>
    <link rel="stylesheet" type="text/css" href="../css/search_button_template.css"/>
    <link rel="stylesheet" type="text/css" href="../css/custom_row_template.css"/>
    <link rel="stylesheet" type="text/css" href="../css/custom_background_template.css"/>
</head>
<body>
    <jsp:directive.include file="header.jsp"/>
    <div class="background-div-content">
        <div class="container mt-5">
            <div class="row justify-content-center text-center mb-5">
                <h1>Quick Actions:</h1>
                <div class="justify-content-center mt-3">
                    <a href="user_form.jsp" class="btn custom-btn-cart me-2">Add a new user</a>
                    <a href="new_customer" class="btn custom-btn-delete me-2">Add a new customer</a>
                    <a href="new_shirt" class="btn custom-btn-cart me-2">Add new shirt</a>
                    <a href="category_form.jsp" class="btn custom-btn-delete">Add a new type</a>
                </div>
            </div>

            <c:if test="${userRole != 'staff'}">
                <div class="row justify-content-center text-center mt-5">
                    <div class="col">
                        <h1>Revenue Chart Detail</h1>
                        <a href="view_dashboard" class="btn custom-btn-submit fs-5 mt-3">Check revenue</a>
                    </div>
                </div>
            </c:if>

            <!-- Charts Section -->
            <div class="text-center mb-5">
                <h2>General Bar Chart</h2>
                <hr class="w-50 mx-auto">
                <canvas id="myChart" class="mx-auto" style="max-width: 700px;"></canvas>
                <script>
                    function getRandomColor() {
                        var letters = "0123456789ABCDEF";
                        var color = '#';
                        for (var i = 0; i < 6; i++) {
                            color += letters[Math.floor(Math.random() * 16)];
                        }
                        return color;
                    }

                    const xValues = ["User", "Shirts", "Type", "Customer", "Rate", "Order"];
                    const yValues = ["${totalUsers}", "${totalShirts}", "${totalTypes}", "${totalCustomers}", "${totalRates}", "${totalOrders}", 0];
                    const barColors = [];

                    for (var i = 0; i < 6; i++) {
                        barColors.push(getRandomColor());
                    }

                    new Chart("myChart", {
                        type: "bar",
                        data: {
                            labels: xValues,
                            datasets: [{
                                backgroundColor: barColors,
                                data: yValues
                            }]
                        },
                        options: {
                            legend: { display: false },
                            title: {
                                display: true,
                                text: "Overall Figures"
                            }
                        }
                    });
                </script>
            </div>

            <div class="row mb-5">
                <div class="col-md-6 text-center">
                    <h2>Types of Shirts Pie Chart</h2>
                    <hr class="w-50 mx-auto">
                    <canvas id="myChart1" class="mx-auto" style="max-width: 700px;"></canvas>
                    <script>
                        const xAxis = [];
                        const yAxis = [];
                        const pieColor = [];

                        <c:forEach items="${typeNames}" var="temp">
                        xAxis.push("${temp}");
                        </c:forEach>

                        <c:forEach items="${shirtsByTypes}" var="temp">
                        yAxis.push("${temp}");
                        pieColor.push(getRandomColor());
                        </c:forEach>

                        new Chart("myChart1", {
                            type: "pie",
                            data: {
                                labels: xAxis,
                                datasets: [{
                                    backgroundColor: pieColor,
                                    data: yAxis
                                }]
                            },
                            options: {
                                title: {
                                    display: true,
                                    text: "Number of Shirts per Type"
                                }
                            }
                        });
                    </script>
                </div>
                <div class="col-md-6 text-center">
                    <h2>Average Rating Stars Pie Chart</h2>
                    <hr class="w-50 mx-auto">
                    <canvas id="myChart2" class="mx-auto" style="max-width: 700px;"></canvas>
                    <script>
                        const horizontalAxis = [];
                        const verticalAxis = [];
                        const colors = [];

                        <c:forEach items="${listRatingStars}" var="temp">
                        horizontalAxis.push("${temp}" + " stars");
                        colors.push(getRandomColor());
                        </c:forEach>

                        <c:forEach items="${countRatingStars}" var="temp">
                        verticalAxis.push("${temp}");
                        </c:forEach>

                        new Chart("myChart2", {
                            type: "pie",
                            data: {
                                labels: horizontalAxis,
                                datasets: [{
                                    backgroundColor: colors,
                                    data: verticalAxis
                                }]
                            },
                            options: {
                                title: {
                                    display: true,
                                    text: "Number of Shirts per Type"
                                }
                            }
                        });
                    </script>
                </div>
            </div>

            <div class="text-center mb-5">
                <h2>Selling Revenue Pie Chart</h2>
                <hr class="w-50 mx-auto">
                <canvas id="myChart3" class="mx-auto" style="max-width: 700px;"></canvas>
                <script>
                    const label = [];
                    const percentages = [];
                    const percentagesColor = [];

                    <c:forEach items="${soldShirtName}" var="temp">
                    label.push("${temp}");
                    percentagesColor.push(getRandomColor());
                    </c:forEach>

                    <c:forEach items="${eachShirtRevenue}" var="temp">
                    percentages.push("${temp}");
                    </c:forEach>

                    new Chart("myChart3", {
                        type: "pie",
                        data: {
                            labels: label,
                            datasets: [{
                                backgroundColor: percentagesColor,
                                data: percentages,
                            }]
                        },
                        options: {
                            title: {
                                display: true,
                                text: "Revenue Of Each Pair Of Shirts"
                            }
                        }
                    });
                </script>
            </div>

            <div class="text-center mb-5">
                <h1>Administrative Dashboard</h1>
                <hr class="w-50 mx-auto">
                <h2>Recent sales:</h2>
                <hr class="w-50 mx-auto">
                <div class="table-responsive">
                    <table  class="table table-bordered table-hover text-center">
                        <thead class="table-dark">
                        <tr>
                            <th>Order's ID</th>
                            <th>Ordered By</th>
                            <th>Subtotal Price</th>
                            <th>Payment method</th>
                            <th>Status</th>
                            <th>Order date</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="order" items="${listMostRecentSales}">
                            <tr>
                                <td><a href="view_order?orderId=${order.id}">${order.id}</a></td>
                                <td>${order.customerName}</td>
                                <td>$${order.tax + order.shippingFee + order.subtotal}</td>
                                <td>${order.payment}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${order.status == 'Processing'}">
                                            <span class="badge bg-warning text-dark">${order.status}</span>
                                        </c:when>
                                        <c:when test="${order.status == 'Shipping'}">
                                            <span class="badge bg-info text-dark">${order.status}</span>
                                        </c:when>
                                        <c:when test="${order.status == 'Delivered'}">
                                            <span class="badge bg-primary">${order.status}</span>
                                        </c:when>
                                        <c:when test="${order.status == 'Completed'}">
                                            <span class="badge bg-success">${order.status}</span>
                                        </c:when>
                                        <c:when test="${order.status == 'Cancelled'}">
                                            <span class="badge bg-danger">${order.status}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">${order.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${order.date}</td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="text-center mb-5">
                <h2>Recent rates:</h2>
                <hr class="w-50 mx-auto">
                <div class="table-responsive">

                    <table  class="table table-bordered table-hover text-center">
                        <thead class="table-dark">
                        <tr>
                            <th>Product</th>
                            <th>Rating</th>
                            <th>Headline</th>
                            <th>Customer</th>
                            <th>Rate on</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${listMostRecentRates}" var="rate">
                            <tr>
                                <td>${rate.productName}</td>
                                <td>
                                    <c:forEach begin="1" end="5" var="i">
                                        <c:choose>
                                            <c:when test="${i <= rate.stars}">
                                                <i class="bi bi-star-fill"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="bi bi-star"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </td>
                                <td><a href="edit_rate?id=${rate.id}">${rate.headline}</a></td>
                                <td>${rate.customerName}</td>
                                <td>${rate.time}</td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <jsp:directive.include file="footer.jsp"/>
</body>
</html>