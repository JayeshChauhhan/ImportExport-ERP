package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.LoginPojo;

@WebServlet("/LoginController")
public class LoginController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        LoginPojo pojo = new LoginPojo();
        pojo.setPort_id(req.getParameter("port_id"));
        pojo.setPassword(req.getParameter("password"));

        String status = pojo.login();

        if ("Login Successful".equals(status)) {
            // Store port_id in session
            HttpSession session = req.getSession();
            session.setAttribute("port_id", pojo.getPort_id());

            // Redirect to home page
            resp.sendRedirect("home.jsp");
        } else {
            req.setAttribute("msg", status);
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        }
    }
}
