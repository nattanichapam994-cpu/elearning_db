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

        // ================= SAVE (INSERT / UPDATE) =================
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

            response.sendRedirect("result_admin.jsp");
            return;
        }

        // ================= DELETE =================
        else if ("delete".equals(action)) {
            String id = request.getParameter("id");
            PreparedStatement ps = conn.prepareStatement(
                "DELETE FROM results WHERE result_id = ?"
            );
            ps.setInt(1, Integer.parseInt(id));
            ps.executeUpdate();

            response.sendRedirect("result_admin.jsp");
            return;
        }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Results Management</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>

<body class="container mt-5">

<h2 class="mb-4">Results Management</h2>

<!-- ================= FORM ================= -->
<form action="result_admin.jsp?action=save" method="post" class="card p-4 mb-4">
    <input type="hidden" name="result_id" id="result_id">

    <div class="row">
        <div class="col-md-3">
            <label>User ID</label>
            <input type="number" name="user_id" id="user_id" class="form-control" required>
        </div>

        <div class="col-md-3">
            <label>Quiz ID</label>
            <input type="number" name="quiz_id" id="quiz_id" class="form-control" required>
        </div>

        <div class="col-md-3">
            <label>Score</label>
            <input type="number" name="score" id="score" class="form-control" required>
        </div>

        <div class="col-md-3 d-flex align-items-end">
            <button type="submit" class="btn btn-primary w-100" id="submit-btn">
                Save Result
            </button>
        </div>
    </div>
</form>

<!-- ================= TABLE ================= -->
<table class="table table-bordered table-hover">
    <thead class="table-dark">
        <tr>
            <th>Result ID</th>
            <th>User ID</th>
            <th>Quiz ID</th>
            <th>Score</th>
            <th>Action</th>
        </tr>
    </thead>
    <tbody>
<%
    Statement stmt = conn.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT * FROM results ORDER BY result_id DESC");

    while (rs.next()) {
%>
        <tr>
            <td><%= rs.getInt("result_id") %></td>
            <td><%= rs.getInt("user_id") %></td>
            <td><%= rs.getInt("quiz_id") %></td>
            <td><%= rs.getInt("score") %></td>
            <td>
                <button class="btn btn-warning btn-sm"
                    onclick="editResult('<%= rs.getInt("result_id") %>',
                                        '<%= rs.getInt("user_id") %>',
                                        '<%= rs.getInt("quiz_id") %>',
                                        '<%= rs.getInt("score") %>')">
                    Edit
                </button>

                <a href="result_admin.jsp?action=delete&id=<%= rs.getInt("result_id") %>"
                   class="btn btn-danger btn-sm"
                   onclick="return confirm('Delete this record?')">
                    Delete
                </a>
            </td>
        </tr>
<%
    }
%>
    </tbody>
</table>

<script>
function editResult(id, user, quiz, score) {
    document.getElementById("result_id").value = id;
    document.getElementById("user_id").value = user;
    document.getElementById("quiz_id").value = quiz;
    document.getElementById("score").value = score;
    window.scrollTo({ top: 0, behavior: 'smooth' });
}
</script>

</body>
</html>

<%
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if (conn != null) conn.close();
    }
%>
