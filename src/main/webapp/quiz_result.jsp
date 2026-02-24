<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  Integer sessUserId = (Integer) session.getAttribute("userId");
  if (sessUserId == null) { response.sendRedirect("login.jsp"); return; }

  int score = 0, correct = 0, total = 0, courseId = 0;
  try { score    = Integer.parseInt(request.getParameter("score"));    } catch (Exception e) {}
  try { correct  = Integer.parseInt(request.getParameter("correct")); } catch (Exception e) {}
  try { total    = Integer.parseInt(request.getParameter("total"));    } catch (Exception e) {}
  try { courseId = Integer.parseInt(request.getParameter("course_id")); } catch (Exception e) {}

  String emoji, title, sub;
  if (score >= 80) {
    emoji = "🎉"; title = "ยอดเยี่ยม!"; sub = "คุณทำแบบทดสอบได้ดีมาก คะแนน " + score + "%";
  } else if (score >= 60) {
    emoji = "👍"; title = "ดี!"; sub = "คุณผ่านการทดสอบ คะแนน " + score + "%";
  } else {
    emoji = "📖"; title = "ลองใหม่อีกครั้ง"; sub = "ยังต้องทบทวนเพิ่มเติม คะแนน " + score + "%";
  }

  request.setAttribute("currentPage", "courses");
%>
<!DOCTYPE html>
<html lang="th">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>ผลการทดสอบ - LearnHub</title>
  <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;500;600;700;800&family=Chakra+Petch:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
<%@ include file="navbar.jspf" %>

<div class="section" style="max-width:500px;">
  <div class="card" style="text-align:center;padding:3rem 2.5rem;">
    <div style="font-size:3.5rem;margin-bottom:1rem;"><%= emoji %></div>
    <h2 style="font-family:'Chakra Petch',sans-serif;margin-bottom:0.5rem;"><%= title %></h2>
    <p style="color:var(--gray);margin-bottom:2rem;"><%= sub %></p>

    <div style="width:120px;height:120px;border-radius:50%;background:linear-gradient(135deg,var(--primary),#6366f1);display:flex;flex-direction:column;align-items:center;justify-content:center;margin:0 auto 2rem;">
      <div style="font-family:'Chakra Petch',sans-serif;font-size:1.75rem;font-weight:700;color:white;"><%= score %>%</div>
      <div style="font-size:0.7rem;color:rgba(255,255,255,0.7);">คะแนน</div>
    </div>

    <div style="display:grid;grid-template-columns:1fr 1fr 1fr;gap:1rem;margin-bottom:2rem;">
      <div style="padding:1rem;background:var(--bg);border-radius:var(--radius);text-align:center;">
        <div style="font-family:'Chakra Petch',sans-serif;font-size:1.5rem;font-weight:700;color:var(--success);"><%= correct %></div>
        <div style="font-size:0.75rem;color:var(--gray);">ถูก</div>
      </div>
      <div style="padding:1rem;background:var(--bg);border-radius:var(--radius);text-align:center;">
        <div style="font-family:'Chakra Petch',sans-serif;font-size:1.5rem;font-weight:700;color:var(--danger);"><%= (total - correct) %></div>
        <div style="font-size:0.75rem;color:var(--gray);">ผิด</div>
      </div>
      <div style="padding:1rem;background:var(--bg);border-radius:var(--radius);text-align:center;">
        <div style="font-family:'Chakra Petch',sans-serif;font-size:1.5rem;font-weight:700;color:var(--primary);"><%= total %></div>
        <div style="font-size:0.75rem;color:var(--gray);">ทั้งหมด</div>
      </div>
    </div>

    <div style="display:flex;gap:0.75rem;flex-direction:column;">
      <% if (courseId > 0) { %>
      <a href="classroom.jsp?id=<%= courseId %>" class="btn btn-primary" style="justify-content:center;">📚 กลับไปเรียนต่อ</a>
      <% } %>
      <a href="dashboard.jsp?tab=results" class="btn btn-outline" style="justify-content:center;">📊 ดูประวัติการทดสอบ</a>
    </div>
  </div>
</div>
</body>
</html>
