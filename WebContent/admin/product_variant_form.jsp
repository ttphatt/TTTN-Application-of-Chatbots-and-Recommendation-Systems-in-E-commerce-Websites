<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=yes">
    <title>
        <c:choose>
            <c:when test="${variant != null}">Edit Product Variant</c:when>
            <c:otherwise>Create New Product Variant</c:otherwise>
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
                            <c:when test="${variant != null}">Edit Product Variant</c:when>
                            <c:otherwise>Create New Product Variant</c:otherwise>
                        </c:choose>
                    </h1>
                </div>
            </div>

            <div class="row justify-content-center text-center">
                <div class="col-md-7 justify-content-center text-center border custom-border" style="border-radius: 20px; padding: 25px">
                    <form action="${variant == null ? 'product_variant_create' : 'product_variant_update'}" method="post" id="productVariantForm" enctype="multipart/form-data">
                        <c:if test="${variant != null}">
                            <input type="hidden" name="productVariantId" id="productVariantId" value="${variant.id}"/>
                        </c:if>
                        <div class="mb-3 text-start">
                            <label for="productId" class="form-label">Product</label>
                            <select name="productId" id="productId" class="form-select">
                                <c:forEach var="product" items="${productList}">
                                    <option value="${product.id}" ${product.id == variant.productId ? 'selected' : ''}>${product.id} - ${product.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3 text-start">
                            <label for="colorId" class="form-label">Color</label>
                            <select name="colorId" id="colorId" class="form-select">
                                <c:forEach var="color" items="${colorList}">
                                    <option value="${color.id}" ${color.id == variant.colorId ? 'selected' : ''}>${color.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3 text-start">
                            <label for="sizeId" class="form-label">Size</label>
                            <select name="sizeId" id="sizeId" class="form-select">
                                <c:forEach var="size" items="${sizeList}">
                                    <option value="${size.id}" ${size.id == variant.sizeId ? 'selected' : ''}>${size.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3 text-start">
                            <label for="materialId" class="form-label">Material</label>
                            <select name="materialId" id="materialId" class="form-select">
                                <c:forEach var="material" items="${materialList}">
                                    <option value="${material.id}" ${material.id == variant.materialId ? 'selected' : ''}>${material.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3 text-start">
                            <label for="image" class="form-label">Image</label>
                            <input type="file" id="image" name="image" class="form-control" ${variant == null ? 'required' : ''}>

                            <c:if test="${variant != null}">
                                <input type="hidden" id="oldImage" name="oldImage" value="${variant.image}">
                            </c:if>

                            <img alt="Image Preview" id="thumbnail" class="img-thumbnail mt-3" style="max-height: 300px; max-width: 300px"
                                 src="${variant != null ? variant.image : ''}" />
                        </div>
                        <div class="mb-3 text-start">
                            <label for="price" class="form-label">Price</label>
                            <input type="number" step="0.01" min="0.01" id="price" name="price" class="form-control" value="${variant.price}" required="required">
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
                                            window.location.href = "list_product_variants";
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


            $("#productVariantForm").submit(function (event){
                event.preventDefault();

                const productVariantId = $("input[name='productVariantId']").val();
                const oldImage = $("#oldImage").val();
                let productId = document.getElementById("productId").value;
                let colorId = document.getElementById("colorId").value;
                let sizeId = document.getElementById("sizeId").value;
                let materialId = document.getElementById("materialId").value;
                let image = $("#image")[0].files[0];
                let price = $("#price").val();

                const formData = new FormData();
                formData.append("productVariantId", productVariantId);
                formData.append("productId", productId);
                formData.append("colorId", colorId);
                formData.append("sizeId", sizeId);
                formData.append("materialId", materialId);
                formData.append("price", price);
                if (image) {
                    formData.append("image", image);
                } else {
                    formData.append("oldImage", oldImage);
                }

                const url = productVariantId ? "product_variant_update" : "product_variant_create";
                $.ajax({
                    url: url,
                    type: "POST",
                    data:formData,
                    contentType: false,
                    processData: false,
                    success: function (response){
                        if(response.valid === false){
                            const message1 = productVariantId ? "FAIL_UPDATE_SHIRT" : "DUPLICATE_SHIRT_NAME";
                            getMessageContent(message1, event);
                        }else{
                            const message = productVariantId ? "SUCCESS_UPDATE_SHIRT" : "SUCCESS_CREATE_NEW_SHIRT";
                            getMessageContent(message, event);
                        }
                    },
                    error: function (){
                        getMessageContent("PERSIT_ERROR",event);
                    }
                })
            });
            $("#productVariantForm").validate({
                rules:{
                    productId: "required",
                    colorId: "required",
                    sizeId: "required",
                    materialId: "required",
                    image: "required",
                    price: "required"
                },
                messages:{
                    productId: "",
                    colorId: "",
                    sizeId: "",
                    materialId: "",
                    image: "",
                    price: ""
                }
            })

        });
    </script>
</body>
</html>
