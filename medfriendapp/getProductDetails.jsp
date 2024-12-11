<%@ page import="java.sql.*" %>
<%@ page contentType="application/json;charset=UTF-8" %>
<%@ page language="java" %>

<%
    String productName = request.getParameter("productName");
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    String dbUrl = "jdbc:mysql://localhost:3306/project"; // Change as needed
    String dbUser = "root"; // Change as needed
    String dbPassword = "Root@123"; // Change as needed

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
        String sql = "SELECT batch_number, expire_date, price, gst FROM products WHERE name = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, productName);
        rs = stmt.executeQuery();
        
        if (rs.next()) {
            String batchNumber = rs.getString("batch_number");
            Date expireDate = rs.getDate("expire_date");
            double price = rs.getDouble("price");
            double gst = rs.getDouble("gst");

            String jsonResponse = String.format("{\"batch_number\":\"%s\", \"expire_date\":\"%s\", \"price\":\"%.2f\", \"gst\":\"%.2f\"}",
                    batchNumber, expireDate, price, gst);
            out.print(jsonResponse);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
