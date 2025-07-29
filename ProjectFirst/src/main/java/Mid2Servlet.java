import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/Mid2Servlet")
public class Mid2Servlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Check if user is logged in
        //if (session == null || session.getAttribute("username") == null) {
          //  response.sendRedirect("login.jsp");
            //return;
        //}

        // Redirect to mid1.jsp for assessment selection
        response.sendRedirect("upload.jsp");
    }
}
