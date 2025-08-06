<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Sign up as a customer</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=yes">
    <script type="text/javascript" src="js/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="js/jquery.validate.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <link rel="stylesheet" type="text/css" href="css/custom_background_template.css"/>
    <link rel="stylesheet" type="text/css" href="css/custom_row_template.css"/>
    <link rel="stylesheet" type="text/css" href="css/custom_border_template.css"/>
    <link rel="stylesheet" type="text/css" href="css/form_control_template.css"/>
    <style>
        .error {
            color: red;
            font-size: 0.875em; /* Adjust font size if needed */
        }
    </style>

    <style>
        body {
            padding-top: 0;
        }
        .form-container {
            max-width: 600px;
            margin: auto;
        }
        .form-heading {
            margin-bottom: 30px;
        }
    </style>
</head>
<body>
<jsp:directive.include file="header.jsp"/>

<div class="background-div-content">
    <div class="container">
        <div class="row justify-content-center">
            <div class="row custom-row mt-5 mb-5" style="width: fit-content; padding-bottom: 5px">
                <h1 class="text-center form-heading">Sign up as a customer</h1>
            </div>
        </div>

        <div class="row justify-content-center mb-5">
            <div class="col-md-8 form-container">
                <form class="form-control custom-form-control" action="register_customer" method="post" id="customerForm">
                    <jsp:directive.include file="/frontend/customer_form.jsp"/>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:directive.include file="footer.jsp"/>
</body>
<script type="text/javascript">
    $(document).ready(function(){
        function getMessageContent(messageId, event){
            fetch('csvdata?id=' + messageId)
                .then(response => response.json())
                .then(data =>{
                    if(data.message){
                        Swal.fire(data.message);
                        event.preventDefault();
                    }
                    else{
                        Swal.fire("Message not found");
                        event.preventDefault();
                    }
                })
                .catch(error => console.error("Error: ", error));
        }

        $("#customerForm").submit(function (event){
            var email = $("#email").val();
            var firstname = $("#firstname").val();
            var lastname = $("#lastname").val();
            var password = $("#password").val();
            var confirmPassword = $("#confirmPassword").val();
            var phoneNumber = $("#phone").val();
            var address1 = $("#address1").val();
            var address2 = $("#address2").val();
            var city = $("#city").val();
            var state = $("#state").val();
            var zip = $("#zip").val();
            var phoneRegex = /^[0-9]{7,10}$/;
            var emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;


            if(email.trim() === ""){
                getMessageContent("NOT_NULL_EMAIL", event);
            }
            else if(!emailRegex.test(email.trim())){
                getMessageContent("INVALID_EMAIL_ADDRESS", event);
                event.preventDefault();
            }
            else if(firstname.trim() === ""){
                getMessageContent("NOT_NULL_FIRSTNAME", event);
            }
            else if(lastname.trim() === ""){
                getMessageContent("NOT_NULL_LASTNAME", event);
            }
            else if(password.trim() === ""){
                getMessageContent("NOT_NULL_PASSWORD", event);
            }
            else if(password.length < 6 || password.length > 50){
                getMessageContent("INVALID_PASSWORD_LENGTH", event);
            }
            else if(confirmPassword.trim() === ""){
                getMessageContent("NOT_NULL_CONFIRM_PASSWORD", event);
            }
            else if(!(confirmPassword.trim() === password.trim())){
                getMessageContent("DIFFERENT_CONFIRM_PASSWORD", event);
            }
            else if(phoneNumber.trim() === ""){
                getMessageContent("NOT_NULL_NUMBER_PHONE", event);
            }
            else if(!phoneRegex.test(phoneNumber)){
                getMessageContent("INVALID_NUMBER_PHONE", event);
            }
            else if(address1.trim() === ""){
                getMessageContent("NOT_NULL_ADDRESS_LINE_1", event);
            }
            else if(address2.trim() === ""){
                getMessageContent("NOT_NULL_ADDRESS_LINE_2", event);
            }
            else if(city.trim() === ""){
                getMessageContent("NOT_NULL_CITY", event);
            }
            else if(state.trim() === ""){
                getMessageContent("NOT_NULL_STATE", event);
            }
            else if(zip.trim() === ""){
                getMessageContent("NOT_NULL_ZIP_CODE", event);
            }
        });


        $("#customerForm").validate({
            rules:{
                email: "required",
                firstname: "required",
                lastname: "required",
                password: "required",
                confirmPassword: "required",
                phone: "required",
                address1: "required",
                address2: "required",
                city: "required",
                state: "required",
                zip: "required",
                country: "required",
            },

            messages:{
                email: "",
                firstname: "",
                lastname: "",
                password: "",
                confirmPassword: "",
                phone: "",
                address1: "",
                address2: "",
                city: "",
                state: "",
                zip: "",
                country: "",
            }
        });

        $("#buttonCancel").click(function(){
            history.go(-1);
        });
    });


</script>
</html>
