import java.io.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/UploadOverallMarksServlet")
@MultipartConfig
public class UploadOverallMarksServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Part filePart = request.getPart("file");
        BufferedReader reader = new BufferedReader(new InputStreamReader(filePart.getInputStream(), "UTF-8"));

        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=overall_marks.csv");

        PrintWriter writer = response.getWriter();
        writer.println("Roll Number,Objective,Open Book,Descriptive,Seminar,Total");

        String line;
        boolean firstLine = true;

        while ((line = reader.readLine()) != null) {
            line = line.trim();
            if (line.isEmpty()) continue;

            String[] parts = line.replaceAll("\"", "").split("\\s*,\\s*");

            if (firstLine && parts[0].toLowerCase().contains("roll")) {
                firstLine = false;
                continue;
            }

            if (parts.length == 5) {
                try {
                    String rollNo = parts[0].trim();
                    double objective = Double.parseDouble(parts[1].trim());
                    double openbook = Double.parseDouble(parts[2].trim());
                    double mid1 = Double.parseDouble(parts[3].trim());
                    double seminar = Double.parseDouble(parts[4].trim());

                    int obj = (int)(objective / 2);
                    int open = (int)(openbook / 4);
                    int des = (int)(mid1 / 3);
                    int semi = (int)(seminar);

                    int total = obj + open + des + semi;
                    if (total > 30) total = 30;

                    writer.println(rollNo + "," + obj + "," + open + "," + des + "," + semi + "," + total);
                } catch (NumberFormatException e) {
                    writer.println("Invalid,Invalid,Invalid,Invalid,Invalid,Invalid");
                }
            }
        }

        reader.close();
        writer.flush();
    }
}
