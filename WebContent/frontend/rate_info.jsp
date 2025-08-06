<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=yes">
    <title>Rate our shirts</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/rateYo/2.3.2/jquery.rateyo.min.css">

    <script type="text/javascript" src="js/jquery-3.7.1.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/rateYo/2.3.2/jquery.rateyo.min.js"></script>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

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
    </style>
</head>
<body>
<jsp:directive.include file="header.jsp"/>

<div class="background-div-content">
    <div class="container mt-5 mb-5">
        <div class="row justify-content-center text-center">
            <form id="rateForm" action="update_rate" method="post" class="col-lg-8">
                <input type="hidden" name="rateId" value="${rate.id}">
                <div class="card border custom-border">
                    <div class="card-body">
                        <h2 class="text-start">You already wrote the rate for this shirt</h2>
                        <hr>
                        <div class="row">
                            <div class="col-md-4">
                                <img src="${product.image}" class="img-fluid mb-3" alt="${product.name}">
                                <h2><b>${product.name}</b></h2>
                            </div>
                            <div class="col-md-8">
                                <div id="rateYo" class="mb-3"></div>
                                <div class="form-group">
                                    <input id="headline" type="text" name="headline" class="form-control" value="${rate.headline}" placeholder="Headline" required>
                                </div>
                                <div class="form-group mt-3">
                                    <textarea id="ratingDetail" name="ratingDetail" class="form-control" rows="5"  placeholder="Share us your experience" required>${rate.detail}</textarea>
                                </div>
                            </div>

                            <div class="d-flex justify-content-end mt-4">
                                <a href="#" class="deleteLink btn custom-btn-delete" id="${rate.id}">Delete</a>&nbsp;&nbsp;
                                <button id="submit" type="submit" class="btn custom-btn-update me-2">Update</button>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:directive.include file="footer.jsp"/>
</body>
<script type="text/javascript">
    $(document).ready(function(){
        var headline = ""
        var ratingDetail = ""

        $("#rateYo").rateYo({
            starWidth: "40px",
            fullStar: true,
            ratedFill: "#000000",
            rating: ${rate.stars},
            readOnly: true,
        });

        $("#submit").click(function(event) {
            headline = document.getElementById("headline").value;
            ratingDetail = document.getElementById("ratingDetail").value

            if(headline.length === 0){
                getMessageContent("NOT_NULL_HEADLINE", event);
            }

            else if(ratingDetail.length === 0){
                getMessageContent("NOT_NULL_RATING_DETAIL", event);
            }
        });

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

        $(".deleteLink").each(function(){
            $(this).on("click", function(){
                rateId = $(this).attr("id");
                Swal.fire({
                    title: 'Are you sure?',
                    text: "Do you want to delete your rate?",
                    icon: 'question',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Yes, certainly!',
                    cancelButtonText: 'No, I change my mind'
                }).then((result) => {
                    if (result.isConfirmed) {
                        window.location.href = "delete_rate?id=" + rateId;
                    }
                });

            })
        });
    });
</script>
</html>
