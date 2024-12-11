<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }
        .container {
            width: 80%;
            margin: auto;
            overflow: hidden;
        }
        header {
            background: #333;
            color: #fff;
            padding-top: 30px;
            min-height: 70px;
            border-bottom: #fff 3px solid;
            text-align: center;
        }
        header h1 {
            margin: 0;
            font-size: 24px;
        }
        .logout-button {
            float: right;
            margin: 10px;
            background: #dc3545; /* Bootstrap danger color */
            color: #fff;
            border: none;
            padding: 10px 20px;
            cursor: pointer;
        }
        .logout-button:hover {
            background: #c82333;
        }
        .button {
            background: #333;
            color: #fff;
            border: none;
            padding: 10px 20px;
            cursor: pointer;
            font-size: 16px;
            margin: 5px;
        }
        .button:hover {
            background: #555;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th, td {
            padding: 10px;
            text-align: left;
        }
        th {
            background: #333;
            color: #fff;
        }
        form {
            margin-top: 20px;
        }
        input[type="text"], input[type="password"], input[type="submit"] {
            padding: 10px;
            margin: 5px 0;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        input[type="submit"] {
            background: #333;
            color: #fff;
            border: none;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background: #555;
        }
    </style>
</head>
<body>
    <header>
        <h1>Admin Dashboard</h1>
        <form action="user_login.jsp" method="post" style="display:inline;">
            <input type="submit" value="Logout" class="logout-button">
        </form>
    </header>
    
    <div class="container">
        <!-- CRUD Operations Form -->
        <form action="admin.jsp" method="post">
            <h2>Add User</h2>
            <div class="mb-3">
                <label for="username" class="form-label">Username:</label>
                <input type="text" id="username" name="username" class="form-control" required>
            </div>
            <div class="mb-3">
                <label for="password" class="form-label">Password:</label>
                <input type="password" id="password" name="password" class="form-control" required>
            </div>
            <div class="mb-3">
                <label for="role" class="form-label">Role:</label>
                <input type="text" id="role" name="role" class="form-control" value="user" required>
            </div>
            <input type="hidden" name="action" value="add">
            <input type="submit" value="Add User" class="btn btn-primary">
        </form>
        
        <!-- Display Users -->
        <h2>User List</h2>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>Password</th>
                    <th>Role</th>
                    <th>Created At</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection con = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;
                    
                    try {
                        // Load JDBC Driver
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        
                        // Establish connection
                        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/project", "root", "Root@123");
                        
                        String action = request.getParameter("action");
                        if ("add".equals(action)) {
                            // Add user
                            String addUserSQL = "INSERT INTO user_login (username, password, role) VALUES (?, ?, ?)";
                            ps = con.prepareStatement(addUserSQL);
                            ps.setString(1, request.getParameter("username"));
                            ps.setString(2, request.getParameter("password")); // Hash password in production
                            ps.setString(3, request.getParameter("role"));
                            ps.executeUpdate();
                        } else if ("delete".equals(action)) {
                            // Delete user
                            int userID = Integer.parseInt(request.getParameter("userID"));
                            String deleteUserSQL = "DELETE FROM user_login WHERE id = ?";
                            ps = con.prepareStatement(deleteUserSQL);
                            ps.setInt(1, userID);
                            ps.executeUpdate();
                        }
                        
                        // Prepare and execute query
                        ps = con.prepareStatement("SELECT * FROM user_login");
                        rs = ps.executeQuery();
                        
                        // Iterate through the result set
                        while (rs.next()) {
                            int id = rs.getInt("id");
                            String username = rs.getString("username");
                            String password = rs.getString("password");
                            String role = rs.getString("role");
                            Timestamp createdAt = rs.getTimestamp("created_at");
                %>
                <tr>
                    <td><%= id %></td>
                    <td><%= username %></td>
                    <td><%= password %></td>
                    <td><%= role %></td>
                    <td><%= createdAt %></td>
                    <td>
                        <form action="admin.jsp" method="post" style="display:inline;">
                            <input type="hidden" name="userID" value="<%= id %>">
                            <input type="hidden" name="action" value="delete">
                            <input type="submit" class="button" value="Delete">
                        </form>
                        <button class="button" onclick="editUser('<%= id %>')">Edit</button>
                    </td>
                </tr>
                <%
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
            </tbody>
        </table>
    </div>
    
    <script>
        function editUser(userID) {
            window.location.href = "editUser.jsp?userID=" + userID;
        }
    </script>
</body>
</html>
