<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
  if (session.getAttribute("userId") != null) {
    response.sendRedirect("dashboard.jsp"); return;
  }

  final String DB_URL  = "jdbc:mysql://localhost:3306/elearning_db?useSSL=false&serverTimezone=Asia/Bangkok&characterEncoding=UTF-8";
  final String DB_USER = "root";
  final String DB_PASS = "";

  String error   = "";
  String valUser = "";

  if ("POST".equals(request.getMethod())) {
    String pUser = request.getParameter("username");
    String pPass = request.getParameter("password");
    if (pUser == null) pUser = "";
    if (pPass == null) pPass = "";
    valUser = pUser;

    if (pUser.trim().isEmpty() || pPass.isEmpty()) {
      error = "กรุณากรอกชื่อผู้ใช้และรหัสผ่าน";
    } else {
      Connection con = null;
      try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

        PreparedStatement ps = con.prepareStatement(
          "SELECT user_id, fullname, role FROM users WHERE username=? AND password=?");
        ps.setString(1, pUser.trim());
        ps.setString(2, pPass);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
          session.setAttribute("userId",   rs.getInt("user_id"));
          session.setAttribute("fullname", rs.getString("fullname"));
          session.setAttribute("username", pUser.trim());
          session.setAttribute("role",     rs.getString("role"));
          rs.close(); ps.close(); con.close();
          response.sendRedirect("dashboard.jsp");
          return;
        } else {
          error = "ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง";
        }
        rs.close(); ps.close();
      } catch (Exception e) {
        error = "เกิดข้อผิดพลาด: " + e.getMessage();
      } finally {
        if (con != null) try { con.close(); } catch (Exception ex) {}
      }
    }
  }

  request.setAttribute("currentPage", "login");
%>
<!DOCTYPE html>
<html lang="th">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>เข้าสู่ระบบ - LearnHub</title>
  <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;500;600;700;800&family=Chakra+Petch:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
<%@ include file="navbar.jspf" %>

<div class="auth-wrapper">
  <div class="auth-card">
    <div class="auth-logo">
      <div class="logo-big">📚</div>
      <h2>เข้าสู่ระบบ</h2>
      <p>ยินดีต้อนรับกลับสู่ LearnHub</p>
    </div>

    <% if (!error.isEmpty()) { %>
      <div class="alert alert-danger">⚠️ <%= error %></div>
    <% } %>

    <form method="POST" action="login.jsp">
      <div class="form-group">
        <label class="form-label">ชื่อผู้ใช้</label>
        <div class="input-icon">
          <span class="icon">👤</span>
          <input type="text" name="username" class="form-control"
            placeholder="กรอกชื่อผู้ใช้" required value="<%= valUser %>">
        </div>
      </div>
      <div class="form-group">
        <label class="form-label">รหัสผ่าน</label>
        <div class="input-icon">
          <span class="icon">🔒</span>
          <input type="password" name="password" class="form-control"
            placeholder="กรอกรหัสผ่าน" required>
        </div>
      </div>
      <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:1.25rem;">
        <label style="display:flex;align-items:center;gap:6px;font-size:0.875rem;cursor:pointer;">
          <input type="checkbox"> จดจำฉัน
        </label>
        <a href="#" style="font-size:0.875rem;color:var(--primary);text-decoration:none;">ลืมรหัสผ่าน?</a>
      </div>
      <button type="submit" class="btn btn-primary btn-block">เข้าสู่ระบบ</button>
    </form>

    <div class="auth-switch">
      ยังไม่มีบัญชี? <a href="register.jsp">สมัครสมาชิกฟรี</a>
    </div>
  </div>
</div>
</body>
</html>
