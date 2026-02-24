-- ====================================================
-- รันไฟล์นี้ใน phpMyAdmin ก่อนใช้งานระบบ
-- ตั้งค่า charset ให้รองรับภาษาไทยอย่างสมบูรณ์
-- ====================================================

-- 1. ตั้งค่า Database charset
ALTER DATABASE elearning_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

-- 2. แก้ทุกตารางให้เป็น utf8mb4
ALTER TABLE users       CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE courses     CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE lessons     CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE quizzes     CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE questions   CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE choices     CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE enrollments CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE results     CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 3. สร้างตาราง submissions (ส่งงาน)
CREATE TABLE IF NOT EXISTS submissions (
  submission_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id       INT          NOT NULL,
  course_id     INT          NOT NULL,
  filename      VARCHAR(255) NOT NULL            COMMENT 'ชื่อไฟล์บน server',
  original_name VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ชื่อไฟล์จริง (ภาษาไทยได้)',
  note          TEXT         CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'หมายเหตุ (ภาษาไทยได้)',
  submitted_at  DATETIME     DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id)   REFERENCES users(user_id)   ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 4. สร้างตาราง lesson_progress
CREATE TABLE IF NOT EXISTS lesson_progress (
  progress_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id     INT NOT NULL,
  lesson_id   INT NOT NULL,
  course_id   INT NOT NULL,
  completed   TINYINT(1) DEFAULT 0,
  viewed_at   DATETIME   DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_progress (user_id, lesson_id),
  FOREIGN KEY (user_id)   REFERENCES users(user_id)     ON DELETE CASCADE,
  FOREIGN KEY (lesson_id) REFERENCES lessons(lesson_id) ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 5. สร้างตาราง student_notes (โน้ตภาษาไทย)
CREATE TABLE IF NOT EXISTS student_notes (
  note_id    INT AUTO_INCREMENT PRIMARY KEY,
  user_id    INT  NOT NULL,
  course_id  INT  NOT NULL,
  note_text  TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_note (user_id, course_id),
  FOREIGN KEY (user_id)   REFERENCES users(user_id)     ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 6. เพิ่ม enrolled_at ใน enrollments (ถ้ายังไม่มี)
ALTER TABLE enrollments
  ADD COLUMN IF NOT EXISTS enrolled_at DATETIME DEFAULT CURRENT_TIMESTAMP;

-- 7. เพิ่ม submitted_at ใน results (ถ้ายังไม่มี)
ALTER TABLE results
  ADD COLUMN IF NOT EXISTS submitted_at DATETIME DEFAULT CURRENT_TIMESTAMP;

-- 8. ทดสอบว่าภาษาไทยทำงานได้
SELECT 'ทดสอบภาษาไทย ✓' AS test_thai;
