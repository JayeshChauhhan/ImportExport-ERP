package operation_implementor;

import model.Order;
import db_config.GetConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderOperationImplementor {

    // ===================== Existing Methods =====================

    public String createOrder(Order order) {
        String msg = "";
        try (Connection con = GetConnection.getConnection()) {
            CallableStatement cs = con.prepareCall("{CALL sp_create_order(?,?,?,?,?)}");
            cs.setString(1, order.getBuyerId());
            cs.setString(2, order.getSellerPortId());
            cs.setInt(3, order.getProductId());
            cs.setInt(4, order.getQuantity());
            cs.setString(5, order.getDeliveryAddress());
            cs.executeUpdate();
            msg = "Order created successfully";
        } catch (SQLException e) {
            msg = "Error creating order: " + e.getMessage();
        }
        return msg;
    }

    public String updateOrderStatus(int orderId, String status) {
        String msg = "";
        try (Connection con = GetConnection.getConnection()) {
            CallableStatement cs = con.prepareCall("{CALL update_order_status(?,?)}");
            cs.setInt(1, orderId);
            cs.setString(2, status);
            cs.executeUpdate();
            msg = "Order status updated successfully";
        } catch (SQLException e) {
            msg = "Error updating status: " + e.getMessage();
        }
        return msg;
    }

    public String deleteOrder(int orderId) {
        String msg = "";
        try (Connection con = GetConnection.getConnection()) {
            CallableStatement cs = con.prepareCall("{CALL sp_delete_order(?)}");
            cs.setInt(1, orderId);
            cs.executeUpdate();
            msg = "Order deleted successfully";
        } catch (SQLException e) {
            msg = "Error deleting order: " + e.getMessage();
        }
        return msg;
    }

    public String getStatusByOrderId(int orderId) {
        String status = "pending";
        try (Connection con = GetConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("SELECT status FROM orders WHERE order_id=?");
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) status = rs.getString("status");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return status;
    }

    public List<Order> getOrdersBySeller(String sellerPortId) {
        List<Order> list = new ArrayList<>();
        try (Connection con = GetConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                    "SELECT * FROM orders WHERE seller_port_id=? ORDER BY order_date DESC");
            ps.setString(1, sellerPortId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Order> getOrdersBySellerAndStatus(String sellerPortId, String status) {
        List<Order> list = new ArrayList<>();
        try (Connection con = GetConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                    "SELECT * FROM orders WHERE seller_port_id=? AND status=? ORDER BY order_date DESC");
            ps.setString(1, sellerPortId);
            ps.setString(2, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ===================== Pagination Methods =====================

    public List<Order> getOrdersBySeller(String sellerPortId, int offset, int pageSize) {
        List<Order> list = new ArrayList<>();
        try (Connection con = GetConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                    "SELECT * FROM orders WHERE seller_port_id=? ORDER BY order_date DESC LIMIT ?, ?");
            ps.setString(1, sellerPortId);
            ps.setInt(2, offset);
            ps.setInt(3, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Order> getOrdersBySellerAndStatus(String sellerPortId, String status, int offset, int pageSize) {
        List<Order> list = new ArrayList<>();
        try (Connection con = GetConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                    "SELECT * FROM orders WHERE seller_port_id=? AND status=? ORDER BY order_date DESC LIMIT ?, ?");
            ps.setString(1, sellerPortId);
            ps.setString(2, status);
            ps.setInt(3, offset);
            ps.setInt(4, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ===================== Total Count Methods =====================

    public int getTotalOrdersCount(String sellerPortId) {
        int count = 0;
        try (Connection con = GetConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) AS total FROM orders WHERE seller_port_id=?");
            ps.setString(1, sellerPortId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt("total");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public int getTotalOrdersCountByStatus(String sellerPortId, String status) {
        int count = 0;
        try (Connection con = GetConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) AS total FROM orders WHERE seller_port_id=? AND status=?");
            ps.setString(1, sellerPortId);
            ps.setString(2, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt("total");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    // ===================== Helper =====================
    private Order mapOrder(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setOrderId(rs.getInt("order_id"));
        o.setBuyerId(rs.getString("buyer_id"));
        o.setSellerPortId(rs.getString("seller_port_id"));
        o.setProductId(rs.getInt("product_id"));
        o.setQuantity(rs.getInt("quantity"));
        o.setTotalAmount(rs.getDouble("total_amount"));
        o.setStatus(rs.getString("status"));
        o.setDeliveryAddress(rs.getString("delivery_address"));
        return o;
    }
}
