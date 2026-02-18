<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    
    // ตั้งค่า Database
    String driver = "com.mysql.cj.jdbc.Driver";
    String url = "jdbc:mysql://localhost:3306/elearning_db?useUnicode=true&characterEncoding=UTF-8";
    String dbUser = "root";
    String dbPass = ""; 

    Connection conn = null;
    String statusMsg = "";

    // ดึงค่า Action
    String action = request.getParameter("action");

    try {
        Class.forName(driver);
        conn = DriverManager.getConnection(url, dbUser, dbPass);

        // --- เริ่มต้นส่วนบันทึกข้อมูล ---
        if ("add_bulk_quiz".equals(action)) {
            try {
                // ปิด AutoCommit เพื่อใช้ Transaction
                conn.setAutoCommit(false);

                int courseId = Integer.parseInt(request.getParameter("course_id"));
                String quizTitle = request.getParameter("quiz_title");
                String[] questions = request.getParameterValues("question_text");
                String[] choices = request.getParameterValues("choice_text"); 
                String[] correctIndices = request.getParameterValues("correct_choice_value");

                if (questions != null && quizTitle != null) {
                    // 1. บันทึกหัวข้อข้อสอบ (quizzes)
                    PreparedStatement psQuiz = conn.prepareStatement("INSERT INTO quizzes (course_id, quiz_title) VALUES (?, ?)", Statement.RETURN_GENERATED_KEYS);
                    psQuiz.setInt(1, courseId);
                    psQuiz.setString(2, quizTitle);
                    psQuiz.executeUpdate();
                    
                    ResultSet rsQuiz = psQuiz.getGeneratedKeys();
                    if (rsQuiz.next()) {
                        int quizId = rsQuiz.getInt(1);

                        // 2. วนลูปบันทึกคำถาม (questions)
                        for (int i = 0; i < questions.length; i++) {
                            PreparedStatement psQ = conn.prepareStatement("INSERT INTO questions (quiz_id, question_text) VALUES (?, ?)", Statement.RETURN_GENERATED_KEYS);
                            psQ.setInt(1, quizId);
                            psQ.setString(2, questions[i]);
                            psQ.executeUpdate();
                            
                            ResultSet rsQ = psQ.getGeneratedKeys();
                            if (rsQ.next()) {
                                int questionId = rsQ.getInt(1);
                                int correctChoiceId = 0;
                                int correctIdxForThisQ = Integer.parseInt(correctIndices[i]);

                                // 3. วนลูปบันทึกตัวเลือก 4 ข้อ (choices)
                                for (int j = 0; j < 4; j++) {
                                    int choiceGlobalIdx = (i * 4) + j; 
                                    PreparedStatement psC = conn.prepareStatement("INSERT INTO choices (question_id, choice_text) VALUES (?, ?)", Statement.RETURN_GENERATED_KEYS);
                                    psC.setInt(1, questionId);
                                    psC.setString(2, choices[choiceGlobalIdx]);
                                    psC.executeUpdate();
                                    
                                    ResultSet rsC = psC.getGeneratedKeys();
                                    if (rsC.next() && j == correctIdxForThisQ) {
                                        correctChoiceId = rsC.getInt(1);
                                    }
                                }

                                // 4. อัปเดต ID ข้อที่ถูกกลับไปที่ตาราง questions
                                PreparedStatement psUpdate = conn.prepareStatement("UPDATE questions SET correct_choice_id = ? WHERE question_id = ?");
                                psUpdate.setInt(1, correctChoiceId);
                                psUpdate.setInt(2, questionId);
                                psUpdate.executeUpdate();
                            }
                        }
                        // บันทึกสำเร็จทั้งหมด
                        conn.commit();
                        statusMsg = "<div class='alert alert-success'>บันทึกชุดข้อสอบ \"" + quizTitle + "\" พร้อมคำถาม " + questions.length + " ข้อสำเร็จแล้ว!</div>";
                    }
                }
            } catch (Exception e) {
                if (conn != null) conn.rollback(); // ย้อนกลับหากพัง
                statusMsg = "<div class='alert alert-danger'>เกิดข้อผิดพลาดในการบันทึก: " + e.getMessage() + "</div>";
                e.printStackTrace();
            }
        }
    } catch (Exception e) {
        statusMsg = "<div class='alert alert-danger'>Database Error: " + e.getMessage() + "</div>";
    }
%>

<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>จัดการข้อสอบ - Quiz Management</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Sarabun', sans-serif; background-color: #f8f9fa; padding: 40px 0; }
        .card { border-radius: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); border: none; }
        .section-title { border-left: 5px solid #0d6efd; padding-left: 15px; margin: 25px 0; color: #333; font-weight: bold; }
        .question-block { background: #fff; border: 1px solid #e0e0e0; padding: 25px; border-radius: 12px; margin-bottom: 25px; transition: 0.3s; }
        .question-block:hover { border-color: #0d6efd; }
        .correct-label { font-size: 0.85rem; }
    </style>
</head>
<body>

<div class="container">
    <div class="card p-4 p-md-5">
        <h2 class="text-primary mb-4 text-center fw-bold">ระบบจัดการข้อสอบแบบกลุ่ม</h2>
        
        <%-- แสดงข้อความสถานะ --%>
        <%= statusMsg %>

        <form action="manage_quiz.jsp" method="post">
            <input type="hidden" name="action" value="add_bulk_quiz">
            
            <h5 class="section-title">ขั้นตอนที่ 1: ข้อมูลชุดข้อสอบ</h5>
            <div class="row g-3 mb-4">
                <div class="col-md-4">
                    <label class="form-label fw-bold">เลือกรายวิชา</label>
                    <select name="course_id" class="form-select" required>
                        <option value="">-- กรุณาเลือกวิชา --</option>
                        <%
                            try {
                                Statement stmt = conn.createStatement();
                                ResultSet rs = stmt.executeQuery("SELECT course_id, course_name FROM courses ORDER BY course_name ASC");
                                while(rs.next()) {
                                    out.println("<option value='" + rs.getInt("course_id") + "'>" + rs.getString("course_name") + "</option>");
                                }
                            } catch(Exception e) {}
                        %>
                    </select>
                </div>
                <div class="col-md-5">
                    <label class="form-label fw-bold">ชื่อชุดข้อสอบ</label>
                    <input type="text" name="quiz_title" class="form-control" placeholder="เช่น ข้อสอบกลางภาค บทที่ 1" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-bold">จำนวนข้อสอบ</label>
                    <div class="input-group">
                        <input type="number" id="q_count" class="form-control" value="1" min="1" max="50">
                        <button type="button" class="btn btn-dark" onclick="generateQuestions()">สร้างช่องกรอก</button>
                    </div>
                </div>
            </div>

            <div id="step2-area" style="display:none;">
                <h5 class="section-title">ขั้นตอนที่ 2: ระบุคำถามและตัวเลือก</h5>
                <div id="questions-area"></div>

                <div class="mt-4">
                    <button type="submit" class="btn btn-primary btn-lg w-100 shadow">บันทึกข้อมูลทั้งหมดลงฐานข้อมูล</button>
                </div>
            </div>
        </form>
    </div>
</div>

<script>
    function generateQuestions() {
        const count = document.getElementById('q_count').value;
        const container = document.getElementById('questions-area');
        const step2Area = document.getElementById('step2-area');
        
        container.innerHTML = ''; 
        if (count < 1) return;

        for (let i = 1; i <= count; i++) {
            let html = `
                <div class="question-block">
                    <h6 class="text-primary mb-3 fw-bold">คำถามข้อที่ ` + i + `</h6>
                    <div class="mb-3">
                        <textarea name="question_text" class="form-control" rows="2" placeholder="พิมพ์โจทย์คำถามที่นี่..." required></textarea>
                    </div>
                    <div class="row g-3">
            `;
            
            for (let j = 0; j < 4; j++) {
                html += `
                    <div class="col-md-6">
                        <div class="input-group">
                            <div class="input-group-text">
                                <input type="radio" name="correct_radio_` + (i-1) + `" value="` + j + `" ` + (j === 0 ? 'checked' : '') + ` onchange="updateCorrectIdx(` + (i-1) + `, ` + j + `)">
                                <span class="ms-2 text-success fw-bold correct-label">เฉลย</span>
                            </div>
                            <input type="text" name="choice_text" class="form-control" placeholder="ตัวเลือกที่ ` + (j+1) + `" required>
                        </div>
                    </div>
                `;
            }
            
            html += `
                    </div>
                    <input type="hidden" name="correct_choice_value" id="correct_val_` + (i-1) + `" value="0">
                </div>
            `;
            container.insertAdjacentHTML('beforeend', html);
        }
        step2Area.style.display = 'block';
        window.scrollTo({ top: step2Area.offsetTop - 20, behavior: 'smooth' });
    }

    function updateCorrectIdx(qIdx, choiceIdx) {
        document.getElementById('correct_val_' + qIdx).value = choiceIdx;
    }
</script>

</body>
</html>

<%
    // ปิดการเชื่อมต่อในส่วนท้ายที่สุด
    if (conn != null) {
        try { conn.close(); } catch (SQLException ignore) {}
    }
%>