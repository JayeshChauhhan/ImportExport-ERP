package operation_implementor;

import model.ProductPojo;
import db_config.GetConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductOperationImplementor {

    // ================= ADD =================
    public String addProduct(ProductPojo pojo) {
        try (Connection con = GetConnection.getConnection()) {
            CallableStatement cs = con.prepareCall("{CALL add_product(?,?,?,?,?)}");
            cs.setString(1, pojo.getSellerPortId());
            cs.setString(2, pojo.getProductName());
            cs.setString(3, pojo.getDescription());
            cs.setInt(4, pojo.getQuantity());
            cs.setDouble(5, pojo.getPrice());
            ResultSet rs = cs.executeQuery();
            if (rs.next()) return rs.getString("message");
        } catch (Exception e) { e.printStackTrace(); }
        return "Error adding product";
    }

    // ================= UPDATE =================
    public String updateProduct(ProductPojo pojo) {
        try (Connection con = GetConnection.getConnection()) {
            CallableStatement cs = con.prepareCall("{CALL update_product(?,?,?,?,?,?)}");
            cs.setInt(1, pojo.getProductId());
            cs.setString(2, pojo.getSellerPortId());
            cs.setString(3, pojo.getProductName());
            cs.setString(4, pojo.getDescription());
            cs.setInt(5, pojo.getQuantity());
            cs.setDouble(6, pojo.getPrice());
            ResultSet rs = cs.executeQuery();
            if (rs.next()) return rs.getString("message");
        } catch (Exception e) { e.printStackTrace(); }
        return "Error updating product";
    }

    // ================= DELETE =================
    public String deleteProduct(int productId) {
        try (Connection con = GetConnection.getConnection()) {
            CallableStatement cs = con.prepareCall("{CALL delete_product(?)}");
            cs.setInt(1, productId);
            ResultSet rs = cs.executeQuery();
            if (rs.next()) return rs.getString("message");
        } catch (Exception e) { e.printStackTrace(); }
        return "Error deleting product";
    }

    // ================= GET PRODUCTS BY SELLER =================
    public List<ProductPojo> getProductsBySeller(String sellerPortId) {
        List<ProductPojo> list = new ArrayList<>();
        String sql = "SELECT * FROM product WHERE seller_port_id = ?";
        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, sellerPortId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductPojo p = new ProductPojo();
                p.setProductId(rs.getInt("product_id"));
                p.setProductName(rs.getString("product_name"));
                p.setDescription(rs.getString("description"));
                p.setPrice(rs.getDouble("price"));
                p.setQuantity(rs.getInt("quantity"));
                p.setSellerPortId(rs.getString("seller_port_id"));
                list.add(p);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // ================= GET PRODUCTS BY SELLER WITH PAGINATION =================
    public List<ProductPojo> getProductsBySeller(String sellerPortId, int page, int pageSize) {
        List<ProductPojo> list = new ArrayList<>();
        String sql = "SELECT * FROM product WHERE seller_port_id = ? ORDER BY product_id LIMIT ? OFFSET ?";
        int offset = (page - 1) * pageSize;
        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, sellerPortId);
            ps.setInt(2, pageSize);
            ps.setInt(3, offset);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductPojo p = new ProductPojo();
                p.setProductId(rs.getInt("product_id"));
                p.setProductName(rs.getString("product_name"));
                p.setDescription(rs.getString("description"));
                p.setPrice(rs.getDouble("price"));
                p.setQuantity(rs.getInt("quantity"));
                p.setSellerPortId(rs.getString("seller_port_id"));
                list.add(p);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // ================= SEARCH PRODUCTS =================
    public List<ProductPojo> searchProducts(String sellerPortId, String keyword) {
        List<ProductPojo> list = new ArrayList<>();
        String sql = "SELECT * FROM product WHERE seller_port_id = ? AND " +
                     "(product_id LIKE ? OR product_name LIKE ?)";
        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, sellerPortId);
            ps.setString(2, "%" + keyword + "%");
            ps.setString(3, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductPojo p = new ProductPojo();
                p.setProductId(rs.getInt("product_id"));
                p.setProductName(rs.getString("product_name"));
                p.setDescription(rs.getString("description"));
                p.setPrice(rs.getDouble("price"));
                p.setQuantity(rs.getInt("quantity"));
                p.setSellerPortId(rs.getString("seller_port_id"));
                list.add(p);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}
