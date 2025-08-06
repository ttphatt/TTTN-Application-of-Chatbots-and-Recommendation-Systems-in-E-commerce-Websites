<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Page Not Found error</title>
	<link rel="stylesheet" href="../css/style.css">
</head>
<body>
	<div align="center">
		<div>
			<img alt="Error Image" src="${pageContext.request.contextPath}/images/Error.png" style="max-height: 600px; max-width: 600px;">
<!-- 			<h2>Sorry but the page you are trying to find could not be found</h2> -->
		</div>
	
		<div>
			<a href="javascript:history.go(-1)">Return</a>
		</div>
	</div>
</body>
</html>