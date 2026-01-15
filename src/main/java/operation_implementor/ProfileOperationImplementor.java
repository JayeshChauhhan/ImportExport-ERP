package operation_implementor;

import java.sql.*;
import db_config.GetConnection;
import model.ProfilePojo;
import operations.ProfileOperations;

public class ProfileOperationImplementor implements ProfileOperations {

    @Override
    public ProfilePojo view(String port_id) {
        ProfilePojo pojo = null;
        try (Connection con = GetConnection.getConnection()) {
            PreparedStatement ps =
                    con.prepareStatement("SELECT * FROM users WHERE port_id=?");
            ps.setString(1, port_id);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                pojo = new ProfilePojo();
                pojo.setPort_id(rs.getString("port_id"));
                pojo.setName(rs.getString("name"));
                pojo.setEmail(rs.getString("email"));
                pojo.setLocation(rs.getString("location"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return pojo;
    }

    @Override
    public String update(ProfilePojo pojo) {
        try (Connection con = GetConnection.getConnection()) {

            PreparedStatement check =
                    con.prepareStatement(
                            "SELECT port_id FROM users WHERE email=? AND port_id<>?"
                    );
            check.setString(1, pojo.getEmail());
            check.setString(2, pojo.getPort_id());

            if (check.executeQuery().next()) {
                return "Email already exists!";
            }

            CallableStatement cs =
                    con.prepareCall("{CALL sp_update_profile(?,?,?,?,?)}");

            cs.setString(1, pojo.getPort_id());
            cs.setString(2, pojo.getPassword());
            cs.setString(3, pojo.getName());
            cs.setString(4, pojo.getEmail());
            cs.setString(5, pojo.getLocation());

            cs.executeUpdate();
            return "Profile Updated Successfully";

        } catch (Exception e) {
            e.printStackTrace();
            return "Error updating profile!";
        }
    }

    @Override
    public String delete(String port_id, String password) {
        try (Connection con = GetConnection.getConnection()) {

            CallableStatement cs =
                    con.prepareCall("{CALL sp_delete_profile(?,?)}");
            cs.setString(1, port_id);
            cs.setString(2, password);

            ResultSet rs = cs.executeQuery();
            if (rs.next()) {
                return rs.getString("status");
            }

        } catch (SQLIntegrityConstraintViolationException fkEx) {
            // FK constraint violation: user has products/orders/reports
            return "Cannot delete account! Please delete your products, orders, and reports first.";
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "Error deleting account!";
    }

    @Override
    public String updatePassword(String port_id, String current, String newPassword) {
        try (Connection con = GetConnection.getConnection()) {

            PreparedStatement ps =
                    con.prepareStatement(
                            "SELECT password FROM users WHERE port_id=? AND password=SHA2(?,256)"
                    );
            ps.setString(1, port_id);
            ps.setString(2, current);

            if (!ps.executeQuery().next()) {
                return "Your current password is wrong!";
            }

            PreparedStatement upd =
                    con.prepareStatement(
                            "UPDATE users SET password=SHA2(?,256) WHERE port_id=?"
                    );
            upd.setString(1, newPassword);
            upd.setString(2, port_id);
            upd.executeUpdate();

            return "Password updated successfully";

        } catch (Exception e) {
            e.printStackTrace();
            return "Error updating password!";
        }
    }
}
