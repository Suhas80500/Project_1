<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page language="java" %>
<%@ page isErrorPage="true" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Purchase - MedFriend</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            background-color: #e9f5ff; /* Light Blue Background */
        }
        .header-text {
            color: #1f618d; /* Dark Blue */
            font-size: 28px;
            margin-bottom: 20px;
        }
        .message {
            color: #27ae60; /* Green */
            font-weight: bold;
            margin-top: 20px;
        }
        .form-label {
            color: #2980b9; /* Blue */
        }
        .btn-secondary {
            background-color: #3498db; /* Bright Blue */
            border: none;
            border-radius: 10px; /* Rounded edges */
        }
        .btn-secondary:hover {
            background-color: #2980b9; /* Darker Blue */
        }
        .submit-btn {
            background-color: #28a745; /* Green */
            color: white;
            border-radius: 7px; /* Rounded edges */
        }
        .submit-btn:hover {
            background-color: #218838; /* Darker Green */
        }
        .back-btn {
            background-color: #3498db; /* Grey */
            color: white;
            border-radius: 20px; /* Rounded edges */
        }
        .back-btn:hover {
            background-color: #7f8c8d; /* Darker Grey */
        }
        .product-entry {
            border: 1px solid #2980b9; /* Blue border */
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 15px;
            background-color: #ffffff; /* White */
        }
    </style>
</head>
<body>

<div class="container">
    <div class="header-text text-center">Purchase Medical Products</div>
    <form id="purchaseForm" method="post" action="purchase.jsp">
        <div class="mb-3">
            <label for="agencyId" class="form-label"><i class="fas fa-id-card"></i> Agency ID</label>
            <input type="text" id="agencyId" name="agencyId" class="form-control" readonly required>
        </div>

        <div class="mb-3">
            <label for="agencyName" class="form-label"><i class="fas fa-id-badge"></i> Agency Name</label>
            <select id="agencyName" name="agencyName" class="form-control" required>
                <option value="">Select Agency Name</option>
                <option value="HealthCare Agency" data-id="A001">HealthCare Agency </option>
                <option value="Pharma Agency" data-id="A002">Pharma Agency </option>
                <option value="Medical Supplies Agency" data-id="A003">Medical Supplies Agency </option>
            </select>
        </div>

        <div id="productsSection">
            <div class="product-entry">
                <label for="productName" class="form-label"><i class="fas fa-box"></i> Product Name</label>
                <select class="form-control product-select" name="productName[]" required>
                    <option value="">Select Product Name</option>
                    <option value="Pain Relief Medicine" data-price="100" data-gst="18">Pain Relief Medicine</option>
                    <option value="Antibiotic Tablet" data-price="200" data-gst="36">Antibiotic Tablet</option>
                    <option value="Cough Syrup" data-price="300" data-gst="54">Cough Syrup</option>
                </select>
                <div class="mb-3">
                    <label for="quantity" class="form-label"><i class="fas fa-sort-numeric-up"></i> Quantity</label>
                    <input type="number" name="quantity[]" class="form-control product-quantity" min="1" required>
                </div>
            </div>
        </div>

        <button type="button" class="btn btn-secondary" id="addProductBtn">Add Another Product</button>

        <div class="mb-3 mt-3">
            <label for="date" class="form-label"><i class="fa-solid fa-calendar-days"></i> Order Date</label>
            <input type="date" name="orderDate" id="date" class="form-control" required>
        </div>

        <div class="d-flex justify-content-between">
            <button type="submit" class="submit-btn">Submit</button>
            <a href="home.jsp" class="btn back-btn">Back to Home</a>
        </div>
    </form>

    <div id="message" class="message" style="display:none;">Order Placed Successfully!</div>
</div>

<script>
    document.getElementById("agencyName").addEventListener("change", function() {
        const selectedOption = this.options[this.selectedIndex];
        const agencyId = selectedOption.getAttribute("data-id");
        document.getElementById("agencyId").value = agencyId;
    });

    document.getElementById("addProductBtn").addEventListener("click", function() {
        const productsSection = document.getElementById("productsSection");
        const newProductEntry = document.createElement("div");
        newProductEntry.className = "product-entry";
        newProductEntry.innerHTML = `
            <label for="productName" class="form-label"><i class="fas fa-box"></i> Product Name</label>
            <select class="form-control product-select" name="productName[]" required>
                <option value="">Select Product Name</option>
                <option value="P001" data-price="100" data-gst="18">Pain Relief Medicine</option>
                <option value="P002" data-price="200" data-gst="36">Antibiotic Tablet</option>
                <option value="P003" data-price="300" data-gst="54">Cough Syrup</option>
            </select>
            <div class="mb-3">
                <label for="quantity" class="form-label"><i class="fas fa-sort-numeric-up"></i> Quantity</label>
                <input type="number" name="quantity[]" class="form-control product-quantity" min="1" required>
            </div>
        `;
        productsSection.appendChild(newProductEntry);
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<%
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String agencyId = request.getParameter("agencyId");
        String agencyName = request.getParameter("agencyName");
        String[] productNames = request.getParameterValues("productName[]");
        String[] quantityStrs = request.getParameterValues("quantity[]");
        String orderDateStr = request.getParameter("orderDate");

        String dbUrl = "jdbc:mysql://localhost:3306/project"; // Change as needed
        String dbUser = "root"; // Change as needed
        String dbPassword = "Root@123"; // Change as needed

        Connection conn = null;
        PreparedStatement stmt = null;
        PreparedStatement salesStmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

            String sql = "INSERT INTO purchases (agency_id, agency_name, product_name, quantity, order_date) VALUES (?, ?, ?, ?, ?)";
            String salesSql = "INSERT INTO sales (agency_id, agency_name, product_name, quantity, order_date, transaction_type) VALUES (?, ?, ?, ?, ?, 'purchase')";
            stmt = conn.prepareStatement(sql);
            salesStmt = conn.prepareStatement(salesSql);

            for (int i = 0; i < productNames.length; i++) {
                int quantity = Integer.parseInt(quantityStrs[i]);
                stmt.setString(1, agencyId);
                stmt.setString(2, agencyName);
                stmt.setString(3, productNames[i]);
                stmt.setInt(4, quantity);
                stmt.setDate(5, Date.valueOf(orderDateStr));
                stmt.executeUpdate();

                // Insert into sales table
                salesStmt.setString(1, agencyId);
                salesStmt.setString(2, agencyName);
                salesStmt.setString(3, productNames[i]);
                salesStmt.setInt(4, quantity);
                salesStmt.setDate(5, Date.valueOf(orderDateStr));
                salesStmt.executeUpdate();
            }

            out.println("<script>document.getElementById('message').style.display = 'block';</script>");

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('An error occurred: " + e.getMessage() + "');</script>");
        } finally {
            if (stmt != null) try { stmt.close(); } catch (SQLException e) { /* Ignored */ }
            if (salesStmt != null) try { salesStmt.close(); } catch (SQLException e) { /* Ignored */ }
            if (conn != null) try { conn.close(); } catch (SQLException e) { /* Ignored */ }
        }
    }
%>
</body>
</html>
