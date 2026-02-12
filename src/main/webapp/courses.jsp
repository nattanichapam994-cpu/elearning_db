<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%
    // --- 1. Database Connection Configuration ---
    String driver = "com.mysql.cj.jdbc.Driver";
    String url = "jdbc:mysql://localhost:3306/elearning_db?useUnicode=true&characterEncoding=UTF-8";
    String user = "root";
    String pass = ""; // Enter your MySQL password here (leave blank if none)

    Connection conn = null;
    request.setCharacterEncoding("UTF-8");

    try {
        Class.forName(driver);
        conn = DriverManager.getConnection(url, user, pass);

        // --- 2. Logic Handling (CRUD Operations) ---
        String action = request.getParameter("action");
        
        // 2.1 Save Data (Create New or Update Existing)
        if ("save".equals(action)) {
            String id = request.getParameter("course_id");
            String name = request.getParameter("course_name");

            if (id == null || id.isEmpty()) {
                // Add New Course
                PreparedStatement ps = conn.prepareStatement("INSERT INTO courses (course_name) VALUES (?)");
                ps.setString(1, name);
                ps.executeUpdate();
            } else {
                // Update Existing Course
                PreparedStatement ps = conn.prepareStatement("UPDATE courses SET course_name=? WHERE course_id=?");
                ps.setString(1, name);
                ps.setInt(2, Integer.parseInt(id));
                ps.executeUpdate();
            }
            response.sendRedirect("all_addmin.jsp"); // Refresh to clear parameters
            return;
        } 
        // 2.2 Delete Data
        else if ("delete".equals(action)) {
            String id = request.getParameter("id");
            PreparedStatement ps = conn.prepareStatement("DELETE FROM courses WHERE course_id = ?");
            ps.setInt(1, Integer.parseInt(id));
            ps.executeUpdate();
            response.sendRedirect("all_addmin.jsp");
            return;
        }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Course Management System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Sarabun', sans-serif; background-color: #f8f9fa; }
        .card { border: none; border-radius: 15px; }
        .table { background: white; border-radius: 10px; overflow: hidden; }
        .form-label { fw-bold; }
    </style>
</head>
<body class="container mt-5">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>📚 Course Management</h2>
    </div>

    <div class="card p-4 mb-4 shadow-sm">
        <h5 id="form-title" class="text-primary mb-3">Add New Course</h5>
        <form action="all_addmin.jsp?action=save" method="post">
            <input type="hidden" name="course_id" id="course_id">
            <div class="row g-3">
                <div class="col-md-9">
                    <label class="form-label">Course Name</label>
                    <input type="text" name="course_name" id="name" class="form-control" placeholder="Enter course name here" required>
                </div>
                <div class="col-md-3 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary w-100">Save Data</button>
                </div>
            </div>
            <div id="edit-cancel" class="mt-2" style="display:none;">
                <a href="all_addmin.jsp" class="btn btn-link btn-sm text-secondary">Cancel Editing</a>
            </div>
        </form>
    </div>

    <div class="table-responsive shadow-sm">
        <table class="table table-hover mb-0">
            <thead class="table-dark">
                <tr>
                    <th width="15%" class="text-center">Course ID</th>
                    <th width="65%">Course Title</th>
                    <th width="20%" class="text-center">Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT * FROM courses ORDER BY course_id DESC");
                    boolean hasData = false;
                    while(rs.next()) {
                        hasData = true;
                %>
                <tr>
                    <td class="text-center"><%= rs.getInt("course_id") %></td>
                    <td><strong><%= rs.getString("course_name") %></strong></td>
                    <td class="text-center">
                        <button class="btn btn-warning btn-sm mx-1" 
                                onclick="editData('<%= rs.getInt("course_id") %>', '<%= rs.getString("course_name") %>')">
                            Edit
                        </button>
                        <a href="all_addmin.jsp?action=delete&id=<%= rs.getInt("course_id") %>" 
                           class="btn btn-danger btn-sm mx-1" 
                           onclick="return confirm('Are you sure you want to delete this course?')">Delete</a>
                    </td>
                </tr>
                <% 
                    } 
                    if (!hasData) {
                        out.println("<tr><td colspan='3' class='text-center py-4 text-muted'>No courses found in the system.</td></tr>");
                    }
                %>
            </tbody>
        </table>
    </div>

    <script>
        /**
         * Function to transfer row data back to the form for editing
         */
        function editData(id, name) {
            document.getElementById('course_id').value = id;
            document.getElementById('name').value = name;
            
            document.getElementById('form-title').innerText = "Edit Course Information (ID: " + id + ")";
            document.getElementById('edit-cancel').style.display = "block";
            document.getElementById('name').focus();
            
            // Highlight the save button during editing
            document.querySelector('button[type="submit"]').className = "btn btn-success w-100";
        }
    </script>

</body>
</html>
<%
    } catch (Exception e) {
        out.println("<div class='alert alert-danger mt-5'><strong>Error Occurred:</strong> " + e.getMessage() + "</div>");
    } finally {
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }
%>