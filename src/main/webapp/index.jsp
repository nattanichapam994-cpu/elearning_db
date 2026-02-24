<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
  final String DB_URL  = "jdbc:mysql://localhost:3306/elearning_db?useSSL=false&serverTimezone=Asia/Bangkok&characterEncoding=UTF-8";
  final String DB_USER = "root";
  final String DB_PASS = "";

  request.setAttribute("currentPage", "home");

  int totalStudents = 0;
  int totalCourses  = 0;
  Connection conIdx = null;
  try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conIdx = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    Statement stIdx = conIdx.createStatement();
    ResultSet rsIdx;

    rsIdx = stIdx.executeQuery("SELECT COUNT(*) FROM users WHERE role='student'");
    if (rsIdx.next()) totalStudents = rsIdx.getInt(1);
    rsIdx.close();

    rsIdx = stIdx.executeQuery("SELECT COUNT(*) FROM courses");
    if (rsIdx.next()) totalCourses = rsIdx.getInt(1);
    rsIdx.close();
    stIdx.close();
  } catch (Exception e) {
    totalStudents = 1200;
    totalCourses  = 50;
  }
%>
<!DOCTYPE html>
<html lang="th">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>LearnHub - แพลตฟอร์มเรียนออนไลน์</title>
  <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;500;600;700;800&family=Chakra+Petch:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
<%@ include file="navbar.jspf" %>

<!-- HERO -->
<section style="background:linear-gradient(135deg,#0f172a 0%,#1e3a8a 50%,#1d4ed8 100%);padding:6rem 2rem;text-align:center;color:white;position:relative;overflow:hidden;">
  <div style="position:absolute;inset:0;background:radial-gradient(ellipse at 30% 50%,rgba(99,102,241,0.15) 0%,transparent 60%);"></div>
  <div style="position:relative;max-width:700px;margin:0 auto;">
    <div style="display:inline-flex;align-items:center;gap:6px;background:rgba(245,158,11,0.2);border:1px solid rgba(245,158,11,0.4);color:#fbbf24;padding:0.375rem 1rem;border-radius:100px;font-size:0.85rem;font-weight:600;margin-bottom:1.5rem;">
      🎓 แพลตฟอร์มเรียนออนไลน์
    </div>
    <h1 style="font-family:'Chakra Petch',sans-serif;font-size:3rem;font-weight:700;line-height:1.15;margin-bottom:1.25rem;">
      เรียนรู้ไม่มี<span style="color:#fbbf24;">ขีดจำกัด</span><br>กับ LearnHub
    </h1>
    <p style="font-size:1.05rem;color:rgba(255,255,255,0.75);margin-bottom:2.5rem;line-height:1.8;">
      คอร์สเรียนคุณภาพสูง มีแบบทดสอบก่อน-หลังเรียน<br>ติดตามความก้าวหน้า และรับใบประกาศนียบัตรเมื่อเรียนจบ
    </p>
    <div style="display:flex;gap:1rem;justify-content:center;flex-wrap:wrap;">
      <a href="courses.jsp" class="btn btn-accent btn-lg">🚀 เริ่มเรียนฟรี</a>
      <a href="courses.jsp" class="btn btn-lg" style="border:1.5px solid rgba(255,255,255,0.3);color:white;background:transparent;">📖 ดูคอร์สทั้งหมด</a>
    </div>
    <div style="display:flex;justify-content:center;gap:3rem;margin-top:4rem;padding-top:3rem;border-top:1px solid rgba(255,255,255,0.1);flex-wrap:wrap;">
      <div style="text-align:center;">
        <div style="font-family:'Chakra Petch',sans-serif;font-size:2rem;font-weight:700;color:#fbbf24;"><%= totalStudents %>+</div>
        <div style="font-size:0.85rem;color:rgba(255,255,255,0.6);margin-top:4px;">นักเรียน</div>
      </div>
      <div style="text-align:center;">
        <div style="font-family:'Chakra Petch',sans-serif;font-size:2rem;font-weight:700;color:#fbbf24;"><%= totalCourses %>+</div>
        <div style="font-size:0.85rem;color:rgba(255,255,255,0.6);margin-top:4px;">คอร์สเรียน</div>
      </div>
      <div style="text-align:center;">
        <div style="font-family:'Chakra Petch',sans-serif;font-size:2rem;font-weight:700;color:#fbbf24;">98%</div>
        <div style="font-size:0.85rem;color:rgba(255,255,255,0.6);margin-top:4px;">ความพึงพอใจ</div>
      </div>
    </div>
  </div>
</section>

<!-- FEATURES -->
<section style="background:var(--white);border-bottom:1px solid var(--border);">
  <div class="section">
    <div class="section-header" style="text-align:center;">
      <h2>ทำไมต้องเรียนกับเรา?</h2>
      <p>ระบบการเรียนที่ครบครัน เพื่อการเรียนรู้ที่มีประสิทธิภาพ</p>
    </div>
    <div class="grid-4">
      <div style="text-align:center;padding:1.5rem;">
        <div style="font-size:2.5rem;margin-bottom:1rem;">📋</div>
        <div style="font-weight:700;margin-bottom:0.5rem;font-size:1rem;">Pre-Test &amp; Post-Test</div>
        <div style="font-size:0.875rem;color:var(--gray);">วัดความรู้ก่อนและหลังเรียนเพื่อติดตามพัฒนาการ</div>
      </div>
      <div style="text-align:center;padding:1.5rem;">
        <div style="font-size:2.5rem;margin-bottom:1rem;">📊</div>
        <div style="font-weight:700;margin-bottom:0.5rem;font-size:1rem;">ติดตามความก้าวหน้า</div>
        <div style="font-size:0.875rem;color:var(--gray);">ดูสถิติการเรียนและผลการทดสอบแบบ Real-time</div>
      </div>
      <div style="text-align:center;padding:1.5rem;">
        <div style="font-size:2.5rem;margin-bottom:1rem;">📁</div>
        <div style="font-weight:700;margin-bottom:0.5rem;font-size:1rem;">เนื้อหาหลากหลาย</div>
        <div style="font-size:0.875rem;color:var(--gray);">วิดีโอ เอกสาร และไฟล์ประกอบการเรียนครบครัน</div>
      </div>
      <div style="text-align:center;padding:1.5rem;">
        <div style="font-size:2.5rem;margin-bottom:1rem;">🏆</div>
        <div style="font-weight:700;margin-bottom:0.5rem;font-size:1rem;">ใบประกาศนียบัตร</div>
        <div style="font-size:0.875rem;color:var(--gray);">รับใบรับรองเมื่อเรียนจบและผ่านการทดสอบ</div>
      </div>
    </div>
  </div>
</section>

<!-- COURSES from DB -->
<div class="section">
  <div class="section-header" style="display:flex;justify-content:space-between;align-items:center;">
    <div>
      <h2>คอร์สยอดนิยม</h2>
      <p>เริ่มต้นการเรียนรู้กับคอร์สที่คัดสรรมาเพื่อคุณ</p>
    </div>
    <a href="courses.jsp" class="btn btn-outline">ดูทั้งหมด →</a>
  </div>
  <div class="grid-3">
  <%
    String[] idxColors = {"blue","green","purple"};
    String[] idxIcons  = {"💻","🌐","🗄️"};
    int idxI = 0;
    try {
      PreparedStatement psIdx = conIdx.prepareStatement(
        "SELECT c.course_id, c.course_name, " +
        "(SELECT COUNT(*) FROM lessons l WHERE l.course_id=c.course_id) AS lc, " +
        "(SELECT COUNT(*) FROM quizzes q WHERE q.course_id=c.course_id) AS qc " +
        "FROM courses c LIMIT 3");
      ResultSet rsIdx2 = psIdx.executeQuery();
      boolean anyIdx = false;
      while (rsIdx2.next()) {
        anyIdx = true;
        String cl = idxColors[idxI % idxColors.length];
        String ic = idxIcons [idxI % idxIcons.length];
  %>
    <div class="course-card">
      <div class="course-thumb <%= cl %>"><span><%= ic %></span></div>
      <div class="course-body">
        <div class="course-title"><%= rsIdx2.getString("course_name") %></div>
        <div class="course-meta">
          <span>📚 <%= rsIdx2.getInt("lc") %> บทเรียน</span>
          <span>📋 <%= rsIdx2.getInt("qc") %> แบบทดสอบ</span>
        </div>
        <a href="courses.jsp" class="btn btn-primary" style="width:100%;justify-content:center;">ดูรายละเอียด</a>
      </div>
    </div>
  <%
        idxI++;
      }
      rsIdx2.close(); psIdx.close();
      if (!anyIdx) {
  %>
    <div style="grid-column:1/-1;text-align:center;padding:2rem;color:var(--gray);">ยังไม่มีคอร์ส</div>
  <%  } %>
  <% } catch (Exception e) { %>
    <div class="card" style="grid-column:1/-1;"><div class="alert alert-danger">DB Error: <%= e.getMessage() %></div></div>
  <% } finally {
    if (conIdx != null) try { conIdx.close(); } catch (Exception ex) {}
  } %>
  </div>
</div>

</body>
</html>
