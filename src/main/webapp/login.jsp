<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Login | Import Export ERP</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

<style>
:root {
    --primary: #2563eb; /* Homepage primary button color */
    --accent: #3b82f6;  /* Slight gradient accent */
    --bg-page: #e0f2ff; /* Light bluish background */
    --card-bg: #ffffff;
    --text-dark: #1f2937;
    --text-muted: #6b7280;
}

/* Body */
body {
    min-height: 100vh;
    margin: 0;
    font-family: "Inter", "Segoe UI", system-ui, sans-serif;
    background: var(--bg-page);
    display: flex;
    align-items: center;
    justify-content: center;
}

/* Container */
.auth-wrapper {
    width: 95%;
    max-width: 820px;
    display: flex;
    border-radius: 20px;
    overflow: hidden;
    box-shadow: 0 12px 30px rgba(0,0,0,0.1);
    transition: all 0.3s ease;
}
.auth-wrapper:hover {
    transform: scale(1.02);
}

/* LEFT: Branding */
.auth-left {
    flex: 1;
    padding: 2.5rem 1.5rem;
    background: linear-gradient(160deg, rgba(37, 99, 235, 0.1), rgba(37, 99, 235, 0.05));
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    text-align: center;
    transition: all 0.3s ease;
}
.auth-left .brand-icon {
    font-size: 3.5rem;
    margin-bottom: 1rem;
    transition: transform 0.3s ease;
}
.auth-left h2 {
    font-weight: 700;
    font-size: 1.6rem;
    color: var(--text-dark);
    margin-bottom: 0.5rem;
}
.auth-left p {
    font-size: 0.9rem;
    color: var(--text-muted);
    max-width: 280px;
}

/* RIGHT: Form Card */
.auth-right {
    flex: 1;
    padding: 2.5rem 1.5rem;
    display: flex;
    flex-direction: column;
    justify-content: center;
    background: var(--card-bg);
    border-radius: 0 20px 20px 0;
    box-shadow: 0 8px 25px rgba(0,0,0,0.05), inset 0 0 8px rgba(0,0,0,0.01);
    transition: all 0.3s ease;
}
.auth-right h3 {
    font-weight: 700;
    color: var(--text-dark);
    margin-bottom: 0.3rem;
    text-align: center;
}
.auth-right .subtitle {
    font-size: 0.85rem;
    color: var(--text-muted);
    margin-bottom: 1.5rem;
    text-align: center;
}

/* Decorative line under heading */
.auth-right h3 + div {
    height:2px;
    width:50px;
    background: linear-gradient(to right, var(--primary), var(--accent));
    margin:0.5rem auto 1.2rem;
    border-radius:2px;
}

/* Inputs */
.form-control {
    border-radius: 0.65rem;
    padding: 0.65rem 1rem;
    font-size: 0.95rem;
    border: 1px solid #d1d5db;
    background: #ffffff;
    color: var(--text-dark);
    transition: all 0.3s ease;
}
.form-control:focus {
    border-color: var(--primary);
    box-shadow: 0 4px 15px rgba(37,99,235,0.25);
}

/* Input-group icon */
.input-group-text {
    background: #f3f4f6;
    border-radius: 0.65rem;
    cursor: pointer;
    color: var(--text-dark);
}

/* Submit button */
.btn-primary {
    margin-top: 0.7rem;
    padding: 0.75rem;
    border-radius: 0.75rem;
    font-weight: 600;
    background: linear-gradient(135deg, var(--primary), var(--accent)); /* Homepage button gradient */
    border: none;
    width: 100%;
    transition: all 0.3s ease;
}
.btn-primary:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 25px rgba(37,99,235,0.3);
}

/* Message */
.msg {
    font-weight: 500;
    font-size: 0.85rem;
    margin-top: 0.8rem;
    text-align: center;
}

/* Footer */
.auth-footer {
    margin-top: 1.2rem;
    font-size: 0.85rem;
    color: var(--text-muted);
    text-align: center;
}
.auth-footer a {
    color: var(--primary);
    font-weight: 500;
    text-decoration: none;
}
.auth-footer a:hover {
    text-decoration: underline;
}

/* Responsive */
@media (max-width: 900px) {
    .auth-wrapper {
        flex-direction: column;
        border-radius: 20px;
    }
    .auth-left {
        border-radius: 20px 20px 0 0;
        height: 160px;
        padding: 1.8rem 1.2rem;
    }
    .auth-right {
        border-radius: 0 0 20px 20px;
        padding: 1.8rem 1.2rem;
    }
}
</style>

<script>
function togglePassword() {
    const pwdField = document.getElementById("password");
    const icon = document.getElementById("toggleIcon");
    if (pwdField.type === "password") {
        pwdField.type = "text";
        icon.classList.remove("bi-eye");
        icon.classList.add("bi-eye-slash");
    } else {
        pwdField.type = "password";
        icon.classList.remove("bi-eye-slash");
        icon.classList.add("bi-eye");
    }
}
</script>
</head>

<body>

<div class="auth-wrapper">

    <!-- LEFT: Logo & Text -->
    <div class="auth-left">
        <div class="brand-icon">🌐</div>
        <h2>Import Export ERP</h2>
        <p>Login to access your enterprise account securely.</p>
    </div>

    <!-- RIGHT: Form -->
    <div class="auth-right">
        <h3>Login</h3>
        <div></div> <!-- decorative line -->
        <div class="subtitle">Enter your credentials</div>

        <form method="post" action="<%= request.getContextPath() %>/LoginController">
            <div class="mb-3">
                <input type="text" class="form-control" name="port_id" placeholder="Port ID" required>
            </div>

            <div class="mb-3 input-group">
                <input type="password" id="password" class="form-control" name="password" placeholder="Password" required>
                <span class="input-group-text" onclick="togglePassword()">
                    <i id="toggleIcon" class="bi bi-eye"></i>
                </span>
            </div>

            <div class="d-grid mb-2">
                <button type="submit" class="btn btn-primary">Login</button>
            </div>
        </form>

        <div class="auth-footer">
            Not registered? <a href="register.jsp">Register here</a>
        </div>

        <% if (request.getAttribute("msg") != null) { %>
            <p class="text-danger msg"><%= request.getAttribute("msg") %></p>
        <% } %>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
