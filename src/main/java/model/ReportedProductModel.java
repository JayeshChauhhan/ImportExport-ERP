package model;

import java.util.List;

import operation_implementor.ReportedProductOperationImplementor;
import operations.ReportedProductOperation;

public class ReportedProductModel {

    private ReportedProductOperation operation =
            new ReportedProductOperationImplementor();

    // Normal fetch
    public List<ReportedProductPojo> getReportsForSeller(String sellerPortId) {
        return operation.getReportsBySeller(sellerPortId);
    }

    // Pagination only
    public List<ReportedProductPojo> getReportsForSellerPaginated(
            String sellerPortId, int start, int recordsPerPage) {

        return ((ReportedProductOperationImplementor) operation)
                .getReportsBySellerPaginated(
                        sellerPortId, start, recordsPerPage);
    }

    // Search + Filter + Pagination
    public List<ReportedProductPojo> searchReports(
            String sellerPortId,
            Integer reportId,
            Integer productId,
            String status,
            int start,
            int recordsPerPage) {

        return ((ReportedProductOperationImplementor) operation)
                .searchReports(
                        sellerPortId,
                        reportId,
                        productId,
                        status,
                        start,
                        recordsPerPage);
    }

    // Search count
    public int getSearchReportsCount(
            String sellerPortId,
            Integer reportId,
            Integer productId,
            String status) {

        return ((ReportedProductOperationImplementor) operation)
                .getSearchReportsCount(
                        sellerPortId,
                        reportId,
                        productId,
                        status);
    }
    

    // Update
    public String update(ReportedProductPojo p) {
        return operation.update(p);
    }

    // Delete
    public String delete(int reportId) {
        return operation.delete(reportId);
    }
}
