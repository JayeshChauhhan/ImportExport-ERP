package controller;

import model.ProductPojo;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/ProductController")
public class ProductController extends HttpServlet {

    private final int PAGE_SIZE = 7; // Number of products per page

    // ================= GET : LOAD + SEARCH + PAGINATION =================
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        // Session validation
        if (session == null || session.getAttribute("port_id") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String sellerPortId = (String) session.getAttribute("port_id");
        String searchKeyword = req.getParameter("search");

        // Pagination parameters
        int page = 1;
        try {
            String pageParam = req.getParameter("page");
            if (pageParam != null) page = Integer.parseInt(pageParam);
        } catch (NumberFormatException e) {
            page = 1;
        }

        ProductPojo pojo = new ProductPojo();
        List<ProductPojo> productList;

        // SEARCH or NORMAL LOAD with pagination
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            productList = pojo.searchProducts(sellerPortId, searchKeyword.trim());
            req.setAttribute("totalPages", 1); // Search shows all results in one page
        } else {
            productList = pojo.getProductsBySeller(sellerPortId, page, PAGE_SIZE);

            // Calculate total pages
            List<ProductPojo> allProducts = pojo.getProductsBySeller(sellerPortId);
            int totalPages = (int) Math.ceil((double) allProducts.size() / PAGE_SIZE);
            req.setAttribute("totalPages", totalPages);
        }

        req.setAttribute("currentPage", page);
        req.setAttribute("productList", productList);
        req.getRequestDispatcher("product.jsp").forward(req, resp);
    }

    // ================= POST : ADD / UPDATE / DELETE =================
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        // Session validation
        if (session == null || session.getAttribute("port_id") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String sellerPortId = (String) session.getAttribute("port_id");
        String action = req.getParameter("action");
        String msg;

        ProductPojo pojo = new ProductPojo();
        pojo.setSellerPortId(sellerPortId);

        try {
            if ("add".equals(action)) {
                // ADD PRODUCT
                pojo.setProductName(req.getParameter("product_name"));
                pojo.setDescription(req.getParameter("description"));
                pojo.setPrice(Double.parseDouble(req.getParameter("price")));
                pojo.setQuantity(Integer.parseInt(req.getParameter("quantity")));
                msg = pojo.addProduct(pojo);

            } else if ("update".equals(action)) {
                // UPDATE PRODUCT (modal)
                pojo.setProductId(Integer.parseInt(req.getParameter("product_id")));
                pojo.setProductName(req.getParameter("product_name"));
                pojo.setDescription(req.getParameter("description"));
                pojo.setPrice(Double.parseDouble(req.getParameter("price")));
                pojo.setQuantity(Integer.parseInt(req.getParameter("quantity")));
                msg = pojo.updateProduct(pojo);

            } else if ("delete".equals(action)) {
                // DELETE PRODUCT
                int productId = Integer.parseInt(req.getParameter("product_id"));
                msg = pojo.deleteProduct(productId);

            } else {
                msg = "Invalid action";
            }
        } catch (Exception e) {
            e.printStackTrace();
            msg = "Error: " + e.getMessage();
        }

        // Reload product list after operation (first page)
        List<ProductPojo> productList = pojo.getProductsBySeller(sellerPortId, 1, PAGE_SIZE);
        List<ProductPojo> allProducts = pojo.getProductsBySeller(sellerPortId);
        int totalPages = (int) Math.ceil((double) allProducts.size() / PAGE_SIZE);

        req.setAttribute("productList", productList);
        req.setAttribute("msg", msg);
        req.setAttribute("currentPage", 1);
        req.setAttribute("totalPages", totalPages);

        req.getRequestDispatcher("product.jsp").forward(req, resp);
    }
}
