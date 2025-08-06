<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
	<title>Edit Order Details</title>
	<jsp:include page="pagehead.jsp"></jsp:include>
</head>
<body>
	<jsp:directive.include file="header.jsp"/>
	<br><br><br><br>
	
	<div align="center">
		<h1>Edit Order with ID: ${order.id}</h1>
		<hr width="70%">	
	</div>
	
	<c:if test="${message != null}">
		<div align="center" style="color: red;">
			<h4>${message}</h4>
		</div>
	</c:if>
		
	<jsp:directive.include file="../common/common_order_detail.jsp"/>
	
	<br><br>
	<div align="center">
		<a href="order_edit?orderId=${order.id}" class="btn btn-outline-primary">Edit order</a>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<a href="javascript:void(0)" id="${order.id}" class="deleteLink btn btn-outline-primary">Delete order</a>
	</div>
	
	<br><br><br><br>
	<jsp:directive.include file="footer.jsp"/>
</body>
<script>
	$(document).ready(function(){
		$(".deleteLink").each(function(){
			$(this).on("click", function(){
				var orderId = $(this).attr("id");
				if(confirm("Are you sure you want to delete the order with order's id: " + orderId + " ?")){
					window.location = "order_delete?orderId=" + orderId;
				}
			})
		});
	});
</script>

</html>