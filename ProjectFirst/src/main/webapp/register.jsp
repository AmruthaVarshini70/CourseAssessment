<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*, java.security.MessageDigest, java.nio.charset.StandardCharsets, java.math.BigInteger"%>
<!DOCTYPE html>
<html>
<head>
    <title>Register</title>
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            font-family: "Times New Roman", Times, serif;
            background: white;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .register-container {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.2);
            text-align: center;
            width: 370px;
            max-height: 90vh;
            overflow-y: auto;
        }

        form {
            width: 100%;
        }

        .form-group {
            text-align: left;
            margin-bottom: 14px;
            width: 100%;
        }

        .form-group label {
            display: block;
            font-size: 14px;
            color: #333;
            margin-bottom: 5px;
            font-weight: bold;
        }

        input[type="text"],
        input[type="password"],
        select {
            width: 100%;
            padding: 10px;
            height: 42px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
            font-family: "Times New Roman", Times, serif;
        }

        input[type="submit"] {
            background-color: #28a745;
            color: white;
            border: none;
            cursor: pointer;
            font-size: 16px;
            transition: 0.3s ease;
            width: 100%;
            margin-top: 10px;
            height: 45px;
        }

        input[type="submit"]:hover {
            background-color: #218838;
            transform: scale(1.05);
        }

        .error {
            color: red;
            font-size: 14px;
        }
    </style>

    <script>
        function validateForm() {
            let password = document.getElementById("password").value;
            let confirmPassword = document.getElementById("confirmPassword").value;
            if (password !== confirmPassword) {
                alert("Passwords do not match!");
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
<div class="register-container">
    <h2>Register</h2>
    <form method="post" onsubmit="return validateForm()">

        <div class="form-group">
            <label for="username">Username</label>
            <input type="text" id="username" name="username" placeholder="Enter your username" required>
        </div>

        <div class="form-group">
            <label for="year">Year</label>
            <select name="year" required>
                <option value="">Select Year</option>
                <option>2022</option>
                <option>2023</option>
                <option>2024</option>
                <option>2025</option>
                <option>2026</option>
                <option>2027</option>
            </select>
        </div>

        <div class="form-group">
            <label for="department">Department</label>
            <select name="department" required>
                <option value="">Select Department</option>
                <option>CSE</option>
                <option>IT</option>
                <option>ECE</option>
                <option>EEE</option>
                <option>AIDS</option>
                <option>AIML</option>
                <option>CSO</option>
                <option>CSM</option>
                <option>MECH</option>
                <option>CIVIL</option>
                <option>CI</option>
                <option>other</option>
            </select>
        </div>

        <div class="form-group">
            <label for="subject">Subject</label>
            <select name="subject" required>
                <option value="">Select Subject</option>
                <option>CNS</option>
                <option>JAVA</option>
                <option>C</option>
                <option>FED</option>
                <option>DS</option>
                <option>DAA</option>
                <option>DBMS</option>
                <option>CN</option>
                <option>PYTHON</option>
                <option>M1</option>
                <option>P&S</option>
                <option>CHEM</option>
                <option>PHY</option>
                <option>ENG</option>
                <option>others</option>
            </select>
        </div>

        <div class="form-group">
            <label for="regulation">Regulation</label>
            <select name="regulation">
                <option value="">Select Regulation</option>
                <option>R17</option>
                <option>R18</option>
                <option>R19</option>
                <option>R20</option>
                <option>R21</option>
                <option>R22</option>
                <option>R23</option>
                <option>R24</option>
            </select>
        </div>

        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" placeholder="Password" required>
        </div>

        <div class="form-group">
            <label for="confirmPassword">Confirm Password</label>
            <input type="password" id="confirmPassword" name="confirmpassword" placeholder="Confirm Password" required>
        </div>

        <input type="submit" value="Register">
    </form>

<%
if ("post".equalsIgnoreCase(request.getMethod())) {
    String username = request.getParameter("username").trim();
    String year = request.getParameter("year").trim();
    String department = request.getParameter("department").trim();
    String subject = request.getParameter("subject").trim();
    String regulation = request.getParameter("regulation").trim();
    String password = request.getParameter("password").trim();
    String confirmPassword = request.getParameter("confirmpassword").trim();

    if (!password.equals(confirmPassword)) {
        out.println("<script>alert('Passwords do not match!');</script>");
    } else {
        Connection conn = null;
        PreparedStatement checkStmt = null;
        PreparedStatement stmt = null;

        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes(StandardCharsets.UTF_8));
            String hashedPassword = String.format("%064x", new BigInteger(1, hash));

            String URL = "jdbc:oracle:thin:@localhost:1521:XE";
            String USER = "system";
            String PASSWORD = "database";

            Class.forName("oracle.jdbc.OracleDriver");
            conn = DriverManager.getConnection(URL, USER, PASSWORD);

            String checkUserSQL = "SELECT COUNT(*) FROM users WHERE username = ?";
            checkStmt = conn.prepareStatement(checkUserSQL);
            checkStmt.setString(1, username);
            ResultSet rs = checkStmt.executeQuery();
            rs.next();
            int count = rs.getInt(1);

            if (count > 0) {
                out.println("<script>alert('Username already exists!');</script>");
            } else {
                String sql = "INSERT INTO users (username, year, department, subject, regulation, password) VALUES (?, ?, ?, ?, ?, ?)";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, username);
                stmt.setString(2, year);
                stmt.setString(3, department);
                stmt.setString(4, subject);
                stmt.setString(5, regulation);
                stmt.setString(6, hashedPassword);

                int rowsInserted = stmt.executeUpdate();
                if (rowsInserted > 0) {
                    response.sendRedirect("login.jsp");
                } else {
                    out.println("<script>alert('Registration failed!');</script>");
                }
            }
        } catch (SQLException e) {
            out.println("<script>alert('Database error: " + e.getMessage() + "');</script>");
            e.printStackTrace();
        } catch (Exception e) {
            out.println("<script>alert('An error occurred: " + e.getMessage() + "');</script>");
            e.printStackTrace();
        } finally {
            if (stmt != null) stmt.close();
            if (checkStmt != null) checkStmt.close();
            if (conn != null) conn.close();
        }
    }
}
%>

    <p style="margin-top: 10px;">Already have an account? <a href="login.jsp">Login here</a></p>
</div>
</body>
</html>
