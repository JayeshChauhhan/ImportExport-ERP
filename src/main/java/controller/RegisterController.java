package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.RegisterPojo;

@WebServlet("/RegisterController")
public class RegisterController extends HttpServlet {

    private static final String DEFAULT_FORWARD_PAGE = "register.jsp";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Create POJO and set values from form
        RegisterPojo pojo = new RegisterPojo();
        pojo.setPort_id(req.getParameter("port_id"));
        pojo.setPassword(req.getParameter("password"));
        pojo.setName(req.getParameter("name"));
        pojo.setEmail(req.getParameter("email"));
        pojo.setLocation(req.getParameter("location"));

        // Call registration method
        String status = pojo.register(pojo);

        if ("Registration Successful".equals(status)) {

            // ✅ Create session (auto-login)
            HttpSession session = req.getSession(true);
            session.setAttribute("port_id", pojo.getPort_id());

            // ✅ Optional redirect support
            String redirectPage = req.getParameter("redirect");

            if (redirectPage != null && !redirectPage.isEmpty()) {
                resp.sendRedirect(redirectPage);
            } else {
                // Default redirect after registration
                resp.sendRedirect("login.jsp");
            }
            return;
        }

        // ❌ Registration failed → stay on register page
        req.setAttribute("msg", status);
        req.getRequestDispatcher(DEFAULT_FORWARD_PAGE).forward(req, resp);
    }
}
