<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
request.setCharacterEncoding("UTF-8");

String driver = "com.mysql.cj.jdbc.Driver";
String url = "jdbc:mysql://localhost:3306/elearning_db?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC";
String dbUser = "root";
String dbPass = "";

Connection conn = null;
String statusMsg = "";
String action = request.getParameter("action");

try {
    Class.forName(driver);
    conn = DriverManager.getConnection(url, dbUser, dbPass);

    if ("add_bulk_quiz".equals(action)) {

        try {
            conn.setAutoCommit(false);

            int courseId = Integer.parseInt(request.getParameter("course_id"));
            String quizTitle = request.getParameter("quiz_title");

            String[] questions = request.getParameterValues("question_text[]");
            String[] choices = request.getParameterValues("choice_text[]");
            String[] correctIndices = request.getParameterValues("correct_choice_value[]");

            if (questions == null || choices == null || correctIndices == null) {
                throw new Exception("ข้อมูลไม่ครบถ้วน");
            }

            PreparedStatement psQuiz = conn.prepareStatement(
                "INSERT INTO quizzes (course_id, quiz_title) VALUES (?, ?)",
                Statement.RETURN_GENERATED_KEYS
            );
            psQuiz.setInt(1, courseId);
            psQuiz.setString(2, quizTitle);
            psQuiz.executeUpdate();

            ResultSet rsQuiz = psQuiz.getGeneratedKeys();
            rsQuiz.next();
            int quizId = rsQuiz.getInt(1);

            for (int i = 0; i < questions.length; i++) {

                PreparedStatement psQ = conn.prepareStatement(
                    "INSERT INTO questions (quiz_id, question_text) VALUES (?, ?)",
                    Statement.RETURN_GENERATED_KEYS
                );
                psQ.setInt(1, quizId);
                psQ.setString(2, questions[i]);
                psQ.executeUpdate();

                ResultSet rsQ = psQ.getGeneratedKeys();
                rsQ.next();
                int questionId = rsQ.getInt(1);

                int correctIdx = Integer.parseInt(correctIndices[i]);

                for (int j = 0; j < 4; j++) {

                    int choiceIndex = (i * 4) + j;
                    int isCorrect = (j == correctIdx) ? 1 : 0;

                    PreparedStatement psC = conn.prepareStatement(
                        "INSERT INTO choices (question_id, choice_text, is_correct) VALUES (?, ?, ?)"
                    );
                    psC.setInt(1, questionId);
                    psC.setString(2, choices[choiceIndex]);
                    psC.setInt(3, isCorrect);
                    psC.executeUpdate();
                }
            }

            conn.commit();
            conn.setAutoCommit(true);

            statusMsg = "<div class='alert alert-success'>บันทึกชุดข้อสอบสำเร็จ!</div>";

        } catch (Exception e) {
            conn.rollback();
            statusMsg = "<div class='alert alert-danger'>เกิดข้อผิดพลาด: " + e.getMessage() + "</div>";
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
<title>Quiz Management</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
<div class="card p-4 shadow">
<h3 class="text-primary mb-4">ระบบจัดการข้อสอบแบบกลุ่ม</h3>

<%= statusMsg %>

<form method="post">
<input type="hidden" name="action" value="add_bulk_quiz">

<div class="row mb-3">
<div class="col-md-4">
<label>รายวิชา</label>
<select name="course_id" class="form-select" required>
<option value="">-- เลือกวิชา --</option>
<%
try {
Statement stmt = conn.createStatement();
ResultSet rs = stmt.executeQuery("SELECT course_id, course_name FROM courses ORDER BY course_name");
while(rs.next()){
%>
<option value="<%=rs.getInt("course_id")%>">
<%=rs.getString("course_name")%>
</option>
<%
}
} catch(Exception e){}
%>
</select>
</div>

<div class="col-md-4">
<label>ชื่อชุดข้อสอบ</label>
<input type="text" name="quiz_title" class="form-control" required>
</div>

<div class="col-md-4">
<label>จำนวนข้อ</label>
<input type="number"
       id="q_count"
       class="form-control"
       value="1"
       min="1"
       onchange="generateQuestions()">
</div>
</div>

<div id="questions-area"></div>

<button type="submit" class="btn btn-primary w-100 mt-3">บันทึกทั้งหมด</button>
</form>
</div>
</div>

<script>

function generateQuestions(){

    let count = parseInt(document.getElementById("q_count").value);
    let container = document.getElementById("questions-area");
    let currentCount = container.children.length;

    if(count > currentCount){

        for(let i = currentCount; i < count; i++){

            let questionNumber = i + 1;

            let div = document.createElement("div");
            div.className = "border p-3 mb-3 rounded bg-white";

            div.innerHTML =
                '<h5>คำถามข้อที่ ' + questionNumber + '</h5>' +

                '<textarea name="question_text[]" class="form-control mb-3" required></textarea>' +

                '<div class="row">' +
                    generateChoicesHTML(i) +
                '</div>' +

                '<input type="hidden" name="correct_choice_value[]" id="correct_' + i + '" value="0">';

            container.appendChild(div);
        }
    }
    else if(count < currentCount){

        for(let i = currentCount; i > count; i--){
            container.removeChild(container.lastElementChild);
        }
    }

    updateQuestionNumbers();
}

function generateChoicesHTML(i){

    let html = "";

    for(let j = 0; j < 4; j++){

        html +=
        '<div class="col-md-6 mb-2">' +
            '<div class="input-group">' +
                '<div class="input-group-text">' +
                    '<input type="radio" ' +
                    'name="correct_radio_' + i + '" ' +
                    'value="' + j + '" ' +
                    (j==0?'checked':'') + ' ' +
                    'onchange="document.getElementById(\'correct_' + i + '\').value=' + j + '">' +
                '</div>' +
                '<input type="text" name="choice_text[]" class="form-control" required>' +
            '</div>' +
        '</div>';
    }

    return html;
}

function updateQuestionNumbers(){

    let container = document.getElementById("questions-area");

    for(let i = 0; i < container.children.length; i++){
        let header = container.children[i].querySelector("h5");
        header.innerText = "คำถามข้อที่ " + (i + 1);
    }
}

window.onload = generateQuestions;

</script>

</body>
</html>

<%
if(conn!=null){
    try{conn.close();}catch(Exception e){}
}
%>
