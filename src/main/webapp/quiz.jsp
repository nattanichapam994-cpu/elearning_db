<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*,java.util.*" %>
<%
  Integer sessUserId = (Integer) session.getAttribute("userId");
  if (sessUserId == null) { response.sendRedirect("login.jsp"); return; }

  final String DB_URL  = "jdbc:mysql://localhost:3306/elearning_db?useSSL=false&serverTimezone=Asia/Bangkok&characterEncoding=UTF-8";
  final String DB_USER = "root";
  final String DB_PASS = "";

  int quizId = 0, courseId = 0;
  String quizType = request.getParameter("type");
  if (quizType == null) quizType = "post";
  try { quizId   = Integer.parseInt(request.getParameter("quiz_id")); }   catch (Exception e) {}
  try { courseId = Integer.parseInt(request.getParameter("course_id")); } catch (Exception e) {}

  String quizTitle = "";
  // question_id -> question_text
  List<Integer>       qIds   = new ArrayList<Integer>();
  List<String>        qTexts = new ArrayList<String>();
  // choice_id -> choice_text
  List<List<Integer>> cIds   = new ArrayList<List<Integer>>();
  List<List<String>>  cTexts = new ArrayList<List<String>>();
  List<Integer>       cCorr  = new ArrayList<Integer>(); // index of correct choice per question

  Connection con = null;
  try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

    PreparedStatement psQ = con.prepareStatement("SELECT quiz_title FROM quizzes WHERE quiz_id=?");
    psQ.setInt(1, quizId);
    ResultSet rsQ = psQ.executeQuery();
    if (rsQ.next()) quizTitle = rsQ.getString("quiz_title");
    rsQ.close(); psQ.close();

    PreparedStatement psQst = con.prepareStatement(
      "SELECT question_id, question_text FROM questions WHERE quiz_id=? ORDER BY question_id");
    psQst.setInt(1, quizId);
    ResultSet rsQst = psQst.executeQuery();
    while (rsQst.next()) {
      int qid = rsQst.getInt("question_id");
      qIds.add(qid);
      qTexts.add(rsQst.getString("question_text"));

      List<Integer> cidList  = new ArrayList<Integer>();
      List<String>  ctxtList = new ArrayList<String>();
      int corrIdx = 0, ci = 0;
      PreparedStatement psCh = con.prepareStatement(
        "SELECT choice_id, choice_text, is_correct FROM choices WHERE question_id=? ORDER BY choice_id");
      psCh.setInt(1, qid);
      ResultSet rsCh = psCh.executeQuery();
      while (rsCh.next()) {
        cidList.add(rsCh.getInt("choice_id"));
        ctxtList.add(rsCh.getString("choice_text"));
        if (rsCh.getBoolean("is_correct")) corrIdx = ci;
        ci++;
      }
      rsCh.close(); psCh.close();
      cIds.add(cidList);
      cTexts.add(ctxtList);
      cCorr.add(corrIdx);
    }
    rsQst.close(); psQst.close();
  } catch (Exception e) {
    // handle below
  }

  // POST: grade and save
  if ("POST".equals(request.getMethod())) {
    int correctCount = 0;
    int total = qIds.size();
    for (int i = 0; i < total; i++) {
      String ans = request.getParameter("q_" + qIds.get(i));
      if (ans != null) {
        List<Integer> cil = cIds.get(i);
        int corrChoiceId = (cCorr.get(i) < cil.size()) ? cil.get(cCorr.get(i)) : -1;
        if (ans.equals(String.valueOf(corrChoiceId))) correctCount++;
      }
    }
    int score = (total > 0) ? (correctCount * 100 / total) : 0;
    try {
      PreparedStatement psR = con.prepareStatement(
        "INSERT INTO results (user_id, quiz_id, score) VALUES (?,?,?)");
      psR.setInt(1, sessUserId);
      psR.setInt(2, quizId);
      psR.setInt(3, score);
      psR.executeUpdate();
      psR.close();
    } catch (Exception e) {}
    if (con != null) try { con.close(); } catch (Exception ex) {}
    response.sendRedirect("quiz_result.jsp?score=" + score + "&correct=" + correctCount + "&total=" + total + "&course_id=" + courseId);
    return;
  }

  request.setAttribute("currentPage", "courses");
  String[] letters = {"A","B","C","D","E","F"};
%>
<!DOCTYPE html>
<html lang="th">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><%= quizTitle.isEmpty() ? "แบบทดสอบ" : quizTitle %> - LearnHub</title>
  <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;500;600;700;800&family=Chakra+Petch:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
<%@ include file="navbar.jspf" %>

<div class="section" style="max-width:720px;">
  <div style="background:var(--white);border-radius:var(--radius-lg);border:1px solid var(--border);overflow:hidden;">
    <div style="background:linear-gradient(135deg,var(--primary),#6366f1);padding:1.75rem 2rem;color:white;">
      <div style="font-size:0.85rem;opacity:0.8;margin-bottom:4px;">
        <%= "pre".equals(quizType) ? "📋 แบบทดสอบก่อนเรียน (Pre-Test)" : "✅ แบบทดสอบหลังเรียน (Post-Test)" %>
      </div>
      <div style="font-weight:700;font-size:1.15rem;"><%= quizTitle.isEmpty() ? "แบบทดสอบ" : quizTitle %></div>
      <div style="font-size:0.85rem;opacity:0.75;margin-top:4px;"><%= qIds.size() %> ข้อ</div>
    </div>

    <% if (qIds.isEmpty()) { %>
    <div style="padding:3rem;text-align:center;color:var(--gray);">
      <div style="font-size:2.5rem;margin-bottom:1rem;">📋</div>
      <div>ยังไม่มีคำถามในแบบทดสอบนี้</div>
      <a href="classroom.jsp?id=<%= courseId %>" class="btn btn-outline" style="margin-top:1rem;">← กลับ</a>
    </div>
    <% } else { %>
    <form method="POST" action="quiz.jsp?quiz_id=<%= quizId %>&course_id=<%= courseId %>&type=<%= quizType %>">
      <div style="padding:2rem;">
      <% for (int qi = 0; qi < qIds.size(); qi++) {
           List<String> cTList = cTexts.get(qi);
           List<Integer> cIList = cIds.get(qi);
      %>
        <div style="margin-bottom:2rem;padding-bottom:2rem;border-bottom:1px solid var(--border);">
          <div style="font-weight:700;font-size:1rem;margin-bottom:1rem;">
            <span style="color:var(--primary);margin-right:6px;"><%= (qi+1) %>.</span>
            <%= qTexts.get(qi) %>
          </div>
          <% for (int ci = 0; ci < cTList.size(); ci++) { %>
          <label style="display:flex;align-items:center;gap:12px;padding:0.875rem 1.25rem;border:2px solid var(--border);border-radius:var(--radius);cursor:pointer;margin-bottom:0.5rem;transition:border-color 0.15s,background 0.15s;"
            onmouseover="this.style.borderColor='var(--primary)';this.style.background='var(--primary-light)'"
            onmouseout="if(!this.querySelector('input').checked){this.style.borderColor='var(--border)';this.style.background='white'}">
            <input type="radio" name="q_<%= qIds.get(qi) %>" value="<%= cIList.get(ci) %>" required
              style="display:none;"
              onchange="selectChoice(this)">
            <div style="width:28px;height:28px;border-radius:6px;background:var(--bg);display:flex;align-items:center;justify-content:center;font-size:0.8rem;font-weight:700;flex-shrink:0;"><%= letters[ci < letters.length ? ci : ci % letters.length] %></div>
            <span style="font-size:0.9rem;"><%= cTList.get(ci) %></span>
          </label>
          <% } %>
        </div>
      <% } %>
      </div>
      <div style="padding:1.25rem 2rem;border-top:1px solid var(--border);display:flex;justify-content:space-between;align-items:center;">
        <a href="classroom.jsp?id=<%= courseId %>" class="btn btn-outline">← ยกเลิก</a>
        <button type="submit" class="btn btn-primary">ส่งคำตอบ 🎯</button>
      </div>
    </form>
    <% } %>
  </div>
</div>

<% if (con != null) try { con.close(); } catch (Exception ex) {} %>

<script>
function selectChoice(radio) {
  document.querySelectorAll('input[name="' + radio.name + '"]').forEach(function(r) {
    var lbl = r.closest('label');
    lbl.style.borderColor = 'var(--border)';
    lbl.style.background  = 'white';
  });
  var lbl = radio.closest('label');
  lbl.style.borderColor = 'var(--primary)';
  lbl.style.background  = 'var(--primary-light)';
}
</script>
</body>
</html>
