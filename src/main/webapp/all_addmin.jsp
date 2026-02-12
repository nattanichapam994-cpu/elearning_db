<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%
    // --- 1. การตั้งค่าการเชื่อมต่อฐานข้อมูล ---
    String driver = "com.mysql.cj.jdbc.Driver";
    String url = "jdbc:mysql://localhost:3306/elearning_db?useUnicode=true&characterEncoding=UTF-8";
    String user = "root";
    String pass = ""; // ใส่รหัสผ่าน MySQL ของคุณ ถ้าไม่มีให้เว้นว่างไว้

    Connection conn = null;
    request.setCharacterEncoding("UTF-8");

    try {
        Class.forName(driver);
        conn = DriverManager.getConnection(url, user, pass);

        // --- 2. จัดการ Logic การทำงาน (CRUD) ---
        String action = request.getParameter("action");
        
        // 2.1 เพิ่มหรือแก้ไขข้อมูล
        if ("save".equals(action)) {
            String id = request.getParameter("course_id");
            String name = request.getParameter("course_name");
            String teacher = request.getParameter("teacher_id");

            if (id == null || id.isEmpty()) {
                // เพิ่มใหม่
                PreparedStatement ps = conn.prepareStatement("INSERT INTO courses (course_name, teacher_id) VALUES (?, ?)");
                ps.setString(1, name);
                ps.setInt(2, Integer.parseInt(teacher));
                ps.executeUpdate();
            } else {
                // แก้ไขข้อมูลเดิม
                PreparedStatement ps = conn.prepareStatement("UPDATE courses SET course_name=?, teacher_id=? WHERE course_id=?");
                ps.setString(1, name);
                ps.setInt(2, Integer.parseInt(teacher));
                ps.setInt(3, Integer.parseInt(id));
                ps.executeUpdate();
            }
            response.sendRedirect("all_addmin.jsp"); // รีเฟรชหน้า
        } 
        // 2.2 ลบข้อมูล
        else if ("delete".equals(action)) {
            String id = request.getParameter("id");
            PreparedStatement ps = conn.prepareStatement("DELETE FROM courses WHERE course_id = ?");
            ps.setInt(1, Integer.parseInt(id));
            ps.executeUpdate();
            response.sendRedirect("all_addmin.jsp");
        }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Course Management (JSP)</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="container mt-5">

    <h2 class="mb-4">จัดการคอร์สเรียน (E-Learning Admin)</h2>

    <div class="card p-4 mb-4 shadow-sm">
        <h5 id="form-title">เพิ่มคอร์สใหม่</h5>
        <form action="all_addmin.jsp?action=save" method="post">
            <input type="hidden" name="course_id" id="course_id">
            <div class="row g-3">
                <div class="col-md-5">
                    <input type="text" name="course_name" id="name" class="form-control" placeholder="ชื่อคอร์ส" required>
                </div>
                <div class="col-md-4">
                    <input type="number" name="teacher_id" id="teacher" class="form-control" placeholder="รหัสผู้สอน (ID)" required>
                </div>
                <div class="col-md-3">
                    <button type="submit" class="btn btn-primary w-100">บันทึกข้อมูล</button>
                </div>
            </div>
        </form>
    </div>

    <table class="table table-hover border">
        <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>ชื่อคอร์ส</th>
                <th>ID ผู้สอน</th>
                <th width="200">จัดการ</th>
            </tr>
        </thead>
        <tbody>
            <%
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM courses ORDER BY course_id DESC");
                while(rs.next()) {
            %>
            <tr>
                <td><%= rs.getInt("course_id") %></td>
                <td><%= rs.getString("course_name") %></td>
                <td><%= rs.getInt("teacher_id") %></td>
                <td>
                    <button class="btn btn-warning btn-sm" 
                            onclick="editData('<%= rs.getInt("course_id") %>', '<%= rs.getString("course_name") %>', '<%= rs.getInt("teacher_id") %>')">
                        แก้ไข
                    </button>
                    <a href="all_addmin.jsp?action=delete&id=<%= rs.getInt("course_id") %>" 
                       class="btn btn-danger btn-sm" 
                       onclick="return confirm('คุณแน่ใจหรือไม่ที่จะลบคอร์สนี้?')">ลบ</a>
                </td>
            </tr>
            <% 
                } 
            %>
        </tbody>
    </table>

    <script>
        // ฟังก์ชันสำหรับดึงข้อมูลจากแถวในตารางขึ้นไปบนฟอร์มเพื่อแก้ไข
        function editData(id, name, teacher) {
            document.getElementById('course_id').value = id;
            document.getElementById('name').value = name;
            document.getElementById('teacher').value = teacher;
            document.getElementById('form-title').innerText = "แก้ไขข้อมูลคอร์ส (ID: " + id + ")";
            document.getElementById('name').focus();
        }
    </script>

</body>
</html>
<%
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
    } finally {
        if (conn != null) conn.close();
    }
%>