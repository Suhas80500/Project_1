<%@ page import="java.sql.*, java.util.ArrayList, java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page language="java" %>

<%
    // Retrieve parameters from the previous page
    String customerName = request.getParameter("customerName");
    String customerAddress = request.getParameter("customerAddress");
    String billingDate = request.getParameter("billingDate");
    
    // Initialize a list to hold product details
    List<String[]> productDetails = new ArrayList<>();
    
    // Loop through the product parameters
    for (int i = 0; request.getParameter("productName" + i) != null; i++) {
        String[] details = new String[6]; // Adjust size according to details needed
        details[0] = request.getParameter("productName" + i);
        details[1] = request.getParameter("batchNumber" + i);
        details[2] = request.getParameter("expireDate" + i);
        details[3] = request.getParameter("quantity" + i);
        details[4] = request.getParameter("price" + i);
        details[5] = request.getParameter("gst" + i);
        productDetails.add(details);
    }

    // Convert List to Array for easy use in JSP
    String[][] productArray = productDetails.toArray(new String[0][]);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Billing Confirmation - MedFriend</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container">
    <centre><h2 class="mt-4">Billing Confirmation</h2></centre>
    <p><strong>Customer Name:</strong> <%= customerName %></p>
    <p><strong>Customer Address:</strong> <%= customerAddress %></p>
    <p><strong>Billing Date:</strong> <%= billingDate %></p>

    <table class="table table-bordered">
        <thead>
            <tr>
                <th>Serial No.</th>
                <th>Product</th>
                <th>Batch Number</th>
                <th>Expire Date</th>
                <th>Quantity</th>
                <th>Price</th>
                <th>GST</th>
                <th>Total</th>
            </tr>
        </thead>
        <tbody>
            <%
                // Check if productArray is not empty
                if (productArray != null) {
                    for (int i = 0; i < productArray.length; i++) {
                        out.println("<tr>");
                        // Serial number
                        out.println("<td>" + (i + 1) + "</td>"); // Serial number starts from 1
                        out.println("<td>" + productArray[i][0] + "</td>");
                        out.println("<td>" + productArray[i][1] + "</td>");
                        out.println("<td>" + productArray[i][2] + "</td>");
                        out.println("<td>" + productArray[i][3] + "</td>");
                        out.println("<td>" + productArray[i][4] + "</td>");
                        out.println("<td>" + productArray[i][5] + "</td>");
                        // Assuming total is calculated as (price + gst) * quantity
                        double total = (Double.parseDouble(productArray[i][4]) + Double.parseDouble(productArray[i][5])) * Double.parseDouble(productArray[i][3]);
                        out.println("<td>" + total + "</td>");
                        out.println("</tr>");
                    }
                }
            %>
        </tbody>
    </table>

    <div class="text-end">
        <button class="btn btn-primary" onclick="window.print()">Print Invoice</button>
        <a href="billing.jsp" class="btn btn-secondary">Back to Billing</a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
