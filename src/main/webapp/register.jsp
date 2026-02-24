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
  String success  = "";
  String valUser  = "";
  String valFull  = "";

  if ("POST".equals(request.getMethod())) {
    String pUser = request.getParameter("username");
    String pPass = request.getParameter("password");
    String pConf = request.getParameter("confirm");
    String pFull = request.getParameter("fullname");

    if (pUser == null) pUser = "";
    if (pPass == null) pPass = "";
    if (pConf == null) pConf = "";
    if (pFull == null) pFull = "";

    valUser = pUser;
    valFull = pFull;

    if (pUser.trim().isEmpty() || pPass.isEmpty() || pFull.trim().isEmpty()) {
      error = "กรุณากรอกข้อมูลให้ครบทุกช่อง";
    } else if (!pPass.equals(pConf)) {
      error = "รหัสผ่านและยืนยันรหัสผ่านไม่ตรงกัน";
    } else if (pPass.length() < 4) {
      error = "รหัสผ่านต้องมีความยาวอย่างน้อย 4 ตัวอักษร";
    } else {
      Connection con = null;
      try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

        PreparedStatement psChk = con.prepareStatement("SELECT 1 FROM users WHERE username=?");
        psChk.setString(1, pUser);
        ResultSet rsChk = psChk.executeQuery();
        if (rsChk.next()) {
          error = "ชื่อผู้ใช้นี้ถูกใช้ไปแล้ว";
        } else {
          PreparedStatement psIns = con.prepareStatement(
            "INSERT INTO users (username, password, fullname, role) VALUES (?,?,?,'student')");
          psIns.setString(1, pUser.trim());
          psIns.setString(2, pPass);
          psIns.setString(3, pFull.trim());
          psIns.executeUpdate();
          psIns.close();
          success = "สมัครสมาชิกสำเร็จ!";
          valUser = "";
          valFull = "";
        }
        rsChk.close();
        psChk.close();
      } catch (Exception e) {
        error = "เกิดข้อผิดพลาด: " + e.getMessage();
      } finally {
        if (con != null) try { con.close(); } catch (Exception ex) {}
      }
    }
  }

  request.setAttribute("currentPage", "register");
%>
<!DOCTYPE html>
<html lang="th">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>สมัครสมาชิก - LearnHub</title>
  <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;500;600;700;800&family=Chakra+Petch:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
<%@ include file="navbar.jspf" %>

<div class="auth-wrapper">
  <div class="auth-card" style="max-width:480px;">
    <div class="auth-logo">
      <div class="logo-big">✨</div>
      <h2>สมัครสมาชิก</h2>
      <p>เริ่มต้นการเรียนรู้กับ LearnHub วันนี้</p>
    </div>

    <% if (!error.isEmpty()) { %>
      <div class="alert alert-danger">⚠️ <%= error %></div>
    <% } %>
    <% if (!success.isEmpty()) { %>
      <div class="alert alert-success">
        ✅ <%= success %> &nbsp;
        <a href="login.jsp" style="color:#065f46;font-weight:700;text-decoration:underline;">คลิกเพื่อเข้าสู่ระบบ</a>
      </div>
    <% } else { %>

    <form method="POST" action="register.jsp">
      <div style="display:grid;grid-template-columns:1fr 1fr;gap:1rem;">
        <div class="form-group">
          <label class="form-label">ชื่อ-นามสกุล <span style="color:red">*</span></label>
          <input type="text" name="fullname" class="form-control"
            placeholder="ชื่อ-นามสกุล" required value="<%= valFull %>">
        </div>
        <div class="form-group">
          <label class="form-label">ชื่อผู้ใช้ <span style="color:red">*</span></label>
          <input type="text" name="username" class="form-control"
            placeholder="username" required value="<%= valUser %>">
        </div>
      </div>
      <div class="form-group">
        <label class="form-label">รหัสผ่าน <span style="color:red">*</span></label>
        <div class="input-icon">
          <span class="icon">🔒</span>
          <input type="password" name="password" class="form-control"
            placeholder="รหัสผ่าน (อย่างน้อย 4 ตัว)" required>
        </div>
      </div>
      <div class="form-group">
        <label class="form-label">ยืนยันรหัสผ่าน <span style="color:red">*</span></label>
        <div class="input-icon">
          <span class="icon">🔒</span>
          <input type="password" name="confirm" class="form-control"
            placeholder="ยืนยันรหัสผ่านอีกครั้ง" required>
        </div>
      </div>
      <div style="margin-bottom:1.25rem;">
        <label style="display:flex;align-items:flex-start;gap:8px;font-size:0.85rem;color:var(--gray);cursor:pointer;">
          <input type="checkbox" required style="margin-top:3px;">
          <span>ฉันยอมรับเงื่อนไขการใช้งานและนโยบายความเป็นส่วนตัว</span>
        </label>
      </div>
      <button type="submit" class="btn btn-primary btn-block">สมัครสมาชิกฟรี</button>
    </form>

    <% } %>
    <div class="auth-switch">
      มีบัญชีอยู่แล้ว? <a href="login.jsp">เข้าสู่ระบบ</a>
    </div>
  </div>
</div>
</body>
</html>
