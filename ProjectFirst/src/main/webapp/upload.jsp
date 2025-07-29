<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Upload Marks</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #4E6688;
            margin: 0;
            padding: 40px;
            text-align: center;
        }

        .container {
            width: 60%;
            margin: auto;
            padding: 30px;
            background: white;
            border-radius: 12px;
            box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.2);
        }

        h2 {
            color: #2c3e50;
        }

        .tabs {
            margin-bottom: 25px;
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 10px;
        }

        .tabs button {
            padding: 10px 18px;
            border: none;
            background-color:#28a745; /* Always blue */
            color: white;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
            transition: 0.3s;
        }

        .tabs button:hover {
            background-color: #2980b9; /* darker blue on hover */
        }

        .upload-section {
            display: none;
            margin-top: 20px;
        }

        form {
            margin-top: 15px;
        }

        input[type="file"] {
            margin: 10px auto;
        }

        .upload-btn {
            padding: 10px 15px;
            background: #28a745; /* Only form buttons green */
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 15px;
        }

        .upload-btn:hover {
            background: #28a745;
        }

        canvas {
            margin-top: 40px;
            max-width: 100%;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>📤 Upload Marks</h2>
    <div class="tabs">
        <button onclick="openTab('objective')">Objective</button>
        <button onclick="openTab('openbook')">Open Book</button>
        <button onclick="openTab('descriptive')">Descriptive</button>
        <button onclick="openTab('overall')">Overall</button>
        <button onclick="openTab('merge')">Upload Individually (Merge)</button>
    </div>

    <!-- Objective -->
    <div id="objective" class="upload-section">
        <h3>Upload Objective Marks</h3>
        <form action="UploadObjectiveServlet" method="post" enctype="multipart/form-data" target="_blank">
            <input type="file" name="file" required><br>
            <button type="submit" class="upload-btn">Upload</button>
        </form>
    </div>

    <!-- Open Book -->
    <div id="openbook" class="upload-section">
        <h3>Upload Open Book Marks</h3>
        <form action="UploadOpenBookServlet" method="post" enctype="multipart/form-data" target="_blank">
            <input type="file" name="file" required><br>
            <button type="submit" class="upload-btn">Upload</button>
        </form>
    </div>

    <!-- Descriptive -->
    <div id="descriptive" class="upload-section">
        <h3>Upload Descriptive Marks</h3>
        <form action="UploadDescriptiveServlet" method="post" enctype="multipart/form-data" target="_blank">
            <input type="file" name="file" required><br>
            <button type="submit" class="upload-btn">Upload</button>
        </form>
    </div>

    <!-- Overall -->
    <div id="overall" class="upload-section">
        <h3>Upload Overall Marks (One File)</h3>
        <form action="UploadOverallMarksServlet" method="post" enctype="multipart/form-data" target="_blank">
            <input type="file" name="file" required><br>
            <button type="submit" class="upload-btn">Upload</button>
        </form>
        <canvas id="overallChart"></canvas>
    </div>

    <!-- Merge -->
    <div id="merge" class="upload-section">
        <h3>Upload All Files Individually to Merge & Generate Final CSV</h3>
        <form action="MergeMarksServlet" method="post" enctype="multipart/form-data" target="_blank">
            <label>Objective Marks:</label>
            <input type="file" name="objective" required><br><br>
            <label>Open Book Marks:</label>
            <input type="file" name="openbook" required><br><br>
            <label>Descriptive Marks:</label>
            <input type="file" name="descriptive" required><br><br>
            <label>Seminar Marks:</label>
            <input type="file" name="seminar" required><br><br>
            <button type="submit" class="upload-btn">Merge and Download CSV</button>
        </form>
        <canvas id="mergedChart"></canvas>
    </div>
</div>

<script>
    function openTab(id) {
        const sections = document.getElementsByClassName("upload-section");
        for (let i = 0; i < sections.length; i++) {
            sections[i].style.display = "none";
        }
        document.getElementById(id).style.display = "block";

        if (id === 'overall') drawChart('overall_marks.csv', 'overallChart');
        if (id === 'merge') drawChart('merged_marks.csv', 'mergedChart');
    }

    function drawChart(csvFile, canvasId) {
        fetch(csvFile)
            .then(res => res.text())
            .then(csv => {
                const lines = csv.trim().split("\n");
                if (lines.length <= 1) return;

                const labels = [], data = [];
                for (let i = 1; i < lines.length; i++) {
                    const [roll, obj, open, desc, semi, total] = lines[i].split(",");
                    labels.push("Roll " + roll);
                    data.push(parseInt(total));
                }

                const ctx = document.getElementById(canvasId).getContext('2d');
                new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: 'Total Marks (out of 30)',
                            data: data,
                            backgroundColor: '#ff6384',
                            borderColor: '#e74c3c',
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        scales: {
                            y: {
                                beginAtZero: true,
                                max: 30
                            }
                        }
                    }
                });
            })
            .catch(err => console.error("Chart error:", err));
    }
</script>
</body>
</html>
