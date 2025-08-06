<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<title>Shirt Store Administration</title>
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
		<div class="container mb-5 mt-5">
			<div class="row justify-content-center text-center">
				<c:if test="${message != null}">
					<c:choose>
						<c:when test="${message.contains('successfully')}">
							<div class="row justify-content-center">
								<div class="row custom-row w-75 mb-5 mt-5">
									<h4>${message}</h4>
								</div>
							</div>
						</c:when>
						<c:otherwise>
							<div class="row justify-content-center">
								<div class="row custom-row-1 w-75 mb-5 mt-5">
									<h4>${message}</h4>
								</div>
							</div>
						</c:otherwise>
					</c:choose>
				</c:if>
			</div>
		</div>
	</div>

	<jsp:directive.include file="footer.jsp"/>
</body>
</html>