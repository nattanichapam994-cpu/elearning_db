<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
  Integer sessUserId = (Integer) session.getAttribute("userId");
  if (sessUserId == null) { response.sendRedirect("login.jsp"); return; }

  final String DB_URL  = "jdbc:mysql://localhost:3306/elearning_db?useSSL=false&serverTimezone=Asia/Bangkok&characterEncoding=UTF-8";
  final String DB_USER = "root";
  final String DB_PASS = "";

  int courseId = 0;
  try { courseId = Integer.parseInt(request.getParameter("id")); } catch (Exception e) {}
  if (courseId == 0) { response.sendRedirect("courses.jsp"); return; }

  String courseName = "";
  int preQuizId = 0, postQuizId = 0;

  Connection con = null;
  try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

    // ชื่อคอร์ส
    PreparedStatement ps = con.prepareStatement("SELECT course_name FROM courses WHERE course_id=?");
    ps.setInt(1, courseId);
    ResultSet rs = ps.executeQuery();
    if (rs.next()) courseName = rs.getString("course_name");
    rs.close(); ps.close();

    // auto enroll
    ps = con.prepareStatement("INSERT IGNORE INTO enrollments (user_id,course_id) VALUES (?,?)");
    ps.setInt(1, sessUserId); ps.setInt(2, courseId);
    ps.executeUpdate(); ps.close();

    // หา quiz ก่อน/หลัง
    ps = con.prepareStatement("SELECT quiz_id, quiz_title FROM quizzes WHERE course_id=?");
    ps.setInt(1, courseId);
    rs = ps.executeQuery();
    while (rs.next()) {
      String t = rs.getString("quiz_title").toLowerCase();
      if (t.contains("ก่อน") || t.contains("pre") || t.contains("กอน")) {
        preQuizId = rs.getInt("quiz_id");
      } else {
        postQuizId = rs.getInt("quiz_id");
      }
    }
    rs.close(); ps.close();
  } catch (Exception e) {
    courseName = "ไม่พบคอร์ส";
  }

  request.setAttribute("currentPage", "courses");
%>
<!DOCTYPE html>
<html lang="th">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><%= courseName %> - LearnHub</title>
  <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;500;600;700;800&family=Chakra+Petch:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
<%@ include file="navbar.jspf" %>

<div class="section">
  <!-- Back + Title -->
  <div style="margin-bottom:1.5rem;display:flex;align-items:center;gap:10px;">
    <a href="courses.jsp" class="btn btn-outline btn-sm">← กลับ</a>
    <div>
      <h2 style="font-size:1.2rem;font-weight:700;"><%= courseName %></h2>
      <p style="font-size:0.8rem;color:var(--gray);">คอร์ส ID: <%= courseId %></p>
    </div>
  </div>

  <!-- Pre-test alert -->
  <% if (preQuizId > 0) { %>
  <div style="background:linear-gradient(135deg,#fff7ed,#fffbeb);border:1.5px solid #fed7aa;border-radius:var(--radius);padding:1.25rem;margin-bottom:1.5rem;display:flex;align-items:center;gap:12px;">
    <span style="font-size:1.5rem;">📋</span>
    <div style="flex:1;">
      <div style="font-weight:700;color:#92400e;">ทำแบบทดสอบก่อนเรียน (Pre-Test)</div>
      <div style="font-size:0.8rem;color:#b45309;margin-top:2px;">วัดความรู้เดิมก่อนเริ่มบทเรียน</div>
    </div>
    <a href="quiz.jsp?quiz_id=<%= preQuizId %>&course_id=<%= courseId %>&type=pre"
       class="btn btn-accent btn-sm">ทำแบบทดสอบ</a>
  </div>
  <% } %>

  <div style="display:grid;grid-template-columns:1fr 320px;gap:1.5rem;">

    <!-- LEFT -->
    <div>
      <!-- Video -->
      <div style="background:linear-gradient(135deg,#1e3a8a,#312e81);border-radius:var(--radius-lg);aspect-ratio:16/9;display:flex;flex-direction:column;align-items:center;justify-content:center;cursor:pointer;position:relative;overflow:hidden;"
        onclick="this.innerHTML='<div style=padding:2rem;color:white;text-align:center;font-size:1rem>▶ กำลังเล่นวิดีโอ...</div>'">
        <div style="width:70px;height:70px;background:rgba(255,255,255,0.15);border:2px solid rgba(255,255,255,0.3);border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:1.75rem;">▶</div>
        <div style="color:rgba(255,255,255,0.7);font-size:0.875rem;margin-top:1rem;">คลิกเพื่อเล่นวิดีโอ</div>
      </div>

      <!-- Tabs -->
      <div style="margin-top:1.25rem;">
        <div class="tabs">
          <div class="tab active" onclick="showTab(this,'tab-overview')">ภาพรวม</div>
          <div class="tab" onclick="showTab(this,'tab-materials')">เอกสาร</div>
          <div class="tab" onclick="showTab(this,'tab-upload')">ส่งงาน</div>
          <div class="tab" onclick="showTab(this,'tab-notes')">โน้ต</div>
        </div>

        <div class="tab-pane active" id="tab-overview">
          <div class="card">
            <h3 style="font-weight:700;margin-bottom:0.75rem;">เกี่ยวกับคอร์สนี้</h3>
            <p style="color:var(--gray);line-height:1.8;font-size:0.9rem;">
              คอร์สนี้ออกแบบมาให้ผู้เรียนได้รับความรู้และทักษะที่จำเป็น
              สามารถนำไปประยุกต์ใช้งานได้จริง
            </p>
            <div style="margin-top:1.25rem;">
              <div style="font-weight:700;margin-bottom:0.75rem;">วัตถุประสงค์</div>
              <div style="display:flex;flex-direction:column;gap:6px;">
                <div style="display:flex;align-items:center;gap:8px;font-size:0.875rem;"><span style="color:var(--success);">✓</span> เข้าใจแนวคิดพื้นฐาน</div>
                <div style="display:flex;align-items:center;gap:8px;font-size:0.875rem;"><span style="color:var(--success);">✓</span> ปฏิบัติงานได้อย่างถูกต้อง</div>
                <div style="display:flex;align-items:center;gap:8px;font-size:0.875rem;"><span style="color:var(--success);">✓</span> นำความรู้ไปประยุกต์ใช้ได้จริง</div>
              </div>
            </div>
          </div>
        </div>

        <div class="tab-pane" id="tab-materials">
          <div class="card">
            <div class="card-header"><div class="card-title">เอกสารและไฟล์ประกอบการเรียน</div></div>
            <div style="display:flex;flex-direction:column;gap:0.75rem;">
              <div style="display:flex;align-items:center;gap:12px;padding:1rem;border:1px solid var(--border);border-radius:var(--radius);">
                <span style="font-size:1.5rem;">📄</span>
                <div style="flex:1;"><div style="font-weight:600;font-size:0.875rem;">สไลด์ประกอบการสอน</div><div style="font-size:0.75rem;color:var(--gray);">PDF</div></div>
                <button class="btn btn-outline btn-sm" onclick="alert('ฟีเจอร์นี้ใช้งานในระบบจริง')">ดาวน์โหลด</button>
              </div>
              <div style="display:flex;align-items:center;gap:12px;padding:1rem;border:1px solid var(--border);border-radius:var(--radius);">
                <span style="font-size:1.5rem;">💾</span>
                <div style="flex:1;"><div style="font-weight:600;font-size:0.875rem;">ไฟล์ตัวอย่าง</div><div style="font-size:0.75rem;color:var(--gray);">ZIP</div></div>
                <button class="btn btn-outline btn-sm" onclick="alert('ฟีเจอร์นี้ใช้งานในระบบจริง')">ดาวน์โหลด</button>
              </div>
            </div>
          </div>
        </div>

        <div class="tab-pane" id="tab-upload">
          <div class="card">
            <div class="card-header"><div class="card-title">📤 ส่งงาน/ไฟล์</div></div>
            <form method="POST" action="upload.jsp" enctype="multipart/form-data">
              <input type="hidden" name="course_id" value="<%= courseId %>">
              <div class="upload-zone" onclick="document.getElementById('fileInput').click()">
                <div style="font-size:2.5rem;margin-bottom:0.75rem;">📁</div>
                <div style="font-weight:600;margin-bottom:0.25rem;">คลิกเพื่อเลือกไฟล์</div>
                <div style="font-size:0.8rem;color:var(--gray);">รองรับ PDF, DOC, ZIP ขนาดไม่เกิน 50MB</div>
              </div>
              <input type="file" id="fileInput" name="file" style="display:none;"
                onchange="document.getElementById('fnDisp').textContent=this.files[0]?'📎 '+this.files[0].name:''">
              <div id="fnDisp" style="margin-top:0.5rem;font-size:0.85rem;color:var(--primary);"></div>
              <div class="form-group" style="margin-top:1rem;">
                <label class="form-label">หมายเหตุ</label>
                <textarea name="note" class="form-control" rows="3" placeholder="เพิ่มหมายเหตุ..."></textarea>
              </div>
              <button type="submit" class="btn btn-primary btn-sm">📤 ส่งไฟล์</button>
            </form>
          </div>
        </div>

        <div class="tab-pane" id="tab-notes">
          <div class="card">
            <div class="card-header"><div class="card-title">📝 โน้ตของฉัน</div></div>
            <textarea class="form-control" rows="10" placeholder="จดโน้ตที่นี่..." id="noteArea"></textarea>
            <button class="btn btn-primary btn-sm" style="margin-top:0.75rem;" onclick="saveNote()">💾 บันทึกโน้ต</button>
          </div>
        </div>
      </div>
    </div>

    <!-- RIGHT: Lesson list -->
    <div>
      <div style="background:var(--white);border-radius:var(--radius-lg);border:1px solid var(--border);overflow:hidden;">
        <div style="padding:1.25rem;border-bottom:1px solid var(--border);font-weight:700;">📚 บทเรียน</div>
      <%
        try {
          PreparedStatement psL = con.prepareStatement(
            "SELECT lesson_id, lesson_title FROM lessons WHERE course_id=? ORDER BY lesson_id");
          psL.setInt(1, courseId);
          ResultSet rsL = psL.executeQuery();
          int ln = 1;
          boolean firstL = true;
          boolean anyL = false;
          while (rsL.next()) {
            anyL = true;
            String bgStyle = firstL ? "background:var(--primary-light);" : "";
            String numBg   = firstL ? "background:var(--primary);color:white;" : "background:var(--bg);color:var(--gray);";
            firstL = false;
      %>
        <div style="<%= bgStyle %>display:flex;align-items:center;gap:12px;padding:0.875rem 1.25rem;border-bottom:1px solid var(--border);cursor:pointer;"
          onmouseover="this.style.background='var(--bg)'"
          onmouseout="this.style.background='<%= ln == 1 ? "var(--primary-light)" : "" %>'">
          <div style="width:28px;height:28px;border-radius:6px;<%= numBg %>display:flex;align-items:center;justify-content:center;font-size:0.75rem;font-weight:700;flex-shrink:0;"><%= ln %></div>
          <div style="font-size:0.875rem;font-weight:600;"><%= rsL.getString("lesson_title") %></div>
        </div>
      <%
            ln++;
          }
          rsL.close(); psL.close();
          if (!anyL) {
      %>
        <div style="padding:2rem;text-align:center;color:var(--gray);font-size:0.875rem;">ยังไม่มีบทเรียน</div>
      <%  } %>
      <% } catch (Exception e) { %>
        <div style="padding:1rem;font-size:0.8rem;color:var(--danger);">Error: <%= e.getMessage() %></div>
      <% } %>
      </div>

      <!-- Post-test button -->
      <% if (postQuizId > 0) { %>
      <a href="quiz.jsp?quiz_id=<%= postQuizId %>&course_id=<%= courseId %>&type=post"
         class="btn btn-success" style="width:100%;justify-content:center;margin-top:1rem;">
        ✅ ทำแบบทดสอบหลังเรียน
      </a>
      <% } %>

      <!-- Progress -->
      <div class="card" style="margin-top:1rem;">
        <div class="card-title" style="margin-bottom:0.75rem;">ความก้าวหน้า</div>
        <div class="progress-label"><span>การเรียน</span><span>—</span></div>
        <div class="progress-bar"><div class="progress-fill" style="width:30%;"></div></div>
      </div>
    </div>
  </div>
</div>

<% if (con != null) try { con.close(); } catch (Exception ex) {} %>

<script>
function showTab(el, id) {
  document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
  document.querySelectorAll('.tab-pane').forEach(t => t.classList.remove('active'));
  el.classList.add('active');
  document.getElementById(id).classList.add('active');
}
function saveNote() {
  localStorage.setItem('note_c<%= courseId %>', document.getElementById('noteArea').value);
  alert('บันทึกโน้ตแล้ว');
}
window.onload = function() {
  var n = localStorage.getItem('note_c<%= courseId %>');
  if (n) document.getElementById('noteArea').value = n;
};
</script>
</body>
</html>
