<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*,java.io.*,java.nio.file.*" %>
<%@ include file="WEB-INF/db.jspf" %>
<%
  Integer userId = (Integer) session.getAttribute("userId");
  if (userId == null) { response.sendRedirect("login.jsp"); return; }
  if (!"POST".equals(request.getMethod())) { response.sendRedirect("courses.jsp"); return; }

  int courseId = 0, lessonId = 0;
  try { courseId = Integer.parseInt(request.getParameter("course_id")); } catch(Exception e) {}
  try { lessonId = Integer.parseInt(request.getParameter("lesson_id")); } catch(Exception e) {}

  // หมายเหตุ: ต้องใช้ Apache Commons FileUpload หรือ Servlet 3.0 @MultipartConfig
  // สำหรับ Tomcat 7+ ให้เพิ่ม annotation หรือใช้ getPart()
  String note = param(request, "note");  // หมายเหตุที่พิมพ์ (ภาษาไทยได้)
  String redirectUrl = "classroom.jsp?id=" + courseId + (lessonId > 0 ? "&lesson=" + lessonId : "");
  String errorMsg = "";

  try {
    // รับไฟล์ผ่าน Servlet 3.0 Part API (Tomcat 7+)
    javax.servlet.http.Part filePart = request.getPart("file");
    if (filePart != null && filePart.getSize() > 0) {
      // ดึงชื่อไฟล์จริง (รองรับ UTF-8)
      String originalName = filePart.getSubmittedFileName();
      if (originalName == null || originalName.isEmpty()) {
        originalName = "file_" + System.currentTimeMillis();
      }
      // Sanitize ชื่อไฟล์ (เก็บนามสกุล)
      String ext = "";
      int dotIdx = originalName.lastIndexOf('.');
      if (dotIdx >= 0) ext = originalName.substring(dotIdx);
      String safeFilename = userId + "_" + System.currentTimeMillis() + ext;

      // โฟลเดอร์บันทึกไฟล์
      String uploadDir = application.getRealPath("/uploads");
      File dir = new File(uploadDir);
      if (!dir.exists()) dir.mkdirs();

      // บันทึกไฟล์
      String savePath = uploadDir + File.separator + safeFilename;
      filePart.write(savePath);

      // บันทึกลง DB (รองรับภาษาไทยในชื่อไฟล์และหมายเหตุ)
      Connection con = null;
      try {
        con = getConnection();
        PreparedStatement ps = con.prepareStatement(
          "INSERT INTO submissions (user_id, course_id, filename, original_name, note) " +
          "VALUES (?, ?, ?, ?, ?)");
        ps.setInt(1, userId);
        ps.setInt(2, courseId);
        ps.setString(3, safeFilename);
        ps.setString(4, originalName);   // ชื่อไฟล์ภาษาไทยได้
        ps.setString(5, note);           // หมายเหตุภาษาไทยได้
        ps.executeUpdate();
        ps.close();
      } finally {
        if (con != null) try { con.close(); } catch(Exception e) {}
      }
      response.sendRedirect(redirectUrl + "&upload=success");
      return;
    } else {
      errorMsg = "กรุณาเลือกไฟล์ก่อนส่ง";
    }
  } catch(Exception e) {
    errorMsg = e.getMessage();
  }

  // ถ้ามี error redirect กลับพร้อม error message
  response.sendRedirect(redirectUrl + "&upload=error&msg=" +
    java.net.URLEncoder.encode(errorMsg, "UTF-8"));
%>
