<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<link rel="stylesheet" href="../css/style.css">
</head>
<body>
	<div align="center">
		<div>
			<img alt="Error Image" src="${pageContext.request.contextPath}/images/505-Error.png" style="max-height: 450px; max-width: 450px;">
			<h2>Sorry but the server has encountered an error</h2>
			<h2>Please check back latter or contact our admin</h2>
		</div>
	
		<div>
			<a href="javascript:history.go(-1)">Return</a>
		</div>
	</div>
	
	
</body>
</html>