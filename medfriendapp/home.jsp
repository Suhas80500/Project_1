<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - Medical Shop Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            background-color: #f5f7fa;
            font-family: 'Arial', sans-serif;
        }

        .navbar {
            background-color: #0d12a8;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
        }

        .navbar-brand {
            color: #ffffff;
            font-weight: bold;
            font-size: 1.5rem;
            text-shadow: 1px 1px 4px rgba(0, 0, 0, 0.2);
        }

        .navbar-nav .nav-link {
            color: #ffffff;
            margin-right: 20px;
            font-size: 1.1rem;
        }

        .navbar-nav .nav-link:hover {
            color: #ffd700;
        }

        .jumbotron {
            background: radial-gradient(circle, #e038c9, #0d12a8);
            color: white;
            padding: 3rem 1.5rem;
            border-radius: 15px;
            margin-top: 30px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }

        .jumbotron h1 {
            font-size: 2.8rem;
            margin-bottom: 20px;
            text-shadow: 1px 1px 5px rgba(0, 0, 0, 0.3);
        }

        .features-section {
            display: flex;
            justify-content: space-around;
            margin-top: 50px;
        }

        .feature-box {
            background-color: #ffffff;
            border-radius: 15px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
            padding: 25px;
            text-align: center;
            width: 30%;
            transition: transform 0.3s ease;
        }

        .feature-box:hover {
            transform: scale(1.05);
        }

        .feature-box i {
            font-size: 3.5rem;
            color: #6c63ff;
            margin-bottom: 15px;
        }

        .feature-box h4 {
            font-size: 1.4rem;
            margin-bottom: 10px;
            color: #444;
        }

        .feature-box p {
            color: #6c63ff;
            font-size: 1rem;
        }

        footer {
            background-color: #0d12a8;
            color: #ffffff;
            padding: 15px 0;
            text-align: center;
            margin-top: 60px;
            box-shadow: 0px -4px 8px rgba(0, 0, 0, 0.1);
        }

        footer a {
            color: #ffd700;
            text-decoration: none;
        }

        footer a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">Medical Shop</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link active" aria-current="page" href="home.jsp" style="color: #f5f7fa;">Home</a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="inventoryDropdown" role="button" data-bs-toggle="dropdown">
                            Inventory
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="item.jsp">Item</a></li>
                            <li><a class="dropdown-item" href="agency.jsp">Agency</a></li>
                            <li><a class="dropdown-item" href="i_order.jsp">Order</a></li>
                            <li><a class="dropdown-item" href="supplies.jsp">Supplies</a></li>
                            <!-- <li><a class="dropdown-item" href="billing1.jsp"> bill</a></li> -->
                            <li><a class="dropdown-item" href="billing.jsp">Customer Bill</a></li>
                            <li><a class="dropdown-item" href="purchase.jsp">Purchase</a></li>
                            <li><a class="dropdown-item" href="salesTracking.jsp">Sales Tracking</a></li>
                        </ul>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#about">About</a>
                    </li>
                    <!-- Added Logout Section -->
                    <li class="nav-item">
                        <a class="nav-link" href="user_login.jsp">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="jumbotron text-center">
            <h1>Welcome to MedFriend</h1>
            <p>Your trusted partner in medical shop management</p>
        </div>

        <div class="features-section">
            <div class="feature-box">
                <i class="fas fa-prescription-bottle-alt"></i>
                <h4>Inventory Management</h4>
                <p>Track and manage your stock effectively.</p>
            </div>
            <div class="feature-box">
                <i class="fas fa-cash-register"></i>
                <h4>Billing System</h4>
                <p>Generate and manage customer bills smoothly.</p>
            </div>
            <div class="feature-box">
                <i class="fas fa-chart-line"></i>
                <h4>Sales Tracking</h4>
                <p>Monitor your sales performance in real-time.</p>
            </div>
        </div>
    </div>

    <footer>
        <p>&copy; 2024 MedFriend Management System. All rights reserved.</p>
        <p><a href="#about">About Us</a> | <a href="#">Privacy Policy</a></p>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
