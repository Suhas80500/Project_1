<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .login-box {
            border: 1px solid #ccc;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            background-color: #fff;
            width: 100%;
            max-width: 400px;
            margin: 20px auto;
        }
        .login-box h3 {
            font-size: 1.5rem;
        }
        .login-box .form-label {
            font-weight: 500;
        }
        .login-box .btn-primary {
            font-size: 1rem;
        }
        .login-box .alert {
            margin-top: 10px;
        }
        .input-group-text {
            cursor: pointer;
        }
    </style>
    <script>
        function togglePasswordVisibility() {
            var passwordField = document.getElementById("password");
            var toggleIcon = document.getElementById("togglePasswordIcon");
            if (passwordField.type === "password") {
                passwordField.type = "text";
                toggleIcon.classList.remove("bi-eye");
                toggleIcon.classList.add("bi-eye-slash");
            } else {
                passwordField.type = "password";
                toggleIcon.classList.remove("bi-eye-slash");
                toggleIcon.classList.add("bi-eye");
            }
        }
    </script>
</head>
<body>
    <div class="container d-flex justify-content-center align-items-center min-vh-100">
        <div class="login-box">
            <h3 class="text-center mb-4">Login</h3>

            <form method="post">
                <div class="mb-3">
                    <label for="username" class="form-label">Username</label>
                    <input type="text" class="form-control" id="username" name="username" placeholder="Enter your username" required>
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <div class="input-group">
                        <input type="password" class="form-control" id="password" name="password" placeholder="Enter your password" required>
                        <span class="input-group-text" id="togglePassword" onclick="togglePasswordVisibility()">
                            <i class="bi bi-eye" id="togglePasswordIcon"></i>
                        </span>
                    </div>
                </div>
                <div class="mb-3">
                    <label for="userRole" class="form-label">Role</label>
                    <select id="userRole" name="userRole" class="form-select" required>
                        <option value="" disabled selected>Select your role</option>
                        <option value="admin">Admin</option>
                        <option value="user">User</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-primary w-100">Login</button>

                <%
                    String username = request.getParameter("username");
                    String password = request.getParameter("password");
                    String role = request.getParameter("userRole");

                    if (username != null && password != null && role != null) {
                        Connection conn = null;
                        PreparedStatement stmt = null;
                        ResultSet rs = null;

                        try {
                            String dbURL = "jdbc:mysql://localhost:3306/project";
                            String dbUser = "root";
                            String dbPassword = "Root@123";

                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                            // Query checks username, password, and role
                            String query = "SELECT * FROM user_login WHERE username = ? AND password = ? AND role = ?";
                            stmt = conn.prepareStatement(query);
                            stmt.setString(1, username);
                            stmt.setString(2, password);
                            stmt.setString(3, role);  // Add role to the query

                            rs = stmt.executeQuery();

                            if (rs.next()) {
                                // Debugging output for validation checks
                                out.println("<div class='alert alert-success'>Login successful</div>");
                                
                                if (role.equalsIgnoreCase("admin")) {
                                    response.sendRedirect("admin.jsp");
                                } else if (role.equalsIgnoreCase("user")) {
                                    response.sendRedirect("home.jsp");
                                }
                            } else {
                                out.println("<div class='alert alert-danger'>Invalid username, password, or role</div>");
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            out.println("<div class='alert alert-danger'>Error occurred: " + e.getMessage() + "</div>");
                        } finally {
                            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                            try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                        }
                    }
                %>
            </form>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.js"></script>
</body>
</html>
