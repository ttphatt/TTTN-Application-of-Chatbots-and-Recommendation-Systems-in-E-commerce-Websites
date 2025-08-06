<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://java.sun.com/jsp/jstl/fmt" %>
<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=yes">
    <title>
        <c:choose>
            <c:when test="${product != null}">Edit Product</c:when>
            <c:otherwise>Create New Product</c:otherwise>
        </c:choose>
    </title>
    <jsp:include page="pagehead.jsp"></jsp:include>
    <jsp:include page="pageLoad.jsp"/>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <link rel="stylesheet" type="text/css" href="../css/custom_background_template.css"/>
    <link rel="stylesheet" type="text/css" href="../css/custom_row_template.css"/>
    <link rel="stylesheet" type="text/css" href="../css/table_list_admin_template.css"/>
    <link rel="stylesheet" type="text/css" href="../css/search_button_template.css"/>
    <link rel="stylesheet" type="text/css" href="../css/custom_border_template.css"/>
</head>
<body>
    <jsp:directive.include file="header.jsp"/>

    <div class="background-div-content">
        <div class="container mb-5 mt-5">
            <div class="row justify-content-center">
                <div class="row custom-row-1 text-center" style="width: fit-content">
                    <h1>
                        <c:choose>
                            <c:when test="${product != null}">Edit Product</c:when>
                            <c:otherwise>Create New Product</c:otherwise>
                        </c:choose>
                    </h1>
                </div>
            </div>

            <div class="row justify-content-center text-center">
                <div class="col-md-7 justify-content-center text-center border custom-border" style="border-radius: 20px; padding: 25px">
                    <form action="${product == null ? 'product_create' : 'product_update'}" method="post" id="productForm" enctype="multipart/form-data">
                        <c:if test="${product != null}">
                            <input type="hidden" name="productId" id="productId" value="${product.id}"/>
                        </c:if>
                        <div class="mb-3 text-start">
                            <label for="category" class="form-label">Category</label>
                            <select name="category" id="category" class="form-select">
                                <c:forEach var="category" items="${listCategories}">
                                    <option value="${category.id}" ${category.id == product.category.id ? 'selected' : ''}>${category.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3 text-start">
                            <label for="productName" class="form-label">Name of the Product</label>
                            <input type="text" id="productName" name="productName" class="form-control" value="${product.name}" required="required">
                        </div>
                        <div class="mb-3 text-start">
                            <label for="brand" class="form-label">Brand</label>
                            <input type="text" id="brand" name="brand" class="form-control" value="${product.brand}" required="required">
                        </div>
                        <div class="mb-3 text-start">
                            <label for="description" class="form-label">Description</label>
                            <textarea rows="5" name="description" id="description" class="form-control" required="required">${product.description}</textarea>
                        </div>
                        <div class="mb-3 text-start">
                            <label for="image" class="form-label">Image</label>
                            <input type="file" id="image" name="image" class="form-control" ${product == null ? 'required' : ''}>

                            <c:if test="${product != null}">
                                <input type="hidden" id="oldImage" name="oldImage" value="${product.image}">
                            </c:if>

                            <img alt="Image Preview" id="thumbnail" class="img-thumbnail mt-3" style="max-height: 300px; max-width: 300px"
                                 src="${product != null ? product.image : ''}" />
                        </div>
                        <div class="mb-3 text-start">
                            <label for="price" class="form-label">Price</label>
                            <input type="number" step="0.01" min="0.01" id="price" name="price" class="form-control" value="${product.price}" required="required">
                        </div>
                        <div class="mb-3 text-start">
                            <label for="releasedDate" class="form-label">Released Date</label>
                            <input type="date" id="releasedDate" name="releasedDate" class="form-control" value="<f:formatDate pattern='yyyy-MM-dd' value='${product.releasedDate}'/>" required="required">
                        </div>
                        <div class="mb-3 text-start">
                            <label for="tags" class="form-label">Tag</label>
                            <select name="tagIds" id="tags" multiple class="form-control">
                                <c:forEach var="tag" items="${listTags}">
                                    <option value="${tag.id}"
                                            <c:if test="${not empty selectedTagIds and fn:contains(selectedTagIds, tag.id)}">
                                                selected
                                            </c:if>>
                                            ${tag.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <br><br>
                        <div class="d-flex justify-content-center">
                            <button type="submit" class="btn custom-btn-submit me-2">Save</button>
                            <button type="button" class="btn custom-btn-return" onclick="history.go(-1);">Cancel</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <jsp:directive.include file="footer.jsp"/>
    <script>
        $(document).ready(function(){
            $("#image").change(function(){
                showImageThumbnail(this);
            });
        });

        function showImageThumbnail(fileInput){
            var file = fileInput.files[0];
            var reader = new FileReader();
            reader.onload = function(e){
                $("#thumbnail").attr("src", e.target.result);
            };
            reader.readAsDataURL(file);
        }
    </script>
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
    <script>
        $(document).ready(function () {
            function getMessageContent(messageId, event) {
                fetch('csvdata?id=' + messageId)
                    .then(response => response.json())
                    .then(data => {
                        if (data.message) {
                            let swalOptions = {
                                title: data.message,
                                confirmButtonText: "OK"
                            };

                            // Kiểm tra các loại thông báo
                            if (messageId === "SUCCESS_CREATE_NEW_SHIRT" || messageId === "SUCCESS_UPDATE_SHIRT") {
                                swalOptions.icon = "success";  // Biểu tượng success
                            } else if (messageId === "DUPLICATE_SHIRT_NAME" || messageId === "FAIL_UPDATE_SHIRT") {
                                swalOptions.icon = "error";  // Biểu tượng error
                            } else {
                                swalOptions.icon = "info";   // Biểu tượng mặc định
                            }

                            // Hiển thị thông báo với Swal
                            Swal.fire(swalOptions)
                                .then((result) => {
                                    if (result.isConfirmed) {
                                        // Chuyển hướng hoặc hành động sau khi nhấn OK nếu cần
                                        if (messageId === "SUCCESS_CREATE_NEW_SHIRT" || messageId === "SUCCESS_UPDATE_SHIRT") {
                                            window.location.href = "list_products";
                                        }
                                    }
                                });

                            event.preventDefault();
                        } else {
                            Swal.fire("Message not found");
                            event.preventDefault();
                        }
                    })
                    .catch(error => {
                        console.error("Error: ", error);
                    });
            }


            $("#productForm").submit(function (event){
                event.preventDefault();

                const productId = $("input[name='productId']").val();
                let category = document.getElementById("category").value;
                let name = $("#productName").val();
                let brand = $("#brand").val();
                let description = $("#description").val();
                let releasedDate = $("#releasedDate").val();
                let tagIds = $("#tags").val();
                let image = $("#image")[0].files[0];
                let price = $("#price").val();
                const oldImage = $("#oldImage").val();
                const specialCharRegex = /[0-9!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]+/;

                if(name.trim() === ""){
                    getMessageContent("NOT_NULL_SHIRT_NAME", event);
                    $("#productName").focus();
                    return;
                }
                else if (name.length > 50) {
                    getMessageContent("OVER_LENGTH_SHIRT_NAME", event);
                    $("#productName").focus();
                    return;
                }
                else if (specialCharRegex.test(name)) {
                    getMessageContent("NO_ITALIC-CHARACTER_SHIRT_NAME", event);
                    $("#productName").focus();
                    return;
                }
                else if (brand.trim() === ""){
                    getMessageContent("NOT_NULL_SHIRT_BRAND", event);
                    $("#brand").focus();
                    return;
                }
                else if (brand.length > 50) {
                    getMessageContent("OVER_LENGTH_SHIRT_BRAND", event);
                    $("#brand").focus();
                    return;
                }
                else if (specialCharRegex.test(brand)) {
                    getMessageContent("NO_ITALIC-CHARACTER_SHIRT_BRAND", event);
                    $("#brand").focus();
                    return;
                }
                else if(description.trim() === ""){
                    getMessageContent("NOT_NULL_SHIRT_DESCRIPTION", event);
                    $("#description").focus();
                    return;
                }
                else if (description.length > 200) {
                    getMessageContent("OVER_LENGTH_SHIRT_DESCRIPTION", event);
                    $("#description").focus();
                    return;
                }
                else if (specialCharRegex.test(description)) {
                    getMessageContent("NO_ITALIC-CHARACTER_SHIRT_DESCRIPTION", event);
                    $("#description").focus();
                    return;
                }
                else if (!releasedDate){
                    getMessageContent("NOT_NUT_SHIRT_DATE", event);
                    $("#releasedDate").focus();
                    return;
                }

                const formData = new FormData();
                formData.append("id", productId);
                formData.append("category", category);
                formData.append("name", name);
                formData.append("brand", brand);
                formData.append("description", description);
                formData.append("releasedDate", releasedDate);
                formData.append("price", price);
                if (tagIds) {
                    for (let i = 0; i < tagIds.length; i++) {
                        formData.append("tagIds", tagIds[i]);
                    }
                }
                if (image) {
                    formData.append("image", image);
                } else {
                    formData.append("oldImage", oldImage);
                }

                const url = productId ? "product_update" : "product_create";
                $.ajax({
                    url: url,
                    type: "POST",
                    data:formData,
                    traditional: true,
                    contentType: false,
                    processData: false,
                    success: function (response){
                        if(response.valid === false){
                            const message1 = productId ? "FAIL_UPDATE_SHIRT" : "DUPLICATE_SHIRT_NAME";
                            getMessageContent(message1, event);
                        }else{
                            const message = productId ? "SUCCESS_UPDATE_SHIRT" : "SUCCESS_CREATE_NEW_SHIRT";
                            getMessageContent(message, event);
                        }
                    },
                    error: function (){
                        getMessageContent("PERSIT_ERROR",event);
                    }
                })
            });
            $("#productForm").validate({
                rules:{
                    category: "required",
                    name: "required",
                    brand: "required",
                    description: "required",
                    releasedDate: "required",
                    tagIds: "required",
                    image: "required",
                    price: "required"
                },
                messages:{
                    category: "",
                    name: "",
                    brand: "",
                    description: "",
                    releasedDate: "",
                    tagIds: "",
                    image: "",
                    price: ""
                }
            })

        });
    </script>
</body>
</html>
