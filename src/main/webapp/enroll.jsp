<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
  Integer sessUserId = (Integer) session.getAttribute("userId");
  if (sessUserId == null) { response.sendRedirect("login.jsp"); return; }

  final String DB_URL  = "jdbc:mysql://localhost:3306/elearning_db?useSSL=false&serverTimezone=Asia/Bangkok&characterEncoding=UTF-8";
  final String DB_USER = "root";
  final String DB_PASS = "";

  int courseId = 0;
  try { courseId = Integer.parseInt(request.getParameter("course_id")); } catch (Exception e) {}
  if (courseId == 0) { response.sendRedirect("courses.jsp"); return; }

  Connection con = null;
  try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    PreparedStatement ps = con.prepareStatement(
      "INSERT IGNORE INTO enrollments (user_id, course_id) VALUES (?,?)");
    ps.setInt(1, sessUserId);
    ps.setInt(2, courseId);
    ps.executeUpdate();
    ps.close();
  } catch (Exception e) {
    // duplicate ignored
  } finally {
    if (con != null) try { con.close(); } catch (Exception ex) {}
  }
  response.sendRedirect("classroom.jsp?id=" + courseId);
%>
