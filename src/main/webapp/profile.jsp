<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.ProfilePojo" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Your Profile | Import Export ERP</title>

<!-- Bootstrap & Icons -->
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

/* Body */
body {
    background: linear-gradient(135deg, var(--bg1), var(--bg2));
    font-family: "Inter", "Segoe UI", sans-serif;
    padding-top: 110px;
    padding-bottom: 90px;
}

/* Navbar */
.navbar {
    background: rgba(255,255,255,.85);
    backdrop-filter: blur(14px);
    border-bottom: 1px solid rgba(0,0,0,.08);
}
.navbar-brand { font-weight: 800; font-size: 1.3rem; color: var(--text-dark)!important; }
.nav-link { color:#334155!important; font-weight:500; margin:0 12px; position:relative; }
.nav-link.active { color: var(--primary)!important; font-weight:700; }
.nav-link::after { content:""; position:absolute; left:0; bottom:-6px; width:0; height:2px; background: var(--primary); transition:.3s; }
.nav-link:hover::after, .nav-link.active::after { width:100%; }
.profile-link { position: relative; display: flex; align-items: center; gap: 6px; font-weight: 600; color: var(--text-dark); cursor:pointer; }
.profile-link::after { content: ""; position:absolute; left:0; bottom:-6px; width:0; height:2px; background: var(--primary); transition:0.3s; }
.profile-link:hover::after { width:100%; }

/* Main container */
.main-container {
    display: flex;
    justify-content: center;
    align-items: flex-start;
    min-height: calc(100vh - 200px);
    padding: 20px;
}

/* Profile Card */
.profile-card {
    width: 100%;
    max-width: 500px;
    background: rgba(255,255,255,.85);
    backdrop-filter: blur(20px);
    border-radius: 25px;
    box-shadow: 0 20px 50px rgba(0,0,0,.1);
    transition: transform .3s, box-shadow .3s;
}
.profile-card:hover { transform: translateY(-5px); box-shadow: 0 35px 70px rgba(0,0,0,.15); }

/* Card header */
.card-header {
    background: linear-gradient(135deg, var(--primary), var(--accent));
    color: #fff;
    border-radius: 25px 25px 0 0;
    text-align: center;
    font-size: 1.6rem;
    font-weight: 700;
    padding: 25px 0;
    position: relative;
}

/* Back button */
.back-btn {
    position: absolute; left: 20px; top: 50%; transform: translateY(-50%);
    border-radius: 10px; font-weight:600;
}

/* Profile Icon */
.profile-icon {
    font-size: 120px;
    color: var(--primary);
    margin: 20px 0;
}

/* Profile Info Blocks */
.profile-info {
    display: flex;
    flex-direction: column;
    gap: 15px;
}
.profile-row {
    display: flex;
    justify-content: space-between;
    padding: 12px 20px;
    border-radius: 12px;
    background: rgba(0,0,0,.03);
    font-weight: 500;
    color: var(--text-dark);
}
.profile-label { font-weight: 600; color: #334155; }
.profile-value { text-align: right; color: var(--text-dark); }

/* Edit button */
.btn-theme {
    background: linear-gradient(135deg, var(--primary), var(--accent));
    color: #fff;
    font-weight:600;
    border:none;
    border-radius:12px;
    width: 100%;
    padding: 12px 0;
    font-size: 1rem;
    transition: transform .2s, box-shadow .2s;
}
.btn-theme:hover { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(37,99,235,.35); }

/* Alerts */
.alert { border-radius: 14px; box-shadow: 0 5px 15px rgba(0,0,0,.1); text-align:center; margin:10px 0; }

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

/* Responsive */
@media(max-width:576px){
    .profile-card { width: 95%; }
    .profile-row { flex-direction: column; align-items: flex-start; }
    .profile-value { text-align:left; margin-top:4px; }
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
                <a class="nav-link dropdown-toggle profile-link" href="#" data-bs-toggle="dropdown">
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
<main class="main-container">
    <div class="profile-card">
        <div class="card-header">
            <a href="home.jsp" class="btn btn-outline-light back-btn">← Back</a>
            Your Profile
        </div>

        <div class="card-body text-center px-4 py-3">
            <% 
                ProfilePojo profile = (ProfilePojo) request.getAttribute("profile");
                String msg = (String) request.getAttribute("msg");
                if(msg == null){
                    msg = (String) session.getAttribute("profile_msg");
                    session.removeAttribute("profile_msg");
                }
                if(msg != null){
                    String alertClass = msg.toLowerCase().contains("error") ? "alert-danger" : "alert-success";
            %>
            <div class="alert <%= alertClass %>"><%= msg %></div>
            <% } %>

            <% if(profile != null){ %>
                <i class="bi bi-person-circle profile-icon"></i>

                <div class="profile-info">
                    <div class="profile-row">
                        <span class="profile-label">Port ID:</span>
                        <span class="profile-value"><%= profile.getPort_id() %></span>
                    </div>
                    <div class="profile-row">
                        <span class="profile-label">Name:</span>
                        <span class="profile-value"><%= profile.getName() %></span>
                    </div>
                    <div class="profile-row">
                        <span class="profile-label">Email:</span>
                        <span class="profile-value"><%= profile.getEmail() %></span>
                    </div>
                    <div class="profile-row">
                        <span class="profile-label">Location:</span>
                        <span class="profile-value"><%= profile.getLocation() %></span>
                    </div>
                </div>

                <a href="ProfileController?edit=true" class="btn btn-theme mt-4">Edit Profile</a>
            <% } else { %>
                <p class="text-danger">No profile found.</p>
            <% } %>
        </div>
    </div>
</main>

<footer>© 2025 Import Export ERP System</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
