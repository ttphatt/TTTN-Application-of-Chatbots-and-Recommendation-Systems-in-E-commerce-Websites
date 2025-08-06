<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Customer's Profile</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=yes">

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <script type="text/javascript" src="js/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" type="text/css" href="css/table_template.css"/>
    <link rel="stylesheet" type="text/css" href="css/custom_background_template.css"/>
    <link rel="stylesheet" type="text/css" href="css/custom_row_template.css"/>
    <link rel="stylesheet" type="text/css" href="css/underscore_template.css"/>

    <jsp:include page="pageLoadCustomer.jsp"/>
    <link rel="stylesheet" type="text/css" href="css/pageLoadCustomer.css"/>
</head>
<body>
<jsp:directive.include file="header.jsp"/>

<div class="background-div-content">
    <div class="container">
        <div class="row justify-content-center">
            <div class="row w-25 custom-row mb-5 mt-5 text-center">
                <h3>Hi there, ${loggedCustomer.firstname} ${loggedCustomer.lastname}</h3>
            </div>
        </div>

        <div class="row justify-content-center">
            <div class="col-md-8" align="center">
                <table class="table table-striped table-bordered table-hover table-custom" style="width: 400px">
                    <tr>
                        <td><b>Email address: </b></td>
                        <td>${loggedCustomer.email}</td>
                    </tr>

                    <tr>
                        <td><b>First name: </b></td>
                        <td>${loggedCustomer.firstname}</td>
                    </tr>

                    <tr>
                        <td><b>Last name: </b></td>
                        <td>${loggedCustomer.lastname}</td>
                    </tr>

                    <tr>
                        <td><b>Phone number: </b></td>
                        <td>${loggedCustomer.phoneNumber}</td>
                    </tr>

                    <tr>
                        <td><b>Address 1: </b></td>
                        <td>${loggedCustomer.addressLine1}</td>
                    </tr>

                    <tr>
                        <td><b>Address 2: </b></td>
                        <td>${loggedCustomer.addressLine2}</td>
                    </tr>

                    <tr>
                        <td><b>City: </b></td>
                        <td>${loggedCustomer.city}</td>
                    </tr>

                    <tr>
                        <td><b>State: </b></td>
                        <td>${loggedCustomer.state}</td>
                    </tr>

                    <tr>
                        <td><b>Zip code: </b></td>
                        <td>${loggedCustomer.zipcode}</td>
                    </tr>

                    <tr>
                        <td><b>Country: </b></td>
                        <td>${loggedCustomer.country}</td>
                    </tr>

                    <tr>
                        <td colspan="2" class="text-center">
                            <a href="edit_profile" class="btn custom-btn-details">Edit your profile</a>
                        </td>
                    </tr>
                </table>
            </div>
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
