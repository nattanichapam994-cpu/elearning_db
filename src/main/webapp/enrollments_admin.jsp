<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%
    // --- 1. Database Connection Settings ---
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
        
        // 2.1 Save Data (Insert new or Update existing)
        if ("save".equals(action)) {
            String id = request.getParameter("enroll_id");
            String userId = request.getParameter("user_id");
            String courseId = request.getParameter("course_id");

            if (id == null || id.isEmpty()) {
                // Insert New Enrollment
                PreparedStatement ps = conn.prepareStatement("INSERT INTO enrollments (user_id, course_id) VALUES (?, ?)");
                ps.setInt(1, Integer.parseInt(userId));
                ps.setInt(2, Integer.parseInt(courseId));
                ps.executeUpdate();
            } else {
                // Update Existing Enrollment
                PreparedStatement ps = conn.prepareStatement("UPDATE enrollments SET user_id=?, course_id=? WHERE enroll_id=?");
                ps.setInt(1, Integer.parseInt(userId));
                ps.setInt(2, Integer.parseInt(courseId));
                ps.setInt(3, Integer.parseInt(id));
                ps.executeUpdate();
            }
            response.sendRedirect("enrollment_admin.jsp"); 
            return;
        } 
        // 2.2 Delete Data
        else if ("delete".equals(action)) {
            String id = request.getParameter("id");
            PreparedStatement ps = conn.prepareStatement("DELETE FROM enrollments WHERE enroll_id = ?");
            ps.setInt(1, Integer.parseInt(id));
            ps.executeUpdate();
            response.sendRedirect("enrollment_admin.jsp");
            return;
        }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enrollment Management System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body { background-color: #f4f7f9; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .main-container { max-width: 1000px; margin-top: 50px; }
        .card { border: none; border-radius: 10px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .table-container { background: white; border-radius: 10px; padding: 20px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .btn-primary { background-color: #0d6efd; }
    </style>
</head>
<body class="container main-container">

    <div class="mb-4 d-flex justify-content-between align-items-center">
        <h2 class="fw-bold text-dark">Enrollment Management</h2>
        <span class="badge bg-secondary">Table: enrollments</span>
    </div>

    <div class="card p-4 mb-4">
        <h5 id="form-title" class="text-primary mb-3">Add New Enrollment</h5>
        <form action="enrollment_admin.jsp?action=save" method="post">
            <input type="hidden" name="enroll_id" id="enroll_id">
            
            <div class="row g-3">
                <div class="col-md-4">
                    <label class="form-label">User ID</label>
                    <input type="number" name="user_id" id="user_id" class="form-control" placeholder="Enter User ID" required>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Course ID</label>
                    <input type="number" name="course_id" id="course_id" class="form-control" placeholder="Enter Course ID" required>
                </div>
                <div class="col-md-4 d-flex align-items-end">
                    <button type="submit" id="submit-btn" class="btn btn-primary w-100">Save Enrollment</button>
                </div>
            </div>
            <div id="cancel-edit" class="mt-2" style="display:none;">
                <a href="enrollment_admin.jsp" class="text-danger text-decoration-none small">Cancel Editing</a>
            </div>
        </form>
    </div>

    <div class="table-container">
        <table class="table table-hover align-middle">
            <thead class="table-dark">
                <tr>
                    <th class="text-center">Enroll ID</th>
                    <th class="text-center">User ID</th>
                    <th class="text-center">Course ID</th>
                    <th class="text-center">Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT * FROM enrollments ORDER BY enroll_id DESC");
                    boolean hasRecords = false;
                    while(rs.next()) {
                        hasRecords = true;
                %>
                <tr>
                    <td class="text-center fw-bold"><%= rs.getInt("enroll_id") %></td>
                    <td class="text-center"><%= rs.getInt("user_id") %></td>
                    <td class="text-center"><%= rs.getInt("course_id") %></td>
                    <td class="text-center">
                        <button class="btn btn-warning btn-sm" 
                                onclick="prepareEdit('<%= rs.getInt("enroll_id") %>', '<%= rs.getInt("user_id") %>', '<%= rs.getInt("course_id") %>')">
                            Edit
                        </button>
                        <a href="enrollment_admin.jsp?action=delete&id=<%= rs.getInt("enroll_id") %>" 
                           class="btn btn-danger btn-sm" 
                           onclick="return confirm('Are you sure you want to delete this record?')">Delete</a>
                    </td>
                </tr>
                <% 
                    } 
                    if (!hasRecords) {
                %>
                    <tr>
                        <td colspan="4" class="text-center text-muted py-4">No enrollment records found.</td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <script>
        /**
         * Populates the form fields with data from the selected row for editing
         */
        function prepareEdit(id, user, course) {
            document.getElementById('enroll_id').value = id;
            document.getElementById('user_id').value = user;
            document.getElementById('course_id').value = course;
            
            // UI Feedback
            document.getElementById('form-title').innerText = "Edit Enrollment (ID: " + id + ")";
            document.getElementById('form-title').className = "text-success mb-3";
            document.getElementById('submit-btn').className = "btn btn-success w-100";
            document.getElementById('cancel-edit').style.display = "block";
            
            // Scroll to form
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }
    </script>

</body>
</html>
<%
    } catch (Exception e) {
        out.println("<div class='alert alert-danger mt-5'><strong>Database Error:</strong> " + e.getMessage() + "</div>");
    } finally {
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }
%>