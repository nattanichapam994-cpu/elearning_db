<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%
    // --- 1. การตั้งค่าการเชื่อมต่อฐานข้อมูล ---
    String driver = "com.mysql.cj.jdbc.Driver";
    String url = "jdbc:mysql://localhost:3306/elearning_db?useUnicode=true&characterEncoding=UTF-8";
    String user = "root";
    String pass = ""; // ใส่รหัสผ่าน MySQL ของคุณ (ถ้าไม่มีให้เว้นว่างไว้)

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

            if (id == null || id.isEmpty()) {
                // เพิ่มคอร์สใหม่
                PreparedStatement ps = conn.prepareStatement("INSERT INTO courses (course_name) VALUES (?)");
                ps.setString(1, name);
                ps.executeUpdate();
            } else {
                // แก้ไขคอร์สเดิม
                PreparedStatement ps = conn.prepareStatement("UPDATE courses SET course_name=? WHERE course_id=?");
                ps.setString(1, name);
                ps.setInt(2, Integer.parseInt(id));
                ps.executeUpdate();
            }
            response.sendRedirect("all_addmin.jsp"); // รีเฟรชหน้าเพื่อล้างค่า Parameter
            return;
        } 
        // 2.2 ลบข้อมูล
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
<html lang="th">
<head>
    <meta charset="UTF-8">
    <title>Course Management System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Sarabun', sans-serif; background-color: #f8f9fa; }
        .card { border: none; border-radius: 15px; }
        .table { background: white; border-radius: 10px; overflow: hidden; }
    </style>
</head>
<body class="container mt-5">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>📚 จัดการคอร์สเรียน</h2>
    </div>

    <div class="card p-4 mb-4 shadow-sm">
        <h5 id="form-title" class="text-primary mb-3">เพิ่มคอร์สเรียนใหม่</h5>
        <form action="all_addmin.jsp?action=save" method="post">
            <input type="hidden" name="course_id" id="course_id">
            <div class="row g-3">
                <div class="col-md-9">
                    <label class="form-label">ชื่อคอร์ส</label>
                    <input type="text" name="course_name" id="name" class="form-control" placeholder="ระบุชื่อคอร์สที่ต้องการเพิ่ม" required>
                </div>
                <div class="col-md-3 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary w-100">บันทึกข้อมูล</button>
                </div>
            </div>
            <div id="edit-cancel" class="mt-2" style="display:none;">
                <a href="all_addmin.jsp" class="btn btn-link btn-sm text-secondary">ยกเลิกการแก้ไข</a>
            </div>
        </form>
    </div>

    <div class="table-responsive shadow-sm">
        <table class="table table-hover mb-0">
            <thead class="table-dark">
                <tr>
                    <th width="15%" class="text-center">รหัสคอร์ส (ID)</th>
                    <th width="65%">ชื่อคอร์สเรียน</th>
                    <th width="20%" class="text-center">เครื่องมือ</th>
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
                            แก้ไข
                        </button>
                        <a href="all_addmin.jsp?action=delete&id=<%= rs.getInt("course_id") %>" 
                           class="btn btn-danger btn-sm mx-1" 
                           onclick="return confirm('คุณต้องการลบคอร์สนี้ใช่หรือไม่?')">ลบ</a>
                    </td>
                </tr>
                <% 
                    } 
                    if (!hasData) {
                        out.println("<tr><td colspan='3' class='text-center py-4 text-muted'>ยังไม่มีข้อมูลคอร์สเรียนในระบบ</td></tr>");
                    }
                %>
            </tbody>
        </table>
    </div>

    <script>
        // ฟังก์ชันสำหรับโยนข้อมูลจากตารางกลับขึ้นไปบนฟอร์มเพื่อแก้ไข
        function editData(id, name) {
            document.getElementById('course_id').value = id;
            document.getElementById('name').value = name;
            
            document.getElementById('form-title').innerText = "แก้ไขข้อมูลคอร์ส (ID: " + id + ")";
            document.getElementById('edit-cancel').style.display = "block";
            document.getElementById('name').focus();
            
            // เปลี่ยนสีปุ่มบันทึกให้เด่นขึ้นเวลาแก้ไข
            document.querySelector('button[type="submit"]').className = "btn btn-success w-100";
        }
    </script>

</body>
</html>
<%
    } catch (Exception e) {
        out.println("<div class='alert alert-danger mt-5'><strong>เกิดข้อผิดพลาด:</strong> " + e.getMessage() + "</div>");
    } finally {
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }
%>