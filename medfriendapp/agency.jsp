<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Agency Management - MedFriend</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600&family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">

    <!-- Custom CSS -->
    <style>
        body {
            font-family: 'Montserrat', sans-serif;
            background-color: #f0f8ff;
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
            background-color: #3498db;
            color: white;
        }
        .btn-custom:hover {
            background-color: #2980b9;
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

<%
    String message = "";
    String messageType = "";

    // Check if the form was submitted
    if (request.getMethod().equalsIgnoreCase("POST")) {
        // Retrieve form data
        String agencyId = request.getParameter("agencyId");
        String agencyName = request.getParameter("agencyName");
        String phoneNumber = request.getParameter("phoneNumber");
        String gstNumber = request.getParameter("gstNumber");
        String location = request.getParameter("location");

        // Database connection parameters
        String dbURL = "jdbc:mysql://localhost:3306/project";
        String dbUser = "root";
        String dbPassword = "Root@123";  // Replace with your actual password

        Connection con = null;
        PreparedStatement ps = null;

        try {
            // Load JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish database connection
            con = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            // SQL query to insert the agency data
            String query = "INSERT INTO Agency (agency_id, agency_name, phone_number, gst_number, location) VALUES (?, ?, ?, ?, ?)";
            ps = con.prepareStatement(query);

            // Set parameters for the SQL query
            ps.setString(1, agencyId);
            ps.setString(2, agencyName);
            ps.setString(3, phoneNumber);
            ps.setString(4, gstNumber);
            ps.setString(5, location);

            // Execute the query
            int rowsAffected = ps.executeUpdate();

            // Set the message to display based on success/failure
            if (rowsAffected > 0) {
                message = "Agency added successfully!";
                messageType = "success";
            } else {
                message = "Error adding agency. Please try again.";
                messageType = "danger";
            }

        } catch (Exception e) {
            message = "Database error: " + e.getMessage();
            messageType = "danger";
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException ex) {
                message = "Error closing the connection: " + ex.getMessage();
                messageType = "danger";
            }
        }
    }
%>

    <div class="container">
        <h1 class="text-center mb-4">Agency Management</h1>
        
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card p-4">
                    <!-- Display success or error message -->
                    <% if (!message.isEmpty()) { %>
                        <div class="alert alert-<%= messageType %> text-center">
                            <%= message %>
                        </div>
                    <% } %>

                    <!-- Agency form -->
                    <form action="agency.jsp" method="post">
                        <div class="mb-3">
                            <label for="agencyId" class="form-label">Agency ID</label>
                            <input type="text" class="form-control" id="agencyId" name="agencyId" required>
                        </div>
                        <div class="mb-3">
                            <label for="agencyName" class="form-label">Agency Name</label>
                            <input type="text" class="form-control" id="agencyName" name="agencyName" required>
                        </div>
                        <div class="mb-3">
                            <label for="phoneNumber" class="form-label">Phone Number</label>
                            <input type="number" class="form-control" id="phoneNumber" name="phoneNumber" required>
                        </div>
                        <div class="mb-3">
                            <label for="gstNumber" class="form-label">GST Number</label>
                            <input type="text" class="form-control" id="gstNumber" name="gstNumber" required>
                        </div>
                        <div class="mb-3">
                            <label for="location" class="form-label">Location</label>
                            <input type="text" class="form-control" id="location" name="location" required>
                        </div>
                        <div class="text-center">
                            <button type="submit" class="btn btn-primary btn-lg btn-custom">Add Agency</button>
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
