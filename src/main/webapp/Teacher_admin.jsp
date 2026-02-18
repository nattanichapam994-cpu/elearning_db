<%@page contentType="text/html" pageEncoding="UTF-8"%>
<% 
    // บรรทัดสำคัญที่สุด: ป้องกันภาษาไทยเพี้ยนจากการรับค่า Form
    request.setCharacterEncoding("UTF-8"); 
%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Teachers Management</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            :root { --primary-color: #3b82f6; --danger-color: #dc3545; --warning-color: #ffc107; --bg-color: #f8f9fa; }
            body { font-family: 'Segoe UI', sans-serif; background-color: var(--bg-color); padding: 40px 20px; }
            .main-container { max-width: 1100px; margin: 0 auto; }
            .card { background: white; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); padding: 25px; margin-bottom: 30px; border: 1px solid #e5e7eb; }
            .form-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; }
            input { width: 100%; padding: 12px; border: 1px solid #d1d5db; border-radius: 8px; box-sizing: border-box; }
            .btn-save { background-color: var(--primary-color); color: white; border: none; padding: 12px 25px; border-radius: 8px; cursor: pointer; float: right; margin-top: 10px; font-weight: bold; }
            table { width: 100%; border-collapse: collapse; }
            thead { background-color: #212529; color: white; }
            th, td { padding: 15px; text-align: left; border-bottom: 1px solid #edf2f7; }
            .btn-edit { background: var(--warning-color); color: black; padding: 6px 12px; border-radius: 4px; text-decoration: none; font-size: 13px; font-weight: bold; }
            .btn-delete { background: var(--danger-color); color: white; padding: 6px 12px; border-radius: 4px; text-decoration: none; font-size: 13px; font-weight: bold; border: none; cursor: pointer; }
            .alert { padding: 15px; border-radius: 8px; margin-bottom: 20px; border: 1px solid transparent; }
            .alert-success { background: #d1e7dd; color: #0f5132; }
            .alert-danger { background: #f8d7da; color: #842029; }
        </style>
    </head>
    <body>

    <div class="main-container">
        <h2><i class="fas fa-chalkboard-teacher"></i> Teachers Management</h2>

        <%
            String dbURL = "jdbc:mysql://localhost:3306/elearning_db?useUnicode=true&characterEncoding=UTF-8";
            String dbUser = "root";
            String dbPass = "";
            
            // --- ส่วนที่ 1: การลบข้อมูล (Delete) ---
            if (request.getParameter("delete_id") != null) {
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
                    String sql = "DELETE FROM teachers WHERE teacher_id = ?";
                    PreparedStatement pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, Integer.parseInt(request.getParameter("delete_id")));
                    pstmt.executeUpdate();
                    out.print("<div class='alert alert-success'>ลบข้อมูลอาจารย์เรียบร้อยแล้ว!</div>");
                    pstmt.close(); conn.close();
                } catch (Exception e) {
                    out.print("<div class='alert alert-danger'>เกิดข้อผิดพลาดในการลบ: " + e.getMessage() + "</div>");
                }
            }

            // --- ส่วนที่ 2: การบันทึกข้อมูล (Insert) ---
            if (request.getParameter("btnSave") != null) {
                String fname = request.getParameter("first_name");
                String lname = request.getParameter("last_name");
                String email = request.getParameter("email");

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
                    String sql = "INSERT INTO teachers (first_name, last_name, email) VALUES (?, ?, ?)";
                    PreparedStatement pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, fname);
                    pstmt.setString(2, lname);
                    pstmt.setString(3, email);
                    pstmt.executeUpdate();
                    out.print("<div class='alert alert-success'>เพิ่มข้อมูลอาจารย์สำเร็จ!</div>");
                    pstmt.close(); conn.close();
                } catch (SQLIntegrityConstraintViolationException e) {
                    out.print("<div class='alert alert-danger'>ข้อผิดพลาด: อีเมลนี้มีอยู่ในระบบแล้ว!</div>");
                } catch (Exception e) {
                    out.print("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
                }
            }
        %>

        <div class="card">
            <span style="color:#3b82f6; font-weight:bold; display:block; margin-bottom:15px;">Add New Teacher</span>
            <form action="Teacher_admin.jsp" method="POST">
                <div class="form-grid">
                    <div class="form-group">
                        <label>First Name (ชื่อ)</label>
                        <input type="text" name="first_name" placeholder="กรอกชื่อ" required>
                    </div>
                    <div class="form-group">
                        <label>Last Name (นามสกุล)</label>
                        <input type="text" name="last_name" placeholder="กรอกนามสกุล" required>
                    </div>
                    <div class="form-group">
                        <label>Email Address</label>
                        <input type="email" name="email" placeholder="ตัวอย่าง: teacher@mail.com" required>
                    </div>
                </div>
                <button type="submit" name="btnSave" class="btn-save">Save Teacher</button>
                <div style="clear:both;"></div>
            </form>
        </div>

        <div class="card" style="padding: 0; overflow: hidden;">
            <table>
                <thead>
                    <tr>
                        <th width="10%">ID</th>
                        <th width="40%">Full Name</th>
                        <th width="30%">Email Address</th>
                        <th width="20%" style="text-align: center;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
                            Statement stmt = conn.createStatement();
                            ResultSet rs = stmt.executeQuery("SELECT * FROM teachers ORDER BY teacher_id DESC");

                            while(rs.next()) {
                                int id = rs.getInt("teacher_id");
                    %>
                    <tr>
                        <td><span style="background:#f1f5f9; padding:4px 8px; border-radius:4px;"><%= id %></span></td>
                        <td><%= rs.getString("first_name") %> <%= rs.getString("last_name") %></td>
                        <td><%= rs.getString("email") %></td>
                        <td style="text-align: center;">
                            <a href="#" class="btn-edit">Edit</a>
                            <button onclick="if(confirm('ยืนยันการลบ?')) { window.location.href='Teacher_admin.jsp?delete_id=<%= id %>'; }" class="btn-delete">Delete</button>
                        </td>
                    </tr>
                    <%
                            }
                            conn.close();
                        } catch (Exception e) { out.print("Error: " + e.getMessage()); }
                    %>
                </tbody>
            </table>
        </div>
    </div>
    </body>
</html>