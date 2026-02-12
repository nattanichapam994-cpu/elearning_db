<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // 1. Check if User is Logged In
    // We retrieve "user_name" from the session established during login
    String currentUserName = (String) session.getAttribute("user_name");

    if (currentUserName == null) {
        // Redirect to login page if session is empty
        response.sendRedirect("login.jsp");
        return; // Stop processing the rest of the page
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>E-Learning | Enrollment Dashboard</title>
    <style>
        :root { --primary: #4e73df; --success: #1cc88a; --danger: #e74a3b; --dark: #5a5c69; --bg: #f8f9fc; }
        body { font-family: 'Segoe UI', Tahoma, sans-serif; background-color: var(--bg); margin: 0; padding: 20px; color: #333; }
        .wrapper { max-width: 950px; margin: 0 auto; }
        
        /* Layout Components */
        .card { background: white; padding: 30px; border-radius: 15px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); margin-bottom: 25px; border-left: 5px solid var(--primary); }
        h2 { margin-top: 0; color: var(--dark); font-size: 1.5rem; display: flex; align-items: center; gap: 10px; }
        
        /* Modern Form */
        .enroll-form { display: grid; grid-template-columns: 1fr 1fr auto; gap: 20px; align-items: end; background: #fcfcfc; padding: 20px; border-radius: 10px; border: 1px solid #eee; }
        .form-group { display: flex; flex-direction: column; }
        label { font-size: 0.8rem; font-weight: bold; margin-bottom: 8px; color: var(--primary); text-transform: uppercase; }
        input, select { padding: 12px; border: 1px solid #d1d3e2; border-radius: 8px; transition: 0.3s; }
        input:focus, select:focus { border-color: var(--primary); box-shadow: 0 0 0 0.2rem rgba(78,115,223,0.25); outline: none; }
        
        /* Table and Actions */
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th { background: #f8f9fc; text-align: left; padding: 15px; border-bottom: 2px solid #e3e6f0; color: var(--dark); font-size: 0.8rem; }
        td { padding: 15px; border-bottom: 1px solid #e3e6f0; vertical-align: middle; }
        .btn { padding: 8px 16px; border: none; border-radius: 6px; cursor: pointer; font-weight: 600; text-decoration: none; font-size: 12px; transition: 0.2s; display: inline-block; }
        .btn-add { background: var(--primary); color: white; height: 45px; }
        .btn-edit { background: var(--success); color: white; margin-right: 5px; }
        .btn-delete { background: var(--danger); color: white; }
        .btn:hover { opacity: 0.85; transform: translateY(-1px); }

        .alert { padding: 15px; border-radius: 8px; margin-bottom: 20px; text-align: center; animation: fadeIn 0.5s; }
        .alert-success { background: #d1e7dd; color: #0f5132; border: 1px solid #badbcc; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body>

<div class="wrapper">
    <div class="card">
        <h2>📚 Register New Course</h2>
        
        <%
            String dbUrl = "jdbc:mysql://localhost:3306/elearning_db";
            String dbUser = "root";
            String dbPass = "";
            Connection conn = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

                // --- ACTION: DELETE ---
                String deleteId = request.getParameter("delete");
                if (deleteId != null) {
                    PreparedStatement psDel = conn.prepareStatement("DELETE FROM enrollments WHERE enroll_id = ?");
                    psDel.setString(1, deleteId);
                    psDel.executeUpdate();
                    out.print("<div class='alert alert-success'>Enrollment deleted successfully.</div>");
                }

                // --- ACTION: INSERT ---
                String courseId = request.getParameter("course_id");
                if (courseId != null && !courseId.isEmpty()) {
                    // We use currentUserName from Session to insert
                    PreparedStatement psIns = conn.prepareStatement("INSERT INTO enrollments (user_name, course_id) VALUES (?, ?)");
                    psIns.setString(1, currentUserName);
                    psIns.setString(2, courseId);
                    psIns.executeUpdate();
                    out.print("<div class='alert alert-success'>Successfully enrolled in the course!</div>");
                }
        %>

        <form method="POST" class="enroll-form">
            <div class="form-group">
                <label>Logged in as</label>
                <input type="text" value="<%= currentUserName %>" readonly style="background: #f1f3f9; font-weight: bold; color: #4e73df;">
            </div>
            <div class="form-group">
                <label>Available Courses</label>
                <select name="course_id" required>
                    <option value="">-- Select a Course --</option>
                    <%
                        ResultSet rsCourses = conn.createStatement().executeQuery("SELECT * FROM courses");
                        while(rsCourses.next()){
                    %>
                        <option value="<%= rsCourses.getString("course_id") %>">
                            <%= rsCourses.getString("course_name") %>
                        </option>
                    <% } %>
                </select>
            </div>
            <button type="submit" class="btn btn-add">Confirm Enrollment</button>
        </form>
    </div>

    

    <div class="card" style="border-left-color: var(--success);">
        <h2>📝 My Learning Records</h2>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Course Title</th>
                    <th>Date Enrolled</th>
                    <th>Management</th>
                </tr>
            </thead>
            <tbody>
                <%
                    // Fetch list using user_name from session
                    String sql = "SELECT e.enroll_id, c.course_name FROM enrollments e " +
                                 "JOIN courses c ON e.course_id = c.course_id " +
                                 "WHERE e.user_name = ?";
                    PreparedStatement psList = conn.prepareStatement(sql);
                    psList.setString(1, currentUserName);
                    ResultSet rsList = psList.executeQuery();
                    
                    if (!rsList.isBeforeFirst()) {
                        out.print("<tr><td colspan='4' style='text-align:center; color:#999;'>No courses enrolled yet.</td></tr>");
                    }

                    while(rsList.next()) {
                %>
                <tr>
                    <td>#<%= rsList.getString("enroll_id") %></td>
                    <td><strong><%= rsList.getString("course_name") %></strong></td>
                    <td style="color: #888;">Feb 12, 2026</td>
                    <td>
                        <a href="edit_enrollment.jsp?id=<%= rsList.getString("enroll_id") %>" class="btn btn-edit">Edit</a>
                        <a href="enrollment.jsp?delete=<%= rsList.getString("enroll_id") %>" 
                           class="btn btn-delete" onclick="return confirm('Do you want to cancel this enrollment?')">Delete</a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <%
            } catch (Exception e) {
                out.print("<div class='alert' style='background:#fff3cd; color:#664d03;'>Database Error: " + e.getMessage() + "</div>");
            } finally {
                if (conn != null) conn.close();
            }
    %>
</div>

</body>
</html>