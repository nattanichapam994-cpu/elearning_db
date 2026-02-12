<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Set character encoding for International text support
    request.setCharacterEncoding("UTF-8");

    String action = request.getParameter("action");
    String user = request.getParameter("username");
    String pass = request.getParameter("password");

    // Database Connection Settings
    String url = "jdbc:mysql://localhost:3306/elearning_db?useUnicode=true&characterEncoding=UTF-8";
    String dbUser = "root"; 
    String dbPass = ""; // Leave blank for default XAMPP/WAMP

    Connection conn = null;
    try {
        // Load MySQL Driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, dbUser, dbPass);

        if ("register".equals(action)) {
            // REGISTER LOGIC: The 'role' column will automatically be 'student' per DB default
            String name = request.getParameter("fullname");
            String sql = "INSERT INTO users (username, password, fullname) VALUES (?, ?, ?)";
            
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, user);
            pstmt.setString(2, pass);
            pstmt.setString(3, name);
            
            int result = pstmt.executeUpdate();
            if (result > 0) {
                out.println("<script>alert('Registration Successful!'); window.location='login.jsp';</script>");
            }
        } 
        else if ("login".equals(action)) {
            // LOGIN LOGIC
            String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, user);
            pstmt.setString(2, pass);
            
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                // Store user info in session
                session.setAttribute("userFullName", rs.getString("fullname"));
                session.setAttribute("userRole", rs.getString("role"));
                
                out.println("<script>alert('Welcome, " + rs.getString("fullname") + "!'); window.location='index.jsp';</script>");
            } else {
                out.println("<script>alert('Invalid Username or Password'); history.back();</script>");
            }
        }
    } catch (Exception e) {
        out.println("Database Error: " + e.getMessage());
    } finally {
        if (conn != null) conn.close();
    }
%>