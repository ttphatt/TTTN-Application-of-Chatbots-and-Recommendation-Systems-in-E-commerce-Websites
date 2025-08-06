<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>

<head>
  <title>Dashboard</title>
  <link href="../css/dashboard.css" rel="stylesheet" type="text/css" />
  <jsp:include page="pagehead.jsp"></jsp:include>
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script>
    function updateTitle() {
      const productSelect = document.getElementById('product_id');
      const typeReportSelect = document.getElementById('typeReport');
      const titleElement = document.getElementById('chart-title');
      const selectedProductId = productSelect.value;
      const selectedReportType = typeReportSelect.value;

      let title = '';

      if (selectedReportType === 'Profits') {
        title = "Profits ";
      } else {
        title = "Revenue ";
      }

      if (selectedProductId === "0") {
        title += "For All Product";
      } else {
        const selectedProductName = productSelect.options[productSelect.selectedIndex].text;
        title += "For Product: " + selectedProductName;
      }

      titleElement.textContent = title;
    }

    window.onload = function () {
      updateTitle();
      document.getElementById('product_id').addEventListener('change', updateTitle);
      document.getElementById('typeReport').addEventListener('change', updateTitle);
    };
  </script>
</head>

<body>
<jsp:directive.include file="header.jsp"/>
<div class="filter-container">
  <form action="view_dashboard" method="POST">
    <div class="form-row">
      <label for="start_date">Start Date:</label>
      <input type="date" id="start_date" name="start_date" value="${param.start_date}" required>

      <label for="end_date">End Date:</label>
      <input type="date" id="end_date" name="end_date" value="${param.end_date}" required>
    </div>

    <div class="form-row">
      <label for="step">Step:</label>
      <select id="step" name="step">
        <option value="1" ${param.step == '1' ? 'selected' : ''}>Ngày</option>
        <option value="7" ${param.step == '7' ? 'selected' : ''}>Tuần</option>
        <option value="30" ${param.step == '30' ? 'selected' : ''}>Tháng</option>
        <option value="365" ${param.step == '365' ? 'selected' : ''}>Năm</option>
      </select>

      <label for="product_id">Product:</label>
      <select id="product_id" name="product_id">
        <option value="0">All</option>
        <c:forEach var="product" items="${listShirts}">
          <option value="${product.shirtID}" ${param.product_id == product.shirtID ? 'selected' : ''}>
              ${product.shirtID} - ${product.shirtName}
          </option>
        </c:forEach>
      </select>
    </div>

    <div class="form-row">
      <label for="typeReport">Type Of Report:</label>
      <select id="typeReport" name="typeReport">
        <option value="Revenue" ${param.typeReport == 'Revenue' ? 'selected' : ''}>Revenue</option>
        <option value="Profits" ${param.typeReport == 'Profits' ? 'selected' : ''}>Profits</option>
      </select>
    </div>

    <button type="submit">Apply Filters</button>
  </form>
</div>

<div class="chart-container">
  <div class="chart-header">
    <h2 id="chart-title">Revenue For All Product</h2>
    <div class="paste-button">
      <button class="button">Print &nbsp; ▼</button>
      <div class="dropdown-content">
        <a id="top" href="#" onclick="sendPrintRequest('PDF')">Print .PDF</a>
        <a id="middle" href="#" onclick="sendPrintRequest('XLSX')">Print .XLSX</a>
      </div>
    </div>
  </div>
  <div class="chart">
    <div class="y-axis">
      <div class="y-label">${maxY}</div>
      <div class="y-label">${(maxY / 5) * 4}</div>
      <div class="y-label">${(maxY / 5) * 3}</div>
      <div class="y-label">${(maxY / 5) * 2}</div>
      <div class="y-label">${maxY / 5}</div>
      <div class="y-label">0</div>
    </div>
    <div class="bars">
      <c:forEach var="item" items="${listReports}">
        <c:if test="${item.total == 0}">
          <div class="bar" style="height: 0.1%;"
               data-label="${item.start_date} - ${item.end_date}" data-value="${item.total}"></div>
        </c:if>
        <c:if test="${item.total != 0}">
          <div class="bar" style="height: ${(item.total / maxY) * 100}%"
               data-label="${item.start_date} - ${item.end_date}" data-value="${item.total}"></div>
        </c:if>
      </c:forEach>
    </div>
  </div>
</div>
<script>
  function sendPrintRequest(format) {
    // Lấy các thông tin cần gửi từ form
    const start_date = document.getElementById('start_date').value;
    const end_date = document.getElementById('end_date').value;
    const step = document.getElementById('step').value;
    const product_id = document.getElementById('product_id').value;
    const typeReport = document.getElementById('typeReport').value;

    // Xây dựng URL sử dụng các biến đã khai báo
    const url = 'print_report?' +
            'start_date=' + encodeURIComponent(start_date) +
            '&end_date=' + encodeURIComponent(end_date) +
            '&step=' + encodeURIComponent(step) +
            '&product_id=' + encodeURIComponent(product_id) +
            '&typeReport=' + encodeURIComponent(typeReport) +
            '&format=' + encodeURIComponent(format);

    // Gửi yêu cầu và tải file về
    window.location.href = url;
  }
</script>
</body>

</html>
