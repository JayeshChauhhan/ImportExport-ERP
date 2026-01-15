package controller;

import model.Order;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/OrderController")
public class OrderController extends HttpServlet {

    private static final int PAGE_SIZE = 8; // number of orders per page

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("port_id") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String sellerPortId = (String) session.getAttribute("port_id");
        String statusFilter = req.getParameter("status");
        String searchQuery = req.getParameter("query"); // Search parameter
        String pageParam = req.getParameter("page");

        int currentPage = 1;
        try {
            if (pageParam != null) currentPage = Integer.parseInt(pageParam);
        } catch (NumberFormatException e) {
            currentPage = 1;
        }

        int offset = (currentPage - 1) * PAGE_SIZE;

        Order orderModel = new Order();
        List<Order> orderList;
        int totalRecords = 0;

        // Apply status filter
        if (statusFilter == null || statusFilter.isEmpty()) {
            orderList = orderModel.getOrdersBySeller(sellerPortId, offset, PAGE_SIZE);
            totalRecords = orderModel.getTotalOrdersCount(sellerPortId);
        } else {
            orderList = orderModel.getOrdersBySellerAndStatus(sellerPortId, statusFilter, offset, PAGE_SIZE);
            totalRecords = orderModel.getTotalOrdersCountByStatus(sellerPortId, statusFilter);
        }

        // Filter by search query (Order ID)
        if (searchQuery != null && !searchQuery.isEmpty()) {
            try {
                int searchOrderId = Integer.parseInt(searchQuery);
                orderList = orderList.stream()
                        .filter(o -> o.getOrderId() == searchOrderId)
                        .collect(Collectors.toList());
                totalRecords = orderList.size();
            } catch (NumberFormatException e) {
                orderList = List.of();
                totalRecords = 0;
            }
        }

        int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);

        req.setAttribute("orderList", orderList);
        req.setAttribute("currentPage", currentPage);
        req.setAttribute("totalPages", totalPages);

        req.getRequestDispatcher("orders.jsp").forward(req, resp);
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
        String msg = "";

        Order orderModel = new Order();

        try {
            if ("create".equals(action)) {
                orderModel.setBuyerId(req.getParameter("buyer_id"));
                orderModel.setSellerPortId(sellerPortId);
                orderModel.setProductId(Integer.parseInt(req.getParameter("product_id")));
                orderModel.setQuantity(Integer.parseInt(req.getParameter("quantity")));
                orderModel.setDeliveryAddress(req.getParameter("delivery_address"));

                msg = orderModel.createOrder();

            } else if ("update".equals(action)) {

                int orderId = Integer.parseInt(req.getParameter("order_id"));
                String newStatus = req.getParameter("new_status"); // <-- only change

                String currentStatus = orderModel.getStatusByOrderId(orderId);

                if ("delivered".equalsIgnoreCase(currentStatus)
                        || "cancelled".equalsIgnoreCase(currentStatus)) {
                    msg = "Delivered or cancelled orders cannot be updated";
                } else {
                    msg = orderModel.updateOrderStatus(orderId, newStatus);
                }

            } else if ("delete".equals(action)) {

                int orderId = Integer.parseInt(req.getParameter("order_id"));
                msg = orderModel.deleteOrder(orderId);
            }

        } catch (Exception e) {
            e.printStackTrace();
            msg = "Something went wrong while processing the request";
        }

        req.setAttribute("msg", msg);

        // Reload orders with pagination after POST
        String pageParam = req.getParameter("page");
        int currentPage = 1;
        try {
            if (pageParam != null) currentPage = Integer.parseInt(pageParam);
        } catch (NumberFormatException e) {
            currentPage = 1;
        }

        int offset = (currentPage - 1) * PAGE_SIZE;

        String statusFilter = req.getParameter("status"); // <-- use filter, not new_status
        String query = req.getParameter("query");

        List<Order> orderList;
        int totalRecords;

        if (statusFilter == null || statusFilter.isEmpty()) {
            orderList = orderModel.getOrdersBySeller(sellerPortId, offset, PAGE_SIZE);
            totalRecords = orderModel.getTotalOrdersCount(sellerPortId);
        } else {
            orderList = orderModel.getOrdersBySellerAndStatus(sellerPortId, statusFilter, offset, PAGE_SIZE);
            totalRecords = orderModel.getTotalOrdersCountByStatus(sellerPortId, statusFilter);
        }

        int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);

        req.setAttribute("orderList", orderList);
        req.setAttribute("currentPage", currentPage);
        req.setAttribute("totalPages", totalPages);

        req.getRequestDispatcher("orders.jsp").forward(req, resp);
    }
}
