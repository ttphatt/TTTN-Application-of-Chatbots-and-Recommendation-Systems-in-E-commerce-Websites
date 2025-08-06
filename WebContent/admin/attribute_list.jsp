<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Manage Attributes</title>
    <jsp:include page="pagehead.jsp"></jsp:include>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>

    <link rel="stylesheet" type="text/css" href="../css/custom_background_template.css"/>
    <link rel="stylesheet" type="text/css" href="../css/custom_row_template.css"/>
    <link rel="stylesheet" type="text/css" href="../css/table_list_admin_template.css"/>
    <link rel="stylesheet" type="text/css" href="../css/search_button_template.css"/>
</head>
<body>

<jsp:directive.include file="header.jsp"/>
<jsp:include page="pageLoad.jsp"/>
<div class="container mt-4" style="margin-top: 200px; margin-bottom: 200px;">
    <div class="row text-center fw-bold mb-3">
        <div class="col">Color</div>
        <div class="col">Size</div>
        <div class="col">Material</div>
    </div>
    <div class="row">

        <!-- COLOR TABLE -->
        <div class="col">
            <table class="table table-bordered table-sm">
                <thead><tr><th>ID</th><th>Value</th><th>Actions</th></tr></thead>
                <tbody id="color-body">
                <c:forEach var="item" items="${colorList}">
                    <tr data-id="${item.id}" data-value="${item.value}">
                        <td>${item.id}</td>
                        <td class="value-text">${item.value}</td>
                        <td>
                            <button class="btn btn-warning btn-sm" onclick="editAttr(this, 'COLOR')">Edit</button>
                            <button class="btn btn-danger btn-sm" onclick="deleteAttr(${item.id}, 'COLOR', '${item.value}')">Delete</button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            <button class="btn btn-primary btn-sm" onclick="showInput('color')">Add</button>
            <div id="color-input" class="mt-2" style="display: none;">
                <input type="text" id="color-value" placeholder="Enter value" class="form-control mb-2"/>
                <button class="btn btn-success btn-sm" onclick="addAttr('color', 'COLOR')">Save</button>
            </div>
        </div>

        <!-- SIZE TABLE -->
        <div class="col">
            <table class="table table-bordered table-sm">
                <thead><tr><th>ID</th><th>Value</th><th>Actions</th></tr></thead>
                <tbody id="size-body">
                <c:forEach var="item" items="${sizeList}">
                    <tr data-id="${item.id}" data-value="${item.value}">
                        <td>${item.id}</td>
                        <td class="value-text">${item.value}</td>
                        <td>
                            <button class="btn btn-warning btn-sm" onclick="editAttr(this, 'SIZE')">Edit</button>
                            <button class="btn btn-danger btn-sm" onclick="deleteAttr(${item.id}, 'SIZE', '${item.value}')">Delete</button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            <button class="btn btn-primary btn-sm" onclick="showInput('size')">Add</button>
            <div id="size-input" class="mt-2" style="display: none;">
                <input type="text" id="size-value" placeholder="Enter value" class="form-control mb-2"/>
                <button class="btn btn-success btn-sm" onclick="addAttr('size', 'SIZE')">Save</button>
            </div>
        </div>

        <!-- MATERIAL TABLE -->
        <div class="col">
            <table class="table table-bordered table-sm">
                <thead><tr><th>ID</th><th>Value</th><th>Actions</th></tr></thead>
                <tbody id="material-body">
                <c:forEach var="item" items="${materialList}">
                    <tr data-id="${item.id}" data-value="${item.value}">
                        <td>${item.id}</td>
                        <td class="value-text">${item.value}</td>
                        <td>
                            <button class="btn btn-warning btn-sm" onclick="editAttr(this, 'MATERIAL')">Edit</button>
                            <button class="btn btn-danger btn-sm" onclick="deleteAttr(${item.id}, 'MATERIAL', '${item.value}')">Delete</button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            <button class="btn btn-primary btn-sm" onclick="showInput('material')">Add</button>
            <div id="material-input" class="mt-2" style="display: none;">
                <input type="text" id="material-value" placeholder="Enter value" class="form-control mb-2"/>
                <button class="btn btn-success btn-sm" onclick="addAttr('material', 'MATERIAL')">Save</button>
            </div>
        </div>
    </div>
</div>
<!-- SCRIPT -->
<script>
    function showInput(domId) {
        $("#" + domId + "-input").toggle();
    }

    function addAttr(domId, type) {
        const value = $("#" + domId + "-value").val().trim();
        if (!value) return alert("Value cannot be empty.");

        $.post("/StoreWebsite/admin/attribute_create", {type: type, value: value})
            .done(() => location.reload())
            .fail(() => alert("Failed to create attribute."));
    }

    function deleteAttr(id, type, value) {
        if (!confirm("Are you sure to delete this attribute?")) return;

        $.post("/StoreWebsite/admin/attribute_delete", {id: id, type: type, value: value})
            .done(() => location.reload())
            .fail(() => alert("Delete failed."));
    }

    function editAttr(btn, type) {
        const tr = $(btn).closest("tr");
        const id = tr.data("id");
        const oldValue = tr.data("value");

        const inputHtml =
            '<input type="text" class="form-control form-control-sm new-value" value="' + oldValue + '" />' +
            '<button class="btn btn-success btn-sm mt-1" onclick="saveEdit(this, ' + id + ', \'' + type + '\')">Save</button>';

        tr.find(".value-text").html(inputHtml);
        $(btn).hide();
    }

    function saveEdit(saveBtn, id, type) {
        const tr = $(saveBtn).closest("tr");
        const newValue = tr.find(".new-value").val().trim();
        if (!newValue) return alert("Value cannot be empty.");

        $.post("/StoreWebsite/admin/attribute_update", {id: id, type: type, value: newValue})
            .done(() => location.reload())
            .fail(() => alert("Update failed."));
    }
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
<jsp:directive.include file="footer.jsp"/>
</body>
</html>
