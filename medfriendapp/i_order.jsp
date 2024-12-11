<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Management - MedFriend</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600&family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">

    <!-- Custom CSS -->
    <style>
        body {
            font-family: 'Montserrat', sans-serif;
            background-color: #f4f6f8;
            color: #333;
        }
        .container {
            margin-top: 50px;
        }
        h1 {
            font-family: 'Roboto', sans-serif;
            font-weight: 700;
            color: #2c3e50;
        }
        .card {
            border-radius: 15px;
            box-shadow: 0px 5px 20px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0px 8px 25px rgba(0, 0, 0, 0.2);
        }
        .btn-custom {
            background-color: #28a745;
            color: white;
        }
        .btn-custom:hover {
            background-color: #218838;
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
            border-color: #28a745;
            box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25);
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
        <h1 class="text-center mb-4">Place Your Order</h1>

        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card p-4">
                    <form action="" method="post">
                        <div class="mb-3">
                            <label for="userId" class="form-label">User ID</label>
                            <input type="number" class="form-control" id="userId" name="userId" required>
                        </div>
                        <div class="mb-3">
                            <label for="itemId" class="form-label">Item ID</label>
                            <input type="number" class="form-control" id="itemId" name="itemId" required>
                        </div>
                        <div class="mb-3">
                            <label for="quantity" class="form-label">Quantity</label>
                            <input type="number" class="form-control" id="quantity" name="quantity" required>
                        </div>
                        <div class="text-center">
                            <button type="submit" class="btn btn-primary btn-lg btn-custom">Place Order</button>
                        </div>
                    </form>

                    <%
                        if ("post".equalsIgnoreCase(request.getMethod())) {
                            String userId = request.getParameter("userId");
                            String itemId = request.getParameter("itemId");
                            String quantity = request.getParameter("quantity");

                            Connection conn = null;
                            PreparedStatement pstmtItem = null;
                            PreparedStatement pstmtUser = null;
                            ResultSet rsItem = null;
                            ResultSet rsUser = null;

                            try {
                                // Load the JDBC driver
                                Class.forName("com.mysql.cj.jdbc.Driver");

                                // Establish connection to the database
                                String dbURL = "jdbc:mysql://localhost:3306/project"; // Change to your database name
                                String usernameDB = "root"; // Change to your database username
                                String passwordDB = "Root@123"; // Change to your database password
                                conn = DriverManager.getConnection(dbURL, usernameDB, passwordDB);

                                // Fetch item details
                                String sqlItem = "SELECT item_name, batch_number, manufacture_date, expire_date, price FROM Item WHERE item_id = ?";
                                pstmtItem = conn.prepareStatement(sqlItem);
                                pstmtItem.setInt(1, Integer.parseInt(itemId));
                                rsItem = pstmtItem.executeQuery();

                                // Fetch user details
                                String sqlUser = "SELECT username, role FROM user_login WHERE id = ?";
                                pstmtUser = conn.prepareStatement(sqlUser);
                                pstmtUser.setInt(1, Integer.parseInt(userId));
                                rsUser = pstmtUser.executeQuery();

                                if (rsItem.next() && rsUser.next()) {
                                    String itemName = rsItem.getString("item_name");
                                    String batchNumber = rsItem.getString("batch_number");
                                    String manufactureDate = rsItem.getString("manufacture_date");
                                    String expireDate = rsItem.getString("expire_date");
                                    String price = rsItem.getString("price");
                                    String usernameFetched = rsUser.getString("username"); // Renamed to avoid conflict
                                    String role = rsUser.getString("role");

                                    // Insert order into the i_order table
                                    String insertOrderSql = "INSERT INTO i_order (id, item_id, quantity) VALUES (?, ?, ?)";
                                    PreparedStatement pstmtOrder = conn.prepareStatement(insertOrderSql);
                                    pstmtOrder.setInt(1, Integer.parseInt(userId));
                                    pstmtOrder.setInt(2, Integer.parseInt(itemId));
                                    pstmtOrder.setInt(3, Integer.parseInt(quantity));
                                    pstmtOrder.executeUpdate();

                                    // Display success message with details
                                    out.println("<div class='alert alert-success mt-4'>");
                                    out.println("<strong>Order Placed Successfully!</strong><br>");
                                    out.println("User ID: " + userId + "<br>");
                                    out.println("Username: " + usernameFetched + "<br>"); // Use the renamed variable
                                    out.println("Role: " + role + "<br>");
                                    out.println("Item ID: " + itemId + "<br>");
                                    out.println("Item Name: " + itemName + "<br>");
                                    out.println("Batch Number: " + batchNumber + "<br>");
                                    out.println("Manufacture Date: " + manufactureDate + "<br>");
                                    out.println("Expire Date: " + expireDate + "<br>");
                                    out.println("Price: " + price + "<br>");
                                    out.println("Quantity: " + quantity);
                                    out.println("</div>");
                                } else {
                                    out.println("<div class='alert alert-danger mt-4'>Failed to fetch item or user details.</div>");
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                                out.println("<div class='alert alert-danger mt-4'>Database error: " + e.getMessage() + "</div>");
                            } finally {
                                if (rsItem != null) try { rsItem.close(); } catch (SQLException ignored) {}
                                if (rsUser != null) try { rsUser.close(); } catch (SQLException ignored) {}
                                if (pstmtItem != null) try { pstmtItem.close(); } catch (SQLException ignored) {}
                                if (pstmtUser != null) try { pstmtUser.close(); } catch (SQLException ignored) {}
                                if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
                            }
                        }
                    %>
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
