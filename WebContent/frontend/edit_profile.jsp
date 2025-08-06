<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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

    <link rel="stylesheet" type="text/css" href="css/custom_border_template.css"/>
    <link rel="stylesheet" type="text/css" href="css/custom_background_template.css"/>
    <link rel="stylesheet" type="text/css" href="css/custom_row_template.css"/>
    <link rel="stylesheet" type="text/css" href="css/form_control_template.css"/>
    <style>
        .error {
            color: red;
            font-size: 0.875em; /* Adjust font size if needed */
        }
    </style>
</head>
<body>
<jsp:directive.include file="header.jsp"/>

<div class="background-div-content">
    <div class="container mb-5">
        <div class="row justify-content-center">
            <div class="row custom-row mt-5 mb-5 w-25 text-center">
                <h1>Profile Editing</h1>
            </div>
        </div>

        <div class="row justify-content-center">
            <div class="col-md-5" style="padding: 10px">
                <form class="form-control custom-form-control" action="update_profile" method="post" id="customerForm" accept-charset="UTF-8">
                    <div class="mb-3">
                        <label for="email" class="form-label">Email</label>
                        <input type="email" class="form-control" id="email" name="email" value="${loggedCustomer.email}" readonly>
                    </div>

                    <div class="mb-3">
                        <label for="firstname" class="form-label">First Name</label>
                        <input type="text" class="form-control" id="firstname" name="firstname" value="${loggedCustomer.firstname}">
                    </div>

                    <div class="mb-3">
                        <label for="lastname" class="form-label">Last Name</label>
                        <input type="text" class="form-control" id="lastname" name="lastname" value="${loggedCustomer.lastname}">
                    </div>

                    <div class="mb-3">
                        <label for="phone" class="form-label">Phone Number</label>
                        <input type="text" class="form-control" id="phone" name="phone" value="${loggedCustomer.phoneNumber}">
                    </div>

                    <div class="mb-3">
                        <label for="gender" class="form-label">Gender</label>
                        <select name="gender" id="gender" class="form-control">
                            <option value="">-- Select Gender --</option>
                            <option value="Male" <c:if test="${loggedCustomer.gender == 'Male'}">selected</c:if>>Male</option>
                            <option value="Female" <c:if test="${loggedCustomer.gender == 'Female'}">selected</c:if>>Female</option>
                            <option value="Other" <c:if test="${loggedCustomer.gender == 'Other'}">selected</c:if>>Other</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="date" class="form-label">Gender</label>
                        <input type="date" id="birthday" name="birthday" class="form-control"
                               value="<fmt:formatDate value='${loggedCustomer.birthday}' pattern='yyyy-MM-dd'/>" />
                    </div>

                    <div class="mb-3">
                        <label for="address1" class="form-label">Address Line 1</label>
                        <input type="text" class="form-control" id="address1" name="address1" value="${loggedCustomer.addressLine1}">
                    </div>

                    <div class="mb-3">
                        <label for="address2" class="form-label">Address Line 2</label>
                        <input type="text" class="form-control" id="address2" name="address2" value="${loggedCustomer.addressLine2}">
                    </div>

                    <div class="mb-3">
                        <label for="city" class="form-label">City</label>
                        <input type="text" class="form-control" id="city" name="city" value="${loggedCustomer.city}">
                    </div>

                    <div class="mb-3">
                        <label for="state" class="form-label">State</label>
                        <input type="text" class="form-control" id="state" name="state" value="${loggedCustomer.state}">
                    </div>

                    <div class="mb-3">
                        <label for="zip" class="form-label">Zip Code</label>
                        <input type="text" class="form-control" id="zip" name="zip" value="${loggedCustomer.zipcode}">
                    </div>

                    <div class="mb-3">
                        <label for="country" class="form-label">Country</label>
                        <select class="form-select" id="country" name="country">
                            <c:forEach items="${mapCountries}" var="country">
                                <option value="${country.value}" <c:if test="${loggedCustomer.country eq country.value}">selected="selected"</c:if>>${country.key}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="mb-3">
                        <%--                            <i><b style="color: #57260e">(Please leave the password field blank if you do not want to change your current password)</b></i>--%>
                        <div class="row custom-row">
                            <i><b style="color: #57260e">(Please leave the password field blank if you do not want to change your current password)</b></i>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="password" class="form-label">Password</label>
                        <input type="password" class="form-control" id="password" name="password">
                    </div>

                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">Confirm Password</label>
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword">
                    </div>

                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                        <button type="submit" class="btn custom-btn-details me-md-2">Save</button>
                        <button type="button" id="buttonCancel" class="btn custom-btn-return">Cancel</button>
                    </div>
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

        $("#customerForm").submit(function (event){
            var email = $("#email").val();
            var firstname = $("#firstname").val();
            var lastname = $("#lastname").val();
            var password = $("#password").val();
            var confirmPassword = $("#confirmPassword").val();
            var phoneNumber = $("#phone").val();
            let gender = $("#gender").val();
            let birthday = $("#birthday").val();
            var address1 = $("#address1").val();
            var address2 = $("#address2").val();
            var city = $("#city").val();
            var state = $("#state").val();
            var zip = $("#zip").val();
            let country = document.getElementById("country").value;
            var phoneRegex = /^[0-9]{7,10}$/;
            var emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
            var specialSymbolsAndNumbersRegex = /[0-9!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]+/;

            if(email.trim() === ""){
                getMessageContent("NOT_NULL_EMAIL", event);
            }
            else if(!emailRegex.test(email.trim())){
                getMessageContent("INVALID_EMAIL_ADDRESS", event);
            }
            else if(firstname.trim() === ""){
                getMessageContent("NOT_NULL_FIRSTNAME", event);
            }
            else if(specialSymbolsAndNumbersRegex.test(firstname.trim())){
                getMessageContent("SPECIAL_CHARACTER_NUMBER_IN_FIRSTNAME", event);
                event.preventDefault();
                $("#firstname").focus()
            }
            else if(lastname.trim() === ""){
                getMessageContent("NOT_NULL_LASTNAME", event);
            }
            else if(specialSymbolsAndNumbersRegex.test(lastname.trim())){
                getMessageContent("SPECIAL_CHARACTER_NUMBER_IN_LASTNAME", event);
                event.preventDefault();
                $("#lastname").focus()
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
                //Password and confirm password
                // else if(password.trim() === ""){
                //     getMessageContent("NOT_NULL_PASSWORD", event);
                // }
                // else if(confirmPassword.trim() === ""){
                //     getMessageContent("NOT_NULL_CONFIRM_PASSWORD", event);
            // }
            else if(!(confirmPassword.trim() === password.trim())){
                getMessageContent("DIFFERENT_CONFIRM_PASSWORD", event);
                event.preventDefault();
            }
            else if(password.trim() !== "" && (password.length < 6 || password.length > 50)){
                getMessageContent("INVALID_PASSWORD_LENGTH", event);
                event.preventDefault();
            }

            const url = "update_profile";
            $.ajax({
                url: url,
                type: "POST",
                data: {
                    email,
                    firstname,
                    lastname,
                    password,
                    phoneNumber,
                    birthday,
                    gender,
                    address1,
                    address2,
                    city,
                    state,
                    zip,
                    country
                }
        });

        $("#customerForm").validate({
            rules:{
                email: "required",
                firstname: "required",
                lastname: "required",
                // password: "required",
                // confirmPassword: "required",
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
                // password: "",
                // confirmPassword: "",
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
