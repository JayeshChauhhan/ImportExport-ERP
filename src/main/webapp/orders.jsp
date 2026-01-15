<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Order" %>
<%
    String userName = (String) session.getAttribute("userName");
    if(userName == null) userName = "User";

    String pageTitle = "Order Management";
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title><%=pageTitle%> | Import Export ERP</title>
<%
int currentPage = (request.getAttribute("currentPage") != null)
        ? (Integer) request.getAttribute("currentPage")
        : 1;

int totalPages = (request.getAttribute("totalPages") != null)
        ? (Integer) request.getAttribute("totalPages")
        : 1;

String statusFilter = request.getParameter("status") != null
        ? request.getParameter("status")
        : "";

String query = request.getParameter("query") != null
        ? request.getParameter("query")
        : "";
%>


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
.navbar-brand{
    font-weight:800;
    font-size:1.3rem;
    color:var(--text-dark)!important;
}
.navbar-nav{
    margin:0 auto;
}
.nav-link{
    color:#334155!important;
    font-weight:500;
    margin:0 12px;
    position:relative;
}
.nav-link.active{
    color:var(--primary)!important;
    font-weight:700;
}
.nav-link::after{
    content:"";
    position:absolute;
    left:0;
    bottom:-6px;
    width:0;
    height:2px;
    background:var(--primary);
    transition:.3s;
}
.nav-link:hover::after,
.nav-link.active::after{
    width:100%;
}

/* PAGE HEADER */
.page-header{
    text-align:center;
    font-size:1.9rem;
    font-weight:700;
    color:var(--text-dark);
    margin-top:0.5rem;
    margin-bottom:2rem;
}

/* CARD */
.card{
    background:rgba(255,255,255,.85);
    backdrop-filter:blur(16px);
    border:none;
    border-radius:20px;
    box-shadow:0 30px 60px rgba(0,0,0,.12);
}

/* TABLE */
.table-premium{
    background:#fff;
    border-radius:14px;
    overflow:hidden;
}
.table-premium th{
    background:linear-gradient(135deg,var(--primary),var(--accent));
    color:#fff;
    font-weight:600;
    text-align:center;
}
.table-premium td{
    text-align:center;
    vertical-align:middle;
    color:var(--text-dark);
}

/* ACTIONS */
.action-row{
    display:flex;
    align-items:center;
    justify-content:center;
    gap:10px;
}
.update-placeholder{
    width:180px;
}

/* BUTTONS */
.btn-theme{
    background: linear-gradient(135deg, var(--primary), var(--accent));
    color: #fff;
    border: none;
    font-weight:600;
}
.btn-delete{
    background:linear-gradient(135deg,#ef4444,#b91c1c);
    color:#fff;
    border:none;
    font-weight:600;
}

/* SEARCH BAR */
.search-bar {
    background:rgba(255,255,255,.85);
    backdrop-filter:blur(14px);
    padding:12px 16px;
    border-radius:12px;
    margin-bottom:20px;
    display:flex;
    gap:10px;
    align-items:center;
    box-shadow:0 8px 25px rgba(0,0,0,.08);
    flex-wrap: wrap;
}

.search-bar input {
    width: 450px;
    height: 38px;
}

.search-bar select {
    width: 160px;
    height: 38px;
}

.search-bar button {
    height: 38px;
}

/* FOOTER */
footer{
    background:rgba(255,255,255,.75);
    backdrop-filter:blur(12px);
    color:#475569;
    padding:14px 0;
    text-align:center;
    position:fixed;
    bottom:0;
    width:100%;
}

/* ALERT CENTERED */
.alert-custom{
    position:fixed;
    top:50%;
    left:50%;
    transform:translate(-50%,-50%);
    z-index:1055;
    border-radius:14px;
    box-shadow:0 20px 40px rgba(0,0,0,.1);
}

/* PAGINATION (Product Page Style) */
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
            <li class="nav-item"><a class="nav-link" href="ProductController">Products</a></li>
            <li class="nav-item"><a class="nav-link active" href="OrderController">Orders</a></li>
            <li class="nav-item"><a class="nav-link" href="ReportController">Reported Products</a></li>
        </ul>

        <ul class="navbar-nav ms-auto">
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">
                    Profile
                </a>
                <ul class="dropdown-menu dropdown-menu-end">
                    <li><a class="dropdown-item" href="ProfileController">View Profile</a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item text-danger" href="login.jsp">Logout</a></li>
                </ul>
            </li>
        </ul>
    </div>
</nav>

<main class="container">

<!-- PAGE HEADER -->
<div class="page-header"><%=pageTitle%></div>

<% String msg=(String)request.getAttribute("msg");
if(msg!=null){ %>
<div class="alert alert-info alert-custom alert-dismissible fade show" role="alert">
    <i class="bi bi-info-circle"></i> <%=msg%>
</div>
<% } %>

<!-- SEARCH & STATUS FILTER BAR -->
<div class="search-bar">

    <form action="OrderController" method="get" class="d-flex gap-2 flex-wrap align-items-center">
        <input type="text" name="query" class="form-control" placeholder="Search by Order ID" value="<%= request.getParameter("query") != null ? request.getParameter("query") : "" %>">
        <button type="submit" class="btn btn-theme">Search</button>
    </form>

    <form action="OrderController" method="get" class="d-flex gap-2 flex-wrap align-items-center">
        <select name="status" class="form-select">
            <option value="">All Status</option>
            <option value="pending" <%= "pending".equals(request.getParameter("status")) ? "selected" : "" %>>Pending</option>
            <option value="shipped" <%= "shipped".equals(request.getParameter("status")) ? "selected" : "" %>>Shipped</option>
            <option value="delivered" <%= "delivered".equals(request.getParameter("status")) ? "selected" : "" %>>Delivered</option>
            <option value="cancelled" <%= "cancelled".equals(request.getParameter("status")) ? "selected" : "" %>>Cancelled</option>
        </select>
        <button type="submit" class="btn btn-theme">Apply</button>
    </form>

</div>

<!-- ORDERS TABLE -->
<div class="card p-4">
<div class="table-responsive">
<table class="table table-bordered table-premium align-middle">
<thead>
<tr>
    <th>Order ID</th>
    <th>Product ID</th>
    <th>Qty</th>
    <th>Amount</th>
    <th>Status</th>
    <th width="320">Actions</th>
</tr>
</thead>

<tbody>
<%
List<Order> list=(List<Order>)request.getAttribute("orderList");
if(list!=null && !list.isEmpty()){
for(Order o:list){

String status=o.getStatus()==null?"pending":o.getStatus();
boolean locked=status.equals("delivered")||status.equals("cancelled");
%>

<tr>
<td><strong><%=o.getOrderId()%></strong></td>
<td><%=o.getProductId()%></td>
<td><%=o.getQuantity()%></td>
<td>₹ <%=o.getTotalAmount()%></td>

<td>
<span class="badge
<%= status.equals("pending")?"bg-warning text-dark":
    status.equals("shipped")?"bg-info text-dark":
    status.equals("delivered")?"bg-success":"bg-danger" %>">
<%=status%>
</span>
</td>

<td>
<div class="action-row">

<% if(!locked){ %>
<form action="OrderController" method="post" class="d-flex gap-2">
    <input type="hidden" name="action" value="update">
    <input type="hidden" name="order_id" value="<%=o.getOrderId()%>">
      <input type="hidden" name="page" value="<%=currentPage%>">
    <input type="hidden" name="status" value="<%=statusFilter%>">
    <input type="hidden" name="query" value="<%=query%>">

    <select name="new_status" class="form-select form-select-sm">
        <option value="pending" <%=status.equals("pending")?"selected":""%>>Pending</option>
        <option value="shipped" <%=status.equals("shipped")?"selected":""%>>Shipped</option>
        <option value="delivered" <%=status.equals("delivered")?"selected":""%>>Delivered</option>
        <option value="cancelled" <%=status.equals("cancelled")?"selected":""%>>Cancelled</option>
    </select>

    <button class="btn btn-theme btn-sm">Update</button>
</form>
<% } else { %>
<div class="update-placeholder"></div>
<% } %>

<!-- DELETE BUTTON TRIGGER -->
<button 
    class="btn btn-delete btn-sm"
    data-bs-toggle="modal"
    data-bs-target="#deleteConfirmModal"
    onclick="setDeleteOrder('<%=o.getOrderId()%>')">
    Delete
</button>

</div>
</td>
</tr>

<% }} else { %>
<tr>
<td colspan="6" class="text-muted">No orders available</td>
</tr>
<% } %>
</tbody>
</table>
</div>
</div>

<!-- PAGINATION (Product Page Style) -->
<% if(totalPages > 1){ %>

<nav aria-label="Page navigation" class="mt-3">
<ul class="pagination justify-content-center">

    <li class="page-item <%= currentPage == 1 ? "disabled" : "" %>">
        <a class="page-link" href="OrderController?page=1&status=<%=statusFilter%>&query=<%=query%>"><i class="bi bi-chevron-double-left"></i></a>
    </li>
    <li class="page-item <%= currentPage == 1 ? "disabled" : "" %>">
        <a class="page-link" href="OrderController?page=<%=currentPage-1%>&status=<%=statusFilter%>&query=<%=query%>"><i class="bi bi-chevron-left"></i> Prev</a>
    </li>

    <% for(int i=1; i<=totalPages; i++){ %>
        <li class="page-item <%= i == currentPage ? "active" : "" %>">
            <a class="page-link" href="OrderController?page=<%=i%>&status=<%=statusFilter%>&query=<%=query%>"><%=i%></a>
        </li>
    <% } %>

    <li class="page-item <%= currentPage == totalPages ? "disabled" : "" %>">
        <a class="page-link" href="OrderController?page=<%=currentPage+1%>&status=<%=statusFilter%>&query=<%=query%>">Next <i class="bi bi-chevron-right"></i></a>
    </li>
    <li class="page-item <%= currentPage == totalPages ? "disabled" : "" %>">
        <a class="page-link" href="OrderController?page=<%=totalPages%>&status=<%=statusFilter%>&query=<%=query%>"><i class="bi bi-chevron-double-right"></i></a>
    </li>

</ul>
</nav>
<% } %>

</main>

<!-- DELETE CONFIRM MODAL -->
<div class="modal fade" id="deleteConfirmModal" tabindex="-1">
<div class="modal-dialog modal-dialog-centered modal-sm">
<div class="modal-content">

<div class="modal-header bg-danger text-white">
    <h5 class="modal-title">
        <i class="bi bi-exclamation-triangle"></i> Confirm Delete
    </h5>
    <button class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
</div>

<form action="OrderController" method="post">
<div class="modal-body text-center">
    <p class="fw-semibold text-danger mb-1">
        This action cannot be undone.
    </p>
    <p>Are you sure you want to delete this order?</p>

    <input type="hidden" name="action" value="delete">
    <input type="hidden" name="order_id" id="deleteOrderId">
</div>

<div class="modal-footer justify-content-center">
    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
    <button type="submit" class="btn btn-delete">Yes, Delete</button>
</div>
</form>

</div>
</div>
</div>

<footer>© 2025 Import Export ERP System</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
setTimeout(() => {
    const alertBox = document.querySelector('.alert-custom');
    if(alertBox){
        alertBox.classList.remove('show');
        alertBox.classList.add('hide');
        setTimeout(() => alertBox.remove(), 500);
    }
}, 3500);

// Set order ID in modal before deleting
function setDeleteOrder(orderId){
    document.getElementById("deleteOrderId").value = orderId;
}
</script>

</body>
</html>
