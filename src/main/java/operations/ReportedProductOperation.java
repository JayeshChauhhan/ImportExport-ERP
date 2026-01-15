package operations;

import java.util.List;
import model.ReportedProductPojo;

public interface ReportedProductOperation {

    List<ReportedProductPojo> getReportsBySeller(String sellerPortId);

    String update(ReportedProductPojo p);

    String delete(int reportId);
    
}
