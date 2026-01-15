package operations;

import model.Order;
import java.util.List;

public interface OrderOperations {
    String createOrder(Order order);
    String updateOrderStatus(int orderId, String status);
    String deleteOrder(int orderId);
    String getStatusByOrderId(int orderId);
    List<Order> getOrdersBySeller(String sellerPortId);
    List<Order> getOrdersBySellerAndStatus(String sellerPortId, String status);
}
