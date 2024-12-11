<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Billing Summary</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            color: #343a40;
        }
        .invoice-container {
            padding: 20px;
            background-color: #ffffff;
            border: 1px solid #dee2e6;
            border-radius: 8px;
        }
        .invoice-header {
            text-align: center;
            margin-bottom: 20px;
        }
        .invoice-header h2 {
            margin: 0;
        }
        .invoice-details, .customer-details, .product-details {
            margin-bottom: 20px;
        }
        .invoice-details th, .product-details th, .product-details td {
            text-align: left;
        }
        .product-details td {
            vertical-align: middle;
        }
        .product-details th {
            background-color: #f1f1f1;
        }
        .total-amount {
            text-align: right;
            font-size: 18px;
            font-weight: bold;
        }
    </style>
</head>
<body>

<div class="container mt-5">
    <div class="invoice-container">
        <div class="invoice-header">
            <h2>Billing Summary</h2>
        </div>
        
        <%
            Connection con = null;
            PreparedStatement pst = null;
            ResultSet rs = null;

            try {
                String url = "jdbc:mysql://localhost:3306/project"; 
                String user = "root"; 
                String password = "Root@123"; 
                
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection(url, user, password);

                String customerName = request.getParameter("customer_name");
                String customerPhone = request.getParameter("phone_number");
                String area = request.getParameter("area");
                String city = request.getParameter("city");
                String pincode = request.getParameter("pincode");
                String billingDate = request.getParameter("billing_date");

                // Insert customer details
                String insertCustomer = "INSERT INTO customer (customer_name, phone_number, area, city, pincode) VALUES (?, ?, ?, ?, ?)";
                pst = con.prepareStatement(insertCustomer, Statement.RETURN_GENERATED_KEYS);
                pst.setString(1, customerName);
                pst.setString(2, customerPhone);
                pst.setString(3, area);
                pst.setString(4, city);
                pst.setString(5, pincode);
                pst.executeUpdate();
                
                rs = pst.getGeneratedKeys();
                rs.next();
                int customerId = rs.getInt(1);

                String[] itemIds = request.getParameterValues("item_id[]");
                String[] quantities = request.getParameterValues("quantity[]");
                String[] gstValues = request.getParameterValues("gst[]");
                String[] totals = request.getParameterValues("total[]");

                // Insert billing details
                for (int i = 0; i < itemIds.length; i++) {
                    String insertBilling = "INSERT INTO billing1 (customer_id, item_id, quantity, gst, total, billing_date) VALUES (?, ?, ?, ?, ?, ?)";
                    pst = con.prepareStatement(insertBilling);
                    pst.setInt(1, customerId);
                    pst.setInt(2, Integer.parseInt(itemIds[i]));
                    pst.setInt(3, Integer.parseInt(quantities[i]));
                    pst.setDouble(4, Double.parseDouble(gstValues[i]));
                    pst.setDouble(5, Double.parseDouble(totals[i]));
                    pst.setString(6, billingDate);
                    pst.executeUpdate();
                }

                // Display customer details
                %>
                <div class="customer-details">
                    <h4>Customer Details:</h4>
                    <p><strong>Name:</strong> <%= customerName %></p>
                    <p><strong>Phone:</strong> <%= customerPhone %></p>
                    <p><strong>Address:</strong> <%= area %>, <%= city %>, <%= pincode %></p>
                    <p><strong>Date:</strong> <%= billingDate %></p>
                </div>

                <%
                // Display product details
                %>
                <div class="product-details">
                    <h4>Product Details:</h4>
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Item ID</th>
                                <th>Quantity</th>
                                <th>GST</th>
                                <th>Total</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            double finalTotal = 0;
                            for (int i = 0; i < itemIds.length; i++) {
                                double itemTotal = Double.parseDouble(totals[i]);
                                finalTotal += itemTotal;
                                %>
                                <tr>
                                    <td><%= itemIds[i] %></td>
                                    <td><%= quantities[i] %></td>
                                    <td><%= gstValues[i] %></td>
                                    <td>₹<%= itemTotal %></td>
                                </tr>
                                <%
                            }
                            %>
                        </tbody>
                    </table>
                </div>

                <div class="total-amount">
                    <p>Total Amount: ₹<%= String.format("%.2f", finalTotal) %></p>
                </div>

                <a href="billing.jsp" class="btn btn-primary">Back to Billing</a>
                <a href="#" onclick="window.print();" class="btn btn-success">Print Invoice</a>
                <%
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
                if (pst != null) try { pst.close(); } catch (SQLException ignore) {}
                if (con != null) try { con.close(); } catch (SQLException ignore) {}
            }
        %>
    </div>
</div>

</body>
</html>

