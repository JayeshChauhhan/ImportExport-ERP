<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    /* LOGIC LEFT UNTOUCHED */
    String userName = (String) session.getAttribute("userName");
    if (userName == null) {
        userName = "User";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Import Export ERP | Dashboard</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        :root {
            --primary: #2563eb;
            --accent: #06b6d4;
            --bg1: #e0f2fe;
            --bg2: #f0f9ff;
            --text-dark: #0f172a;
        }

        body {
            min-height: 100vh;
            margin: 0;
            font-family: "Inter","Segoe UI",system-ui,sans-serif;
            background: linear-gradient(135deg,var(--bg1),var(--bg2));
        }

        /* NAVBAR */
        .navbar-custom {
            background: rgba(255,255,255,0.75);
            backdrop-filter: blur(14px);
            border-bottom: 1px solid rgba(0,0,0,0.08);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .navbar-brand {
            font-weight: 800;
            color: var(--text-dark);
            font-size: 1.35rem;
        }

        .nav-link {
            color: #334155 !important;
            font-weight: 500;
            margin: 0 1rem;
            position: relative;
        }

        .nav-link.active {
            color: var(--primary) !important;
            font-weight: 700;
        }

        .nav-link::after {
            content: "";
            position: absolute;
            left: 0;
            bottom: -6px;
            width: 0;
            height: 2px;
            background: var(--primary);
            transition: 0.3s;
        }

        .nav-link:hover::after,
        .nav-link.active::after {
            width: 100%;
        }

        /* DROPDOWN */
        .dropdown-menu {
            border-radius: 14px;
            border: none;
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }

        /* MAIN */
        .container-main {
            padding: 4rem 1rem 5rem;
        }

        .dashboard-title {
            font-weight: 800;
            color: var(--text-dark);
            text-align: center;
            margin-bottom: 3rem;
        }

        .erp-card {
            background: rgba(255,255,255,0.85);
            border-radius: 20px;
            padding: 2.3rem 1.5rem;
            text-align: center;
            box-shadow: 0 25px 50px rgba(0,0,0,0.12);
            transition: all 0.35s ease;
        }

        .erp-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 35px 70px rgba(0,0,0,0.18);
        }

        .erp-card i {
            font-size: 3.5rem;
            background: linear-gradient(135deg,var(--primary),var(--accent));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .btn-erp {
            margin-top: 0.5rem;
            background: linear-gradient(135deg,var(--primary),var(--accent));
            border: none;
            border-radius: 12px;
            padding: 10px 26px;
            font-weight: 600;
            color: #fff;
        }
        .modal-footer{
    border-top:none;
}

       /* FOOTER */
footer{
    background:rgba(255,255,255,.75);
    backdrop-filter:blur(12px);
    text-align:center;
    padding:14px 0;
    position:fixed;
    bottom:0;
    width:100%;
}
    </style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-custom">
    <div class="container">
        <a class="navbar-brand" href="home.jsp">🌐 Import Export ERP</a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mx-auto">
                <li class="nav-item"><a class="nav-link active" href="home.jsp">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="ProductController">Products</a></li>
                <li class="nav-item"><a class="nav-link" href="OrderController">Orders</a></li>
                <li class="nav-item"><a class="nav-link" href="ReportController">Reported Products</a></li>
            </ul>

            <!-- ✅ PROFILE — SAME STYLE AS PRODUCT PAGE -->
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
    </div>
</nav>

<!-- MAIN -->
<div class="container container-main">
    <h3 class="dashboard-title">Seller Dashboard</h3>

    <div class="row g-4 justify-content-center">
        <div class="col-md-4">
            <div class="erp-card">
                <i class="bi bi-box-seam"></i>
                <h5>Product Management</h5>
                <p>Add, update, and delete products</p>
                <a href="ProductController" class="btn btn-erp">Manage</a>
            </div>
        </div>

        <div class="col-md-4">
            <div class="erp-card">
                <i class="bi bi-cart-check"></i>
                <h5>Order Management</h5>
                <p>View, track, and update orders</p>
                <a href="OrderController" class="btn btn-erp">Manage</a>
            </div>
        </div>

        <div class="col-md-4">
            <div class="erp-card">
                <i class="bi bi-flag"></i>
                <h5>Reported Products</h5>
                <p>Review and resolve reported products</p>
                <a href="ReportController" class="btn btn-erp">View</a>
            </div>
        </div>
    </div>
</div>

<footer>© 2025 Import Export ERP System</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
