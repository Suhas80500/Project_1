<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Supplies Management - MedFriend</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body { background-color: #f4f6f8; }
        table { width: 100%; margin-top: 20px; }
        th, td { padding: 12px; text-align: center; border: 1px solid #ddd; }
    </style>
</head>
<body>

<div class="container">
    <h1 class="text-center mb-4">Supplies List</h1>

    <table class="table table-bordered">
        <thead>
            <tr>
                <th>Agency ID</th>
                <th>Item ID</th>
                <th>Invoice Number</th>
                <th>Quantity</th>
                <th>Created At</th>
            </tr>
        </thead>
        <tbody>
            <%
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    String dbURL = "jdbc:mysql://localhost:3306/project";
                    String usernameDB = "root";
                    String passwordDB = "Root@123";
                    conn = DriverManager.getConnection(dbURL, usernameDB, passwordDB);

                    String sql = "SELECT agency_id, item_id, invoice_number, quantity, created_at FROM supplies";
                    pstmt = conn.prepareStatement(sql);
                    rs = pstmt.executeQuery();

                    while (rs.next()) {
                        String agencyId = rs.getString("agency_id");
                        int itemId = rs.getInt("item_id");
                        int invoiceNumber = rs.getInt("invoice_number");
                        int quantity = rs.getInt("quantity");
                        Timestamp createdAt = rs.getTimestamp("created_at");

                        out.println("<tr>");
                        out.println("<td>" + agencyId + "</td>");
                        out.println("<td>" + itemId + "</td>");
                        out.println("<td>" + invoiceNumber + "</td>");
                        out.println("<td>" + quantity + "</td>");
                        out.println("<td>" + createdAt + "</td>");
                        out.println("</tr>");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
                    if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
                }
            %>
        </tbody>
    </table>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
