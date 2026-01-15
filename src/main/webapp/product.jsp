<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.ProductPojo" %>

<%
    String userName = (String) session.getAttribute("userName");
    if(userName == null) userName = "User";

    String pageTitle = "Product Management";

    int currentPage = request.getAttribute("currentPage") != null ?
                      (Integer)request.getAttribute("currentPage") : 1;
    int totalPages = request.getAttribute("totalPages") != null ?
                     (Integer)request.getAttribute("totalPages") : 1;
    String searchQuery = request.getParameter("search") != null ? request.getParameter("search") : "";
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title><%= pageTitle %> | Import Export ERP</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

<style>
:root{
    --primary:#2563eb;
    --accent:#06b6d4;
    --bg1:#e0f2fe;
    --bg2:#f0f9ff;
    --text-dark:#0f172a;
}
body{
    background:linear-gradient(135deg,var(--bg1),var(--bg2));
    font-family:"Inter","Segoe UI",sans-serif;
    padding-top:110px;
    padding-bottom:90px;
}
/* NAVBAR */
.navbar{
    background:rgba(255,255,255,.75);
    backdrop-filter:blur(14px);
    border-bottom:1px solid rgba(0,0,0,.08);
}
.navbar-brand{ font-weight:800; font-size:1.3rem; color:var(--text-dark)!important; }
.navbar-nav{ margin:0 auto; }
.nav-link{ color:#334155!important; font-weight:500; margin:0 12px; position:relative; }
.nav-link.active{ color:var(--primary)!important; font-weight:700; }
.nav-link::after{ content:""; position:absolute; left:0; bottom:-6px; width:0; height:2px; background:var(--primary); transition:.3s; }
.nav-link:hover::after, .nav-link.active::after{ width:100%; }
/* PAGE TITLE */
.page-title{ font-size:1.9rem; font-weight:700; text-align:center; margin-bottom:20px; }
/* CARD */
.card{ background:rgba(255,255,255,.85); backdrop-filter:blur(16px); border:none; border-radius:20px; box-shadow:0 30px 60px rgba(0,0,0,.12); padding:2.5rem; }
/* SEARCH */
.search-box{ max-width:360px; margin-bottom:12px; }
/* SECTION TITLE */
.section-title{ font-weight:600; color:#334155; margin-bottom:14px; }
/* TABLE */
.table-glass th{ background:linear-gradient(135deg,var(--primary),var(--accent)); color:#fff; font-weight:600; text-align:center; }
.table-glass td{ text-align:center; vertical-align:middle; color:var(--text-dark); }
/* BUTTONS */
.btn-theme, .btn-update{ background:linear-gradient(135deg,var(--primary),var(--accent)); color:#fff; border:none; font-weight:600; }
.btn-delete{ background:linear-gradient(135deg,#ef4444,#b91c1c); color:#fff; border:none; }
.actions-container{ display:flex; gap:8px; justify-content:center; }
/* FOOTER */
footer{ background:rgba(255,255,255,.75); backdrop-filter:blur(12px); text-align:center; padding:14px 0; position:fixed; bottom:0; width:100%; }
/* MODAL INPUTS */
.modal-body label{ font-weight:600; margin-top:8px; }
.modal-body input, .modal-body textarea{ margin-bottom:12px; }
/* PAGINATION (Order Page Style) */
.pagination .page-item .page-link{
    border-radius:12px;
    padding:6px 14px;
    margin:0 3px;
    font-weight:500;
    border:none;
    color:#334155;
    background:#fff;
    box-shadow:0 2px 6px rgba(0,0,0,0.08);
    transition:0.3s;
}
.pagination .page-item.active .page-link{
    background:linear-gradient(135deg,var(--primary),var(--accent));
    color:#fff;
    font-weight:600;
    box-shadow:0 4px 12px rgba(0,0,0,0.18);
}
.pagination .page-item.disabled .page-link{
    opacity:0.5;
    cursor:not-allowed;
}
.pagination .page-item:hover:not(.active) .page-link{
    background:var(--accent);
    color:#fff;
}
</style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg fixed-top">
<div class="container">
    <a class="navbar-brand" href="home.jsp">🌐 Import Export ERP</a>
    <ul class="navbar-nav">
        <li class="nav-item"><a class="nav-link" href="home.jsp">Home</a></li>
        <li class="nav-item"><a class="nav-link active" href="ProductController">Products</a></li>
        <li class="nav-item"><a class="nav-link" href="OrderController">Orders</a></li>
        <li class="nav-item"><a class="nav-link" href="ReportController">Reported Products</a></li>
    </ul>
    <ul class="navbar-nav ms-auto">
        <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">Profile</a>
            <ul class="dropdown-menu dropdown-menu-end">
                <li><a class="dropdown-item" href="ProfileController">View Profile</a></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item text-danger" href="login.jsp">Logout</a></li>
            </ul>
        </li>
    </ul>
</div>
</nav>

<!-- TITLE -->
<div class="page-title"><i class="bi bi-box-seam"></i> <%= pageTitle %></div>

<!-- MAIN -->
<div class="container">
<div class="card">

    <!-- SEARCH -->
    <form action="ProductController" method="get" class="search-box">
        <div class="input-group">
            <input type="text" name="search" class="form-control" placeholder="Search by Product ID or Name" value="<%= searchQuery %>">
            <button class="btn btn-theme">Search</button>
        </div>
    </form>

    <!-- MESSAGE -->
    <%
        String msg = (String) request.getAttribute("msg");
        if(msg != null){
    %>
    <div id="alertBox" class="alert alert-info text-center mt-2"><%= msg %></div>
    <% } %>

    <!-- ADD TITLE -->
    <div class="section-title mt-3"> Add Products</div>

    <!-- ADD PRODUCT FORM -->
    <form action="ProductController" method="post" class="row g-3 mb-4">
        <input type="hidden" name="action" value="add">
        <div class="col-md-4">
            <input name="product_name" class="form-control" placeholder="Product Name" required>
        </div>
        <div class="col-md-4">
            <input name="price" type="number" step="0.01" class="form-control" placeholder="Price (₹)" required>
        </div>
        <div class="col-md-4">
            <input name="quantity" type="number" class="form-control" placeholder="Stock Quantity" required>
        </div>
        <div class="col-12">
            <textarea name="description" class="form-control" placeholder="Description" required></textarea>
        </div>
        <div class="col-12 text-end"><button class="btn btn-theme">Add Product</button></div>
    </form>

    <!-- PRODUCTS TABLE -->
    <div class="table-responsive">
        <table class="table table-glass align-middle">
            <thead>
                <tr>
                    <th>ID</th><th>Name</th><th>Description</th>
                    <th>Price</th><th>Stock</th><th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <%
                List<ProductPojo> products = (List<ProductPojo>) request.getAttribute("productList");
                if(products != null && !products.isEmpty()){
                    for(ProductPojo p : products){
            %>
            <tr>
                <td><%= p.getProductId() %></td>
                <td><%= p.getProductName() %></td>
                <td><%= p.getDescription() %></td>
                <td>₹ <%= p.getPrice() %></td>
                <td><%= p.getQuantity() %></td>
                <td>
                    <div class="actions-container">
                        <button class="btn btn-update btn-sm" 
                                data-bs-toggle="modal" 
                                data-bs-target="#updateModal"
                                data-id="<%=p.getProductId()%>"
                                data-name="<%=p.getProductName()%>"
                                data-desc="<%=p.getDescription()%>"
                                data-price="<%=p.getPrice()%>"
                                data-qty="<%=p.getQuantity()%>">
                            Update
                        </button>
                        <form action="ProductController" method="post" onsubmit="return confirmDelete();">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="product_id" value="<%=p.getProductId()%>">
                            <button class="btn btn-delete btn-sm">Delete</button>
                        </form>
                    </div>
                </td>
            </tr>
            <% } } else { %>
            <tr><td colspan="6">No products found</td></tr>
            <% } %>
            </tbody>
        </table>
    </div>

  

</div>
</div>
 <!-- PAGINATION (Order Page Style) -->
    <% if(totalPages > 1){ %>
    <nav aria-label="Page navigation" class="mt-3">
        <ul class="pagination justify-content-center">
            <li class="page-item <%= currentPage == 1 ? "disabled" : "" %>">
                <a class="page-link" href="ProductController?page=1&search=<%=searchQuery%>"><i class="bi bi-chevron-double-left"></i></a>
            </li>
            <li class="page-item <%= currentPage == 1 ? "disabled" : "" %>">
                <a class="page-link" href="ProductController?page=<%=currentPage-1%>&search=<%=searchQuery%>"><i class="bi bi-chevron-left"></i> Prev</a>
            </li>

            <% for(int i = 1; i <= totalPages; i++){ %>
                <li class="page-item <%= i == currentPage ? "active" : "" %>">
                    <a class="page-link" href="ProductController?page=<%=i%>&search=<%=searchQuery%>"><%=i%></a>
                </li>
            <% } %>

            <li class="page-item <%= currentPage == totalPages ? "disabled" : "" %>">
                <a class="page-link" href="ProductController?page=<%=currentPage+1%>&search=<%=searchQuery%>">Next <i class="bi bi-chevron-right"></i></a>
            </li>
            <li class="page-item <%= currentPage == totalPages ? "disabled" : "" %>">
                <a class="page-link" href="ProductController?page=<%=totalPages%>&search=<%=searchQuery%>"><i class="bi bi-chevron-double-right"></i></a>
            </li>
        </ul>
    </nav>
    <% } %>

<!-- UPDATE MODAL WITH LABELS -->
<div class="modal fade" id="updateModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <form action="ProductController" method="post" class="modal-content">
      <input type="hidden" name="action" value="update">
      <input type="hidden" name="product_id" id="modalProductId">
      <div class="modal-header">
        <h5 class="modal-title">Update Product</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <label>Product Name</label>
        <input type="text" id="modalProductName" name="product_name" class="form-control" required>

        <label>Description</label>
        <textarea id="modalDescription" name="description" class="form-control" required></textarea>

        <label>Price (₹)</label>
        <input type="number" id="modalPrice" name="price" step="0.01" class="form-control" required>

        <label>Stock Quantity</label>
        <input type="number" id="modalQty" name="quantity" class="form-control" required>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
        <button type="submit" class="btn btn-theme">Update</button>
      </div>
    </form>
  </div>
</div>

<footer>© 2025 Import Export ERP System</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
// Auto-dismiss alert
setTimeout(() => {
    const alert = document.getElementById("alertBox");
    if(alert){ alert.style.opacity = "0"; setTimeout(() => alert.remove(), 500); }
}, 2500);

// Populate modal with product data
const updateModal = document.getElementById('updateModal');
updateModal.addEventListener('show.bs.modal', event => {
    const button = event.relatedTarget;
    document.getElementById('modalProductId').value = button.getAttribute('data-id');
    document.getElementById('modalProductName').value = button.getAttribute('data-name');
    document.getElementById('modalDescription').value = button.getAttribute('data-desc');
    document.getElementById('modalPrice').value = button.getAttribute('data-price');
    document.getElementById('modalQty').value = button.getAttribute('data-qty');
});

// Delete confirmation
function confirmDelete(){
    return confirm("Are you sure you want to delete this product?");
}
</script>

</body>
</html>
