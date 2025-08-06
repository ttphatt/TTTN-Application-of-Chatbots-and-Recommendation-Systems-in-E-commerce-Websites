<link rel="stylesheet" type="text/css" href="css/card_template.css"/>
<div class="col text-center" style="font-family: 'Roboto', sans-serif">
	<div class="card">
		<a href="view_product?id=${product.id}">
			<div class="content">
				<img class="image-product" src="${product.image}"/>
			</div>
		</a>

		<a href="view_product?id=${product.id}" style="text-decoration: none">
			<div class="content">
				<div style="font-size: 25px">
					<b style="color: #FFFFFF">${product.name}</b>
				</div>
			</div>
		</a>

		<a href="view_product?id=${product.id}" style="text-decoration: none">
			<div class="content">
				<jsp:directive.include file="product_rating.jsp"/>
			</div>
		</a>

		<a href="view_product?id=${product.id}" style="text-decoration: none">
			<div class="content" style="font-size: 25px; color: #FFFFFF">
				<b>From: ${product.brand}</b>
			</div>
		</a>

		<a href="view_product?id=${product.id}" style="text-decoration: none">
			<div class="content" style="font-size: 25px; color: #FFFFFF">
				<b>Price: $${product.price}</b>
			</div>
		</a>
	</div>
</div>
