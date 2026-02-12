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
        body { background-color: #f4f7f6; font-family: 'Segoe UI', sans-serif; }
        .main-card { border: none; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        .table-container { background: white; border-radius: 12px; padding: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        .content-preview { max-width: 200px; display: inline-block; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; vertical-align: bottom; }
    </style>
</head>
<body class="container mt-5 pb-5">

    <div class="mb-4">
        <h2 class="fw-bold text-dark">📖 Lessons Management</h2>
    </div>

    <div class="card main-card p-4 mb-4">
        <h5 id="form-title" class="text-primary mb-3">Add New Lesson</h5>
        <form action="lessons_admin.jsp?action=save" method="post">
            <input type="hidden" name="lesson_id" id="lesson_id">
            <div class="row g-3">
                <div class="col-md-4">
                    <label class="form-label fw-bold">Select Course</label>
                    <select name="course_id" id="course_id" class="form-select" required>
                        <option value="">-- Select Course --</option>
                        <%
                            Statement stmtC = conn.createStatement();
                            ResultSet rsC = stmtC.executeQuery("SELECT course_id, course_name FROM courses ORDER BY course_name ASC");
                            while(rsC.next()) {
                        %>
                            <option value="<%= rsC.getInt("course_id") %>">
                                <%= rsC.getString("course_name") %>
                            </option>
                        <% } %>
                    </select>
                </div>
                <div class="col-md-8">
                    <label class="form-label fw-bold">Lesson Title</label>
                    <input type="text" name="lesson_title" id="lesson_title" class="form-control" placeholder="E.g. Introduction to Java" required>
                </div>
                <div class="col-12">
                    <label class="form-label fw-bold">Lesson Content</label>
                    <textarea name="lesson_content" id="lesson_content" class="form-control" rows="4" placeholder="Enter detailed content here..." required></textarea>
                </div>
                <div class="col-12 text-end">
                    <span id="cancel-edit" style="display:none;" class="me-3">
                        <a href="lessons_admin.jsp" class="text-danger text-decoration-none">Cancel Edit</a>
                    </span>
                    <button type="submit" id="submit-btn" class="btn btn-primary px-5 fw-bold">Save Lesson</button>
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
                    <th>Content Preview</th>
                    <th class="text-center">Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    String sql = "SELECT l.*, c.course_name FROM lessons l " +
                                 "LEFT JOIN courses c ON l.course_id = c.course_id " +
                                 "ORDER BY l.lesson_id DESC";
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery(sql);
                    while(rs.next()) {
                        String rawContent = rs.getString("lesson_content");
                        String safeContent = rawContent.replace("'", "\\'").replace("\n", " ").replace("\r", " ");
                %>
                <tr>
                    <td class="text-center fw-bold"><%= rs.getInt("lesson_id") %></td>
                    <td><span class="badge bg-light text-dark border">ID: <%= rs.getInt("course_id") %></span> <%= rs.getString("course_name") %></td>
                    <td><%= rs.getString("lesson_title") %></td>
                    <td>
                        <span class="content-preview text-muted small"><%= rawContent %></span>
                        <button class="btn btn-link btn-sm p-0 ms-1" onclick="viewFullContent('<%= safeContent %>')">View</button>
                    </td>
                    <td class="text-center">
                        <div class="btn-group">
                            <button class="btn btn-warning btn-sm" 
                                    onclick="prepareEdit('<%= rs.getInt("lesson_id") %>', '<%= rs.getInt("course_id") %>', '<%= rs.getString("lesson_title") %>', '<%= safeContent %>')">
                                Edit
                            </button>
                            <a href="lessons_admin.jsp?action=delete&id=<%= rs.getInt("lesson_id") %>" 
                               class="btn btn-danger btn-sm" 
                               onclick="return confirm('Delete this lesson?')">Delete</a>
                        </div>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <div class="modal fade" id="contentModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Full Lesson Content</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div id="full-content-area" style="white-space: pre-wrap;"></div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function prepareEdit(id, course, title, content) {
            document.getElementById('lesson_id').value = id;
            document.getElementById('course_id').value = course;
            document.getElementById('lesson_title').value = title;
            document.getElementById('lesson_content').value = content;
            document.getElementById('form-title').innerText = "Edit Lesson (ID: " + id + ")";
            document.getElementById('submit-btn').className = "btn btn-success px-5 fw-bold";
            document.getElementById('cancel-edit').style.display = "inline";
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }

        function viewFullContent(content) {
            document.getElementById('full-content-area').innerText = content;
            var myModal = new bootstrap.Modal(document.getElementById('contentModal'));
            myModal.show();
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