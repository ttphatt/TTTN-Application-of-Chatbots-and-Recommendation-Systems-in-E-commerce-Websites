<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=yes">
    <title>Done rating</title>

    <script type="text/javascript" src="js/jquery-3.7.1.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <link rel="stylesheet" type="text/css" href="css/custom_background_template.css"/>
    <link rel="stylesheet" type="text/css" href="css/custom_row_template.css"/>
    <link rel="stylesheet" type="text/css" href="css/custom_border_template.css"/>

    <style>
        body {
            padding-top: 0;
        }
        .img-fluid {
            max-height: 240px;
            object-fit: cover;
        }
        .col-md-8 {
            margin-top: 70px;
        }
    </style>
</head>
<body>
<jsp:directive.include file="header.jsp"/>
<div class="background-div-content">
    <div class="container mt-5 mb-5">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card border custom-border">
                    <div class="card-body text-center">
                        <h2>Share us your thoughts, ${loggedCustomer.fullName}</h2>
                        <hr>
                        <div class="row">
                            <div class="col-md-4">
                                <img src="${shirt.shirtImage}" class="img-fluid mb-3" alt="${shirt.shirtName}">
                                <h2><b>${shirt.shirtName}</b></h2>
                            </div>
                            <div class="col-md-8">
                                <h3>${message}</h3>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:directive.include file="footer.jsp"/>
</body>
</html>
