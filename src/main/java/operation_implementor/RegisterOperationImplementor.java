package operation_implementor;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;

import db_config.GetConnection;
import model.RegisterPojo;
import operations.RegisterOperations;

public class RegisterOperationImplementor implements RegisterOperations {

    @Override
    public String register(RegisterPojo pojo) {
        String status = "FAILED";
        try {
            Connection con = GetConnection.getConnection();

            CallableStatement cs =
                con.prepareCall("{CALL sp_add_profile(?,?,?,?,?)}");

            cs.setString(1, pojo.getPort_id());
            cs.setString(2, pojo.getPassword());
            cs.setString(3, pojo.getName());
            cs.setString(4, pojo.getEmail());
            cs.setString(5, pojo.getLocation());

            ResultSet rs = cs.executeQuery();
            if (rs.next()) {
                status = rs.getString("status");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }
}
