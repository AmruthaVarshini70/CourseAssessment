<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Overall Marks Visualization</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 40px;
            text-align: center;
        }
        .container {
            width: 80%;
            margin: auto;
            padding: 30px;
            background: white;
            border-radius: 12px;
            box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.2);
        }
        h2 {
            color: #2c3e50;
        }
        .summary {
            margin-top: 20px;
            padding: 20px;
            background-color: #eaf2f8;
            border-radius: 10px;
        }
        canvas {
            margin: 30px auto;
            max-width: 100%;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>📊 Overall Marks Visualization</h2>
        <div class="summary">
            <p><strong>Class Average:</strong> <span id="average"></span></p>
            <p><strong>Pass Percentage:</strong> <span id="pass"></span>%</p>
            <p><strong>Topper:</strong> <span id="topper"></span></p>
        </div>
        <canvas id="barChart"></canvas>
        <canvas id="pieChart"></canvas>
    </div>

    <script>
        fetch("overall_marks.csv")
            .then(response => response.text())
            .then(csvText => {
                const lines = csvText.trim().split("\n");
                if (lines.length <= 1) return;

                const labels = [];
                const marks = [];
                let total = 0, pass = 0;
                let max = -1, topRoll = "";

                for (let i = 1; i < lines.length; i++) {
                    const parts = lines[i].split(",");
                    if (parts.length < 6) continue;

                    const roll = parts[0];
                    const totalStr = parts[5];
                    const t = parseInt(totalStr);

                    labels.push("Roll " + roll);
                    marks.push(t);
                    total += t;
                    if (t >= 16) pass++;
                    if (t > max) {
                        max = t;
                        topRoll = roll;
                    }
                }

                const average = (total / marks.length).toFixed(2);
                const passPercent = ((pass / marks.length) * 100).toFixed(1);

                document.getElementById("average").innerText = average;
                document.getElementById("pass").innerText = passPercent;
                document.getElementById("topper").innerText = `Roll ${topRoll} (${max} marks)`;

                // Bar Chart
                new Chart(document.getElementById("barChart"), {
                    type: 'bar',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: 'Total Marks (out of 30)',
                            data: marks,
                            backgroundColor: '#3498db'
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

                // Pie Chart
                new Chart(document.getElementById("pieChart"), {
                    type: 'pie',
                    data: {
                        labels: ['Pass', 'Fail'],
                        datasets: [{
                            data: [pass, marks.length - pass],
                            backgroundColor: ['#2ecc71', '#e74c3c']
                        }]
                    },
                    options: {
                        responsive: true
                    }
                });
            })
            .catch(err => console.error("Error loading CSV:", err));
    </script>
</body>
</html>
