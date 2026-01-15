package model;

import operation_implementor.ProfileOperationImplementor;
import operations.ProfileOperations;

public class ProfileModel {

    private ProfileOperations ops = new ProfileOperationImplementor();

    public ProfilePojo viewProfile(String port_id) {
        return ops.view(port_id);
    }

    public String updateProfile(ProfilePojo pojo) {
        return ops.update(pojo);
    }

    public String changePassword(String port_id,
                                 String current,
                                 String newPassword) {
        return ops.updatePassword(port_id, current, newPassword);
    }

    public String deleteAccount(String port_id, String password) {
        return ops.delete(port_id, password);
    }
}
