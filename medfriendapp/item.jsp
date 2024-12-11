<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Item Management - MedFriend</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    
    <!-- Custom CSS -->
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f9f9f9;
            color: #333;
        }
        .container {
            margin-top: 50px;
        }
        h1 {
            font-family: 'Roboto', sans-serif;
            font-weight: 700;
            color: #6a1b9a;
        }
        .card {
            border-radius: 10px;
            box-shadow: 0px 5px 15px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0px 8px 20px rgba(0, 0, 0, 0.2);
        }
        .btn-custom {
            background-color: #6a1b9a;
            color: white;
        }
        .btn-custom:hover {
            background-color: #9c27b0;
        }
        label {
            font-weight: 500;
        }
        input, select {
            border-radius: 5px;
            padding: 10px;
        }
        .form-control {
            box-shadow: none;
            border: 1px solid #ced4da;
        }
        .form-control:focus {
            border-color: #6a1b9a;
            box-shadow: 0 0 0 0.2rem rgba(108, 52, 131, 0.25);
        }
        .btn-primary {
            background-color: #8e24aa;
            border-color: #8e24aa;
        }
        .btn-primary:hover {
            background-color: #ab47bc;
            border-color: #ab47bc;
        }
        .footer {
            text-align: center;
            padding: 20px;
            font-size: 14px;
            color: #777;
        }
    </style>
</head>
<body>

    <div class="container">
        <h1 class="text-center mb-4">Item Management</h1>
        
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card p-4">
                    <%
                        // Database connection setup
                        String url = "jdbc:mysql://localhost:3306/project"; // Change to your DB details
                        String username = "root"; // Your DB username
                        String password = "Root@123"; // Your DB password
                        
                        Connection conn = null;
                        PreparedStatement ps = null;
                        String message = "";

                        if(request.getMethod().equalsIgnoreCase("POST")) {
                            // Get form values
                            String itemName = request.getParameter("itemName");
                            String batchNumber = request.getParameter("batchNumber");
                            String manDate = request.getParameter("manDate");
                            String expiryDate = request.getParameter("expiryDate");
                            double price = Double.parseDouble(request.getParameter("price"));
                            int minStock = Integer.parseInt(request.getParameter("minmumStock"));

                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                conn = DriverManager.getConnection(url, username, password);

                                // Inserting item into the database
                                String sql = "INSERT INTO Item (item_name, batch_number, manufacture_date, expire_date, price, minmum_stock) VALUES (?, ?, ?, ?, ?, ?)";
                                ps = conn.prepareStatement(sql);
                                ps.setString(1, itemName);
                                ps.setString(2, batchNumber);
                                ps.setString(3, manDate);
                                ps.setString(4, expiryDate);
                                ps.setDouble(5, price);
                                ps.setInt(6, minStock);

                                int result = ps.executeUpdate();
                                if(result > 0) {
                                    message = "Item added successfully!";
                                } else {
                                    message = "Failed to add item!";
                                }
                            } catch (Exception e) {
                                message = "Database error: " + e.getMessage();
                            } finally {
                                if(ps != null) ps.close();
                                if(conn != null) conn.close();
                            }
                        }
                    %>
                    
                    <!-- Display message -->
                    <div class="alert alert-info" role="alert">
                        <%= message %>
                    </div>

                    <form action="" method="post">
                        <div class="mb-3">
                            <label for="itemName" class="form-label">Item Name</label>
                            <input type="text" class="form-control" id="itemName" name="itemName" required>
                        </div>
                        <div class="mb-3">
                            <label for="batchNumber" class="form-label">Batch Number</label>
                            <input type="text" class="form-control" id="batchNumber" name="batchNumber" required>
                        </div>
                        <div class="mb-3">
                            <label for="manDate" class="form-label">Manufacture Date</label>
                            <input type="date" class="form-control" id="manDate" name="manDate" required>
                        </div>
                        <div class="mb-3">
                            <label for="expiryDate" class="form-label">Expiry Date</label>
                            <input type="date" class="form-control" id="expiryDate" name="expiryDate" required>
                        </div>
                        <div class="mb-3">
                            <label for="price" class="form-label">Price</label>
                            <input type="number" step="0.01" class="form-control" id="price" name="price" required>
                        </div>
                        <div class="mb-3">
                            <label for="minmumStock" class="form-label">Minimum Stock</label>
                            <input type="number" class="form-control" id="minmumStock" name="minmumStock" required>
                        </div>
                        <div class="text-center">
                            <button type="submit" class="btn btn-primary btn-lg btn-custom">Add Item</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <footer class="footer">
        &copy; 2024 MedFriend - All Rights Reserved
    </footer>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.min.js"></script>
</body>
</html>
