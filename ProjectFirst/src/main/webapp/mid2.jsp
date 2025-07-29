<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Mid2 Assessment</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            background-color: #f4f4f4;
        }
        .container {
            width: 50%;
            margin: auto;
            padding: 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.2);
        }
        h2 {
            color: #333;
        }
        a {
            display: block;
            margin: 10px;
            padding: 10px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            width: 80%;
            margin-left: auto;
            margin-right: auto;
        }
        a:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Select Mid2 Assessment Type</h2>
        <a href="upload.jsp?type=assignment">Assignment Marks</a>
        <a href="upload.jsp?type=objective">Objective Marks</a>
        <a href="upload.jsp?type=openbook">Open Book Marks</a>
        <a href="upload.jsp?type=descriptive">Descriptive Marks</a>
        <a href="upload.jsp?type=overall">Overall Mid2 Marks</a>
    </div>
</body>
</html>
    