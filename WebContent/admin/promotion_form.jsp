<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=yes">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <title>
        <c:choose>
            <c:when test="${promotion != null}">Edit Promotion</c:when>
            <c:otherwise>Create New Promotion</c:otherwise>
        </c:choose>
    </title>
    <jsp:include page="pagehead.jsp"></jsp:include>

    <link rel="stylesheet" type="text/css" href="../css/custom_background_template.css"/>
    <link rel="stylesheet" type="text/css" href="../css/custom_row_template.css"/>
    <link rel="stylesheet" type="text/css" href="../css/table_list_admin_template.css"/>
    <link rel="stylesheet" type="text/css" href="../css/search_button_template.css"/>
    <link rel="stylesheet" type="text/css" href="../css/custom_border_template.css"/>
</head>
<body>
<jsp:directive.include file="header.jsp"/>

    <div class="background-div-content">
        <div class="container mt-5">
            <div class="row justify-content-center">
                <div class="row custom-row-1 text-center" style="width: fit-content">
                    <h1>
                        <c:choose>
                            <c:when test="${promotion != null}">Edit Promotion</c:when>
                            <c:otherwise>Create New Promotion</c:otherwise>
                        </c:choose>
                    </h1>
                </div>
            </div>

            <div class="row justify-content-center mt-4 mb-5">
                <div class="col-md-8 justify-content-center text-center border custom-border" style="border-radius: 20px; padding: 25px">
<%--                    <form action="${promotion == null ? 'create_promotion' : 'update_promotion'}" method="post" id="promotionForm">--%>
                    <c:if test="${promotion != null}">
                    <form action="promotion_update" method="post" id="promotionForm">
                        <input type="hidden" name="promotionId" value="${promotion.id}" />
                        </c:if>

                        <c:if test="${promotion == null}">
                                <form action="promotion_create" method="post" id="promotionForm">
                            </c:if>

                                <div class="mb-3 text-start">
                                    <label for="promotionId" class="form-label">Promotion code</label>
                                    <input type="text" id="promotionId" name="promotionId" class="form-control"
                                           value="${promotion != null ? promotion.id : ''}"
                                           required ${promotion != null ? 'readonly' : ''}>
                                </div>

                                <div class="mb-3 text-start">
                                    <label for="description" class="form-label">Description</label>
                                    <textarea rows="3" name="description" id="description" class="form-control"
                                              required>${promotion != null ? promotion.description : ''}</textarea>
                                </div>

                        <div class="row justify-content-center mb-4 mt-4">
                            <div class="row custom-row text-center" style="width: flex">
                                <label for="startDate" class="form-label fs-5">Validity Period</label>
                            </div>
                        </div>
                        <div class="mb-3 text-start" style="display: flex; gap: 10px;">
                            <div style="flex: 1;">
                                <label for="startDate" class="form-label">Start Date</label>
                                <input type="date" id="startDate" name="startDate" class="form-control" value="<f:formatDate pattern='yyyy-MM-dd' value='${promotion.startDate}'/>" required>
                            </div>
                            <div style="flex: 1;">
                                <label for="endDate" class="form-label">End Date</label>
                                <input type="date" id="endDate" name="endDate" class="form-control" value="<f:formatDate pattern='yyyy-MM-dd' value='${promotion.endDate}'/>" required>
                            </div>
                        </div>
                                <div class="mb-3 text-start">
                                    <label for="type" class="form-label">Promotion Type</label>
                                    <select name="type" id="type" class="form-control"
                                    ${promotion != null ? 'disabled' : ''} required>
                                        <option value="" ${promotion != null && promotion.type == null ? 'selected' : ''}></option>
                                        <option value="order_discount" ${promotion != null && promotion.type == 'order_discount' ? 'selected' : ''}>Order Discount</option>
                                        <option value="shipping_discount" ${promotion != null && promotion.type == 'shipping_discount' ? 'selected' : ''}>Shipping Discount</option>
                                    </select>
                                </div>
                                <div class="row justify-content-center mb-4 mt-4">
                                    <div class="row custom-row text-center" style="width: flex">
                                        <label for="percent" class="form-label">Detail Discount</label>
                                    </div>
                                </div>

                                <div class="mb-3 text-start" style="display: flex; gap: 10px;">
                                    <div style="flex: 1; position: relative;">
                                        <label for="percent" class="form-label">Discount Rate</label>
                                        <input type="number" id="percent" name="percent" class="form-control"
                                               value="${promotion != null ? promotion.percent : ''}"
                                               required min="0" max="100" step="0.01" ${promotion != null ? 'readonly' : ''}>
                                        <span style="position: absolute; right: 10px; top: 35px; pointer-events: none;">%</span>
                                    </div>
                                    <div style="flex: 1;">
                                        <label for="maxDiscount" class="form-label">Max Discount</label>
                                        <input type="number" id="maxDiscount" name="maxDiscount" class="form-control"
                                               value="${promotion != null ? promotion.maxDiscount : ''}"
                                               required min="0" step="0.01" ${promotion != null ? 'readonly' : ''}>
                                    </div>
                                </div>

                                <div class="mb-3 text-start">
                                    <label for="priceLimit" class="form-label">Order's Limit Price To Apply Promotion</label>
                                    <input type="number" id="priceLimit" name="priceLimit" class="form-control"
                                           value="${promotion != null ? promotion.priceLimit : ''}"
                                           required ${promotion != null ? 'readonly' : ''}>
                                </div>


                        <div class="mb-3 text-start">
                            <label for="quantityInStock" class="form-label">Quantity of promotion</label>
                            <input type="number" id="quantityInStock" name="quantityInStock" class="form-control" value="${promotion.quantityInStock}" required>
                        </div>

                                <div class="mb-3 text-start">
                                    <label for="status" class="form-label">State</label>
                                    <select name="status" id="status" class="form-control" required>
                                        <option value="pending" ${promotion != null && promotion.status == 'pending' ? 'selected' : ''}>Pending</option>
                                        <option value="active" ${promotion != null && promotion.status == 'active' ? 'selected' : ''}>Active</option>
                                        <option value="expired" ${promotion != null && promotion.status == 'expired' ? 'selected' : ''}>Expired</option>
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
</body>
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
                        if (messageId === "SUCCESS_CREATE_NEW_PROMOTION" || messageId === "SUCCESS_UPDATE_PROMOTION") {
                            swalOptions.icon = "success";  // Biểu tượng success
                        } else if (messageId === "DUPLICATE_PROMOTION" || messageId === "FAIL_UPDATE_PROMOTION") {
                            swalOptions.icon = "error";  // Biểu tượng error
                        } else {
                            swalOptions.icon = "info";   // Biểu tượng mặc định
                        }

                        // Hiển thị thông báo với Swal
                        Swal.fire(swalOptions)
                            .then((result) => {
                                if (result.isConfirmed) {
                                    // Chuyển hướng hoặc hành động sau khi nhấn OK nếu cần
                                    if (messageId === "SUCCESS_CREATE_NEW_PROMOTION" || messageId === "SUCCESS_UPDATE_PROMOTION") {
                                        window.location.href = "list_promotions";
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

        $("#promotionForm").submit(function (event){
            event.preventDefault();

            const promotionId = $("#promotionId").val();
            const description = $("#description").val();
            const maxDiscount = parseFloat($("#maxDiscount").val());
            const type = document.getElementById("type").value;
            const status = $("#status").val();
            const quantityInStock = parseInt($("#quantityInStock").val());
            const priceLimit = parseFloat($("#priceLimit").val());
            const percent = parseFloat($("#percent").val());
            // Fetch raw date inputs
            const startDate = $("#startDate").val();
            const endDate = $("#endDate").val();

            var specialSymbolsAndNumbersRegex = /[!@#^&*()_+\-=\[\]{};':"\\|<>\/?]+/;

            if (!promotionId || promotionId.trim() === "") {
                getMessageContent("NOT_NULL_PROMOTION", event);
                $("#promotionId").focus();
                return
            }
            else if(promotionId.length >20){
                getMessageContent("OVER_LENGTH_FIELD_PROMOTION", event);
                $("#promotionId").focus();
                return;
            }
            else if(specialSymbolsAndNumbersRegex.test(promotionId.trim())){
                getMessageContent("NO_ITALIC_CHARACTER_FIELD_PROMOTION", event);
                event.preventDefault();
                $("#promotionId").focus()
                return
            }
            else if (!description || description.trim() === "") {
                getMessageContent("NOT_NULL_DESCRIPTION", event);
                $("#description").focus();
                return;
            }
            else if (description.length >200){
                getMessageContent("OVER_LENGTH_FIELD_DESCRIPTION", event);
                $("#description").focus();
                return;
            }
            else if(specialSymbolsAndNumbersRegex.test(description.trim())){
                getMessageContent("NO_ITALIC_CHARACTER_FIELD_DESCRIPTION", event);
                event.preventDefault();
                $("#description").focus()
                return
            }
            else if (!startDate || !endDate) {
                getMessageContent("NOT_NULL_DATE", event);
                event.preventDefault();
                return
            }
            else if (startDate >= endDate) {
                getMessageContent("ILLOGICAL_DATE_FIELD", event);
                event.preventDefault();
                $("#startDate").focus()
                return
            }
            else if (type.trim() === "") {
                getMessageContent("NOT_NULL_PROMOTION_TYPE", event);
                event.preventDefault();
                $("#type").focus()
                return
            }
            else if (isNaN(percent)) {
                getMessageContent("NOT_NULL_DISCOUNT_RATE", event);
                event.preventDefault();
                $("#percent").focus()
                return
            }
            else if (percent <= 0 || percent > 100) {
                getMessageContent("ERROR_NUM_FIELD_DISCOUNT_RATE", event);
                event.preventDefault();
                $("#percent").focus()
                return
            }
            else if (isNaN(maxDiscount)) {
                getMessageContent("NOT_NULL_MAX_DISCOUNT", event);
                event.preventDefault();
                $("#maxDiscount").focus()
                return
            }
            else if (maxDiscount <= 0) {
                getMessageContent("ERROR_NUM_FIELD_MAX_DISCOUNT", event);
                event.preventDefault();
                $("#maxDiscount").focus()
                return
            }
            else if (isNaN(priceLimit)) {
                getMessageContent("NOT_NULL_PRICE_LIMIT", event);
                event.preventDefault();
                $("#priceLimit").focus()
                return
            }
            else if (priceLimit <= 0) {
                getMessageContent("ERROR_NUM_FIELD_PRICE_LIMIT", event);
                event.preventDefault();
                $("#priceLimit").focus()
                return
            }
            else if (isNaN(quantityInStock)) {
                getMessageContent("NOT_NULL_QUANTITY_IN_STOCK", event);
                event.preventDefault();
                $("#quantityInStock").focus()
                return
            }
            else if (quantityInStock <= 0) {
                getMessageContent("ERROR_NUM_FIELD_QUANTITY_IN_STOCK", event);
                event.preventDefault();
                $("#quantityInStock").focus()
                return
            }

            // Xác định chế độ Update hay Create
            const isUpdate = ${sessionScope.isUpdate};

            // In ra giá trị cho debug
            console.log("Promotion ID:", promotionId);
            console.log("isUpdate:", isUpdate);

            // Xác định URL dựa trên chế độ
            const url = isUpdate ? "promotion_update" : "promotion_create";

            $.ajax({
                url: url,
                type: "POST",
                data:{
                    promotionId,
                    description,
                    maxDiscount,
                    quantityInStock,
                    priceLimit,
                    percent,
                    startDate,
                    endDate,
                    status,
                    type,
                    // startDate,
                    // endDate,
                },
                success: function (response){
                    if(!response.valid){
                        const message1 = isUpdate ? "FAIL_UPDATE_PROMOTION" : "DUPLICATE_PROMOTION";
                        getMessageContent(message1, event)
                    }else{
                        const message = isUpdate ? "SUCCESS_UPDATE_PROMOTION" : "SUCCESS_CREATE_NEW_PROMOTION";
                        getMessageContent(message, event)
                    }
                },
                error: function (){
                    getMessageContent("PERSIT_ERROR",event);
                }
            })
        });
        $("#promotionForm").validate({
            rules:{
                promotionId: "required",
                description: "required",
                maxDiscount: "required",
                quantityInStock: "required",
                priceLimit: "required",
                percent: "required",
                type:"required",
                startDate: "required",
                endDate: "required",
                status: "required",
            },
            messages:{
                promotionId: "",
                description: "",
                maxDiscount: "",
                quantityInStock:"",
                priceLimit:"",
                percent:"",
                type:"",
                startDate:"",
                endDate:"",
                status:""
            }
        })

    });
</script>
</html>
