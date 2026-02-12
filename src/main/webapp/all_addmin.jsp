package com.example.demo;

import jakarta.persistence.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.List;

// --- 1. Model (Entity) ---
@Entity
@Table(name = "courses")
class Course {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long course_id;
    private String course_name;
    private Integer teacher_id;

    // Getters and Setters
    public Long getCourse_id() { return course_id; }
    public void setCourse_id(Long course_id) { this.course_id = course_id; }
    public String getCourse_name() { return course_name; }
    public void setCourse_name(String course_name) { this.course_name = course_name; }
    public Integer getTeacher_id() { return teacher_id; }
    public void setTeacher_id(Integer teacher_id) { this.teacher_id = teacher_id; }
}

// --- 2. Repository ---
interface CourseRepository extends JpaRepository<Course, Long> { }

// --- 3. Controller ---
@Controller
@RequestMapping("/courses")
class CourseController {

    @Autowired
    private CourseRepository repo;

    @GetMapping
    @ResponseBody // ????????????????????? String
    public String listPage() {
        List<Course> list = repo.findAll();
        StringBuilder rows = new StringBuilder();
        for (Course c : list) {
            rows.append(String.format("""
                <tr>
                    <td>%d</td>
                    <td>%s</td>
                    <td>%d</td>
                    <td>
                        <a href='/courses/delete/%d' class='btn btn-danger btn-sm'>??</a>
                        <button class='btn btn-warning btn-sm' onclick="edit('%d','%s','%d')">?????</button>
                    </td>
                </tr>
                """, c.getCourse_id(), c.getCourse_name(), c.getTeacher_id(), c.getCourse_id(), 
                     c.getCourse_id(), c.getCourse_name(), c.getTeacher_id()));
        }

        return """
            <html>
            <head>
                <link rel='stylesheet' href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css'>
                <title>Course Management</title>
            </head>
            <body class='container mt-5'>
                <h2>???????????????? (E-Learning)</h2>
                <div class='card p-3 mb-4'>
                    <form action='/courses/save' method='post'>
                        <input type='hidden' name='course_id' id='course_id'>
                        <div class='row'>
                            <div class='col'><input type='text' name='course_name' id='name' class='form-control' placeholder='?????????' required></div>
                            <div class='col'><input type='number' name='teacher_id' id='teacher' class='form-control' placeholder='ID ??????' required></div>
                            <div class='col'><button type='submit' class='btn btn-primary'>??????</button></div>
                        </div>
                    </form>
                </div>
                <table class='table table-bordered'>
                    <thead class='table-dark'><tr><th>ID</th><th>?????????</th><th>ID ??????</th><th>??????</th></tr></thead>
                    <tbody> %s </tbody>
                </table>
                <script>
                    function edit(id, name, teacher) {
                        document.getElementById('course_id').value = id;
                        document.getElementById('name').value = name;
                        document.getElementById('teacher').value = teacher;
                    }
                </script>
            </body>
            </html>
            """.formatted(rows.toString());
    }

    @PostMapping("/save")
    public String save(@ModelAttribute Course course) {
        repo.save(course);
        return "redirect:/courses";
    }

    @GetMapping("/delete/{id}")
    public String delete(@PathVariable Long id) {
        repo.deleteById(id);
        return "redirect:/courses";
    }
}

// --- 4. Main  Application ---
@SpringBootApplication
public class CourseApp {
    public static void main(String[] args) {
        SpringApplication.run(CourseApp.class, args);
    }
}