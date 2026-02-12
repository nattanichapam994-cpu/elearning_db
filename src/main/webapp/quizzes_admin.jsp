<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
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

        // ================= SAVE =================
        if ("save".equals(action)) {

            String id = request.getParameter("quiz_id");
            String courseId = request.getParameter("course_id");
            String title = request.getParameter("quiz_title");

            if (id == null || id.isEmpty()) {
                PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO quizzes (course_id, quiz_title) VALUES (?, ?)"
                );
                ps.setInt(1, Integer.parseInt(courseId));
                ps.setString(2, title);
                ps.executeUpdate();
            } else {
                PreparedStatement ps = conn.prepareStatement(
                    "UPDATE quizzes SET course_id=?, quiz_title=? WHERE quiz_id=?"
                );
                ps.setInt(1, Integer.parseInt(courseId));
                ps.setString(2, title);
                ps.setInt(3, Integer.parseInt(id));
                ps.executeUpdate();
            }

            response.sendRedirect("quizzes_admin.jsp");
            return;
        }

        // ================= DELETE =================
        else if ("delete".equals(action)) {

            String id = request.getParameter("id");

            PreparedStatement ps = conn.prepareStatement(
                "DELETE FROM quizzes WHERE quiz_id=?"
            );
            ps.setInt(1, Integer.parseInt(id));
            ps.executeUpdate();

            response.sendRedirect("quizzes_admin.jsp");
            return;
        }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quiz Management</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>

<body class="container mt-5">

<h2 class="mb-4">Quiz Management</h2>

<!-- ================= FORM ================= -->
<form action="quizzes_admin.jsp?action=save" method="post" class="card p-4 mb-4">
    <input type="hidden" name="quiz_id" id="quiz_id">

    <div class="row">
        <div class="col-md-4">
            <label>Course ID</label>
            <input type="number" name="course_id" id="course_id"
                   class="form-control" required>
        </div>

        <div class="col-md-4">
            <label>Quiz Title</label>
            <input type="text" name="quiz_title" id="quiz_title"
                   class="form-control" required>
        </div>

        <div class="col-md-4 d-flex align-items-end">
            <button type="submit" class="btn btn-primary w-100">
                Save Quiz
            </button>
        </div>
    </div>
</form>

<!-- ================= TABLE ================= -->
<table class="table table-bordered table-hover">
    <thead class="table-dark">
        <tr>
            <th>Quiz ID</th>
            <th>Course ID</th>
            <th>Quiz Title</th>
            <th>Action</th>
        </tr>
    </thead>
    <tbody>
<%
    Statement stmt = conn.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT * FROM quizzes ORDER BY quiz_id DESC");

    while (rs.next()) {
%>
        <tr>
            <td><%= rs.getInt("quiz_id") %></td>
            <td><%= rs.getInt("course_id") %></td>
            <td><%= rs.getString("quiz_title") %></td>
            <td>
                <button class="btn btn-warning btn-sm"
                        onclick="editQuiz('<%= rs.getInt("quiz_id") %>',
                                          '<%= rs.getInt("course_id") %>',
                                          '<%= rs.getString("quiz_title") %>')">
                    Edit
                </button>

                <a href="quizzes_admin.jsp?action=delete&id=<%= rs.getInt("quiz_id") %>"
                   class="btn btn-danger btn-sm"
                   onclick="return confirm('Delete this quiz?')">
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
function editQuiz(id, course, title) {
    document.getElementById("quiz_id").value = id;
    document.getElementById("course_id").value = course;
    document.getElementById("quiz_title").value = title;
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
