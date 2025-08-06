<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="css/search_button_template.css"/>
<link rel="stylesheet" href="css/custom_background_template.css"/>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<style>
    .dropdown-submenu {
        position: relative;
    }

    .submenu {
        display: none;
        position: absolute;
        top: 0;
        left: 100%;
        z-index: 9999;
        min-width: 200px;
    }

    .dropdown-submenu:hover > .submenu {
        display: block;
    }
</style>

<div class="background-div-header">
    <div class="container">
        <div class="row align-items-center justify-content-between" style="font-family: 'Roboto', sans-serif">
            <div class="col-md-5 d-flex align-items-center">
                <a href="${pageContext.request.contextPath}" style="text-decoration: none; color: #0c0c0c">
                    <h1 class="display-5">
                        <img src="images/shirt-logo-black.png" style="max-height: 100px" class="img-fluid">
                        The Store
                    </h1>
                </a>
            </div>

            <div class="col-md-6 d-flex align-items-center justify-content-end">
                <!-- Categories Dropdown -->
                <div class="dropdown custom-dropdown me-2">
                    <button class="btn btn-outline-primary dropdown-toggle" type="button" id="categoryMenu"
                            data-bs-toggle="dropdown" aria-expanded="false" style="font-size: large">
                        Categories
                    </button>
                    <ul class="dropdown-menu" id="category-menu" aria-labelledby="categoryMenu">
                        <c:forEach var="category" items="${parentList}">
                            <li class="dropdown-submenu">
                                <a class="dropdown-item category-item" href="#" data-id="${category.id}">
                                    <c:out value="${category.name}"/>
                                </a>
                            </li>
                        </c:forEach>
                    </ul>
                </div>

                <!-- Login / Logout -->
                <c:if test="${loggedCustomer != null}">
                    <div class="dropdown custom-dropdown">
                        <button class="btn btn-dark dropdown-toggle" type="button" id="userMenu"
                                data-bs-toggle="dropdown" aria-expanded="false" style="font-size: large">
                            Hi there, ${loggedCustomer.firstname} ${loggedCustomer.lastname}
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userMenu">
                            <li><a class="dropdown-item" href="view_profile">Profile</a></li>
                            <li><a class="dropdown-item" href="view_orders">My Orders</a></li>
                            <li><a class="dropdown-item" href="logout">Logout</a></li>
                        </ul>
                    </div>
                </c:if>

                <c:if test="${loggedCustomer == null}">
                    <a href="login" class="btn custom-btn-login" style="font-size: large">Login</a>
                    <a href="register" class="btn custom-btn-signup ms-2" style="font-size: large">Sign up</a>
                </c:if>

                <a href="view_cart" class="btn custom-btn-cart ms-2" style="font-size: large">
                    <img src="images/online-shopping.png" style="max-height: 20px;">&nbsp;&nbsp;Cart
                </a>
            </div>
        </div>

        <!-- Search -->
        <br>
        <div class="row justify-content-end mb-4">
            <div class="col-md-5" style="font-family: 'Roboto', sans-serif">
                <form action="search" method="get" class="d-flex">
                    <div class="input-group input-group-sm">
                        <input type="text" name="keyword" class="cta_input" placeholder="Search here"/>
                        <button type="submit" class="cta">
                            <span class="span">FIND</span>
                            <span class="second"></span>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- JS xử lý danh mục nhiều cấp -->
<script>
    $(document).ready(function () {
        // Hiển thị submenu khi hover
        $(document).on('mouseenter', '.category-item', function () {
            const $this = $(this);
            const catId = $this.data("id");
            const $parentLi = $this.closest('li');

            if ($parentLi.children('.submenu').length > 0) return;

            $.get("/StoreWebsite/api/get_subcategories", { parentId: catId }, function (subs) {
                if (subs && subs.length > 0) {
                    const submenu = $('<ul>', {
                        class: 'dropdown-menu submenu'
                    });

                    subs.forEach(sub => {
                        const li = $('<li>', { class: 'dropdown-submenu' });
                        const a = $('<a>', {
                            class: 'dropdown-item category-item',
                            href: "#",
                            'data-id': sub.id,
                            text: sub.name
                        });
                        li.append(a);
                        submenu.append(li);
                    });

                    $parentLi.append(submenu);
                }
            });
        });

        $(document).on('click', '.category-item', function (e) {
            e.preventDefault();
            const id = $(this).data('id');
            if (id) {
                window.location.href = "view_category?id=" + id;
            }
        });
    });
</script>
