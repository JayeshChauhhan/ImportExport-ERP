package model;

import java.util.List;
import operation_implementor.ProductOperationImplementor;

public class ProductPojo {

    private int productId;
    private String productName;
    private String description;
    private double price;
    private int quantity;
    private String sellerPortId;

    // ================= GETTERS & SETTERS =================
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getSellerPortId() { return sellerPortId; }
    public void setSellerPortId(String sellerPortId) { this.sellerPortId = sellerPortId; }

    // ================= MODEL → DAO BRIDGE =================

    public String addProduct(ProductPojo pojo) {
        return new ProductOperationImplementor().addProduct(pojo);
    }

    public String updateProduct(ProductPojo pojo) {
        return new ProductOperationImplementor().updateProduct(pojo);
    }

    public String deleteProduct(int productId) {
        return new ProductOperationImplementor().deleteProduct(productId);
    }

    // Existing method
    public List<ProductPojo> getProductsBySeller(String sellerPortId) {
        return new ProductOperationImplementor().getProductsBySeller(sellerPortId);
    }

    // ================= PAGINATION VERSION =================
    public List<ProductPojo> getProductsBySeller(String sellerPortId, int page, int pageSize) {
        return new ProductOperationImplementor().getProductsBySeller(sellerPortId, page, pageSize);
    }

    public List<ProductPojo> searchProducts(String sellerPortId, String keyword) {
        return new ProductOperationImplementor().searchProducts(sellerPortId, keyword);
    }
}
