<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>E-Learning System</title>
    <style>
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            display: flex; 
            justify-content: center; 
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: #f0f2f5; 
        }
        .login-card { 
            background: #ffffff; 
            padding: 40px; 
            border-radius: 12px; 
            width: 360px; 
            box-shadow: 0 15px 35px rgba(0,0,0,0.1); 
            text-align: center;
        }
        h2 { color: #1c1e21; margin-bottom: 25px; }
        input { 
            width: 100%; 
            padding: 14px; 
            margin: 10px 0; 
            border: 1px solid #dddfe2; 
            border-radius: 8px; 
            box-sizing: border-box; 
            font-size: 15px;
        }
        .button-group { display: flex; flex-direction: column; gap: 10px; margin-top: 15px; }
        button { 
            width: 100%; 
            padding: 12px; 
            border: none; 
            border-radius: 8px; 
            font-size: 16px; 
            font-weight: bold; 
            cursor: pointer; 
            transition: 0.2s;
        }
        .btn-login { background-color: #1877f2; color: white; }
        .btn-login:hover { background-color: #166fe5; }
        
        .btn-register-toggle { background-color: #42b72a; color: white; }
        .btn-register-toggle:hover { background-color: #36a420; }
        
        /* ซ่อนฟิลด์ชื่อเต็มไว้ตอนแรก */
        #fullname-field { display: none; }
        .back-link { 
            display: block; 
            margin-top: 15px; 
            color: #1877f2; 
            text-decoration: none; 
            font-size: 14px; 
            cursor: pointer;
        }
    </style>
</head>
<body>

    <div class="login-card">
        <h2 id="form-title">E-Learning Login</h2>
        
        <form action="auth_process.jsp" method="POST" id="auth-form">
            <input type="hidden" name="action" id="form-action" value="login">
            
            <input type="text" name="username" placeholder="Username" required>
            <input type="password" name="password" placeholder="Password" required>
            
            <div id="fullname-field">
                <input type="text" name="fullname" id="fullname-input" placeholder="Full Name">
            </div>

            <div class="button-group" id="login-buttons">
                <button type="submit" class="btn-login">Login</button>
                <button type="button" class="btn-register-toggle" onclick="switchToRegister()">Create New Account</button>
            </div>

            <div class="button-group" id="register-buttons" style="display: none;">
                <button type="submit" class="btn-register-toggle">Confirm Sign Up</button>
                <span class="back-link" onclick="switchToLogin()">Back to Login</span>
            </div>
        </form>
    </div>

    <script>
        function switchToRegister() {
            document.getElementById('form-title').innerText = "Create Account";
            document.getElementById('form-action').value = "register";
            document.getElementById('fullname-field').style.display = "block";
            document.getElementById('fullname-input').required = true;
            document.getElementById('login-buttons').style.display = "none";
            document.getElementById('register-buttons').style.display = "flex";
        }

        function switchToLogin() {
            document.getElementById('form-title').innerText = "E-Learning Login";
            document.getElementById('form-action').value = "login";
            document.getElementById('fullname-field').style.display = "none";
            document.getElementById('fullname-input').required = false;
            document.getElementById('login-buttons').style.display = "flex";
            document.getElementById('register-buttons').style.display = "none";
        }
    </script>

</body>
</html>