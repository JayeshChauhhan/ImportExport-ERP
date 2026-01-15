package model;

import operation_implementor.OrderOperationImplementor;
import java.util.List;

public class Order {
    private int orderId;
    private String buyerId;
    private String sellerPortId;
    private int productId;
    private int quantity;
    private double totalAmount;
    private String status;
    private String deliveryAddress;

    // ==================== Getters & Setters ====================
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public String getBuyerId() { return buyerId; }
    public void setBuyerId(String buyerId) { this.buyerId = buyerId; }

    public String getSellerPortId() { return sellerPortId; }
    public void setSellerPortId(String sellerPortId) { this.sellerPortId = sellerPortId; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getDeliveryAddress() { return deliveryAddress; }
    public void setDeliveryAddress(String deliveryAddress) { this.deliveryAddress = deliveryAddress; }

    // ==================== Model Methods ====================
    public String createOrder() {
        return new OrderOperationImplementor().createOrder(this);
    }

    public String updateOrderStatus(int orderId, String status) {
        return new OrderOperationImplementor().updateOrderStatus(orderId, status);
    }

    public String deleteOrder(int orderId) {
        return new OrderOperationImplementor().deleteOrder(orderId);
    }

    public String getStatusByOrderId(int orderId) {
        return new OrderOperationImplementor().getStatusByOrderId(orderId);
    }

    public List<Order> getOrdersBySeller(String sellerPortId) {
        return new OrderOperationImplementor().getOrdersBySeller(sellerPortId);
    }

    public List<Order> getOrdersBySellerAndStatus(String sellerPortId, String status) {
        return new OrderOperationImplementor().getOrdersBySellerAndStatus(sellerPortId, status);
    }

    // ==================== Pagination Methods ====================
    /**
     * Get paginated list of orders for a seller
     * @param sellerPortId Seller's port ID
     * @param offset Offset for SQL LIMIT
     * @param pageSize Number of records per page
     * @return List of orders
     */
    public List<Order> getOrdersBySeller(String sellerPortId, int offset, int pageSize) {
        return new OrderOperationImplementor().getOrdersBySeller(sellerPortId, offset, pageSize);
    }

    /**
     * Get paginated list of orders for a seller filtered by status
     * @param sellerPortId Seller's port ID
     * @param status Order status filter
     * @param offset Offset for SQL LIMIT
     * @param pageSize Number of records per page
     * @return List of orders
     */
    public List<Order> getOrdersBySellerAndStatus(String sellerPortId, String status, int offset, int pageSize) {
        return new OrderOperationImplementor().getOrdersBySellerAndStatus(sellerPortId, status, offset, pageSize);
    }

    /**
     * Get total number of orders for pagination
     */
    public int getTotalOrdersCount(String sellerPortId) {
        return new OrderOperationImplementor().getTotalOrdersCount(sellerPortId);
    }

    public int getTotalOrdersCountByStatus(String sellerPortId, String status) {
        return new OrderOperationImplementor().getTotalOrdersCountByStatus(sellerPortId, status);
    }
}
