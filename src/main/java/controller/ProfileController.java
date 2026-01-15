package controller;

import model.ProfileModel;
import model.ProfilePojo;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;

@WebServlet("/ProfileController")
public class ProfileController extends HttpServlet {

    private ProfileModel model = new ProfileModel();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("port_id") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String port_id = (String) session.getAttribute("port_id");
        ProfilePojo profile = model.viewProfile(port_id);

        if (profile == null) {
            // Profile not found, redirect to error page or login
            resp.sendRedirect("login.jsp?msg=" + URLEncoder.encode("Profile not found", "UTF-8"));
            return;
        }

        req.setAttribute("profile", profile);

        if ("true".equals(req.getParameter("edit"))) {
            req.getRequestDispatcher("profile_edit.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("profile.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("port_id") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String port_id = (String) session.getAttribute("port_id");
        String message = "";

        // Update profile details
        if (req.getParameter("update") != null) {
            ProfilePojo pojo = new ProfilePojo();
            pojo.setPort_id(port_id);
            pojo.setName(req.getParameter("name"));
            pojo.setEmail(req.getParameter("email"));
            pojo.setLocation(req.getParameter("location"));

            message = model.updateProfile(pojo);

        // Change password
        } else if (req.getParameter("changePassword") != null) {
            message = model.changePassword(
                    port_id,
                    req.getParameter("current_password"),
                    req.getParameter("new_password")
            );

        // Delete account
        } else if (req.getParameter("delete") != null) {
            message = model.deleteAccount(
                    port_id,
                    req.getParameter("delete_password")
            );

            if ("Account Deleted Successfully".equalsIgnoreCase(message)) {
                session.invalidate();
                resp.sendRedirect("login.jsp?msg=" + URLEncoder.encode(message, "UTF-8"));
                return;
            }
        }

        // Fetch profile safely after any operation
        ProfilePojo profile = model.viewProfile(port_id);
        if (profile == null) {
            resp.sendRedirect("login.jsp?msg=" + URLEncoder.encode("Profile not found", "UTF-8"));
            return;
        }

        req.setAttribute("msg", message);
        req.setAttribute("profile", profile);
        req.getRequestDispatcher("profile_edit.jsp").forward(req, resp);
    }
}
