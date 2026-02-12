<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%
    // --- 1. Database Connection Configuration ---
    String driver = "com.mysql.cj.jdbc.Driver";
    String url = "jdbc:mysql://localhost:3306/elearning_db?useUnicode=true&characterEncoding=UTF-8";
    String user = "root";
    String pass = ""; // Enter your MySQL password here

    Connection conn = null;
    request.setCharacterEncoding("UTF-8");

    try {
        Class.forName(driver);
        conn = DriverManager.getConnection(url, user, pass);

        // --- 2. Logic Handling (CRUD Operations) ---
        String action = request.getParameter("action");
        
        // 2.1 Save Lesson (Insert or Update)
        if ("save".equals(action)) {
            String id = request.getParameter("lesson_id");
            String courseId = request.getParameter("course_id");
            String title = request.getParameter("lesson_title");
            String content = request.getParameter("lesson_content");

            if (id == null || id.isEmpty()) {
                // Insert New Lesson
                PreparedStatement ps = conn.prepareStatement("INSERT INTO lessons (course_id, lesson_title, lesson_content) VALUES (?, ?, ?)");
                ps.setInt(1, Integer.parseInt(courseId));
                ps.setString(2, title);
                ps.setString(3, content);
                ps.executeUpdate();
            } else {
                // Update Existing Lesson
                PreparedStatement ps = conn.prepareStatement("UPDATE lessons SET course_id=?, lesson_title=?, lesson_content=? WHERE lesson_id=?");
                ps.setInt(1, Integer.parseInt(courseId));
                ps.setString(2, title);
                ps.setString(3, content);
                ps.setInt(4, Integer.parseInt(id));
                ps.executeUpdate();
            }
            response.sendRedirect("lessons_admin.jsp"); 
            return;
        } 
        // 2.2 Delete Lesson
        else if ("delete".equals(action)) {
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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lessons Management</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body { background-color: #f8f9fa; font-family: 'Segoe UI', Tahoma, sans-serif; }
        .main-card { border: none; border-radius: 12px; box-shadow: 0 4px 10px rgba(0,0,0,0.08); }
        .table-container { background: white; border-radius: 12px; padding: 20px; box-shadow: 0 4px 10px rgba(0,0,0,0.08); }
        .lesson-content-cell { max-width: 250px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
    </style>
</head>
<body class="container mt-5">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold text-dark">📖 Lessons Management</h2>
        <span class="badge bg-dark">Table: lessons</span>
    </div>

    <div class="card main-card p-4 mb-4">
        <h5 id="form-title" class="text-primary mb-3">Add New Lesson</h5>
        <form action="lessons_admin.jsp?action=save" method="post">
            <input type="hidden" name="lesson_id" id="lesson_id">
            <div class="row g-3">
                <div class="col-md-3">
                    <label class="form-label">Course ID</label>
                    <input type="number" name="course_id" id="course_id" class="form-control" placeholder="Course ID" required>
                </div>
                <div class="col-md-9">
                    <label class="form-label">Lesson Title</label>
                    <input type="text" name="lesson_title" id="lesson_title" class="form-control" placeholder="Enter lesson title" required>
                </div>
                <div class="col-12">
                    <label class="form-label">Lesson Content</label>
                    <textarea name="lesson_content" id="lesson_content" class="form-control" rows="3" placeholder="Enter lesson content details..." required></textarea>
                </div>
                <div class="col-12 text-end">
                    <span id="cancel-edit" style="display:none;" class="me-3">
                        <a href="lessons_admin.jsp" class="text-decoration-none text-danger">Cancel Edit</a>
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
                    <th class="text-center" width="10%">ID</th>
                    <th class="text-center" width="10%">Course</th>
                    <th width="25%">Title</th>
                    <th width="35%">Content</th>
                    <th class="text-center" width="20%">Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT * FROM lessons ORDER BY lesson_id DESC");
                    boolean empty = true;
                    while(rs.next()) {
                        empty = false;
                %>
                <tr>
                    <td class="text-center fw-bold"><%= rs.getInt("lesson_id") %></td>
                    <td class="text-center"><span class="badge bg-info text-dark">ID: <%= rs.getInt("course_id") %></span></td>
                    <td><%= rs.getString("lesson_title") %></td>
                    <td class="lesson-content-cell text-muted"><%= rs.getString("lesson_content") %></td>
                    <td class="text-center">
                        <button class="btn btn-warning btn-sm" 
                                onclick="prepareEdit('<%= rs.getInt("lesson_id") %>', '<%= rs.getInt("course_id") %>', '<%= rs.getString("lesson_title") %>', '<%= rs.getString("lesson_content").replace("'", "\\'") %>')">
                            Edit
                        </button>
                        <a href="lessons_admin.jsp?action=delete&id=<%= rs.getInt("lesson_id") %>" 
                           class="btn btn-danger btn-sm" 
                           onclick="return confirm('Delete this lesson?')">Delete</a>
                    </td>
                </tr>
                <% 
                    } 
                    if (empty) {
                        out.println("<tr><td colspan='5' class='text-center py-4'>No lessons found.</td></tr>");
                    }
                %>
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
            document.getElementById('form-title').className = "text-success mb-3";
            document.getElementById('submit-btn').className = "btn btn-success px-5";
            document.getElementById('cancel-edit').style.display = "inline";
            
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }
    </script>

</body>
</html>
<%
    } catch (Exception e) {
        out.println("<div class='alert alert-danger mt-4'><strong>Error:</strong> " + e.getMessage() + "</div>");
    } finally {
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }
%>