<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // ดึงข้อมูลจาก Session
    String fullName = (String) session.getAttribute("userFullName");
    boolean isLoggedIn = (fullName != null);
%>
<style>
    .nav-container {
        background-color: #1877f2;
        padding: 0 50px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        color: white;
        height: 60px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    .nav-menu {
        display: flex;
        gap: 20px;
        list-style: none;
        margin: 0;
        padding: 0;
    }
    .nav-menu a {
        color: white;
        text-decoration: none;
        font-weight: 500;
    }
    .nav-menu a:hover {
        text-decoration: underline;
    }
    .user-info {
        display: flex;
        align-items: center;
        gap: 15px;
    }
    .btn-auth {
        background-color: white;
        color: #1877f2;
        padding: 5px 15px;
        border-radius: 5px;
        text-decoration: none;
        font-weight: bold;
    }
</style>

<nav class="nav-container">
    <div style="display: flex; align-items: center; gap: 30px;">
        <h2 style="margin: 0;">E-Learning</h2>
        <ul class="nav-menu">
            <li><a href="index.jsp">Home</a></li>
            <li><a href="courses.jsp">Courses</a></li>
            <li><a href="lessons.jsp">Lessons</a></li>
            <li><a href="quizzes.jsp">Quizzes</a></li>
            <li><a href="results.jsp">Results</a></li>
        </ul>
    </div>

    <div class="user-info">
        <% if (isLoggedIn) { %>
            <span>Welcome, <strong><%= fullName %></strong></span>
            <a href="logout.jsp" class="btn-auth" style="background-color: #ff4d4d; color: white;">Sign Out</a>
        <% } else { %>
            <span>Guest</span>
            <a href="login.jsp" class="btn-auth">Login</a>
        <% } %>
    </div>
</nav>