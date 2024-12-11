<%@ page import="java.sql.*, java.math.BigDecimal, java.net.URLEncoder" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page language="java" %>

<%
    // Database connection details
    String url = "jdbc:mysql://localhost:3306/project";
    String username = "root";
    String password = "Root@123";
    boolean isSubmitted = false; // To check if the form is submitted

    // Initialize variables for form submission
    String customerName = "";
    String customerAddress = "";
    String billingDate = "";
    String[] productNames = null;
    String[] batchNumbers = null;
    String[] expireDates = null;
    String[] quantities = null;
    String[] prices = null;
    String[] gsts = null;
    String[] totals = null;

    // Check if the form is submitted
    if (request.getMethod().equalsIgnoreCase("POST")) {
        customerName = request.getParameter("customerName");
        customerAddress = request.getParameter("customerAddress");
        billingDate = request.getParameter("billingDate");
        productNames = request.getParameterValues("productName[]");
        batchNumbers = request.getParameterValues("batchNumber[]");
        expireDates = request.getParameterValues("expireDate[]");
        quantities = request.getParameterValues("quantity[]");
        prices = request.getParameterValues("price[]");
        gsts = request.getParameterValues("gst[]");
        totals = request.getParameterValues("total[]");

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(url, username, password);

            for (int i = 0; i < productNames.length; i++) {
                String query = "INSERT INTO billing (customerName, customerAddress, billingDate, productName, batchNumber, expireDate, quantity, price, gst, total) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                pstmt = conn.prepareStatement(query);
                pstmt.setString(1, customerName);
                pstmt.setString(2, customerAddress);
                pstmt.setDate(3, java.sql.Date.valueOf(billingDate));
                pstmt.setString(4, productNames[i]);
                pstmt.setString(5, batchNumbers[i]);
                pstmt.setDate(6, java.sql.Date.valueOf(expireDates[i]));
                pstmt.setInt(7, Integer.parseInt(quantities[i]));
                pstmt.setBigDecimal(8, new BigDecimal(prices[i]));
                pstmt.setBigDecimal(9, new BigDecimal(gsts[i]));
                pstmt.setBigDecimal(10, new BigDecimal(totals[i]));
                pstmt.executeUpdate();
            }

            isSubmitted = true; // Set submission status to true
            
            // Redirect to confirmation.jsp
            if (isSubmitted) {
                StringBuilder redirectURL = new StringBuilder("confirmation.jsp?");
                redirectURL.append("customerName=" + URLEncoder.encode(customerName, "UTF-8"))
                           .append("&customerAddress=" + URLEncoder.encode(customerAddress, "UTF-8"))
                           .append("&billingDate=" + URLEncoder.encode(billingDate, "UTF-8"));

                for (int i = 0; i < productNames.length; i++) {
                    redirectURL.append("&productName" + i + "=" + URLEncoder.encode(productNames[i], "UTF-8"));
                    redirectURL.append("&batchNumber" + i + "=" + URLEncoder.encode(batchNumbers[i], "UTF-8"));
                    redirectURL.append("&expireDate" + i + "=" + URLEncoder.encode(expireDates[i], "UTF-8"));
                    redirectURL.append("&quantity" + i + "=" + URLEncoder.encode(quantities[i], "UTF-8"));
                    redirectURL.append("&price" + i + "=" + URLEncoder.encode(prices[i], "UTF-8"));
                    redirectURL.append("&gst" + i + "=" + URLEncoder.encode(gsts[i], "UTF-8"));
                    redirectURL.append("&total" + i + "=" + URLEncoder.encode(totals[i], "UTF-8"));
                }

                response.sendRedirect(redirectURL.toString());
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Billing - MedFriend</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f0f8ff; /* Light blue background */
        }
        .header-text {
            color: #2c3e50; /* Dark Blue */
            font-size: 28px;
            margin-bottom: 20px;
        }
        .table th, .table td {
            vertical-align: middle;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="header-text text-center">Customer Billing</div>

    <form method="post">
        <div class="mb-3">
            <label for="customerName" class="form-label">Customer Name</label>
            <input type="text" id="customerName" name="customerName" class="form-control" required value="<%= customerName %>">
        </div>
        <div class="mb-3">
            <label for="customerAddress" class="form-label">Customer Address</label>
            <input type="text" id="customerAddress" name="customerAddress" class="form-control" required value="<%= customerAddress %>">
        </div>
        <div class="mb-3">
            <label for="billingDate" class="form-label">Billing Date</label>
            <input type="date" id="billingDate" name="billingDate" class="form-control" required value="<%= billingDate %>">
        </div>
        
        <table class="table table-bordered" id="productsTable">
            <thead>
                <tr>
                    <th>Product</th>
                    <th>Batch Number</th>
                    <th>Expire Date</th>
                    <th>Quantity</th>
                    <th>Price</th>
                    <th>GST</th>
                    <th>Total</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody id="productsSection">
                <tr class="product-entry">
                    <td>
                        <select class="form-control product-select" name="productName[]" required onchange="updateProductDetails(this)">
                            <option value="">Select Product</option>
                            <option value="Paracetamol" data-batch="B123" data-expire="2025-12-01" data-price="5.00" data-gst="0.50">Paracetamol</option>
                            <option value="Ibuprofen" data-batch="B124" data-expire="2025-11-15" data-price="7.00" data-gst="0.70">Ibuprofen</option>
                            <option value="Amoxicillin" data-batch="B125" data-expire="2025-10-20" data-price="10.00" data-gst="1.00">Amoxicillin</option>
                            <option value="Cetrizine" data-batch="B126" data-expire="2025-09-30" data-price="3.50" data-gst="0.35">Cetrizine</option>
                        </select>
                    </td>
                    <td><input type="text" name="batchNumber[]" class="form-control" readonly required></td>
                    <td><input type="date" name="expireDate[]" class="form-control" readonly required></td>
                    <td><input type="number" name="quantity[]" class="form-control" min="1" required oninput="calculateTotal(this)"></td>
                    <td><input type="text" name="price[]" class="form-control" readonly required></td>
                    <td><input type="text" name="gst[]" class="form-control" readonly required></td>
                    <td><input type="text" name="total[]" class="form-control" readonly required></td>
                    <td>
                        <button type="button" class="btn btn-danger" onclick="this.closest('tr').remove();">Remove</button>
                    </td>
                </tr>
            </tbody>
        </table>
        
        <button type="button" class="btn btn-primary" id="addProductBtn">Add Another Product</button>

        <div class="mt-3">
            <button type="submit" class="btn btn-success">Submit</button>
        </div>
    </form>
</div>

<script>
    document.getElementById('addProductBtn').onclick = function() {
        var newRow = document.createElement('tr');
        newRow.classList.add('product-entry');
        newRow.innerHTML = `
            <td>
                <select class="form-control product-select" name="productName[]" required onchange="updateProductDetails(this)">
                    <option value="">Select Product</option>
                    <option value="Paracetamol" data-batch="B123" data-expire="2025-12-01" data-price="5.00" data-gst="0.50">Paracetamol</option>
                    <option value="Ibuprofen" data-batch="B124" data-expire="2025-11-15" data-price="7.00" data-gst="0.70">Ibuprofen</option>
                    <option value="Amoxicillin" data-batch="B125" data-expire="2025-10-20" data-price="10.00" data-gst="1.00">Amoxicillin</option>
                    <option value="Cetrizine" data-batch="B126" data-expire="2025-09-30" data-price="3.50" data-gst="0.35">Cetrizine</option>
                </select>
            </td>
            <td><input type="text" name="batchNumber[]" class="form-control" readonly required></td>
            <td><input type="date" name="expireDate[]" class="form-control" readonly required></td>
            <td><input type="number" name="quantity[]" class="form-control" min="1" required oninput="calculateTotal(this)"></td>
            <td><input type="text" name="price[]" class="form-control" readonly required></td>
            <td><input type="text" name="gst[]" class="form-control" readonly required></td>
            <td><input type="text" name="total[]" class="form-control" readonly required></td>
            <td>
                <button type="button" class="btn btn-danger" onclick="this.closest('tr').remove();">Remove</button>
            </td>
        `;
        document.getElementById('productsSection').appendChild(newRow);
    };

    function updateProductDetails(selectElement) {
        var selectedOption = selectElement.options[selectElement.selectedIndex];
        var row = selectElement.closest('tr');

        row.querySelector('input[name="batchNumber[]"]').value = selectedOption.getAttribute('data-batch');
        row.querySelector('input[name="expireDate[]"]').value = selectedOption.getAttribute('data-expire');
        row.querySelector('input[name="price[]"]').value = selectedOption.getAttribute('data-price');
        row.querySelector('input[name="gst[]"]').value = selectedOption.getAttribute('data-gst');

        calculateTotal(row.querySelector('input[name="quantity[]"]'));
    }

    function calculateTotal(quantityInput) {
        var row = quantityInput.closest('tr');
        var price = parseFloat(row.querySelector('input[name="price[]"]').value) || 0;
        var quantity = parseInt(quantityInput.value) || 0;
        var gst = parseFloat(row.querySelector('input[name="gst[]"]').value) || 0;

        var total = (price + gst) * quantity;
        row.querySelector('input[name="total[]"]').value = total.toFixed(2);
    }
</script>

</body>
</html>
