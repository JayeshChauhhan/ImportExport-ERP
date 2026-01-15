package operations;

import model.ProfilePojo;

public interface ProfileOperations {

    ProfilePojo view(String port_id);

    String update(ProfilePojo pojo);

    String delete(String port_id, String password);

    String updatePassword(String port_id, String current, String newPassword);
}
