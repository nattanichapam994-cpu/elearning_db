<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
  final String DB_URL  = "jdbc:mysql://localhost:3306/elearning_db?useSSL=false&serverTimezone=Asia/Bangkok&characterEncoding=UTF-8";
  final String DB_USER = "root";
  final String DB_PASS = "";

  request.setAttribute("currentPage", "courses");
  Integer sessUserId = (Integer) session.getAttribute("userId");
%>
<!DOCTYPE html>
<html lang="th">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>คอร์สเรียน - LearnHub</title>
  <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;500;600;700;800&family=Chakra+Petch:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
<%@ include file="navbar.jspf" %>

<div class="section">
  <div class="section-header">
    <h2>คอร์สเรียนทั้งหมด</h2>
    <p>เลือกคอร์สที่คุณสนใจและเริ่มเรียนได้เลย</p>
  </div>
  <div class="grid-3">
  <%
    String[] colors = {"blue","green","purple","orange","blue","green"};
    String[] icons  = {"💻","🌐","🗄️","📱","🎨","📊"};
    Connection con = null;
    try {
      Class.forName("com.mysql.cj.jdbc.Driver");
      con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

      PreparedStatement ps = con.prepareStatement(
        "SELECT c.course_id, c.course_name, " +
        "(SELECT COUNT(*) FROM lessons l WHERE l.course_id=c.course_id) AS lc, " +
        "(SELECT COUNT(*) FROM quizzes q WHERE q.course_id=c.course_id) AS qc, " +
        "(SELECT COUNT(*) FROM enrollments e WHERE e.course_id=c.course_id) AS ec " +
        "FROM courses c ORDER BY c.course_id");
      ResultSet rs = ps.executeQuery();
      int idx = 0;
      boolean any = false;
      while (rs.next()) {
        any = true;
        int cid = rs.getInt("course_id");
        String cname = rs.getString("course_name");
        boolean enrolled = false;
        if (sessUserId != null) {
          PreparedStatement psE = con.prepareStatement(
            "SELECT 1 FROM enrollments WHERE user_id=? AND course_id=?");
          psE.setInt(1, sessUserId);
          psE.setInt(2, cid);
          ResultSet rsE = psE.executeQuery();
          enrolled = rsE.next();
          rsE.close(); psE.close();
        }
  %>
    <div class="course-card">
      <div class="course-thumb <%= colors[idx % colors.length] %>">
        <span><%= icons[idx % icons.length] %></span>
      </div>
      <div class="course-body">
        <div class="course-title"><%= cname %></div>
        <div class="course-meta">
          <span>📚 <%= rs.getInt("lc") %> บทเรียน</span>
          <span>📋 <%= rs.getInt("qc") %> แบบทดสอบ</span>
          <span>👥 <%= rs.getInt("ec") %> คน</span>
        </div>
        <% if (enrolled) { %>
          <a href="classroom.jsp?id=<%= cid %>" class="btn btn-success" style="width:100%;justify-content:center;">✅ เรียนต่อ</a>
        <% } else if (sessUserId != null) { %>
          <a href="enroll.jsp?course_id=<%= cid %>" class="btn btn-primary" style="width:100%;justify-content:center;">ลงทะเบียนเรียน</a>
        <% } else { %>
          <a href="login.jsp" class="btn btn-primary" style="width:100%;justify-content:center;">เข้าสู่ระบบเพื่อเรียน</a>
        <% } %>
      </div>
    </div>
  <%
        idx++;
      }
      if (!any) {
  %>
    <div style="grid-column:1/-1;text-align:center;padding:3rem;color:var(--gray);">
      <div style="font-size:3rem;margin-bottom:1rem;">📚</div>
      <div>ยังไม่มีคอร์สเรียน</div>
    </div>
  <%
      }
      rs.close(); ps.close();
    } catch (Exception e) {
  %>
    <div class="card" style="grid-column:1/-1;">
      <div class="alert alert-danger">เกิดข้อผิดพลาด: <%= e.getMessage() %></div>
    </div>
  <%
    } finally {
      if (con != null) try { con.close(); } catch (Exception ex) {}
    }
  %>
  </div>
</div>
</body>
</html>
