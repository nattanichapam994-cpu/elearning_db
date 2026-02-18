<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%@ page import="java.sql.*, java.util.*" %>
<%
    // --- 1. Database Connection Configuration ---
    String url = "jdbc:mysql://localhost:3306/elearning_db?useUnicode=true&characterEncoding=UTF-8";
    String dbUser = "root";
    String dbPass = ""; 

    Connection conn = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, dbUser, dbPass);

        // --- 2. Get Data from Form & Session ---
        // หมายเหตุ: user_id ควรดึงมาจาก Session ที่ Login ไว้ 
        // หากยังไม่มีระบบ Login ให้ลองกำหนดค่าตัวอย่างเป็น 1 ไปก่อน
        Integer userId = (Integer) session.getAttribute("user_id");
        if (userId == null) {
            userId = 1; // ค่าตัวอย่างสำหรับทดสอบ
        }

        String quizIdParam = request.getParameter("quiz_id");
        if (quizIdParam == null || quizIdParam.isEmpty()) {
            out.println("Invalid Quiz ID.");
            return;
        }
        int quizId = Integer.parseInt(quizIdParam);
        int totalQuestions = 0;
        int score = 0;

        // --- 3. Process Scoring ---
        // ดึงคำถามและเฉลย (correct_choice_id) จากตาราง questions
        String sqlCheck = "SELECT question_id, correct_choice_id FROM questions WHERE quiz_id = ?";
        PreparedStatement psCheck = conn.prepareStatement(sqlCheck);
        psCheck.setInt(1, quizId);
        ResultSet rsCheck = psCheck.executeQuery();

        while (rsCheck.next()) {
            totalQuestions++;
            int questionId = rsCheck.getInt("question_id");
            int correctAnswerId = rsCheck.getInt("correct_choice_id");

            // รับค่าคำตอบที่ผู้ใช้ส่งมาจากหน้าทำข้อสอบ (สมมติว่าตั้งชื่อ input radio เป็น "q_รหัสคำถาม")
            String userResponse = request.getParameter("q_" + questionId);
            
            if (userResponse != null) {
                int userChoiceId = Integer.parseInt(userResponse);
                // เปรียบเทียบกับเฉลย
                if (userChoiceId == correctAnswerId) {
                    score++;
                }
            }
        }

        // --- 4. Save Result to Database ---
        // บันทึกลงตาราง results (result_id, user_id, quiz_id, score)
        String sqlInsert = "INSERT INTO results (user_id, quiz_id, score) VALUES (?, ?, ?)";
        PreparedStatement psInsert = conn.prepareStatement(sqlInsert);
        psInsert.setInt(1, userId);
        psInsert.setInt(2, quizId);
        psInsert.setInt(3, score);
        psInsert.executeUpdate();

        // --- 5. Display Result Page ---
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quiz Result</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@400;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Sarabun', sans-serif; background-color: #f8f9fa; display: flex; align-items: center; justify-content: center; height: 100vh; margin: 0; }
        .result-card { background: white; padding: 40px; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); text-align: center; max-width: 500px; width: 100%; }
        .score-circle { width: 150px; height: 150px; border-radius: 50%; background: #e9ecef; display: flex; align-items: center; justify-content: center; margin: 20px auto; border: 8px solid #0d6efd; }
        .score-num { font-size: 48px; font-weight: bold; color: #0d6efd; }
    </style>
</head>
<body>

    <div class="result-card">
        <h2 class="mb-4">Quiz Completed!</h2>
        <p class="text-muted">You have finished the evaluation.</p>
        
        <div class="score-circle">
            <div class="score-num"><%= score %>/<%= totalQuestions %></div>
        </div>
        
        <h4 class="mt-4">Your Score: <%= score %> Points</h4>
        <p>Information has been saved to the system.</p>
        
        <div class="mt-4">
            <a href="index.jsp" class="btn btn-primary px-4">Back to Home</a>
            <button onclick="window.print()" class="btn btn-outline-secondary px-4">Print Result</button>
        </div>
    </div>

</body>
</html>
<%
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'><strong>Error:</strong> " + e.getMessage() + "</div>");
    } finally {
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }
%>