<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%
    String driver = "com.mysql.cj.jdbc.Driver";
    String url = "jdbc:mysql://localhost:3306/elearning_db?useUnicode=true&characterEncoding=UTF-8";
    String user = "root";
    String pass = ""; 

    Connection conn = null;
    request.setCharacterEncoding("UTF-8");

    try {
        Class.forName(driver);
        conn = DriverManager.getConnection(url, user, pass);

        String action = request.getParameter("action");
        
        if ("save".equals(action)) {
            String id = request.getParameter("result_id");
            String userId = request.getParameter("user_id");
            String quizId = request.getParameter("quiz_id");
            String score = request.getParameter("score");

            if (id == null || id.isEmpty()) {
                PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO results (user_id, quiz_id, score) VALUES (?, ?, ?)"
                );
                ps.setInt(1, Integer.parseInt(userId));
                ps.setInt(2, Integer.parseInt(quizId));
                ps.setInt(3, Integer.parseInt(score));
                ps.executeUpdate();
            } else {
                PreparedStatement ps = conn.prepareStatement(
                    "UPDATE results SET user_id=?, quiz_id=?, score=? WHERE result_id=?"
                );
                ps.setInt(1, Integer.parseInt(userId));
                ps.setInt(2, Integer.parseInt(quizId));
                ps.setInt(3, Integer.parseInt(score));
                ps.setInt(4, Integer.parseInt(id));
                ps.executeUpdate();
            }
            response.sendRedirect("results_admin.jsp"); 
            return;

        } else if ("delete".equals(action)) {
            String id = request.getParameter("id");
            PreparedStatement ps = conn.prepareStatement(
                "DELETE FROM results WHERE result_id = ?"
            );
            ps.setInt(1, Integer.parseInt(id));
            ps.executeUpdate();
            response.sendRedirect("results_admin.jsp");
            return;
        }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Results Management</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<style>
body { background-color: #f4f7f6; font-family: 'Segoe UI', sans-serif; }
.main-card { border: none; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
.table-container { background: white; border-radius: 12px; padding: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
</style>
</head>

<body class="container mt-5 pb-5">

<div class="mb-4">
    <h2 class="fw-bold text-dark">📝 Results Management</h2>
</div>

<!-- ================= FORM ================= -->
<div class="card main-card p-4 mb-4">
<h5 id="form-title" class="text-primary mb-3">Add New Result</h5>

<form action="results_admin.jsp?action=save" method="post">
<input type="hidden" name="result_id" id="result_id">

<div class="row g-3">

<div class="col-md-4">
<label class="form-label fw-bold">Select User</label>
<select name="user_id" id="user_id" class="form-select" required>
<option value="">-- Select User --</option>
<%
Statement stmtU = conn.createStatement();
ResultSet rsU = stmtU.executeQuery(
    "SELECT user_id, username FROM users ORDER BY username ASC"
);
while(rsU.next()){
%>
<option value="<%= rsU.getInt("user_id") %>">
<%= rsU.getString("username") %>
</option>
<% } %>
</select>
</div>

<div class="col-md-4">
<label class="form-label fw-bold">Select Quiz</label>
<select name="quiz_id" id="quiz_id" class="form-select" required>
<option value="">-- Select Quiz --</option>
<%
Statement stmtQ = conn.createStatement();
ResultSet rsQ = stmtQ.executeQuery(
    "SELECT quiz_id, quiz_title FROM quizzes ORDER BY quiz_title ASC"
);
while(rsQ.next()){
%>
<option value="<%= rsQ.getInt("quiz_id") %>">
<%= rsQ.getString("quiz_title") %>
</option>
<% } %>
</select>
</div>

<div class="col-md-4">
<label class="form-label fw-bold">Score</label>
<input type="number" name="score" id="score" class="form-control" required>
</div>

<div class="col-12 text-end">
<span id="cancel-edit" style="display:none;" class="me-3">
<a href="results_admin.jsp" class="text-danger text-decoration-none">Cancel Edit</a>
</span>
<button type="submit" id="submit-btn" class="btn btn-primary px-5 fw-bold">
Save Result
</button>
</div>

</div>
</form>
</div>

<!-- ================= TABLE ================= -->
<div class="table-container">
<table class="table table-hover align-middle">
<thead class="table-dark">
<tr>
<th class="text-center">ID</th>
<th>User</th>
<th>Quiz</th>
<th>Score</th>
<th class="text-center">Actions</th>
</tr>
</thead>

<tbody>
<%
String sql =
"SELECT r.*, u.username, q.quiz_title " +
"FROM results r " +
"LEFT JOIN users u ON r.user_id = u.user_id " +
"LEFT JOIN quizzes q ON r.quiz_id = q.quiz_id " +
"ORDER BY r.result_id DESC";

Statement stmt = conn.createStatement();
ResultSet rs = stmt.executeQuery(sql);

while(rs.next()){
%>
<tr>
<td class="text-center fw-bold"><%= rs.getInt("result_id") %></td>
<td>
<span class="badge bg-light text-dark border">
ID: <%= rs.getInt("user_id") %>
</span>
<%= rs.getString("username") %>
</td>
<td>
<span class="badge bg-light text-dark border">
ID: <%= rs.getInt("quiz_id") %>
</span>
<%= rs.getString("quiz_title") %>
</td>
<td><%= rs.getInt("score") %></td>

<td class="text-center">
<div class="btn-group">
<button class="btn btn-warning btn-sm"
onclick="prepareEdit(
'<%= rs.getInt("result_id") %>',
'<%= rs.getInt("user_id") %>',
'<%= rs.getInt("quiz_id") %>',
'<%= rs.getInt("score") %>'
)">
Edit
</button>

<a href="results_admin.jsp?action=delete&id=<%= rs.getInt("result_id") %>"
class="btn btn-danger btn-sm"
onclick="return confirm('Delete this result?')">
Delete
</a>
</div>
</td>
</tr>
<% } %>
</tbody>
</table>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
function prepareEdit(id, userId, quizId, score) {
    document.getElementById('result_id').value = id;
    document.getElementById('user_id').value = userId;
    document.getElementById('quiz_id').value = quizId;
    document.getElementById('score').value = score;

    document.getElementById('form-title').innerText =
        "Edit Result (ID: " + id + ")";

    document.getElementById('submit-btn').className =
        "btn btn-success px-5 fw-bold";

    document.getElementById('cancel-edit').style.display = "inline";

    window.scrollTo({ top: 0, behavior: 'smooth' });
}
</script>

</body>
</html>

<%
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
    } finally {
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }
%>
