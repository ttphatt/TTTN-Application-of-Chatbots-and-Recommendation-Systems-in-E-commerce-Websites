<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<title>Shirt Store Administration</title>
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
			<div class="row justify-content-center">
				<div class="row custom-row-1 text-center" style="width: fit-content">
					<h1>
						<c:if test="${user != null}">
							Edit User
						</c:if>

						<c:if test="${user == null}">
							Create New User
						</c:if>
					</h1>
				</div>
			</div>

			<br><br>

			<div class="row justify-content-center text-center">
				<div class="col-md-auto justify-content-center text-center border custom-border" style="border-radius: 20px; padding: 25px">
					<c:if test="${user != null}">
					<form action="update_user" method="post" id="userForm">
						<input type="hidden" name="userId" value="${user.id}">

						</c:if>

						<c:if test="${user == null}">
						<form action="create_user" method="post" id="userForm">

							</c:if>

							<table>
								<tr>
									<td align="left">Email&nbsp;</td>
									<td align="right"><input type="email" id="email" name="email" size="20" value="${user.email}" class="form-control" required="required"/></td>
								</tr>

								<tr>
									<td align="left">Full Name&nbsp;</td>
									<td align="right"><input type="text" id= "fullname" name="fullname" size="20" value="${user.fullName}" class="form-control" required="required"/></td>
								</tr>

								<tr>
									<td align="left">Password&nbsp;</td>
									<td align="right"><input type="password" id="password" name="password" size="20" value="" class="form-control" required="required" minlength="6" maxlength="100"/></td>
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
							if (messageId === "SUCCESS_CREATE_NEW_USER" || messageId === "SUCCESS_UPDATE_USER") {
								swalOptions.icon = "success";  // Biểu tượng success
							} else if (messageId === "DUPLICATE_USER" || messageId === "FAIL_UPDATE_USER") {
								swalOptions.icon = "error";  // Biểu tượng error
							} else {
								swalOptions.icon = "info";   // Biểu tượng mặc định
							}

							// Hiển thị thông báo với Swal
							Swal.fire(swalOptions)
									.then((result) => {
										if (result.isConfirmed) {
											// Chuyển hướng hoặc hành động sau khi nhấn OK nếu cần
											if (messageId === "SUCCESS_CREATE_NEW_USER" || messageId === "SUCCESS_UPDATE_USER") {
												window.location.href = "list_users";
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


		$("#userForm").submit(function (event){
			event.preventDefault();

			var email = $("#email").val();
			var fullname = $("#fullname").val();
			var password = $("#password").val();
			const userId = $("input[name='userId']").val(); // Lấy giá trị userId nếu tồn tại
			var emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
			var specialSymbolsAndNumbersRegex = /[0-9!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]+/;
			var specialSymbolsAndNumbersRegexPassword = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]+/;

			if(email.trim() === ""){
				getMessageContent("NOT_NULL_EMAIL", event);
				$("#email").focus();
				return;
			}
			else if(!emailRegex.test(email.trim())){
				getMessageContent("INVALID_EMAIL_ADDRESS", event);
				$("#email").focus();
				return;
			}else if(fullname.trim() ===""){
				getMessageContent("NOT_NULL_FULLNAME",event);
				$("#fullname").focus();
				return;
			}else if(specialSymbolsAndNumbersRegex.test(fullname.trim())){
				getMessageContent("SPECIAL_CHARACTER_NUMBER_IN_FULLNAME", event);
				event.preventDefault();
				$("#fullname").focus()
				return
			}
			else if(!userId && password.trim() ==="") {
				getMessageContent("NOT_NULL_PASSWORD", event);
				$("#password").focus();
				return;
			}
			else if(specialSymbolsAndNumbersRegexPassword.test(password.trim())){
				getMessageContent("SPECIAL_CHARACTER_NUMBER_IN_PASSWORD", event);
				event.preventDefault();
				$("#password").focus()
				return
			}

			// Xác định URL và thông báo dựa trên create/update
			const url = userId ? "update_user" : "create_user";
			$.ajax({
				url: url,
				type: "POST",
				data:{
					email, fullname, password, userId
				},
				success: function (response){
					if(response.valid){
						const message = userId ? "SUCCESS_UPDATE_USER" : "SUCCESS_CREATE_NEW_USER";
						getMessageContent(message, event)
					}else{
						const message1 = userId ? "FAIL_UPDATE_USER" : "DUPLICATE_USER";
						getMessageContent(message1, event)
					}
				},
				error: function (){
					Swal.fire("Error !!!");
				}
			})
		});
		$("#userForm").validate({
			rules:{
				email: "required",
				fullname: "required",
				password: "required",
			},
			messages:{
				email: "",
				fullname: "",
				password: "",
			}
		})

	});
</script>
</html>