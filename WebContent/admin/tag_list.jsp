<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Manage Tags</title>
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
    <h2 class="text-center mb-4">Manage Tags</h2>
    <div class="row justify-content-center">
        <div class="col-md-8">
            <table class="table table-bordered table-sm">
                <thead><tr><th>ID</th><th>Name</th><th>Actions</th></tr></thead>
                <tbody id="tag-body">
                <c:forEach var="tag" items="${tagList}">
                    <tr data-id="${tag.id}" data-name="${tag.name}">
                        <td>${tag.id}</td>
                        <td class="value-text">${tag.name}</td>
                        <td>
                            <button class="btn btn-warning btn-sm" onclick="editTag(this)">Edit</button>
                            <button class="btn btn-danger btn-sm" onclick="deleteTag(${tag.id})">Delete</button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>

            <button class="btn btn-primary btn-sm" onclick="showInput()">Add</button>
            <div id="tag-input" class="mt-2" style="display: none;">
                <input type="text" id="tag-name" placeholder="Enter tag name" class="form-control mb-2"/>
                <button class="btn btn-success btn-sm" onclick="addTag()">Save</button>
            </div>
        </div>
    </div>
</div>

<!-- SCRIPT -->
<script>
    function showInput() {
        $("#tag-input").toggle();
    }

    function addTag() {
        const name = $("#tag-name").val().trim();
        if (!name) return alert("Tag name cannot be empty.");

        $.post("/StoreWebsite/admin/tag_create", { name: name })
            .done(() => location.reload())
            .fail(() => alert("Failed to create tag."));
    }

    function deleteTag(id) {
        if (!confirm("Are you sure to delete this tag?")) return;

        $.post("/StoreWebsite/admin/tag_delete", { id: id })
            .done(() => location.reload())
            .fail(() => alert("Delete failed."));
    }

    function editTag(btn) {
        const tr = $(btn).closest("tr");
        const id = tr.data("id");
        const oldName = tr.data("name");

        const inputHtml =
            '<input type="text" class="form-control form-control-sm new-value" value="' + oldName + '" />' +
            '<button class="btn btn-success btn-sm mt-1" onclick="saveEdit(this, ' + id + ')">Save</button>';

        tr.find(".value-text").html(inputHtml);
        $(btn).hide();
    }

    function saveEdit(saveBtn, id) {
        const tr = $(saveBtn).closest("tr");
        const newName = tr.find(".new-value").val().trim();
        if (!newName) return alert("Name cannot be empty.");

        $.post("/StoreWebsite/admin/tag_update", { id: id, name: newName })
            .done(() => location.reload())
            .fail(() => alert("Update failed."));
    }
</script>

<script>
    window.addEventListener("load", () => {
        const loader = document.querySelector(".loader_wrapper");
        if (!loader) return;

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
