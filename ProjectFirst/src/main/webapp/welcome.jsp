<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Welcome</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: #4E6688;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .dashboard-container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0px 8px 20px rgba(0, 0, 0, 0.2);
            text-align: center;
            width: 400px;
        }

        h2 {
            color: #333;
            margin-bottom: 20px;
        }

        .btn {
            display: block;
            width: 100%;
            padding: 12px;
            margin: 10px 0;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            transition: 0.3s;
        }

        .internals { background: #33cc33; color: white; }
        .externals { background: #33cc33; color: white; }
        .mid1, .mid2 { background: #ffbb33; color: white; display: none; }

        .btn:hover { opacity: 0.8; transform: scale(1.05); }

        .logout {
            background: #d9534f;
            color: white;
            margin-top: 15px;
        }
    </style>
</head>
<body>
    <%
        HttpSession sessionObj = request.getSession(false);
        if (sessionObj == null || sessionObj.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        String username = (String) sessionObj.getAttribute("username");
    %>

    <div class="dashboard-container">
        <h2>Welcome, <%= username %>!</h2>
        <p>Select an assessment type:</p>

        <button class="btn internals" onclick="showInternals()">Internals</button>
        <button class="btn mid1" id="mid1" onclick="location.href='Mid1Servlet'">Mid 1</button>
        <button class="btn mid2" id="mid2" onclick="location.href='Mid2Servlet'">Mid 2</button>
        <button class="btn externals" onclick="location.href='ExternalsServlet'">Externals</button>
        
        <form action="LogoutServlet" method="post">
            <button class="btn logout">Logout</button>
        </form>
    </div>

    <script>
        function showInternals() {
            document.getElementById("mid1").style.display = "block";
            document.getElementById("mid2").style.display = "block";
        }
    </script>
</body>
</html>
