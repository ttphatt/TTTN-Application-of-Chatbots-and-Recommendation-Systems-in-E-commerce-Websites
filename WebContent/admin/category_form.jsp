<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=yes">
	<title>
		<c:if test="${category != null}">
			Category Editing
		</c:if>
				
		<c:if test="${category == null}">
			Create a new category
		</c:if>
	</title>

	<jsp:include page="pagehead.jsp"></jsp:include>
	<jsp:include page="pageLoad.jsp"/>

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
			<div class="row justify-content-center mb-5">
				<div class="row custom-row-1 text-center" style="width: fit-content">
					<h1>
						<c:if test="${category != null}">
							Edit Category
						</c:if>

						<c:if test="${category == null}">
							Create a New Category
						</c:if>
					</h1>
				</div>
			</div>

			<br>

			<div class="row justify-content-center text-center">
				<div class="col-md-auto justify-content-center text-center border custom-border" style="border-radius: 20px; padding: 25px">
					<c:if test="${category != null}">
					<form action="update_category" method="post" id="listForm">
						<input type="hidden" name="categoryId" value="${category.id}">

						</c:if>

						<c:if test="${category == null}">
						<form action="create_category" method="post" id="listForm">

							</c:if>
							<table>
								<tr>
									<td align="left">Category's name:&nbsp;</td>
									<td align="right"><input type="text" id="categoryName" name="categoryName" size="20" value="${category.name}" required="required" class="form-control"/></td>
								</tr>

								<tr>
									<td align="left">Parent category:&nbsp;</td>
									<td align="right">
										<select name="parentId" class="form-control">
											<option value="">-- Select Parent --</option>
											<c:forEach var="parent" items="${parentList}">
												<option value="${parent.id}"
														<c:if test="${category.parentId != null && category.parentId.equals(parent.id)}">selected</c:if>>
														${parent.name}
												</option>
											</c:forEach>
										</select>
									</td>
								</tr>

								<tr><td>&nbsp;</td></tr>

								<tr>
									<td colspan="2" align="center">
										<button type = "submit" class="btn custom-btn-submit">Save</button>
										<button type="button" class="btn custom-btn-return" onclick="history.go(-1);">Cancel</button>
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
<script>
	$(document).ready(function (){
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
							if (messageId === "SUCCESS_CREATE_NEW_TYPE" || messageId === "SUCCESS_UPDATE_TYPE") {
								swalOptions.icon = "success";  // Biểu tượng success
							} else if (messageId === "DUPLICATE_TYPE" || messageId === "FAIL_UPDATE_TYPE" || messageId ==="PERSIT_ERROR") {
								swalOptions.icon = "error";  // Biểu tượng error
							} else {
								swalOptions.icon = "info";   // Biểu tượng mặc định
							}

							// Hiển thị thông báo với Swal
							Swal.fire(swalOptions)
									.then((result) => {
										if (result.isConfirmed) {
											// Chuyển hướng hoặc hành động sau khi nhấn OK nếu cần
											if (messageId === "SUCCESS_CREATE_NEW_TYPE" || messageId === "SUCCESS_UPDATE_TYPE") {
												window.location.href = "list_category";
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

		$("#listForm").submit(function (event){
			event.preventDefault();

			var categoryName = $("#categoryName").val();
			const parentId = $("select[name='parentId']").val();
			const categoryId = $("input[name='categoryId']").val(); // Lấy giá trị type nếu tồn tại
			var specialSymbolsAndNumbersRegex = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]+/;

			if(categoryName.trim() === ""){
				getMessageContent("NOT_NULL_TYPE", event);
				$("#categoryName").focus();
				return;
			}else if(specialSymbolsAndNumbersRegex.test(categoryName.trim())){
				getMessageContent("SPECIAL_CHARACTER_NUMBER_IN_TYPE", event);
				event.preventDefault();
				$("#categoryName").focus();
				return
			}

			// Xác định URL và thông báo dựa trên create/update
			const url = categoryId ? "update_category" : "create_category";

			$.ajax({
				url: url,
				type: "POST",
				data:{
					categoryName,
					categoryId,
					parentId: parentId !== "" ? parentId : null
				},
				success: function (response){
					if(response.valid){
						const message = categoryId ? "SUCCESS_UPDATE_TYPE" : "SUCCESS_CREATE_NEW_TYPE";
						getMessageContent(message, event);
					}else{
						const message1 = categoryId ? "FAIL_UPDATE_TYPE" : "DUPLICATE_TYPE";
						getMessageContent(message1, event);
					}
				},
				error: function (){
					getMessageContent("PERSIT_ERROR",event);
				}
			})
		});

		$("#listForm").validate({
			rules:{
				categoryName: "required",
			},
			messages:{
				categoryName: "",
			}
		})

	});
</script>
</html>