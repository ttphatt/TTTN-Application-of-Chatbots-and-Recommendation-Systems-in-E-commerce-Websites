<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us - The Shirt Store</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f8fc;
            color: #333;
        }

        .center {
            text-align: center;
            margin: 20px 0;
        }

        .pageheading h1 {
            font-size: 2.8em;
            color: #0056b3;
            text-transform: uppercase;
            margin-top: 10px;
            letter-spacing: 1px;
        }

        .store_info {
            width: 80%;
            margin: 30px auto;
            background: #ffffff;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
        }

        .store_info h2 {
            color: #d63384;
            font-size: 2em;
            margin-bottom: 10px;
            border-bottom: 3px solid #ffc107;
            display: inline-block;
            padding-bottom: 5px;
            text-transform: uppercase;
        }

        .store_info p {
            font-size: 1.2em;
            line-height: 1.8em;
            color: #555;
            margin-bottom: 20px;
        }

        .features {
            display: flex;
            flex-direction: column;
            gap: 20px;
            margin-top: 20px;
        }

        .feature-item {
            display: flex;
            align-items: flex-start;
            gap: 15px;
            background-color: #f9f9f9;
            padding: 15px;
            border: 2px solid transparent;
            border-radius: 10px;
            transition: all 0.3s ease;
        }

        .feature-item:hover {
            border-color: #ffc107;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.15);
            background-color: #fdfdfd;
        }

        .feature-icon {
            font-size: 1.8em;
            color: #007bff;
        }

        .feature-text {
            font-size: 1.2em;
            color: #333;
        }

        .footer {
            text-align: center;
            margin-top: 30px;
            font-size: 1em;
            color: #6c757d;
        }

        .footer b {
            color: #17a2b8;
        }
    </style>
</head>
<body>
<div class="center">
    <a href="${pageContext.request.contextPath}/">
        <img src="images/ShirtStoreLogo.png" class="img-fluid" alt="The Shirt Store Logo" style="width: 150px;"/>
    </a>
</div>

<div class="center pageheading">
    <h1>About Us</h1>
</div>

<div class="store_info">
    <h2>Welcome to The Shirt Store!</h2>
    <p>At The Shirt Store, we take pride in offering a vibrant and carefully curated collection of shirts for every style and occasion. From high-end luxury to casual streetwear and cherished local brands, we strive to inspire confidence and individuality in every customer. Thank you for trusting us as your go-to fashion destination.</p>

    <h2>Why Choose Us?</h2>
    <div class="features">
        <div class="feature-item">
            <i class="feature-icon fas fa-tshirt"></i>
            <span class="feature-text">A comprehensive range of shirts: from premium designer pieces to everyday casuals.</span>
        </div>
        <div class="feature-item">
            <i class="feature-icon fas fa-check-circle"></i>
            <span class="feature-text">Unmatched attention to quality, comfort, and durability in every product.</span>
        </div>
        <div class="feature-item">
            <i class="feature-icon fas fa-laptop"></i>
            <span class="feature-text">A streamlined, customer-friendly online shopping experience.</span>
        </div>
        <div class="feature-item">
            <i class="feature-icon fas fa-tags"></i>
            <span class="feature-text">Exclusive deals and promotions to provide unbeatable value.</span>
        </div>
        <div class="feature-item">
            <i class="feature-icon fas fa-handshake"></i>
            <span class="feature-text">Committed to exceptional service and customer satisfaction.</span>
        </div>
    </div>

    <h2>Stay Connected</h2>
    <p>Subscribe to our email notifications to receive the latest updates, special offers, and tailored promotions. Our dedicated support team is here to assist with any questions or feedback, ensuring a seamless shopping experience every time you visit us.</p>
</div>

<div class="footer">
    <p><b>Copyright &copy; 2024 by The Shirt Store. All rights reserved.</b></p>
</div>
</body>
</html>