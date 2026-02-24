<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<% request.setCharacterEncoding("UTF-8"); %>
<%
  Integer sessUserId = (Integer) session.getAttribute("userId");
  if (sessUserId == null) { response.sendRedirect("login.jsp"); return; }

  final String DB_URL  = "jdbc:mysql://localhost:3306/elearning_db?useSSL=false&serverTimezone=Asia/Bangkok&characterEncoding=UTF-8&useUnicode=true";
  final String DB_USER = "root";
  final String DB_PASS = "";

  String sessFullname = (String) session.getAttribute("fullname");
  String sessUsername = (String) session.getAttribute("username");
  if (sessFullname == null) sessFullname = "";
  if (sessUsername == null) sessUsername = "";
  String sessInitial = (sessFullname.length() > 0) ? String.valueOf(sessFullname.charAt(0)) : "U";

  String activeTab = request.getParameter("tab");
  if (activeTab == null) activeTab = "overview";

  // สถิติ
  int enrollCount = 0, quizDoneCount = 0;
  double avgScore = 0;
  Connection con = null;
  try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

    PreparedStatement ps;
    ResultSet rs;

    ps = con.prepareStatement("SELECT COUNT(*) FROM enrollments WHERE user_id=?");
    ps.setInt(1, sessUserId); rs = ps.executeQuery();
    if (rs.next()) enrollCount = rs.getInt(1);
    rs.close(); ps.close();

    ps = con.prepareStatement("SELECT COUNT(*), COALESCE(AVG(score),0) FROM results WHERE user_id=?");
    ps.setInt(1, sessUserId); rs = ps.executeQuery();
    if (rs.next()) { quizDoneCount = rs.getInt(1); avgScore = rs.getDouble(2); }
    rs.close(); ps.close();

  } catch (Exception e) {}

  // Profile POST
  String profileMsg = "";
  if ("profile".equals(activeTab) && "POST".equals(request.getMethod())) {
    String pFull = request.getParameter("fullname");
    String pPass = request.getParameter("new_password");
    if (pFull == null) pFull = "";
    if (pPass == null) pPass = "";
    if (!pFull.trim().isEmpty()) {
      try {
        PreparedStatement psU;
        if (!pPass.isEmpty()) {
          psU = con.prepareStatement("UPDATE users SET fullname=?, password=? WHERE user_id=?");
          psU.setString(1, pFull.trim());
          psU.setString(2, pPass);
          psU.setInt(3, sessUserId);
        } else {
          psU = con.prepareStatement("UPDATE users SET fullname=? WHERE user_id=?");
          psU.setString(1, pFull.trim());
          psU.setInt(2, sessUserId);
        }
        psU.executeUpdate(); psU.close();
        session.setAttribute("fullname", pFull.trim());
        sessFullname = pFull.trim();
        sessInitial  = String.valueOf(sessFullname.charAt(0));
        profileMsg = "success";
      } catch (Exception e) {
        profileMsg = e.getMessage();
      }
    }
  }

  request.setAttribute("currentPage", "dashboard");
  String[] courseColors = {"blue","green","purple","orange"};
  String[] courseIcons  = {"💻","🌐","🗄️","📱"};
%>
<!DOCTYPE html>
<html lang="th">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>แดชบอร์ด - LearnHub</title>
  <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;500;600;700;800&family=Chakra+Petch:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
<%@ include file="navbar.jspf" %>

<div class="dashboard-layout">

  <!-- SIDEBAR -->
  <div class="sidebar">
    <div style="padding:0 1.25rem 1.25rem;border-bottom:1px solid var(--border);">
      <div style="display:flex;align-items:center;gap:10px;padding:0.75rem 0;">
        <div class="avatar" style="width:44px;height:44px;font-size:1.1rem;"><%= sessInitial %></div>
        <div>
          <div style="font-weight:700;font-size:0.9rem;"><%= sessFullname %></div>
          <div style="font-size:0.75rem;color:var(--gray);">นักเรียน</div>
        </div>
      </div>
    </div>
    <div style="margin-top:1rem;">
      <div class="sidebar-label">เมนูหลัก</div>
      <a class="sidebar-item <%= "overview".equals(activeTab)   ? "active" : "" %>" href="dashboard.jsp?tab=overview">  <span>📊</span> ภาพรวม</a>
      <a class="sidebar-item <%= "mycourses".equals(activeTab)  ? "active" : "" %>" href="dashboard.jsp?tab=mycourses"> <span>📚</span> คอร์สของฉัน</a>
      <a class="sidebar-item <%= "history".equals(activeTab)    ? "active" : "" %>" href="dashboard.jsp?tab=history">   <span>📖</span> ประวัติการเรียน</a>
      <a class="sidebar-item <%= "results".equals(activeTab)    ? "active" : "" %>" href="dashboard.jsp?tab=results">
        <span>📋</span> ประวัติการสอบ
        <% if (quizDoneCount > 0) { %><span class="sidebar-badge"><%= quizDoneCount %></span><% } %>
      </a>
      <a class="sidebar-item <%= "profile".equals(activeTab)    ? "active" : "" %>" href="dashboard.jsp?tab=profile">   <span>👤</span> โปรไฟล์</a>
    </div>
  </div>

  <!-- MAIN -->
  <div class="dashboard-main">

  <%-- ===== OVERVIEW ===== --%>
  <% if ("overview".equals(activeTab)) { %>
    <h2 style="font-family:'Chakra Petch',sans-serif;font-size:1.5rem;font-weight:700;margin-bottom:0.25rem;">
      สวัสดี, <%= sessFullname %> 👋
    </h2>
    <p style="color:var(--gray);font-size:0.875rem;margin-bottom:1.5rem;">วันนี้คุณพร้อมเรียนรู้สิ่งใหม่แล้วหรือยัง?</p>

    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-icon blue">📚</div>
        <div><div class="stat-value"><%= enrollCount %></div><div class="stat-label">คอร์สที่ลงทะเบียน</div></div>
      </div>
      <div class="stat-card">
        <div class="stat-icon orange">📋</div>
        <div><div class="stat-value"><%= quizDoneCount %></div><div class="stat-label">แบบทดสอบที่ทำ</div></div>
      </div>
      <div class="stat-card">
        <div class="stat-icon purple">⭐</div>
        <div><div class="stat-value"><%= String.format("%.0f", avgScore) %>%</div><div class="stat-label">คะแนนเฉลี่ย</div></div>
      </div>
    </div>

    <div class="card">
      <div class="card-header">
        <div class="card-title">คอร์สที่กำลังเรียน</div>
        <a href="courses.jsp" class="btn btn-outline btn-sm">+ เพิ่มคอร์ส</a>
      </div>
      <%
        try {
          PreparedStatement psOv = con.prepareStatement(
            "SELECT c.course_id, c.course_name FROM enrollments e JOIN courses c ON e.course_id=c.course_id WHERE e.user_id=? LIMIT 5");
          psOv.setInt(1, sessUserId);
          ResultSet rsOv = psOv.executeQuery();
          boolean anyOv = false; int ovI = 0;
          while (rsOv.next()) {
            anyOv = true;
      %>
      <div style="display:flex;align-items:center;gap:1rem;padding:1rem;border:1px solid var(--border);border-radius:var(--radius);margin-bottom:0.75rem;">
        <div style="width:44px;height:44px;background:var(--primary-light);border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:1.25rem;flex-shrink:0;"><%= courseIcons[ovI % courseIcons.length] %></div>
        <div style="flex:1;">
          <div style="font-weight:600;font-size:0.9rem;margin-bottom:4px;"><%= rsOv.getString("course_name") %></div>
          <div class="progress-bar"><div class="progress-fill" style="width:40%;"></div></div>
        </div>
        <a href="classroom.jsp?id=<%= rsOv.getInt("course_id") %>" class="btn btn-primary btn-sm">เรียนต่อ</a>
      </div>
      <%    ovI++; }
          if (!anyOv) { %>
      <div style="text-align:center;padding:2rem;color:var(--gray);">
        <div style="font-size:2rem;margin-bottom:0.5rem;">📚</div>
        ยังไม่ได้ลงทะเบียนคอร์สใด &nbsp; <a href="courses.jsp" style="color:var(--primary);">เลือกคอร์สเรียน</a>
      </div>
      <%  }
          rsOv.close(); psOv.close();
        } catch (Exception e) {
          out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
        }
      %>
    </div>

  <%-- ===== MY COURSES ===== --%>
  <% } else if ("mycourses".equals(activeTab)) { %>
    <h2 style="font-family:'Chakra Petch',sans-serif;font-size:1.5rem;font-weight:700;margin-bottom:1.5rem;">คอร์สของฉัน</h2>
    <div class="grid-3">
    <%
      try {
        PreparedStatement psMc = con.prepareStatement(
          "SELECT c.course_id, c.course_name FROM enrollments e JOIN courses c ON e.course_id=c.course_id WHERE e.user_id=?");
        psMc.setInt(1, sessUserId);
        ResultSet rsMc = psMc.executeQuery();
        boolean anyMc = false; int mcI = 0;
        while (rsMc.next()) {
          anyMc = true;
    %>
      <div class="course-card">
        <div class="course-thumb <%= courseColors[mcI % courseColors.length] %>">
          <span><%= courseIcons[mcI % courseIcons.length] %></span>
        </div>
        <div class="course-body">
          <div class="course-title"><%= rsMc.getString("course_name") %></div>
          <div class="progress-label" style="margin-bottom:4px;"><span>ความก้าวหน้า</span><span>—</span></div>
          <div class="progress-bar" style="margin-bottom:1rem;"><div class="progress-fill" style="width:40%;"></div></div>
          <a href="classroom.jsp?id=<%= rsMc.getInt("course_id") %>" class="btn btn-primary" style="width:100%;justify-content:center;">เรียนต่อ</a>
        </div>
      </div>
    <%      mcI++;
        }
        if (!anyMc) {
    %>
      <div style="grid-column:1/-1;text-align:center;padding:3rem;color:var(--gray);">
        <div style="font-size:3rem;margin-bottom:1rem;">📚</div>
        ยังไม่ได้ลงทะเบียนคอร์สใด <a href="courses.jsp" style="color:var(--primary);">เลือกคอร์สเรียน</a>
      </div>
    <%  }
        rsMc.close(); psMc.close();
      } catch (Exception e) {
        out.println("<div class='alert alert-danger' style='grid-column:1/-1;'>Error: " + e.getMessage() + "</div>");
      }
    %>
    </div>

  <%-- ===== HISTORY ===== --%>
  <% } else if ("history".equals(activeTab)) { %>
    <h2 style="font-family:'Chakra Petch',sans-serif;font-size:1.5rem;font-weight:700;margin-bottom:1.5rem;">ประวัติการเรียน</h2>
    <div class="table-wrapper">
      <table>
        <thead>
          <tr><th>#</th><th>คอร์ส</th><th>สถานะ</th><th></th></tr>
        </thead>
        <tbody>
        <%
          try {
            PreparedStatement psHi = con.prepareStatement(
              "SELECT c.course_id, c.course_name FROM enrollments e JOIN courses c ON e.course_id=c.course_id WHERE e.user_id=? ORDER BY e.enroll_id DESC");
            psHi.setInt(1, sessUserId);
            ResultSet rsHi = psHi.executeQuery();
            int rn = 1; boolean anyHi = false;
            while (rsHi.next()) {
              anyHi = true;
        %>
          <tr>
            <td><%= rn %></td>
            <td><strong><%= rsHi.getString("course_name") %></strong></td>
            <td><span class="badge badge-info">กำลังเรียน</span></td>
            <td><a href="classroom.jsp?id=<%= rsHi.getInt("course_id") %>" class="btn btn-primary btn-sm">เรียนต่อ</a></td>
          </tr>
        <%      rn++;
            }
            if (!anyHi) { %>
          <tr><td colspan="4" style="text-align:center;color:var(--gray);padding:2rem;">ยังไม่มีประวัติการเรียน</td></tr>
        <%  }
            rsHi.close(); psHi.close();
          } catch (Exception e) { %>
          <tr><td colspan="4"><div class="alert alert-danger">Error: <%= e.getMessage() %></div></td></tr>
        <% } %>
        </tbody>
      </table>
    </div>

  <%-- ===== RESULTS ===== --%>
  <% } else if ("results".equals(activeTab)) { %>
    <h2 style="font-family:'Chakra Petch',sans-serif;font-size:1.5rem;font-weight:700;margin-bottom:1.5rem;">ประวัติการทดสอบ</h2>
    <div class="table-wrapper">
      <table>
        <thead>
          <tr><th>#</th><th>แบบทดสอบ</th><th>คอร์ส</th><th>คะแนน</th><th>ผล</th></tr>
        </thead>
        <tbody>
        <%
          try {
            PreparedStatement psRe = con.prepareStatement(
              "SELECT r.score, q.quiz_title, c.course_name " +
              "FROM results r " +
              "JOIN quizzes q ON r.quiz_id=q.quiz_id " +
              "JOIN courses c ON q.course_id=c.course_id " +
              "WHERE r.user_id=? ORDER BY r.result_id DESC");
            psRe.setInt(1, sessUserId);
            ResultSet rsRe = psRe.executeQuery();
            int rn = 1; boolean anyRe = false;
            while (rsRe.next()) {
              anyRe = true;
              int sc = rsRe.getInt("score");
              String bClass = sc >= 60 ? "badge-success" : "badge-danger";
              String bText  = sc >= 60 ? "ผ่าน" : "ไม่ผ่าน";
        %>
          <tr>
            <td><%= rn %></td>
            <td><%= rsRe.getString("quiz_title") %></td>
            <td><%= rsRe.getString("course_name") %></td>
            <td><strong><%= sc %>%</strong></td>
            <td><span class="badge <%= bClass %>"><%= bText %></span></td>
          </tr>
        <%      rn++;
            }
            if (!anyRe) { %>
          <tr><td colspan="5" style="text-align:center;color:var(--gray);padding:2rem;">ยังไม่มีประวัติการทดสอบ</td></tr>
        <%  }
            rsRe.close(); psRe.close();
          } catch (Exception e) { %>
          <tr><td colspan="5"><div class="alert alert-danger">Error: <%= e.getMessage() %></div></td></tr>
        <% } %>
        </tbody>
      </table>
    </div>

  <%-- ===== PROFILE ===== --%>
  <% } else if ("profile".equals(activeTab)) { %>
    <h2 style="font-family:'Chakra Petch',sans-serif;font-size:1.5rem;font-weight:700;margin-bottom:1.5rem;">โปรไฟล์</h2>
    <% if ("success".equals(profileMsg)) { %>
      <div class="alert alert-success">✅ อัปเดตข้อมูลสำเร็จ</div>
    <% } else if (!profileMsg.isEmpty()) { %>
      <div class="alert alert-danger">⚠️ <%= profileMsg %></div>
    <% } %>
    <div class="card" style="max-width:560px;">
      <div style="text-align:center;margin-bottom:2rem;">
        <div class="avatar" style="width:80px;height:80px;font-size:2rem;margin:0 auto 1rem;"><%= sessInitial %></div>
        <div style="font-weight:700;font-size:1.1rem;"><%= sessFullname %></div>
        <div style="color:var(--gray);font-size:0.875rem;">@<%= sessUsername %></div>
      </div>
      <form method="POST" action="dashboard.jsp?tab=profile" accept-charset="UTF-8">
        <div class="form-group">
          <label class="form-label">ชื่อผู้ใช้</label>
          <input class="form-control" value="<%= sessUsername %>" readonly
            style="background:var(--bg);cursor:not-allowed;">
        </div>
        <div class="form-group">
          <label class="form-label">ชื่อ-นามสกุล</label>
          <input class="form-control" name="fullname" value="<%= sessFullname %>" required>
        </div>
        <div class="form-group">
          <label class="form-label">เปลี่ยนรหัสผ่าน (เว้นว่างถ้าไม่ต้องการเปลี่ยน)</label>
          <input class="form-control" type="password" name="new_password" placeholder="รหัสผ่านใหม่">
        </div>
        <button type="submit" class="btn btn-primary">💾 บันทึกการเปลี่ยนแปลง</button>
      </form>
    </div>
  <% } %>

  </div><%-- end dashboard-main --%>
</div><%-- end dashboard-layout --%>

<% if (con != null) try { con.close(); } catch (Exception ex) {} %>
</body>
</html>