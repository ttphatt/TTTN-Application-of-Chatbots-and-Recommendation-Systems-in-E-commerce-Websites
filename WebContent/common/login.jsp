<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Form</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/newLogin.css">
    <script>
        // Lấy giá trị isAdminLogin từ server truyền xuống
        let isAdminLogin = ${isAdminLogin ? 'true' : 'false'};

        function toggleLogin() {
            let form = document.getElementById("loginForm");
            let heading = document.getElementById("loginHeading");
            let toggleText = document.getElementById("toggleLogin");

            if (isAdminLogin) {
                // Đang ở Admin -> chuyển về Customer
                form.action = "/StoreWebsite/login";
                heading.textContent = "Customer Login";
                toggleText.textContent = "Login with admin account";
                isAdminLogin = false;
            } else {
                // Đang ở Customer -> chuyển sang Admin
                form.action = "/StoreWebsite/admin/login";
                heading.textContent = "Admin Login";
                toggleText.textContent = "Login with customer account";
                isAdminLogin = true;
            }
        }
    </script>
</head>
<body>
<form id="loginForm" action="${isAdminLogin ? '/StoreWebsite/admin/login' : '/StoreWebsite/login'}" method="post">
    <c:if test="${message != null}">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="alert alert-danger">
                        ${message}
                </div>
            </div>
        </div>
    </c:if>

    <h3 id="loginHeading">${isAdminLogin ? 'Admin Login' : 'Customer Login'}</h3>

    <label for="email">Username</label>
    <input type="text" placeholder="Email" name="email" id="email" required>

    <label for="password">Password</label>
    <input type="password" placeholder="Password" name="password" id="password" required>

    <button type="submit">Log In</button>
    <p class="social-text">
        <a href="javascript:void(0);" id="toggleLogin" onclick="toggleLogin()">
            ${isAdminLogin ? 'Login with customer account' : 'Login with admin account'}
        </a>
    </p>
</form>
</body>
</html>
