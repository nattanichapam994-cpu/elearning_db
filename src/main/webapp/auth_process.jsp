<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String fullName = (String) session.getAttribute("userFullName");
    boolean isLoggedIn = (fullName != null);
%>

<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>E-Learning</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" 
          rel="stylesheet" 
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" 
          crossorigin="anonymous">
    
    <style>
        /* เพิ่มแต่งเล็กน้อยให้ดูทันสมัยและเข้ากับสี Facebook-ish */
        .navbar {
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }
        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
        }
        .nav-link {
            font-weight: 500;
        }
        .btn-outline-primary {
            font-weight: 600;
        }
        .btn-danger {
            font-weight: 600;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container-fluid px-4 px-lg-5">
        
        <!-- Brand + Menu -->
        <a class="navbar-brand" href="index.jsp">E-Learning</a>
        
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" 
                data-bs-target="#navbarContent" aria-controls="navbarContent" 
                aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarContent">
            
            <!-- เมนูตรงกลาง (หรือชิดซ้ายก็ได้) -->
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link" href="index.jsp">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="courses.jsp">Courses</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="lessons.jsp">Lessons</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="quizzes.jsp">Quizzes</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="results.jsp">Results</a>
                </li>
            </ul>

            <!-- ส่วนขวา: User info / Auth buttons -->
            <div class="d-flex align-items-center gap-3">
                <% if (isLoggedIn) { %>
                    <span class="text-white fw-medium">
                        Welcome, <strong><%= fullName %></strong>
                    </span>
                    <a href="logout.jsp" 
                       class="btn btn-danger btn-sm px-3">Sign Out</a>
                <% } else { %>
                    <span class="text-white fw-light">Guest</span>
                    <a href="login.jsp" 
                       class="btn btn-outline-light btn-sm px-3">Login</a>
                <% } %>
            </div>
            
        </div>
    </div>
</nav>

<!-- ถ้าต้องการ JS ของ Bootstrap (สำหรับ collapse) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" 
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" 
        crossorigin="anonymous"></script>

</body>
</html>