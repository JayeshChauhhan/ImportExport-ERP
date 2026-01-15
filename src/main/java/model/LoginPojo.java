package model;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import db_config.GetConnection;

public class LoginPojo {

    private String port_id;
    private String password;

    public String getPort_id() { return port_id; }
    public void setPort_id(String port_id) { this.port_id = port_id; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    // Login method
    public String login() {
        String status = "Login Failed";
        try (Connection con = GetConnection.getConnection()) {

            if (con == null) return "Database connection failed!";

            CallableStatement cs = con.prepareCall("{call sp_user_login(?, ?)}");
            cs.setString(1, port_id);
            cs.setString(2, password);

            ResultSet rs = cs.executeQuery();
            if (rs.next()) {
                status = rs.getString("status");
            }

            rs.close();
            cs.close();

        } catch (Exception e) {
            e.printStackTrace();
            status = "Database error!";
        }

        return status;
    }
}
