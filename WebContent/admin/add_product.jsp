<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<title>Add Product To Import</title>

<body class="body">
<div id="productModal" class="modal" style="display: none;">
    <div class="modal-content">
        <div class="modal-header">
            <h1 class="Heading-H1">Add Product</h1>
        </div>

        <div class="form-wrapper is_add_form w-form">
            <form id="addProductForm" method="get" class="form" action="#">
                <div class="fields-wrapper is_contain_combobox">
                    <label for="productSelect" class="field-label">Product</label>
                    <select id="productSelect" name="productSelect" class="combobox w-select">
                        <option value="">Select a product...</option>
                    </select>
                </div>

                <!-- Hidden product ID for internal logic -->
                <input type="hidden" id="productId" name="productId" />

                <div class="fields-wrapper is_contain_combobox">
                    <label for="colorSelect" class="field-label">Color</label>
                    <select id="colorSelect" name="colorSelect" class="combobox w-select">
                        <option value="">Select a color...</option>
                    </select>
                </div>

                <div class="fields-wrapper is_contain_combobox">
                    <label for="sizeSelect" class="field-label">Size</label>
                    <select id="sizeSelect" name="sizeSelect" class="combobox w-select">
                        <option value="">Select a size...</option>
                    </select>
                </div>

                <div class="fields-wrapper is_contain_combobox">
                    <label for="materialSelect" class="field-label">Material</label>
                    <select id="materialSelect" name="materialSelect" class="combobox w-select">
                        <option value="">Select a material...</option>
                    </select>
                </div>

                <div class="fields-wrapper">
                    <label for="quantity" class="field-label">Quantity</label>
                    <input class="text-field is-form_add_product w-input" name="quantity" type="text" id="quantity" />
                </div>

                <div class="fields-wrapper">
                    <label for="price" class="field-label">Price</label>
                    <input class="text-field is-form_add_product w-input" name="price" type="text" id="price" />
                </div>
            </form>
        </div>

        <!-- Buttons -->
        <div class="form_button">
            <a href="#" class="button is-medium-button w-button" id="addProductBtn">Add</a>
            <a href="#" class="button is-medium-button is-red w-button close" onclick="document.getElementById('productModal').style.display='none'">Cancel</a>
        </div>
    </div>
</div>

<script>
    const productSelect = document.getElementById("productSelect");
    const productIdField = document.getElementById("productId");
    const colorSelect = document.getElementById("colorSelect");
    const sizeSelect = document.getElementById("sizeSelect");
    const materialSelect = document.getElementById("materialSelect");
    const quantityField = document.getElementById("quantity");
    const priceField = document.getElementById("price");
    let counter = 1;

    // When 'Add' button is clicked
    function addProductToTable() {
        let productId = productIdField.value;
        let productName = productSelect.options[productSelect.selectedIndex].text;
        let colorId = colorSelect.value;
        let colorName = colorSelect.options[colorSelect.selectedIndex].text;
        let sizeId = sizeSelect.value;
        let sizeName = sizeSelect.options[sizeSelect.selectedIndex].text;
        let materialId = materialSelect.value;
        let materialName = materialSelect.options[materialSelect.selectedIndex].text;
        let quantity = quantityField.value;
        let price = priceField.value;

        const total = (quantity * price).toString();

        // Check if product already exists in the table
        let table = document.getElementById("result");
        let rows = table.getElementsByTagName("tr");
        let found = false;

        // Loop through the table rows to find the matching product ID
        for (let i = 0; i < rows.length; i++) {
            let cells = rows[i].getElementsByTagName("td");
            if (cells.length > 0 && cells[1].textContent === productId && cells[3].textContent === colorName && cells[4].textContent === sizeName && cells[5].textContent === materialName) { // Check if productId matches
                // Update the existing row with new quantity, price, and total
                let existingQuantity = parseInt(cells[6].textContent);  // Existing quantity
                let existingPrice = parseFloat(cells[7].textContent);  // Existing price
                let newQuantity = existingQuantity + parseInt(quantity); // Add the new quantity to existing one
                let newTotal = newQuantity * price; // Recalculate total using the old price
                let oldTotal = existingPrice * existingQuantity;

                cells[6].textContent = newQuantity;  // Update quantity
                cells[7].textContent = price;
                cells[8].textContent = newTotal.toFixed(2);  // Update total

                // Update the total price field
                updateTotalPrice((newTotal - oldTotal).toFixed(2));

                found = true; // Product found and updated
                break;
            }
        }

        // If the product wasn't found, create a new row
        if (!found) {
            let parent = document.createElement('tr');
            parent.classList.add('table_row');

            let indexCol = document.createElement('td');
            indexCol.classList.add('table_cell', 'align-middle', 'text-center');
            let IDCol = document.createElement('td');
            IDCol.classList.add('table_cell', 'align-middle', 'text-center');
            let nameCol = document.createElement('td');
            nameCol.classList.add('table_cell', 'align-middle', 'text-center');
            let colorCol = document.createElement('td');
            colorCol.classList.add('table_cell', 'align-middle', 'text-center');
            let sizeCol = document.createElement('td');
            sizeCol.classList.add('table_cell', 'align-middle', 'text-center');
            let materialCol = document.createElement('td');
            materialCol.classList.add('table_cell', 'align-middle', 'text-center');
            let quanCol = document.createElement('td');
            quanCol.classList.add('table_cell', 'align-middle', 'text-center');
            let priceCol = document.createElement('td');
            priceCol.classList.add('table_cell', 'align-middle', 'text-center');
            let totalCol = document.createElement('td');
            totalCol.classList.add('table_cell', 'align-middle', 'text-center');

            indexCol.textContent = counter.toString();
            IDCol.textContent = productId;
            nameCol.textContent = productName;
            colorCol.textContent = colorName;
            colorCol.setAttribute("data-id", colorId);
            sizeCol.textContent = sizeName;
            sizeCol.setAttribute("data-id", sizeId);
            materialCol.textContent = materialName;
            materialCol.setAttribute("data-id", materialId);
            quanCol.textContent = quantity;
            priceCol.textContent = price;
            totalCol.textContent = total;

            parent.appendChild(indexCol);
            parent.appendChild(IDCol);
            parent.appendChild(nameCol);
            parent.appendChild(colorCol);
            parent.appendChild(sizeCol);
            parent.appendChild(materialCol);
            parent.appendChild(quanCol);
            parent.appendChild(priceCol);
            parent.appendChild(totalCol);

            document.getElementById('result').appendChild(parent);

            updateTotalPrice(total);
            counter++;
        }

        // Close modal
        document.getElementById("productModal").style.display = "none";

        // Clear modal fields for next input
        productSelect.value = "";
        colorSelect.value = "";
        sizeSelect.value = "";
        materialSelect.value = "";
        productIdField.value = "";
        quantityField.value = "";
        priceField.value = "";
    }

    // Function to update total price
    function updateTotalPrice(newTotal) {
        const totalPriceField = document.getElementById("totalPriceField");
        let currentTotal = parseFloat(totalPriceField.value) || 0;
        currentTotal += parseFloat(newTotal);
        totalPriceField.value = currentTotal.toFixed(2);
    }

    function loadAllProducts() {
        $.get("/StoreWebsite/api/all_product", function (data) {
            const select = $("#productSelect");
            select.empty().append($('<option>', {
                value: "",
                text: "Select a product..."
            }));

            data.forEach(p => {
                if (p && p.id && p.name) {
                    const option = $('<option>', {
                        value: p.id,
                        text: p.name
                    });
                    select.append(option);
                }
            });
        });
    }

    function updateSelect(selector, list, label) {
        const select = $(selector);
        const currentValue = select.val();

        select.empty().append($('<option>', {
            value: "",
            text: "Select a " + label + " ..."
        }));

        let found = false;
        list.forEach(p => {
            if (p && p.id && p.value) {
                const option = $('<option>', {
                    value: p.id,
                    text: p.value
                });
                if (p.id == currentValue) found = true;
                select.append(option);
            }
        });

        // Nếu giá trị cũ vẫn tồn tại thì giữ lại
        if (found) {
            select.val(currentValue);
        }
    }

    function onVariantFiltersChange() {
        const productId = $("#productSelect").val();
        const colorId = $("#colorSelect").val();
        const sizeId = $("#sizeSelect").val();
        const materialId = $("#materialSelect").val();

        $.get("/StoreWebsite/api/import_options", {
            productId, sizeId, colorId, materialId
        }, function (data) {
            updateSelect("#colorSelect", data.colors, "color");
            updateSelect("#sizeSelect", data.sizes, "size");
            updateSelect("#materialSelect", data.materials, "material");
        });
    }
</script>
<script>
    $(document).ready(function () {
        loadAllProducts();

        $("#productSelect, #sizeSelect, #colorSelect, #materialSelect").on("change", onVariantFiltersChange);

        $("#productSelect").change(function() {
            const selectedProductId = $(this).val();
            $("#productId").val(selectedProductId);
        });

        document.getElementById("addProductBtn").addEventListener("click", function (event){
            event.preventDefault();

            let color = document.getElementById("colorSelect").options[
                document.getElementById("colorSelect").selectedIndex
                ].text;
            let size = document.getElementById("sizeSelect").options[
                document.getElementById("sizeSelect").selectedIndex
                ].text;
            let material = document.getElementById("materialSelect").options[
                document.getElementById("materialSelect").selectedIndex
                ].text;
            let productId = $("#productId").val();
            let quantity = $("#quantity").val();
            let price = $("#price").val();
            const specialCharRegex = /[^a-zA-Z0-9\s]/;
            const onlyNumbersRegex = /^[0-9]+$/;

            if(!productId){
                getMessageContent("NOT_NULL_IMPORT_PRODUCT_ID", event);
                $("#productSelect").focus();
                return;
            }
            else if(color === ""){
                getMessageContent("NOT_NULL_IMPORT_SIZE", event);
                $("#sizeSelect").focus();
                return;
            }
            else if(size === ""){
                getMessageContent("NOT_NULL_IMPORT_SIZE", event);
                $("#sizeSelect").focus();
                return;
            }
            else if(material === ""){
                getMessageContent("NOT_NULL_IMPORT_SIZE", event);
                $("#sizeSelect").focus();
                return;
            }
            else if(quantity.trim() === ""){
                getMessageContent("NOT_NULL_IMPORT_QUANTITY", event);
                $("#quantity").focus();
                return;
            }
            else if(specialCharRegex.test(quantity)){
                getMessageContent("NO_ITALIC-CHARACTER_IMPORT_QUANTITY", event);
                $("#quantity").focus();
                return;
            }
            else if (!onlyNumbersRegex.test(quantity)) {
                getMessageContent("ONLY_NUMBER_IMPORT_QUANTITY", event);
                $("#quantity").focus();
                return;
            }
            else if(Number(quantity) <= 0){
                getMessageContent("IMPORT_QUANTITY_MUST_BE_POSITIVE", event);
                $("#quantity").focus();
                return;
            }
            else if(price.trim() === ""){
                getMessageContent("NOT_NULL_IMPORT_PRICE", event);
                $("#price").focus();
                return;
            }
            else if(specialCharRegex.test(price)){
                getMessageContent("NO_ITALIC-CHARACTER_IMPORT_PRICE", event);
                $("#price").focus();
                return;
            }
            else if (!onlyNumbersRegex.test(price)) {
                getMessageContent("ONLY_NUMBER_IMPORT_PRICE", event);
                $("#price").focus();
                return;
            }
            else if(Number(price) <= 0){
                getMessageContent("IMPORT_PRICE_MUST_BE_POSITIVE", event);
                $("#price").focus();
                return;
            }

            addProductToTable();

            this.submit();
        });
        $("#addProductForm").validate({
            rules:{
                productId: "required",
                color: "required",
                size: "required",
                material: "required",
                quantity: "required",
                price: "required"
            },
            messages:{
                color: "",
                size: "",
                material: "",
                productId: "",
                quantity: "",
                price: ""
            }
        })
    });
</script>


</body>
