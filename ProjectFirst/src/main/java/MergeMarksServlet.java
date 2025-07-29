import java.io.*;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/MergeMarksServlet")
@MultipartConfig
public class MergeMarksServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Map<String, Double> objectiveMap = readCSV(request.getPart("objective"));
        Map<String, Double> openbookMap = readCSV(request.getPart("openbook"));
        Map<String, Double> descriptiveMap = readCSV(request.getPart("descriptive"));
        Map<String, Double> seminarMap = readCSV(request.getPart("seminar"));

        Set<String> allRolls = new HashSet<>();
        allRolls.addAll(objectiveMap.keySet());
        allRolls.addAll(openbookMap.keySet());
        allRolls.addAll(descriptiveMap.keySet());
        allRolls.addAll(seminarMap.keySet());

        List<Integer> sorted = new ArrayList<>();
        for (String roll : allRolls) {
            try {
                sorted.add(Integer.parseInt(roll));
            } catch (Exception e) { }
        }
        Collections.sort(sorted);

        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=merged_marks.csv");

        PrintWriter writer = response.getWriter();
        writer.println("Roll Number,Objective,Open Book,Descriptive,Seminar,Total");

        for (int roll : sorted) {
            String r = String.valueOf(roll);
            double obj = objectiveMap.getOrDefault(r, 0.0);
            double open = openbookMap.getOrDefault(r, 0.0);
            double des = descriptiveMap.getOrDefault(r, 0.0);
            double semi = seminarMap.getOrDefault(r, 0.0);

            int objective = (int)(obj / 2);
            int openbook = (int)(open / 4);
            int descriptive = (int)(des / 3);
            int seminar = (int)semi;
            int total = objective + openbook + descriptive + seminar;
            if (total > 30) total = 30;

            writer.println(r + "," + objective + "," + openbook + "," + descriptive + "," + seminar + "," + total);
        }

        writer.flush();
        writer.close();
    }

    private Map<String, Double> readCSV(Part part) throws IOException {
        Map<String, Double> map = new HashMap<>();
        BufferedReader reader = new BufferedReader(new InputStreamReader(part.getInputStream(), "UTF-8"));
        String line;
        boolean first = true;
        while ((line = reader.readLine()) != null) {
            line = line.trim();
            if (line.isEmpty()) continue;

            String[] parts = line.replaceAll("\"", "").split("\\s*,\\s*");
            if (first && parts[0].toLowerCase().contains("roll")) {
                first = false;
                continue;
            }

            if (parts.length >= 2) {
                try {
                    String roll = parts[0].trim();
                    double marks = Double.parseDouble(parts[1].trim());
                    map.put(roll, marks);
                } catch (Exception e) {}
            }
        }
        reader.close();
        return map;
    }
}
