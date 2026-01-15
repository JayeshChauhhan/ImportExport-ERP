package controller;

import model.ReportedProductModel;
import model.ReportedProductPojo;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/ReportController")
public class ReportController extends HttpServlet {

    private ReportedProductModel model = new ReportedProductModel();

    private final int RECORDS_PER_PAGE = 8; // you can adjust page size

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("port_id") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String sellerPortId = (String) session.getAttribute("port_id");

        // ----------------------------
        // Pagination parameters
        // ----------------------------
        int page = 1;
        if (req.getParameter("page") != null) {
            try {
                page = Integer.parseInt(req.getParameter("page"));
            } catch (NumberFormatException ignored) {}
        }
        int start = (page - 1) * RECORDS_PER_PAGE;

        // ----------------------------
        // Search & Filter parameters
        // ----------------------------
        Integer searchReportId = null;
        if (req.getParameter("searchReportId") != null
                && !req.getParameter("searchReportId").isEmpty()) {
            try { searchReportId = Integer.parseInt(req.getParameter("searchReportId")); } 
            catch (NumberFormatException ignored) {}
        }

        Integer searchProductId = null;
        if (req.getParameter("searchProductId") != null
                && !req.getParameter("searchProductId").isEmpty()) {
            try { searchProductId = Integer.parseInt(req.getParameter("searchProductId")); }
            catch (NumberFormatException ignored) {}
        }

        String statusFilter = req.getParameter("status");
        if (statusFilter == null) statusFilter = "All";

        // ----------------------------
        // Fetch reports using search + filter + pagination
        // ----------------------------
        List<ReportedProductPojo> reports = model.searchReports(
                sellerPortId,
                searchReportId,
                searchProductId,
                statusFilter,
                start,
                RECORDS_PER_PAGE
        );

        // Total count for pagination
        int totalRecords = model.getSearchReportsCount(
                sellerPortId,
                searchReportId,
                searchProductId,
                statusFilter
        );

        int totalPages = (int) Math.ceil((double) totalRecords / RECORDS_PER_PAGE);

        // ----------------------------
        // Pass attributes to JSP
        // ----------------------------
        req.setAttribute("reports", reports);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);

        req.setAttribute("searchReportId", searchReportId);
        req.setAttribute("searchProductId", searchProductId);
        req.setAttribute("statusFilter", statusFilter);

        req.getRequestDispatcher("reported_product.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("port_id") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String sellerPortId = (String) session.getAttribute("port_id");
        String action = req.getParameter("action");
        String message;

        try {
            if ("update".equalsIgnoreCase(action)) {

                ReportedProductPojo p = new ReportedProductPojo();
                p.setReportId(Integer.parseInt(req.getParameter("reportId")));
                p.setStatus(req.getParameter("status"));

                message = model.update(p);

            } else if ("delete".equalsIgnoreCase(action)) {

                int reportId = Integer.parseInt(req.getParameter("reportId"));
                message = model.delete(reportId);

            } else {
                message = "Invalid action";
            }

        } catch (Exception e) {
            e.printStackTrace();
            message = "Operation failed";
        }

        // ----------------------------
        // After update/delete, reload page with current filters
        // ----------------------------
        Integer searchReportId = null;
        if (req.getParameter("searchReportId") != null
                && !req.getParameter("searchReportId").isEmpty()) {
            try { searchReportId = Integer.parseInt(req.getParameter("searchReportId")); }
            catch (NumberFormatException ignored) {}
        }

        Integer searchProductId = null;
        if (req.getParameter("searchProductId") != null
                && !req.getParameter("searchProductId").isEmpty()) {
            try { searchProductId = Integer.parseInt(req.getParameter("searchProductId")); }
            catch (NumberFormatException ignored) {}
        }

        String statusFilter = req.getParameter("statusFilter");
        if (statusFilter == null) statusFilter = "All";

        int page = 1;
        if (req.getParameter("page") != null) {
            try { page = Integer.parseInt(req.getParameter("page")); } 
            catch (NumberFormatException ignored) {}
        }
        int start = (page - 1) * RECORDS_PER_PAGE;

        List<ReportedProductPojo> reports = model.searchReports(
                sellerPortId,
                searchReportId,
                searchProductId,
                statusFilter,
                start,
                RECORDS_PER_PAGE
        );

        int totalRecords = model.getSearchReportsCount(
                sellerPortId,
                searchReportId,
                searchProductId,
                statusFilter
        );
        int totalPages = (int) Math.ceil((double) totalRecords / RECORDS_PER_PAGE);

        req.setAttribute("message", message);
        req.setAttribute("reports", reports);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("searchReportId", searchReportId);
        req.setAttribute("searchProductId", searchProductId);
        req.setAttribute("statusFilter", statusFilter);

        req.getRequestDispatcher("reported_product.jsp").forward(req, resp);
    }
}
