<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Billing Page</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            color: #343a40;
        }
        .form-group label {
            font-weight: bold;
        }
        .table th, .table td {
            text-align: center;
        }
        .remove-btn {
            color: #dc3545;
            cursor: pointer;
        }
        .add-product-btn {
            color: #28a745;
            cursor: pointer;
        }
    </style>
    <script>
        function calculateGST() {
            let quantity = document.getElementsByName("quantity[]");
            let price = document.getElementsByName("price[]");
            let gstRate = 0.18; // Example GST rate
            let totalAmount = 0;

            for (let i = 0; i < quantity.length; i++) {
                let quantityValue = parseFloat(quantity[i].value) || 0;
                let priceValue = parseFloat(price[i].value) || 0;
                let gst = (quantityValue * priceValue * gstRate).toFixed(2);
                let total = (quantityValue * priceValue + parseFloat(gst)).toFixed(2);
                
                document.getElementsByName("gst[]")[i].value = gst;
                document.getElementsByName("total[]")[i].value = total;
                totalAmount += parseFloat(total);
            }

            document.getElementById("finalTotal").innerText = totalAmount.toFixed(2);
        }

        function addProductRow() {
            const tableBody = document.getElementById("productTableBody");
            const row = document.createElement("tr");

            row.innerHTML = `   
                <td>
                    <select class="form-control" name="item_id[]" onchange="fetchItemDetails(this)">
                        <option value="">Select Item</option>
                        <!-- Options will be populated by JSP code -->
                    </select>
                </td>
                <td><input type="text" class="form-control" name="batch_number[]" readonly></td>
                <td><input type="date" class="form-control" name="expire_date[]" readonly></td>
                <td><input type="number" class="form-control" name="quantity[]" oninput="calculateGST()" required></td>
                <td><input type="number" class="form-control" name="price[]" oninput="calculateGST()" required></td>
                <td><input type="text" class="form-control" name="gst[]" readonly></td>
                <td><input type="text" class="form-control" name="total[]" readonly></td>
                <td><span class="remove-btn" onclick="removeProductRow(this)">Remove</span></td>
            `;
            tableBody.appendChild(row);
        }

        function removeProductRow(element) {
            element.closest("tr").remove();
            calculateGST();
        }

        function fetchItemDetails(selectElement) {
            const selectedOption = selectElement.options[selectElement.selectedIndex];
            const batchNumberInput = selectElement.closest("tr").querySelector("input[name='batch_number[]']");
            const expireDateInput = selectElement.closest("tr").querySelector("input[name='expire_date[]']");
            const priceInput = selectElement.closest("tr").querySelector("input[name='price[]']");

            batchNumberInput.value = selectedOption.getAttribute("data-batch") || ""; 
            expireDateInput.value = selectedOption.getAttribute("data-expiry") || ""; 
            priceInput.value = selectedOption.getAttribute("data-price") || 0;
            calculateGST();
        }
    </script>
</head>
<body>

<div class="container mt-5">
    <h2 class="text-center">Billing Form</h2>
    <form action="submit_billing.jsp" method="post"> 
        <div class="form-group">
            <label for="customer_name">Customer Name:</label>
            <input type="text" class="form-control" id="customer_name" name="customer_name" required>
        </div>
        <div class="form-group">
            <label for="phone_number">Phone Number:</label>
            <input type="text" class="form-control" id="phone_number" name="phone_number" required>
        </div>
        <div class="form-group">
            <label for="area">Area:</label>
            <input type="text" class="form-control" id="area" name="area" required>
        </div>
        <div class="form-group">
            <label for="city">City:</label>
            <input type="text" class="form-control" id="city" name="city" required>
        </div>
        <div class="form-group">
            <label for="pincode">Pincode:</label>
            <input type="text" class="form-control" id="pincode" name="pincode" required>
        </div>
        <div class="form-group">
            <label for="billing_date">Billing Date:</label>
            <input type="date" class="form-control" id="billing_date" name="billing_date" required>
        </div>
        
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Item</th>
                    <th>Batch Number</th>
                    <th>Expire Date</th>
                    <th>Quantity</th>
                    <th>Price</th>
                    <th>GST</th>
                    <th>Total</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody id="productTableBody">
                <tr>
                    <td>
                        <select class="form-control" name="item_id[]" onchange="fetchItemDetails(this)">
                            <option value="">Select Item</option>
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
                                    String sql = "SELECT item_id, item_name, price, batch_number, expire_date FROM item"; 
                                    pst = con.prepareStatement(sql);
                                    rs = pst.executeQuery();

                                    while (rs.next()) {
                                        %>
                                        <option value="<%= rs.getInt("item_id") %>" 
                                            data-price="<%= rs.getDouble("price") %>" 
                                            data-batch="<%= rs.getString("batch_number") %>" 
                                            data-expiry="<%= rs.getDate("expire_date") != null ? rs.getDate("expire_date").toString() : "" %>">
                                            <%= rs.getString("item_name") %>
                                        </option>
                                        <%
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                } finally {
                                    if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
                                    if (pst != null) try { pst.close(); } catch (SQLException ignore) {}
                                    if (con != null) try { con.close(); } catch (SQLException ignore) {}
                                }
                            %>
                        </select>
                    </td>
                    <td><input type="text" class="form-control" name="batch_number[]" readonly></td>
                    <td><input type="date" class="form-control" name="expire_date[]" readonly></td>
                    <td><input type="number" class="form-control" name="quantity[]" oninput="calculateGST()" required></td>
                    <td><input type="number" class="form-control" name="price[]" oninput="calculateGST()" required></td>
                    <td><input type="text" class="form-control" name="gst[]" readonly></td>
                    <td><input type="text" class="form-control" name="total[]" readonly></td>
                    <td><span class="remove-btn" onclick="removeProductRow(this)">Remove</span></td>
                </tr>
            </tbody>
        </table>
        <button type="button" class="add-product-btn" onclick="addProductRow()">Add Product</button>
        <div class="form-group mt-3">
            <label>Total Amount:</label>
            <h4 id="finalTotal">0.00</h4>
        </div>
        <button type="submit" class="btn btn-primary">Submit Billing</button>
    </form>
</div>

</body>
</html>
