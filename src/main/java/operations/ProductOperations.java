package operations;

import model.ProductPojo;
import java.util.List;

public interface ProductOperations {
    String addProduct(ProductPojo pojo);
    String updateProduct(ProductPojo pojo);
    String deleteProduct(int productId);
    List<ProductPojo> getProductsBySeller(String portId);
}
