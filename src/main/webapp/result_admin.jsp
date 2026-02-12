<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
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

        // ===== SAVE (เพิ่ม / แก้ไข) =====
        if ("save".equals(action)) {

            String resultId = request.getParameter("result_id");
            String userId = request.getParameter("user_id");
            String quizId = request.getParameter("quiz_id");
            String score = request.getParameter("score");

            if (resultId == null || resultId.isEmpty()) {
                // เพิ่มใหม่
                PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO result (user_id, quiz_id, score) VALUES (?, ?, ?)"
                );
                ps.setInt(1, Integer.parseInt(userId));
                ps.setInt(2, Integer.parseInt(quizId));
                ps.setInt(3, Integer.parseInt(score));
                ps.executeUpdate();
            } else {
                // แก้ไข
                PreparedStatement ps = conn.prepareStatement(
                    "UPDATE result SET user_id=?, quiz_id=?, score=? WHERE result_id=?"
                );
                ps.setInt(1, Integer.parseInt(userId));
                ps.setInt(2, Integer.parseInt(quizId));
                ps.setInt(3, Integer.parseInt(score));
                ps.setInt(4, Integer.parseInt(resultId));
                ps.executeUpdate();
            }

            response.sendRedirect("result_admin.jsp");
            return;
        }

        // ===== DELETE =====
        else if ("delete".equals(action)) {
            String id = request.getParameter("id");

            PreparedStatement ps = conn.prepareStatement(
                "DELETE FROM result WHERE result_id=?"
            );
            ps.setInt(1, Integer.parseInt(id));
            ps.executeUpdate();

            response.sendRedirect("result_admin.jsp");
            return;
        }
%>

<!DOCTYPE html>
<html lang="th">
<head>
<meta charset="UTF-8">
<title>จัดการผลคะแนน</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-5">

<h2 class="mb-4">📊 จัดการผลคะแนน</h2>

<!-- ===== FORM ===== -->
<div class="card p-4 mb-4 shadow">
    <h5 id="form-title">เพิ่มผลคะแนน</h5>
    <form action="result_admin.jsp?action=save" method="post">
        <input type="hidden" name="result_id" id="result_id">

        <div class="row g-3">
            <div class="col-md-3">
                <label>รหัสผู้ใช้</label>
                <input type="number" name="user_id" id="user_id" class="form-control" required>
            </div>

            <div class="col-md-3">
                <label>รหัสแบบทดสอบ</label>
                <input type="number" name="quiz_id" id="quiz_id" class="form-control" required>
            </div>

            <div class="col-md-3">
                <label>คะแนน</label>
                <input type="number" name="score" id="score" class="form-control" required>
            </div>

            <div class="col-md-3 d-flex align-items-end">
                <button type="submit" class="btn btn-primary w-100">
                    บันทึก
                </button>
            </div>
        </div>
    </form>
</div>

<!-- ===== TABLE ===== -->
<table class="table table-bordered table-hover">
    <thead class="table-dark">
        <tr>
            <th>Result ID</th>
            <th>User ID</th>
            <th>Quiz ID</th>
            <th>Score</th>
            <th width="180">จัดการ</th>
        </tr>
    </thead>
    <tbody>
    <%
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM result ORDER BY result_id DESC");

        boolean hasData = false;
        while (rs.next()) {
            hasData = true;
    %>
        <tr>
            <td><%= rs.getInt("result_id") %></td>
            <td><%= rs.getInt("user_id") %></td>
            <td><%= rs.getInt("quiz_id") %></td>
            <td><%= rs.getInt("score") %></td>
            <td>
                <button class="btn btn-warning btn-sm"
                    onclick="editData(
                        '<%= rs.getInt("result_id") %>',
                        '<%= rs.getInt("user_id") %>',
                        '<%= rs.getInt("quiz_id") %>',
                        '<%= rs.getInt("score") %>'
                    )">
                    แก้ไข
                </button>

                <a href="result_admin.jsp?action=delete&id=<%= rs.getInt("result_id") %>"
                   class="btn btn-danger btn-sm"
                   onclick="return confirm('ต้องการลบใช่หรือไม่?')">
                   ลบ
                </a>
            </td>
        </tr>
    <%
        }

        if (!hasData) {
            out.println("<tr><td colspan='5' class='text-center'>ยังไม่มีข้อมูล</td></tr>");
        }
    %>
    </tbody>
</table>

<script>
function editData(id, userId, quizId, score) {
    document.getElementById("result_id").value = id;
    document.getElementById("user_id").value = userId;
    document.getElementById("quiz_id").value = quizId;
    document.getElementById("score").value = score;

    document.getElementById("form-title").innerText = "แก้ไข Result ID: " + id;
}
</script>

</body>
</html>

<%
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>" + e.getMessage() + "</div>");
    } finally {
        if (conn != null) conn.close();
    }
%>
