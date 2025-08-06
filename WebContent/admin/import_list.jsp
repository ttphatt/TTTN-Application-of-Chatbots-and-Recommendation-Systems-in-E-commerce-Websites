<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<head>
    <title>Import Manager</title>
    <jsp:include page="pagehead.jsp"></jsp:include>`

    <link href="../css/warehouse-style.css" rel="stylesheet" type="text/css" />

    <link rel="stylesheet" type="text/css" href="../css/custom_background_template.css"/>
    <link rel="stylesheet" type="text/css" href="../css/custom_row_template.css"/>
    <link rel="stylesheet" type="text/css" href="../css/table_list_admin_template.css"/>
    <link rel="stylesheet" type="text/css" href="../css/search_button_template.css"/>
    <link rel="stylesheet" type="text/css" href="../css/custom_border_template.css"/>
</head>

<body class="body-2">
    <jsp:directive.include file="header.jsp" />
    <jsp:include page="pageLoad.jsp"/>

    <div class="background-div-content">
        <div class="container">
            <div class="w-layout-blockcontainer w-container">

                <div class="nav-wrapper">
                    <h1 class="heading-h1">Warehouse</h1>

                    <div class="nav-button-wrapper">
                        <a href="list_imports" class="button w-button">View Import Receipt</a>
                        <a href="show_import_form" class="button w-button">Create Import Receipt</a>
                        <a href="list_warehouses" class="button w-button">Stock Check</a>
                    </div>

                    <h1 class="heading-h2">View Import Receipt</h1>
                </div>

                <div class="search-wrapper">
                    <form action="import_search" class="search w-form">
                        <input class="search-input w-input" maxlength="256"
                               name="query" placeholder="Search…" type="search" id="search" required="" />
                        <input type="submit"
                               class="button is-medium-button w-button" value="Search" />
                    </form>
                </div>

                <table class="table-wrapper">
                    <thead class="table_head">
                    <tr class="table_row">
                        <th class="table_header align-middle text-center">Index</th>
                        <th class="table_header align-middle text-center">Import&#x27;s ID</th>
                        <th class="table_header align-middle text-center">User Created</th>
                        <th class="table_header align-middle text-center">Created Date</th>
                        <th class="table_header align-middle text-center">Total Price</th>
                        <th class="table_header align-middle text-center">Actions</th>
                    </tr>
                    </thead>
                    <tbody class="table_body" id="tableBody">
                    <c:forEach var="import_info" items="${importList}" varStatus="status">
                        <tr class="table_row">
                            <td class="table_cell align-middle text-center">${status.index + 1}</td>
                            <td class="table_cell align-middle text-center">${import_info.id}</td>
                            <td class="table_cell align-middle text-center">${import_info.userId} - ${import_info.userName}</td>
                            <td class="table_cell align-middle text-center">${import_info.date}</td>
                            <td class="table_cell align-middle text-center">${import_info.totalPrice}</td>
                            <td class="table_cell align-middle text-center">
                                <a href="import_detail?id=${import_info.id}" class="button is-small-button is-red w-button">Detail</a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>

                <div class="row justify-content-center mb-5">
                    <div class="pagination-wrapper">
                        <a href="#" class="button is-medium-button w-button" id="prevPage" >Previous</a>
                        <a href="#" class="button is-medium-button w-button" id="nextPage" >Next</a>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <script src="../js/warehouse-js.js" type="text/javascript"></script>
    <script>
        let curPage = 1
        let recordsPerPage = 10;
        let products = onload();
        document.getElementById("prevPage").addEventListener("click", prevPage);
        document.getElementById("nextPage").addEventListener("click", nextPage);
        changePage(1);

        function onload() {
            return document.getElementById("tableBody").getElementsByTagName("tr");
        }

        function prevPage() {
            if (curPage > 1) {
                curPage--;
                changePage(curPage);
            }
        }

        function nextPage() {
            if (curPage < numPages()) {
                curPage++;
                changePage(curPage);
            }
        }

        function changePage(page) {
            for (let i = 0; i < products.length; i++) {
                products[i].style.display = "none";
            }

            for (let i = (page - 1) * recordsPerPage; i < products.length && i < (page * recordsPerPage); i++) {
                products[i].style.display = "flex";
            }
        }

        function numPages() {
            return Math.ceil(products.length / recordsPerPage);
        }
    </script>

    <jsp:directive.include file="footer.jsp" />
</body>
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
</html>