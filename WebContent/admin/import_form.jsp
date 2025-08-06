<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>

<head>
  <title>Create Import</title>
  <jsp:include page="pagehead.jsp"></jsp:include>
  <jsp:include page="pageLoad.jsp"/>
  <jsp:include page="add_product.jsp"></jsp:include>

  <link href="../css/warehouse-style.css" rel="stylesheet" type="text/css" />
  <link href="../css/modal-style.css" rel="stylesheet" type="text/css" />

  <link rel="stylesheet" type="text/css" href="../css/custom_background_template.css"/>
  <link rel="stylesheet" type="text/css" href="../css/custom_row_template.css"/>
  <link rel="stylesheet" type="text/css" href="../css/table_list_admin_template.css"/>
  <link rel="stylesheet" type="text/css" href="../css/search_button_template.css"/>
  <link rel="stylesheet" type="text/css" href="../css/custom_border_template.css"/>
</head>

<body class="body">
  <jsp:directive.include file="header.jsp" />

  <div class="background-div-content">
    <div class="container">
      <div class="w-layout-blockcontainer w-container">
        <div class="nav-wrapper">

          <h1 class="heading-h1">Warehouse</h1>

          <div class="nav-button-wrapper">
            <a href="list_imports" class="button w-button">View Import Receipt</a>
            <a href="#" class="button w-button">Create Import Receipt</a>
            <a href="list_warehouses" class="button w-button">Stock Check</a>
          </div>

          <h1 class="heading-h2">Create Import Receipt</h1>

        </div>

        <div class="form-wrapper w-form border custom-border">
          <form id="create_import_form" name="create_import_form" method="post" class="form" action="add_import">
            <div class="fields-wrapper">
              <label for="staffName" class="field-label">Staff&#x27;s Name</label>
              <input class="text-field w-input" maxlength="256" name="staffName" type="text"
                     id="staffName" value="${sessionScope.userFullName}" readonly/>
            </div>

            <div class="fields-wrapper">
              <label for="importId" class="field-label">Import&#x27;s ID</label>
              <input class="text-field w-input" maxlength="256" name="importId"
                     type="text" id="importId"/>
            </div>

            <div class="fields-wrapper">
              <label for="totalPriceField" class="field-label">Total Price</label>
              <input class="text-field w-input" maxlength="256" name="totalPriceField" id="totalPriceField"
                     type="text" value="0.00" readonly/>
            </div>

            <div class="fields-wrapper is-contains-datefield">
              <label for="createdDate" class="field-label">Created Date</label>
              <input type="date" class="input" id="createdDate" name="createdDate"/>
            </div>

            <input type="hidden" name="productData" id="productData" />
            <input type="hidden" name="staffEmail" id="staffEmail" value="${sessionScope.userEmail}" />

          </form>
        </div>

        <table class="table-wrapper">
          <thead class="table_head">
          <tr class="table_row">
            <th class="table_header align-middle text-center">Index</th>
            <th class="table_header align-middle text-center">Product ID</th>
            <th class="table_header align-middle text-center">Name</th>
            <th class="table_header align-middle text-center">Color</th>
            <th class="table_header align-middle text-center">Size</th>
            <th class="table_header align-middle text-center">Material</th>
            <th class="table_header align-middle text-center">Quantity</th>
            <th class="table_header align-middle text-center">Price</th>
            <th class="table_header align-middle text-center">Total</th>
          </tr>
          </thead>
          <tbody class="table_body" id="result">

          </tbody>
        </table>

        <div class="row justify-content-center mb-5">
          <div class="button-group">
            <a href="#" class="button is-medium-button w-button" id="createImportBtn">Create</a>
            <a href="#" class="open-modal-btn button w-button">Add</a>
            <a href="#" class="button is-medium-button is-delete-button w-button"  id="deleteProductBtn">Detele</a>
          </div>
        </div>

      </div>
    </div>
  </div>

  <script src="../js/warehouse-js.js" type="text/javascript"></script>

  <jsp:directive.include file="footer.jsp" />

  <script>
    // Get the modal
    var modal = document.getElementById("productModal");

    // Get the button that opens the modal
    var btn = document.querySelector(".open-modal-btn");

    // Get the <span> element that closes the modal
    var closeBtn = document.querySelectorAll(".close");

    // When the user clicks the button, open the modal
    btn.onclick = function () {
      modal.style.display = "block";
    }

    // When the user clicks on (x) or Cancel button, close the modal
    closeBtn.forEach(function (element) {
      element.onclick = function () {
        modal.style.display = "none";
      }
    });

    window.onclick = function (event) {
      if (event.target == modal) {
        modal.style.display = "none";
      }
    }

    let selectedRow = null; // Biến để lưu dòng được chọn

    // Sự kiện cho các dòng trong bảng, khi click vào sẽ chọn dòng
    document.getElementById('result').addEventListener('click', function(e) {
      if (e.target && e.target.nodeName === "TD") {
        // Bỏ chọn dòng trước đó
        if (selectedRow) {
          selectedRow.classList.remove('selected');
        }

        // Gán dòng được chọn
        selectedRow = e.target.closest('tr');
        selectedRow.classList.add('selected'); // Thêm class để tô sáng dòng
      }
    });

    // Khi nhấn nút 'Delete', xóa dòng đã chọn
    document.getElementById("deleteProductBtn").addEventListener("click", function() {
      if (selectedRow) {
        let rowTotal = parseFloat(selectedRow.querySelector('td:nth-child(9)').textContent); // Lấy tổng tiền của dòng được chọn
        selectedRow.remove(); // Xóa dòng được chọn
        console.log("rowTotal: " + rowTotal);
        updateTotalPrice(-rowTotal); // Cập nhật tổng tiền
        selectedRow = null; // Reset lại biến sau khi xóa dòng
      } else {
        alert("Please select a row to delete.");
      }
    });

  </script>
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

</body>
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
                  if (messageId === "SUCCESS_CREATE_NEW_IMPORT_RECEIPT") {
                    swalOptions.icon = "success";  // Biểu tượng success
                  } else if (messageId === "DUPLICATE_IMPORT_ID") {
                    swalOptions.icon = "error";  // Biểu tượng error
                  } else {
                    swalOptions.icon = "info";   // Biểu tượng mặc định
                  }

                  // Hiển thị thông báo với Swal
                  Swal.fire(swalOptions)
                          .then((result) => {
                            if (result.isConfirmed) {
                              // Chuyển hướng hoặc hành động sau khi nhấn OK nếu cần
                              if (messageId === "SUCCESS_CREATE_NEW_IMPORT_RECEIPT") {
                                window.location.href = "list_imports";
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


    document.getElementById("createImportBtn").addEventListener("click", function (event){
      event.preventDefault();

      let importId = $("#importId").val();
      let totalPriceField = $("#totalPriceField").val();
      let createdDate = $("#createdDate").val();
      let staffEmail = $("#staffEmail").val();
      const specialCharRegex = /[^a-zA-Z0-9\s]/;

      if(importId.trim() === ""){
        getMessageContent("NOT_NULL_IMPORT_ID", event);
        $("#importId").focus();
        return;
      }
      else if(specialCharRegex.test(importId)){
        getMessageContent("NO_ITALIC-CHARACTER_IMPORT_ID", event);
        $("#import_id").focus();
        return;
      }

      const productsTable = document.getElementById("result");
      let productDataArray = [];
      for (let i = 0; i < productsTable.rows.length; i++) {
        const row = productsTable.rows[i];
        const productId = row.cells[1].textContent;
        const colorId = row.cells[3].getAttribute("data-id");
        const sizeId = row.cells[4].getAttribute("data-id");
        const materialId = row.cells[5].getAttribute("data-id");
        const quantity = row.cells[6].textContent;
        const price = row.cells[7].textContent;

        // Thêm dữ liệu sản phẩm vào mảng dưới dạng JSON
        productDataArray.push({
          importId: importId,
          productVariant: {
            productId: productId,
            colorId: colorId,
            sizeId: sizeId,
            materialId: materialId
          },
          quantity: quantity,
          price: price
        });
      }

      // Chuyển mảng dữ liệu sản phẩm thành chuỗi JSON và đặt vào input ẩn
      document.getElementById("productData").value = JSON.stringify(productDataArray);
      let productData = $("#productData").val();

      const url = "import_create";
      $.ajax({
        url: url,
        type: "POST",
        data: {
          staffEmail,
          importId,
          totalPriceField,
          createdDate,
          productData
        },
        success: function (response){
          if(response.valid){
            const message = "SUCCESS_CREATE_NEW_IMPORT_RECEIPT";
            getMessageContent(message, event);
          }else{
            const message1 = "DUPLICATE_IMPORT_ID";
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
        importId: "required",
        totalPriceField: "required",
        createdDate: "required",
        productData: "required"
      },
      messages:{
        importId: "",
        totalPriceField: "",
        createdDate: "",
        productData: ""
      }
    })

  });
</script>
</body>
</html>