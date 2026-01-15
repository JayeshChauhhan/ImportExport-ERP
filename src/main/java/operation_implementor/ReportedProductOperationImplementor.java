package operation_implementor;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import model.ReportedProductPojo;
import operations.ReportedProductOperation;
import db_config.GetConnection;

public class ReportedProductOperationImplementor
        implements ReportedProductOperation {

    /* ================================
       NORMAL FETCH (NO PAGINATION)
       ================================ */
    @Override
    public List<ReportedProductPojo> getReportsBySeller(String sellerPortId) {

        List<ReportedProductPojo> list = new ArrayList<>();

        String sql =
            "SELECT rp.report_id, rp.product_id, p.product_name, " +
            "rp.reporter_id, rp.reason, rp.reported_at, rp.status " +
            "FROM reported_products rp " +
            "JOIN product p ON rp.product_id = p.product_id " +
            "WHERE p.seller_port_id = ? " +
            "ORDER BY rp.reported_at DESC";

        try (
            Connection con = GetConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setString(1, sellerPortId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ReportedProductPojo r = mapRow(rs);
                list.add(r);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /* ================================
       PAGINATION ONLY
       ================================ */
    public List<ReportedProductPojo> getReportsBySellerPaginated(
            String sellerPortId, int start, int recordsPerPage) {

        List<ReportedProductPojo> list = new ArrayList<>();

        String sql =
            "SELECT rp.report_id, rp.product_id, p.product_name, " +
            "rp.reporter_id, rp.reason, rp.reported_at, rp.status " +
            "FROM reported_products rp " +
            "JOIN product p ON rp.product_id = p.product_id " +
            "WHERE p.seller_port_id = ? " +
            "ORDER BY rp.reported_at DESC " +
            "LIMIT ? OFFSET ?";

        try (
            Connection con = GetConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setString(1, sellerPortId);
            ps.setInt(2, recordsPerPage);
            ps.setInt(3, start);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ReportedProductPojo r = mapRow(rs);
                list.add(r);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /* ================================
       SEARCH + FILTER + PAGINATION
       ================================ */
    public List<ReportedProductPojo> searchReports(
            String sellerPortId,
            Integer reportId,
            Integer productId,
            String status,
            int start,
            int recordsPerPage) {

        List<ReportedProductPojo> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
            "SELECT rp.report_id, rp.product_id, p.product_name, " +
            "rp.reporter_id, rp.reason, rp.reported_at, rp.status " +
            "FROM reported_products rp " +
            "JOIN product p ON rp.product_id = p.product_id " +
            "WHERE p.seller_port_id = ? "
        );

        if (reportId != null) sql.append("AND rp.report_id = ? ");
        if (productId != null) sql.append("AND rp.product_id = ? ");
        if (status != null && !"All".equalsIgnoreCase(status))
            sql.append("AND rp.status = ? ");

        sql.append("ORDER BY rp.reported_at DESC LIMIT ? OFFSET ?");

        try (
            Connection con = GetConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql.toString())
        ) {

            int i = 1;
            ps.setString(i++, sellerPortId);

            if (reportId != null) ps.setInt(i++, reportId);
            if (productId != null) ps.setInt(i++, productId);
            if (status != null && !"All".equalsIgnoreCase(status))
                ps.setString(i++, status);

            ps.setInt(i++, recordsPerPage);
            ps.setInt(i, start);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ReportedProductPojo r = mapRow(rs);
                list.add(r);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /* ================================
       SEARCH COUNT (FOR PAGINATION)
       ================================ */
    public int getSearchReportsCount(
            String sellerPortId,
            Integer reportId,
            Integer productId,
            String status) {

        int count = 0;

        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) " +
            "FROM reported_products rp " +
            "JOIN product p ON rp.product_id = p.product_id " +
            "WHERE p.seller_port_id = ? "
        );

        if (reportId != null) sql.append("AND rp.report_id = ? ");
        if (productId != null) sql.append("AND rp.product_id = ? ");
        if (status != null && !"All".equalsIgnoreCase(status))
            sql.append("AND rp.status = ? ");

        try (
            Connection con = GetConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql.toString())
        ) {

            int i = 1;
            ps.setString(i++, sellerPortId);

            if (reportId != null) ps.setInt(i++, reportId);
            if (productId != null) ps.setInt(i++, productId);
            if (status != null && !"All".equalsIgnoreCase(status))
                ps.setString(i++, status);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    /* ================================
       UPDATE
       ================================ */
    @Override
    public String update(ReportedProductPojo p) {

        String sql =
            "UPDATE reported_products SET status=? WHERE report_id=?";

        try (
            Connection con = GetConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setString(1, p.getStatus());
            ps.setInt(2, p.getReportId());
            return ps.executeUpdate() > 0
                    ? "Updated successfully"
                    : "Update failed";

        } catch (Exception e) {
            e.printStackTrace();
            return "Error while updating";
        }
    }

    /* ================================
       DELETE
       ================================ */
    @Override
    public String delete(int reportId) {

        String sql =
            "DELETE FROM reported_products WHERE report_id=?";

        try (
            Connection con = GetConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setInt(1, reportId);
            return ps.executeUpdate() > 0
                    ? "Deleted successfully"
                    : "Delete failed";

        } catch (Exception e) {
            e.printStackTrace();
            return "Error while deleting";
        }
    }
    

    /* ================================
       COMMON ROW MAPPER
       ================================ */
    private ReportedProductPojo mapRow(ResultSet rs) throws SQLException {

        ReportedProductPojo r = new ReportedProductPojo();
        r.setReportId(rs.getInt("report_id"));
        r.setProductId(rs.getInt("product_id"));
        r.setProductName(rs.getString("product_name"));
        r.setReporterId(rs.getString("reporter_id"));
        r.setReason(rs.getString("reason"));
        r.setReportedAt(rs.getString("reported_at"));
        r.setStatus(rs.getString("status"));
        return r;
    }
}
