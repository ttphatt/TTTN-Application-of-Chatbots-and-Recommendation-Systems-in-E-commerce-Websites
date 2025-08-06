<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Reset Password</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=yes">
    <script type="text/javascript" src="js/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="js/jquery.validate.min.js"></script>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <link rel="stylesheet" type="text/css" href="css/pageLoad.css">
    <link rel="stylesheet" type="text/css" href="css/custom_background_template.css"/>
    <link rel="stylesheet" type="text/css" href="css/custom_row_template.css"/>
    <link rel="stylesheet" type="text/css" href="css/custom_border_template.css"/>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        .error {
            color: red;
            font-size: 0.875em; /* Adjust font size if needed */
        }
    </style>

<%--    <style>--%>
<%--        body {--%>
<%--            padding-top: 0;--%>
<%--        }--%>
<%--        .form-container {--%>
<%--            max-width: 600px;--%>
<%--            margin: auto;--%>
<%--        }--%>
<%--        .form-heading {--%>
<%--            margin-bottom: 30px;--%>
<%--        }--%>
<%--    </style>--%>
</head>
<body>
<jsp:directive.include file="header.jsp" />

<div class="background-div-content">
    <div class="container mb-5 mt-5">
        <div class="row justify-content-center">
            <div class="col-md-auto text-center border custom-border">
                <h2>Reset Your Password</h2>
                <p>
                    Please enter your login email, we'll send a new random password to your inbox:
                </p>

                <div class="row justify-content-center">
                    <div class="col-md-auto text-center justify-content-center">
                        <form id="resetForm" action="reset_password" method="post">
                            <table>
                                <tr>
                                    <td>Email:</td>
                                    <td><input type="text" name="email" id="email" size="20"></td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <button type="submit" class="mt-4 btn custom-btn-submit fs-5">Send me new password</button>
                                    </td>
                                </tr>
                            </table>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:directive.include file="footer.jsp" />

<script type="text/javascript">

    $(document).ready(function() {
        function getMessageContent(messageId, event){
            fetch('csvdata?id=' + messageId)
                .then(response => response.json())
                .then(data =>{
                    if(data.message){
                        Swal.fire({
                            title: data.message,
                            icon: "info",
                            html: `
                        <p>${data.message}</p>
                    `,
                            showCloseButton: true,
                            confirmButtonText: "OK",
                            focusConfirm: false
                        });
                        event.preventDefault();
                    }
                    else{
                        Swal.fire("Message not found");
                        event.preventDefault();
                    }
                })
                .catch(error => console.error("Error: ", error));
        }

        $("#resetForm").submit(function (event){
           var email = $("#email").val();
           var emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;

           if(email.trim() === ""){
               getMessageContent("NOT_NULL_EMAIL", event);
           }
           else if(!emailRegex.test(email)){
               getMessageContent("INVALID_EMAIL_ADDRESS", event);
               event.preventDefault();
           }
        });

        $("#resetForm").validate({
            rules: {
                email: {
                    required: true,
                    email: true
                }
            },

            messages: {
                email: {
                    required: "",
                    email: ""
                }
            }
        });

    });
</script>
</body>
</html>