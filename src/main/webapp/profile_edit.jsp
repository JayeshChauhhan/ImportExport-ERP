<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.ProfilePojo" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Edit Profile | Import Export ERP</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

<style>
:root {
    --primary: #2563eb;
    --accent: #06b6d4;
    --bg1: #e0f2fe;
    --bg2: #f0f9ff;
    --text-dark: #0f172a;
}

/* Body */
body {
    background: linear-gradient(135deg, var(--bg1), var(--bg2));
    font-family: "Inter", sans-serif;
    padding-top: 110px;
    padding-bottom: 80px;
}

/* Navbar */
.navbar {
    background: rgba(255,255,255,.75);
    backdrop-filter: blur(14px);
    border-bottom: 1px solid rgba(0,0,0,.08);
}
.navbar-brand { font-weight: 800; font-size: 1.3rem; color: var(--text-dark)!important; }
.nav-link { color:#334155!important; font-weight:500; margin:0 12px; position:relative; }
.nav-link.active { color: var(--primary)!important; font-weight:700; }
.nav-link::after { content:""; position:absolute; left:0; bottom:-6px; width:0; height:2px; background: var(--primary); transition:.3s; }
.nav-link:hover::after, .nav-link.active::after { width:100%; }

/* Container */
.main-container {
    display: flex;
    justify-content: center;
    padding: 20px;
}

/* Cards Layout */
.profile-grid {
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
    width: 100%;
    max-width: 1000px;
}

/* Card */
.profile-card {
    flex: 1 1 450px;
    border-radius: 20px;
    background: rgba(255,255,255,.85);
    backdrop-filter: blur(20px);
    box-shadow: 0 20px 40px rgba(0,0,0,.1);
    padding: 25px;
    transition: transform .3s;
}
.profile-card:hover {
    transform: translateY(-3px);
}

/* Card Header */
.card-header {
    font-size: 1.3rem;
    font-weight: 700;
    margin-bottom: 15px;
    display: flex;
    align-items: center;
}
.card-header i {
    font-size: 1.5rem;
    color: var(--primary);
    margin-right: 10px;
}

/* Form labels and inputs */
.form-label { font-weight:600; color:#334155; }
.form-control { border-radius:8px; }

/* Buttons matching Product/Order page */
.btn-theme { background: linear-gradient(135deg, var(--primary), var(--accent)); color: #fff; border:none; font-weight:600; transition:.2s; }
.btn-theme:hover { transform: translateY(-1px); }

.btn-warning { background: linear-gradient(135deg, #f59e0b, #d97706); color:#fff; border:none; font-weight:600; transition:.2s; }
.btn-warning:hover { transform: translateY(-1px); }

.btn-danger { background: linear-gradient(135deg, #ef4444, #b91c1c); color:#fff; border:none; font-weight:600; transition:.2s; }
.btn-danger:hover { transform: translateY(-1px); }

/* Alerts */
.alert { border-radius: 14px; box-shadow: 0 5px 15px rgba(0,0,0,.1); text-align:center; }

/* Footer */
footer {
    background: rgba(255,255,255,.75);
    backdrop-filter: blur(12px);
    text-align:center;
    padding:14px 0;
    position: fixed;
    bottom:0;
    width:100%;
}

/* Responsive adjustments */
@media(max-width: 768px){
    .profile-grid { flex-direction: column; }
}
</style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg fixed-top">
    <div class="container">
        <a class="navbar-brand" href="home.jsp">🌐 Import Export ERP</a>
        <ul class="navbar-nav">
            <li class="nav-item"><a class="nav-link" href="home.jsp">Home</a></li>
            <li class="nav-item"><a class="nav-link" href="ProductController">Products</a></li>
            <li class="nav-item"><a class="nav-link" href="OrderController">Orders</a></li>
            <li class="nav-item"><a class="nav-link" href="ReportController">Reported Products</a></li>
        </ul>
        <ul class="navbar-nav ms-auto">
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle active" href="#" data-bs-toggle="dropdown">
                    <i class="bi bi-person-circle"></i> Profile
                </a>
                <ul class="dropdown-menu dropdown-menu-end">
                    <li><a class="dropdown-item" href="ProfileController">View Profile</a></li>
                    <li><a class="dropdown-item text-danger" href="login.jsp">Logout</a></li>
                </ul>
            </li>
        </ul>
    </div>
</nav>

<!-- Main -->
<div class="main-container">
    <div class="profile-grid">

        <% ProfilePojo profile = (ProfilePojo) request.getAttribute("profile");
           String msg = (String) request.getAttribute("msg");
        %>

        <% if(msg != null) { %>
        <div class="alert <%= msg.toLowerCase().contains("error") ? "alert-danger" : "alert-success" %> alert-dismissible fade show w-100" role="alert">
            <%= msg %>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <% } %>

        <!-- Update Profile -->
        <div class="profile-card">
            <div class="card-header"><i class="bi bi-person-fill"></i> Update Profile</div>
            <form method="post" action="ProfileController">
                <div class="mb-3">
                    <label for="port_id" class="form-label">Port ID</label>
                    <input type="text" class="form-control" id="port_id" value="<%= profile.getPort_id() %>" readonly>
                </div>
                <div class="mb-3">
                    <label for="name" class="form-label">Name</label>
                    <input type="text" class="form-control" name="name" id="name" value="<%= profile.getName() %>" required>
                </div>
                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" class="form-control" name="email" id="email" value="<%= profile.getEmail() %>" required>
                </div>
                <div class="mb-3">
                    <label for="location" class="form-label">Location</label>
                    <input type="text" class="form-control" name="location" id="location" value="<%= profile.getLocation() %>">
                </div>
                <button type="submit" name="update" class="btn btn-theme w-100">Update Profile</button>
            </form>
        </div>

        <!-- Change Password -->
        <div class="profile-card">
            <div class="card-header"><i class="bi bi-shield-lock-fill"></i> Change Password</div>
            <form method="post" action="ProfileController">
                <div class="mb-3">
                    <label for="current_password" class="form-label">Current Password</label>
                    <input type="password" class="form-control" name="current_password" id="current_password" minlength="8" required>
                </div>
                <div class="mb-3">
                    <label for="new_password" class="form-label">New Password</label>
                    <input type="password" class="form-control" name="new_password" id="new_password" minlength="8" required>
                </div>
                <button type="submit" name="changePassword" class="btn btn-warning w-100">Change Password</button>
            </form>
        </div>

        <!-- Delete Account -->
        <div class="profile-card" style="flex-basis:100%; text-align:center;">
            <div class="card-header text-danger"><i class="bi bi-trash-fill"></i> Delete Account</div>
            <form method="post" action="ProfileController" onsubmit="return confirm('Are you sure you want to delete your account? All your products, orders, and reports must be deleted first.')">
                <div class="mb-3">
                    <label for="delete_password" class="form-label">Confirm Password</label>
                    <input type="password" class="form-control" name="delete_password" id="delete_password" minlength="8" required>
                </div>
                <button type="submit" name="delete" class="btn btn-danger w-50">Delete Account</button>
            </form>
        </div>

    </div>
</div>

<footer>© 2025 Import Export ERP System</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
