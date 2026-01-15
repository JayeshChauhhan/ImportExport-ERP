<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*, model.ReportedProductPojo" %>
<%
    String userName = (String) session.getAttribute("userName");
    if(userName == null) userName = "User";

    String pageTitle = "Reported Products";

    // Get search/filter parameters
    String searchReportIdStr = request.getParameter("searchReportId");
    String searchProductIdStr = request.getParameter("searchProductId");
    String statusFilter = request.getParameter("status");
    if(statusFilter == null) statusFilter = "All";

    Integer searchReportId = null;
    Integer searchProductId = null;
    try {
        if(searchReportIdStr != null && !searchReportIdStr.isEmpty()) searchReportId = Integer.parseInt(searchReportIdStr);
        if(searchProductIdStr != null && !searchProductIdStr.isEmpty()) searchProductId = Integer.parseInt(searchProductIdStr);
    } catch(Exception e){}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><%=pageTitle%> | Import Export ERP</title>

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
.navbar-nav{ margin:0 auto; }
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
.nav-link.active::after{ width:100%; }

.profile-link{ font-weight:600; }

/* PAGE HEADER */
.page-header{
    text-align:center;
    font-size:1.9rem;
    font-weight:700;
    color:var(--text-dark);
    margin-top:0.5rem;
    margin-bottom:2rem;
}

/* SEARCH & FILTER */
.search-filter{
    display:flex;
    gap:10px;
    margin-bottom:20px;
    flex-wrap: wrap;
    justify-content:flex-start; /* left-aligned */
}
.search-filter input,
.search-filter select{
    border-radius:12px;
    padding:10px;
    border:1px solid #cbd5e1;
    width:180px;
}
.search-filter button{
    border-radius:12px;
    padding:10px 20px;
    font-weight:600;
    background: linear-gradient(135deg, var(--primary), var(--accent));
    color:#fff;
    border:none;
}

/* CARDS */
.card{
    background:rgba(255,255,255,.85);
    backdrop-filter:blur(16px);
    border:none;
    border-radius:20px;
    box-shadow:0 30px 60px rgba(0,0,0,.12);
}

.stats-card{
    background:rgba(255,255,255,.85);
    border-radius:20px;
    padding:20px;
    margin-bottom:24px;
    display:flex;
    justify-content:space-around;
    box-shadow:0 20px 40px rgba(0,0,0,.08);
}

.stat-item{text-align:center;}
.stat-number{
    font-size:28px;
    font-weight:700;
    color:var(--primary);
}
.stat-label{ font-size:14px;color:#475569; }

/* TABLE */
.table-premium{
    background:#fff;
    border-radius:14px;
    overflow:hidden;
}
.table-premium th{
    background:linear-gradient(135deg,var(--primary),var(--accent));
    color:#fff;
    text-align:center;
}
.table-premium td{
    text-align:center;
    vertical-align:middle;
}

.action-row{
    display:flex;
    gap:10px;
    justify-content:center;
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

/* MODAL THEME */
.modal-content{
    background:rgba(255,255,255,.85);
    backdrop-filter:blur(18px);
    border:none;
    border-radius:18px;
    box-shadow:0 30px 60px rgba(0,0,0,.18);
}

.modal-header{
    background:linear-gradient(135deg,var(--primary),var(--accent));
    color:#fff;
    border-bottom:none;
    border-radius:18px 18px 0 0;
}

.modal-title{
    font-weight:700;
}

.modal-footer{
    border-top:none;
}

.modal select{
    border-radius:12px;
    padding:10px;
}

.modal .btn-update{
    background: linear-gradient(135deg, var(--primary), var(--accent));
    color: #fff;
    font-weight:600;
    border:none;
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
        <li class="nav-item"><a class="nav-link" href="OrderController">Orders</a></li>
        <li class="nav-item"><a class="nav-link active" href="ReportController">Reported Products</a></li>
    </ul>

    <ul class="navbar-nav ms-auto">
        <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle profile-link" data-bs-toggle="dropdown">
                <i class="bi bi-person-circle"></i> Profile
            </a>
            <ul class="dropdown-menu dropdown-menu-end">
                <li><a class="dropdown-item" href="ProfileController">Profile</a></li>
                <li><a class="dropdown-item text-danger" href="login.jsp">Logout</a></li>
            </ul>
        </li>
    </ul>
</div>
</nav>

<div class="container">

<!-- PAGE HEADER -->
<div class="page-header"><%=pageTitle%></div>

<%-- ALERT MESSAGE CENTERED --%>
<%
String message = (String) request.getAttribute("message");
if(message != null && !message.isEmpty()){
%>
<div class="alert alert-info alert-custom alert-dismissible fade show" role="alert">
  <i class="bi bi-info-circle"></i> <%=message%>
  <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
</div>
<% } %>

<!-- SEARCH & FILTER BAR -->
<form method="get" action="ReportController" class="search-filter">
    <input type="number" name="searchReportId" value="" placeholder="Search by Report ID">
    <input type="number" name="searchProductId" value="" placeholder="Search by Product ID">
    <select name="status">
        <option value="All" <%= "All".equals(statusFilter)?"selected":"" %>>All Status</option>
        <option value="Open" <%= "Open".equals(statusFilter)?"selected":"" %>>Open</option>
        <option value="Resolved" <%= "Resolved".equals(statusFilter)?"selected":"" %>>Resolved</option>
    </select>
    <button type="submit">Search</button>
</form>

<%
List<ReportedProductPojo> reports=(List<ReportedProductPojo>)request.getAttribute("reports");
int total=(reports!=null)?reports.size():0;
int open=0;
if(reports!=null){
    for(ReportedProductPojo r:reports)
        if("Open".equals(r.getStatus())) open++;
}
%>

<div class="stats-card">
    <div class="stat-item">
        <div class="stat-number"><%=total%></div>
        <div class="stat-label">Total Reports</div>
    </div>
    <div class="stat-item">
        <div class="stat-number" style="color:#f59e0b;"><%=open%></div>
        <div class="stat-label">Open</div>
    </div>
    <div class="stat-item">
        <div class="stat-number" style="color:#10b981;"><%=total-open%></div>
        <div class="stat-label">Resolved</div>
    </div>
</div>

<div class="card p-4">
<div class="table-responsive">
<table class="table table-bordered table-premium">
<thead>
<tr>
<th>ID</th><th>Product</th><th>Reporter</th><th>Reason</th><th>Status</th><th>Actions</th>
</tr>
</thead>
<tbody>
<%
if(reports!=null && !reports.isEmpty()){
for(ReportedProductPojo r:reports){
%>
<tr>
<td>#<%=r.getReportId()%></td>
<td><%=r.getProductId()%></td>
<td><%=r.getReporterId()%></td>
<td><%=r.getReason()%></td>
<td>
<span class="badge <%= "Resolved".equals(r.getStatus())?"bg-success":"bg-warning text-dark"%>">
<%=r.getStatus()%>
</span>
</td>
<td>
<div class="action-row">
<button class="btn btn-theme btn-sm" data-bs-toggle="modal"
data-bs-target="#updateModal"
onclick="setUpdate('<%=r.getReportId()%>','<%=r.getStatus()%>')">
Update
</button>
<button class="btn btn-delete btn-sm" data-bs-toggle="modal"
data-bs-target="#deleteModal"
onclick="setDelete('<%=r.getReportId()%>')">
Delete
</button>
</div>
</td>
</tr>
<% }} else { %>
<tr><td colspan="6" class="text-muted text-center">No reports found</td></tr>
<% } %>
</tbody>
</table>
</div>
</div>

<%
Integer currentPage = (Integer) request.getAttribute("currentPage");
Integer totalPages = (Integer) request.getAttribute("totalPages");
if (currentPage == null) currentPage = 1;
if (totalPages == null) totalPages = 1;
%>

<!-- PAGINATION -->
<% if(totalPages > 1){ %>
<nav class="mt-4">
<ul class="pagination justify-content-center">
    <li class="page-item <%= currentPage==1 ? "disabled":"" %>">
        <a class="page-link" href="ReportController?page=1"><i class="bi bi-chevron-double-left"></i></a>
    </li>
    <li class="page-item <%= currentPage==1 ? "disabled":"" %>">
        <a class="page-link" href="ReportController?page=<%=currentPage-1%>"><i class="bi bi-chevron-left"></i> Prev</a>
    </li>
    <% for(int i=1;i<=totalPages;i++){ %>
    <li class="page-item <%= i==currentPage?"active":"" %>">
        <a class="page-link" href="ReportController?page=<%=i%>"><%=i%></a>
    </li>
    <% } %>
    <li class="page-item <%= currentPage==totalPages?"disabled":"" %>">
        <a class="page-link" href="ReportController?page=<%=currentPage+1%>">Next <i class="bi bi-chevron-right"></i></a>
    </li>
    <li class="page-item <%= currentPage==totalPages?"disabled":"" %>">
        <a class="page-link" href="ReportController?page=<%=totalPages%>"><i class="bi bi-chevron-double-right"></i></a>
    </li>
</ul>
</nav>
<% } %>

<!-- UPDATE MODAL -->
<div class="modal fade" id="updateModal">
<div class="modal-dialog modal-dialog-centered">
<div class="modal-content">
<form method="post" action="ReportController">
<div class="modal-header">
<h5 class="modal-title">Update Status</h5>
<button class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
</div>
<div class="modal-body">
<input type="hidden" name="action" value="update">
<input type="hidden" name="reportId" id="updateId">
  <!-- Add this hidden input to preserve current page -->
    <input type="hidden" name="page" value="<%=currentPage%>">
<label class="form-label fw-semibold">Status</label>
<select class="form-select" name="status" id="updateStatus" required>
<option value="Open">Open</option>
<option value="Resolved">Resolved</option>
</select>
</div>
<div class="modal-footer">
<button class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
<button class="btn btn-update">Update</button>
</div>
</form>
</div>
</div>
</div>

<!-- DELETE MODAL -->
<div class="modal fade" id="deleteModal">
<div class="modal-dialog modal-sm">
<div class="modal-content">
<form method="post" action="ReportController">
<input type="hidden" name="action" value="delete">
<input type="hidden" name="reportId" id="deleteId">
<div class="modal-body text-center">
<p>Delete this report?</p>
<button class="btn btn-delete btn-sm">Delete</button>
</div>
</form>
</div>
</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
function setUpdate(id,status){
    document.getElementById("updateId").value=id;
    document.getElementById("updateStatus").value=status;
}
function setDelete(id){
    document.getElementById("deleteId").value=id;
}

// Auto-hide alerts after 4 seconds
setTimeout(()=>{
    let alertElem=document.querySelector('.alert-custom');
    if(alertElem){
        alertElem.classList.remove('show');
        alertElem.classList.add('hide');
        setTimeout(()=>alertElem.remove(),500);
    }
},4000);
</script>

<footer>© 2025 Import Export ERP System</footer>
</body>
</html>
