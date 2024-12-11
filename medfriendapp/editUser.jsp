<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit User</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }
        .container {
            width: 50%;
            margin: auto;
            overflow: hidden;
            margin-top: 50px;
        }
        header {
            background: #333;
            color: #fff;
            padding: 10px;
            text-align: center;
        }
    </style>
</head>
<body>
    <header>
        <h1>Edit User</h1>
    </header>
    
    <div class="container">
        <%
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                // Load JDBC Driver
                Class.forName("com.mysql.cj.jdbc.Driver");
                
                // Establish connection
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/project", "root", "Root@123");

                int userID = Integer.parseInt(request.getParameter("userID"));

                // Fetch current user details
                String selectUserSQL = "SELECT * FROM user_login WHERE id = ?";
                ps = con.prepareStatement(selectUserSQL);
                ps.setInt(1, userID);
                rs = ps.executeQuery();

                if (rs.next()) {
                    String username = rs.getString("username");
                    String password = rs.getString("password");
                    String role = rs.getString("role");
        %>
        <form action="editUser.jsp" method="post">
            <div class="mb-3">
                <label for="username" class="form-label">Username:</label>
                <input type="text" id="username" name="username" class="form-control" value="<%= username %>" required>
            </div>
            <div class="mb-3">
                <label for="password" class="form-label">Password:</label>
                <input type="password" id="password" name="password" class="form-control" value="<%= password %>" required>
            </div>
            <div class="mb-3">
                <label for="role" class="form-label">Role:</label>
                <input type="text" id="role" name="role" class="form-control" value="<%= role %>" required>
            </div>
            <input type="hidden" name="userID" value="<%= userID %>">
            <input type="hidden" name="action" value="update">
            <input type="submit" value="Update User" class="btn btn-primary">
        </form>
        <%
                } else {
                    out.println("<p>User not found!</p>");
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                // Close resources
                if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        %>

        <%
            // Handle the update action
            String action = request.getParameter("action");
            if ("update".equals(action)) {
                try {
                    // Establish connection
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/project", "root", "Root@123");

                    // Update user details
                    String updateUserSQL = "UPDATE user_login SET username = ?, password = ?, role = ? WHERE id = ?";
                    ps = con.prepareStatement(updateUserSQL);
                    ps.setString(1, request.getParameter("username"));
                    ps.setString(2, request.getParameter("password")); // Hash password in production
                    ps.setString(3, request.getParameter("role"));
                    ps.setInt(4, Integer.parseInt(request.getParameter("userID")));
                    ps.executeUpdate();

                    out.println("<p>User updated successfully!</p>");
                } catch (SQLException e) {
                    e.printStackTrace();
                } finally {
                    // Close resources
                    if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
            }
        %>
    </div>
</body>
</html>
