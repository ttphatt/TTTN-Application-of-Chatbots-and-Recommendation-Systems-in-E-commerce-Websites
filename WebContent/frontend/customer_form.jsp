<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<table cellpadding="10px">
	<tr>
		<td align="left">Email</td>
		<td align="left"><input type="email" id="email" name="email" size="40" value="${customer.email}"  minlength="5" maxlength="50" class="form-control"/></td>
	</tr>

	<tr>
		<td align="left">First Name</td>
		<td align="left"><input type="text" id="firstname" name="firstname" size="40" value="${customer.firstname}"  minlength="2" maxlength="50" class="form-control"/></td>
	</tr>

	<tr>
		<td align="left">Last Name</td>
		<td align="left"><input type="text" id="lastname" name="lastname" size="40" value="${customer.lastname}"  minlength="2" maxlength="50" class="form-control"/></td>
	</tr>

	<tr>
		<td align="left">Password</td>
		<td align="left"><input type="password" id="password" name="password" size="40" value=""  minlength="6" maxlength="50" class="form-control"/></td>
	</tr>

	<tr>
		<td align="left">Confirm password</td>
		<td align="left"><input type="password" id="confirmPassword" name="confirmPassword" size="40" value="" class="form-control"/></td>
	</tr>

	<tr>
		<td align="left">Phone number</td>
		<td align="left"><input type="text" id="phone" name="phone" size="20" value="${customer.phoneNumber}"  minlength="10" maxlength="20" class="form-control"/></td>
	</tr>

	<tr>
		<td align="left">Gender</td>
		<td align="left">
			<select name="gender" id="gender" class="form-control">
				<option value="">-- Select Gender --</option>
				<option value="Male" <c:if test="${customer.gender == 'Male'}">selected</c:if>>Male</option>
				<option value="Female" <c:if test="${customer.gender == 'Female'}">selected</c:if>>Female</option>
				<option value="Other" <c:if test="${customer.gender == 'Other'}">selected</c:if>>Other</option>
			</select>
		</td>
	</tr>

	<tr>
		<td align="left">Birthday</td>
		<td align="left">
			<input type="date" id="birthday" name="birthday" class="form-control"
				   value="<fmt:formatDate value='${customer.birthday}' pattern='yyyy-MM-dd'/>" />
		</td>
	</tr>

	<tr>
		<td align="left">Address Line 1</td>
		<td align="left"><input type="text" id="address1" name="address1" size="70" value="${customer.addressLine1}"  minlength="5" maxlength="50" class="form-control"/></td>
	</tr>

	<tr>
		<td align="left">Address Line 2</td>
		<td align="left"><input type="text" id="address2" name="address2" size="70" value="${customer.addressLine2}"  minlength="5" maxlength="50" class="form-control"/></td>
	</tr>

	<tr>
		<td align="left">City</td>
		<td align="left"><input type="text" id="city" name="city" size="20" value="${customer.city}"  minlength="1" maxlength="50" class="form-control"/></td>
	</tr>

	<tr>
		<td align="left">State</td>
		<td align="left"><input type="text" id="state" name="state" size="20" value="${customer.state}"  minlength="1" maxlength="50" class="form-control"/></td>
	</tr>

	<tr>
		<td align="left">Zip Code</td>
		<td align="left"><input type="number" id="zip" name="zip" size="20" value="${customer.zipcode}"  minlength="5" maxlength="10" class="form-control"/></td>
	</tr>

	<tr>
		<td align="left">Country</td>
		<td align="left">
			<select name="country" id="country" class="btn btn-outline-secondary dropdown-toggle dropdown-toggle-split">
				<c:forEach items="${mapCountries}" var="country">
					<option value="${country.value}"<c:if test='${customer.country eq country.value}'>selected='selected'</c:if> >${country.key}</option>
				</c:forEach>
			</select>
		</td>
	</tr>

	<tr><td>&nbsp;</td></tr>

	<tr>
		<td colspan="2" align="center">
			<button type="submit" class="btn custom-btn-details">Save</button>
			<button type="button" class="btn custom-btn-return" onclick="history.go(-1);">Cancel</button>
		</td>
	</tr>
</table>
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
							if (messageId === "SUCCESS_CREATE_NEW_CUSTOMER" || messageId === "SUCCESS_UPDATE_CUSTOMER") {
								swalOptions.icon = "success";  // Biểu tượng success
							} else if (messageId === "DUPLICATE_CUSTOMER_EMAIL" || messageId === "FAIL_UPDATE_CUSTOMER") {
								swalOptions.icon = "error";  // Biểu tượng error
							} else {
								swalOptions.icon = "info";   // Biểu tượng mặc định
							}

							// Hiển thị thông báo với Swal
							Swal.fire(swalOptions)
									.then((result) => {
										if (result.isConfirmed) {
											// Chuyển hướng hoặc hành động sau khi nhấn OK nếu cần
											if (messageId === "SUCCESS_CREATE_NEW_CUSTOMER" || messageId === "SUCCESS_UPDATE_CUSTOMER") {
												window.location.href = "/StoreWebsite/login";
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
						getMessageContent("PERSIT_ERROR",event);
					});
		}


		$("#customerForm").submit(function (event){
			event.preventDefault();

			const customerId = $("input[name='customerId']").val();
			let email = $("#email").val();
			let firstname = $("#firstname").val();
			let lastname = $("#lastname").val();
			let password = $("#password").val();
			let confirmPassword = $("#confirmPassword").val();
			let phone = $("#phone").val();
			let address1 = $("#address1").val();
			let address2 = $("#address2").val();
			let city = $("#city").val();
			let state = $("#state").val();
			let zip = $("#zip").val();
			let gender = $("#gender").val();
			let birthday = $("#birthday").val();
			let country = document.getElementById("country").value;
			const specialCharRegex = /^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸỳỵỷỹý\s.'-]{2,50}$/;
			const onlyNumbersRegex = /^[0-9]+$/;

			if(email.trim() === ""){
				getMessageContent("NOT_NULL_CUSTOMER_EMAIL", event);
				$("#email").focus();
				return;
			}
			else if (email.length > 50) {
				getMessageContent("OVER_LENGTH_CUSTOMER_EMAIL", event);
				$("#email").focus();
				return;
			}
			else if (firstname.trim() === ""){
				getMessageContent("NOT_NULL_CUSTOMER_FIRST_NAME", event);
				$("#firstname").focus();
				return;
			}
			else if (firstname.length > 50) {
				getMessageContent("OVER_LENGTH_CUSTOMER_FIRST_NAME", event);
				$("#firstname").focus();
				return;
			}
			else if (specialCharRegex.test(firstname)) {
				getMessageContent("NO_ITALIC-CHARACTER_CUSTOMER_FIRST_NAME", event);
				$("#firstname").focus();
				return;
			}
			else if (lastname.trim() === ""){
				getMessageContent("NOT_NULL_CUSTOMER_LAST_NAME", event);
				$("#lastname").focus();
				return;
			}
			else if (lastname.length > 50) {
				getMessageContent("OVER_LENGTH_CUSTOMER_LAST_NAME", event);
				$("#lastname").focus();
				return;
			}
			else if (specialCharRegex.test(lastname)) {
				getMessageContent("NO_ITALIC-CHARACTER_CUSTOMER_LAST_NAME", event);
				$("#lastname").focus();
				return;
			}
			else if (confirmPassword.length === 0 && password.length !== 0){
				getMessageContent("NOT_NULL_CONFIRM_PASSWORD", event);
				$("#confirmPassword").focus();
				return;
			}
			else if (password.length > 0 && confirmPassword !== password){
				getMessageContent("NOT_SAME_CONFIRM_PASSWORD", event);
				$("#confirmPassword").focus();
				return;
			}
			else if(phone.trim() === ""){
				getMessageContent("NOT_NULL_CUSTOMER_PHONE_NUMBER", event);
				$("#phone").focus();
				return;
			}
			else if (phone.length > 10) {
				getMessageContent("OVER_LENGTH_CUSTOMER_PHONE_NUMBER", event);
				$("#phone").focus();
				return;
			}
			else if (specialCharRegex.test(phone)) {
				getMessageContent("NO_ITALIC-CHARACTER_CUSTOMER_PHONE_NUMBER", event);
				$("#phone").focus();
				return;
			}
			else if (!onlyNumbersRegex.test(phone)) {
				getMessageContent("ONLY_NUMBER_CUSTOMER_PHONE_NUMBER", event);
				$("#phone").focus();
				return;
			}
			else if (gender.trim() === "") {
				getMessageContent("NOT_NULL_CUSTOMER_GENDER", event);
				$("#gender").focus();
				return;
			}
			else if (birthday.trim() === "") {
				getMessageContent("NOT_NULL_CUSTOMER_BIRTHDAY", event);
				$("#birthday").focus();
				return;
			}
			else if(address1.trim() === ""){
				getMessageContent("NOT_NULL_ADDRESS_1", event);
				$("#address1").focus();
				return;
			}
			else if (specialCharRegex.test(address1)) {
				getMessageContent("NO_ITALIC-CHARACTER_CUSTOMER_ADDRESS_LINE_1", event);
				$("#address1").focus();
				return;
			}
			else if(address2.trim() === ""){
				getMessageContent("NOT_NULL_ADDRESS_2", event);
				$("#address2").focus();
				return;
			}
			else if (specialCharRegex.test(address2)) {
				getMessageContent("NO_ITALIC-CHARACTER_CUSTOMER_ADDRESS_LINE_2", event);
				$("#address2").focus();
				return;
			}
			else if(city.trim() === ""){
				getMessageContent("NOT_NULL_CUSTOMER_CITY", event);
				$("#city").focus();
				return;
			}
			else if (specialCharRegex.test(city)) {
				getMessageContent("NO_ITALIC-CHARACTER_CUSTOMER_CITY", event);
				$("#city").focus();
				return;
			}
			else if(state.trim() === ""){
				getMessageContent("NOT_NULL_CUSTOMER_STATE", event);
				$("#state").focus();
				return;
			}
			else if (specialCharRegex.test(state)) {
				getMessageContent("NO_ITALIC-CHARACTER_CUSTOMER_STATE", event);
				$("#state").focus();
				return;
			}
			else if(zip.trim() === ""){
				getMessageContent("NOT_NULL_CUSTOMER_ZIPCODE", event);
				$("#zip").focus();
				return;
			}
			else if (zip.length > 9) {
				getMessageContent("OVER_LENGTH_CUSTOMER_ZIPCODE", event);
				$("#zip").focus();
				return;
			}
			else if (specialCharRegex.test(zip)) {
				getMessageContent("NO_ITALIC-CHARACTER_CUSTOMER_ZIPCODE", event);
				$("#zip").focus();
				return;
			}

			const url = customerId ? "update_customer" : "register_customer";
			$.ajax({
				url: url,
				type: "POST",
				data: {
					customerId,
					email,
					firstname,
					lastname,
					password,
					phone,
					birthday,
					gender,
					address1,
					address2,
					city,
					state,
					zip,
					country
				},
				success: function (response){
					console.log("valid: " + response.valid);
					if(response.valid === true || response.valid === undefined){
						const message = customerId ? "SUCCESS_UPDATE_CUSTOMER" : "SUCCESS_CREATE_NEW_CUSTOMER";
						getMessageContent(message, event);
					}else{
						const message1 = customerId ? "FAIL_UPDATE_CUSTOMER" : "DUPLICATE_CUSTOMER_EMAIL";
						getMessageContent(message1, event);
					}
				},
				error: function (){
					getMessageContent("PERSIT_ERROR",event);
				}
			})
			// this.submit();
		});
		$("#customerForm").validate({
			rules:{
				email: "required",
				firstname: "required",
				lastname: "required",
				password: "required",
				phone: "required",
				birthday: "required",
				gender: "required",
				address1: "required",
				address2: "required",
				city: "required",
				state: "required",
				zip: "required",
				country: "required"
			},
			messages:{
				email: "",
				firstname: "",
				lastname: "",
				password: "",
				phone: "",
				birthday: "",
				gender: "",
				address1: "",
				address2: "",
				city: "",
				state: "",
				zip: "",
				country: ""
			}
		})

	});
</script>