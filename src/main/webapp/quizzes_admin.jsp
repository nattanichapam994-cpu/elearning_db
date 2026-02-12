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
            String id = request.getParameter("quiz_id");
            String courseId = request.getParameter("course_id");
            String title = request.getParameter("quiz_title");

            if (id == null || id.isEmpty()) {
                PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO quizzes (course_id, quiz_title) VALUES (?, ?)");
                ps.setInt(1, Integer.parseInt(courseId));
                ps.setString(2, title);
                ps.executeUpdate();
            } else {
                PreparedStatement ps = conn.prepareStatement(
                    "UPDATE quizzes SET course_id=?, quiz_title=? WHERE quiz_id=?");
                ps.setInt(1, Integer.parseInt(courseId));
                ps.setString(2, title);
                ps.setInt(3, Integer.parseInt(id));
                ps.executeUpdate();
            }

            response.sendRedirect("quizzes_admin.jsp");
            return;

        } else if ("delete".equals(action)) {
            String id = request.getParameter("id");
            PreparedStatement ps = conn.prepareStatement(
                "DELETE FROM quizzes WHERE quiz_id=?");
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
    <title>Quizzes Management</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body { background-color: #f4f7f6; font-family: 'Segoe UI', sans-serif; }
        .main-card { border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        .table-container { background: white; border-radius: 12px; padding: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
    </style>
</head>

<body class="container mt-5 pb-5">

<h2 class="fw-bold mb-4">📝 Quizzes Management</h2>

<div class="card main-card p-4 mb-4">
    <h5 id="form-title" class="text-primary mb-3">Add New Quiz</h5>

    <form action="quizzes_admin.jsp?action=save" method="post">
        <input type="hidden" name="quiz_id" id="quiz_id">

        <div class="row g-3">
            <div class="col-md-6">
                <label class="form-label fw-bold">Select Course</label>
                <select name="course_id" id="course_id" class="form-select" required>
                    <option value="">-- Select Course --</option>
                    <%
                        Statement stmtC = conn.createStatement();
                        ResultSet rsC = stmtC.executeQuery(
                            "SELECT course_id, course_name FROM courses ORDER BY course_name ASC");
                        while (rsC.next()) {
                    %>
                        <option value="<%= rsC.getInt("course_id") %>">
                            <%= rsC.getString("course_name") %>
                        </option>
                    <% } %>
                </select>
            </div>

            <div class="col-md-6">
                <label class="form-label fw-bold">Quiz Title</label>
                <input type="text" name="quiz_title" id="quiz_title"
                       class="form-control" required>
            </div>

            <div class="col-12 text-end">
                <span id="cancel-edit" style="display:none;" class="me-3">
                    <a href="quizzes_admin.jsp" class="text-danger text-decoration-none">
                        Cancel Edit
                    </a>
                </span>
                <button type="submit" id="submit-btn"
                        class="btn btn-primary px-5 fw-bold">
                    Save Quiz
                </button>
            </div>
        </div>
    </form>
</div>

<div class="table-container">
    <table class="table table-hover align-middle">
        <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Course</th>
                <th>Quiz Title</th>
                <th class="text-center">Actions</th>
            </tr>
        </thead>
        <tbody>
            <%
                String sql = "SELECT q.*, c.course_name FROM quizzes q " +
                             "LEFT JOIN courses c ON q.course_id = c.course_id " +
                             "ORDER BY q.quiz_id DESC";

                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql);

                while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getInt("quiz_id") %></td>
                <td>
                    <span class="badge bg-light text-dark border">
                        ID: <%= rs.getInt("course_id") %>
                    </span>
                    <%= rs.getString("course_name") %>
                </td>
                <td><%= rs.getString("quiz_title") %></td>
                <td class="text-center">
                    <div class="btn-group">
                        <button class="btn btn-warning btn-sm"
                                onclick="prepareEdit(
                                    '<%= rs.getInt("quiz_id") %>',
                                    '<%= rs.getInt("course_id") %>',
                                    '<%= rs.getString("quiz_title") %>'
                                )">
                            Edit
                        </button>

                        <a href="quizzes_admin.jsp?action=delete&id=<%= rs.getInt("quiz_id") %>"
                           class="btn btn-danger btn-sm"
                           onclick="return confirm('Delete this quiz?')">
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
function prepareEdit(id, course, title) {
    document.getElementById("quiz_id").value = id;
    document.getElementById("course_id").value = course;
    document.getElementById("quiz_title").value = title;

    document.getElementById("form-title").innerText = "Edit Quiz (ID: " + id + ")";
    document.getElementById("submit-btn").className = "btn btn-success px-5 fw-bold";
    document.getElementById("cancel-edit").style.display = "inline";

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
