<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Chọn khách hàng để trò chuyện</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      padding: 20px;
    }
    h2 {
      margin-bottom: 20px;
    }
    .customer-list {
      list-style-type: none;
      padding: 0;
    }
    .customer-item {
      margin: 10px 0;
      padding: 10px;
      background-color: #f1f1f1;
      border-radius: 6px;
      transition: background-color 0.3s;
    }
    .customer-item:hover {
      background-color: #e0e0e0;
    }
    .customer-link {
      text-decoration: none;
      color: #333;
      font-weight: bold;
    }
  </style>
</head>
<body>
<h2>Danh sách khách hàng</h2>

<c:if test="${not empty customers}">
  <ul class="customer-list">
    <c:forEach var="customer" items="${customers}">
      <li class="customer-item">
        <a class="customer-link" href="${pageContext.request.contextPath}/admin/chat?id=${customer.id}">
            ${customer.firstName} ${customer.lastName}
        </a>
      </li>
    </c:forEach>
  </ul>
</c:if>

<c:if test="${empty customers}">
  <p>Không có khách hàng nào để hiển thị.</p>
</c:if>
</body>
</html>
