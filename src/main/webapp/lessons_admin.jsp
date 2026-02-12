<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%
    // --- 1. Database Connection Configuration ---
    String driver = "com.mysql.cj.jdbc.Driver";
    String url = "jdbc:mysql://localhost:3306/elearning_db?useUnicode=true&characterEncoding=UTF-8";
    String user = "root";
    String pass = ""; 

    Connection conn = null;
    request.setCharacterEncoding("UTF-8");

    try {
        Class.forName(driver);
        conn = DriverManager.getConnection(url, user, pass);

        // --- 2. Logic Handling (CRUD Operations) ---
        String action = request.getParameter("action");
        
        if ("save".equals(action)) {
            String id = request.getParameter("lesson_id");
            String courseId = request.getParameter("course_id");
            String title = request.getParameter("lesson_title");
            String content = request.getParameter("lesson_content");

            if (id == null || id.isEmpty()) {
                PreparedStatement ps = conn.prepareStatement("INSERT INTO lessons (course_id, lesson_title, lesson_content) VALUES (?, ?, ?)");
                ps.setInt(1, Integer.parseInt(courseId));
                ps.setString(2, title);
                ps.setString(3, content);
                ps.executeUpdate();
            } else {
                PreparedStatement ps = conn.prepareStatement("UPDATE lessons SET course_id=?, lesson_title=?, lesson_content=? WHERE lesson_id=?");
                ps.setInt(1, Integer.parseInt(courseId));
                ps.setString(2, title);
                ps.setString(3, content);
                ps.setInt(4, Integer.parseInt(id));
                ps.executeUpdate();
            }
            response.sendRedirect("lessons_admin.jsp"); 
            return;
        } else if ("delete".equals(action)) {
            String id = request.getParameter("id");
            PreparedStatement ps = conn.prepareStatement("DELETE FROM lessons WHERE lesson_id = ?");
            ps.setInt(1, Integer.parseInt(id));
            ps.executeUpdate();
            response.sendRedirect("lessons_admin.jsp");
            return;
        }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Lessons Management</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body { background-color: #f8f9fa; font-family: 'Segoe UI', sans-serif; }
        .main-card { border: none; border-radius: 12px; box-shadow: 0 4px 10px rgba(0,0,0,0.08); }
        .table-container { background: white; border-radius: 12px; padding: 20px; box-shadow: 0 4px 10px rgba(0,0,0,0.08); }
    </style>
</head>
<body class="container mt-5">

    <div class="mb-4">
        <h2 class="fw-bold">📖 Lessons Management</h2>
    </div>

    <div class="card main-card p-4 mb-4">
        <h5 id="form-title" class="text-primary mb-3">Add New Lesson</h5>
        <form action="lessons_admin.jsp?action=save" method="post">
            <input type="hidden" name="lesson_id" id="lesson_id">
            <div class="row g-3">
                <div class="col-md-4">
                    <label class="form-label">Select Course</label>
                    <select name="course_id" id="course_id" class="form-select" required>
                        <option value="">-- Select Course --</option>
                        <%
                            // ดึงรายชื่อคอร์สทั้งหมดมาทำเป็น Dropdown
                            Statement stmtCourse = conn.createStatement();
                            ResultSet rsCourse = stmtCourse.executeQuery("SELECT course_id, course_name FROM courses ORDER BY course_name ASC");
                            while(rsCourse.next()) {
                        %>
                            <option value="<%= rsCourse.getInt("course_id") %>">
                                <%= rsCourse.getString("course_name") %> (ID: <%= rsCourse.getInt("course_id") %>)
                            </option>
                        <% } %>
                    </select>
                </div>
                <div class="col-md-8">
                    <label class="form-label">Lesson Title</label>
                    <input type="text" name="lesson_title" id="lesson_title" class="form-control" required>
                </div>
                <div class="col-12">
                    <label class="form-label">Lesson Content</label>
                    <textarea name="lesson_content" id="lesson_content" class="form-control" rows="3" required></textarea>
                </div>
                <div class="col-12 text-end">
                    <span id="cancel-edit" style="display:none;" class="me-3">
                        <a href="lessons_admin.jsp" class="text-danger">Cancel Edit</a>
                    </span>
                    <button type="submit" id="submit-btn" class="btn btn-primary px-5">Save Lesson</button>
                </div>
            </div>
        </form>
    </div>

    <div class="table-container">
        <table class="table table-hover align-middle">
            <thead class="table-dark">
                <tr>
                    <th class="text-center">ID</th>
                    <th>Course Name</th>
                    <th>Lesson Title</th>
                    <th class="text-center">Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    // JOIN ตาราง courses เพื่อเอา course_name มาแสดง
                    String sql = "SELECT l.*, c.course_name FROM lessons l " +
                                 "LEFT JOIN courses c ON l.course_id = c.course_id " +
                                 "ORDER BY l.lesson_id DESC";
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery(sql);
                    while(rs.next()) {
                %>
                <tr>
                    <td class="text-center"><%= rs.getInt("lesson_id") %></td>
                    <td><span class="badge bg-secondary">ID: <%= rs.getInt("course_id") %></span> <%= rs.getString("course_name") %></td>
                    <td><%= rs.getString("lesson_title") %></td>
                    <td class="text-center">
                        <button class="btn btn-warning btn-sm" 
                                onclick="prepareEdit('<%= rs.getInt("lesson_id") %>', '<%= rs.getInt("course_id") %>', '<%= rs.getString("lesson_title") %>', '<%= rs.getString("lesson_content").replace("'", "\\'") %>')">
                            Edit
                        </button>
                        <a href="lessons_admin.jsp?action=delete&id=<%= rs.getInt("lesson_id") %>" class="btn btn-danger btn-sm" onclick="return confirm('Delete?')">Delete</a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <script>
        function prepareEdit(id, course, title, content) {
            document.getElementById('lesson_id').value = id;
            document.getElementById('course_id').value = course;
            document.getElementById('lesson_title').value = title;
            document.getElementById('lesson_content').value = content;
            document.getElementById('form-title').innerText = "Edit Lesson (ID: " + id + ")";
            document.getElementById('submit-btn').className = "btn btn-success px-5";
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