CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

select * from Departments

CREATE TABLE Instructors (
    instructor_id INT PRIMARY KEY,
    instructor_name VARCHAR(100),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

select * from Instructors

CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    instructor_id INT,
    department_id INT,
    FOREIGN KEY (instructor_id) REFERENCES Instructors(instructor_id),
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

select * from Courses

CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    enrollment_year INT,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

select * from Students 

CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    grade DECIMAL(3,2),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

select * from Enrollments

-- Departments
INSERT INTO Departments VALUES (1, 'Computer Science'), (2, 'Mathematics'), (3, 'Physics');

-- Instructors
INSERT INTO Instructors VALUES 
(1, 'Alice Johnson', 1),
(2, 'Bob Smith', 2),
(3, 'Charlie Brown', 3);

-- Courses
INSERT INTO Courses VALUES 
(1, 'Database Systems', 1, 1),
(2, 'Calculus', 2, 2),
(3, 'Quantum Mechanics', 3, 3),
(4, 'Algorithms', 1, 1),
(5, 'Linear Algebra', 2, 2);

-- Students
INSERT INTO Students VALUES 
(1, 'John Doe', 2021, 1),
(2, 'Jane Roe', 2020, 2),
(3, 'Mike Miles', 2022, 1),
(4, 'Sara Stone', 2021, 3);

-- Enrollments
INSERT INTO Enrollments VALUES 
(1, 1, 1,7.50),
(2, 1, 2,5.65),
(3, 2, 2,6.43),
(4, 3, 1,4.76),
(5, 3, 4,9.44),
(6, 4, 3,7.86),
(7, 2, 5,7.45),
(8, 4, 5,3.85);


~10 joins queries

-- 1. Students and their departments
SELECT s.student_name, d.department_name
FROM Students s
JOIN Departments d ON s.department_id = d.department_id;

-- 2. Students with their enrolled courses
SELECT s.student_name, c.course_name
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id;

-- 3. Courses and their instructors
SELECT c.course_name, i.instructor_name
FROM Courses c
JOIN Instructors i ON c.instructor_id = i.instructor_id;

-- 4. Instructors and their departments
SELECT i.instructor_name, d.department_name
FROM Instructors i
JOIN Departments d ON i.department_id = d.department_id;

-- 5. Enrollments with student and course details
SELECT e.enrollment_id, s.student_name, c.course_name, e.grade
FROM Enrollments e
JOIN Students s ON e.student_id = s.student_id
JOIN Courses c ON e.course_id = c.course_id;

-- 6. Students, their departments, and courses
SELECT s.student_name, d.department_name, c.course_name
FROM Students s
JOIN Departments d ON s.department_id = d.department_id
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id;

-- 7. Courses and department names
SELECT c.course_name, d.department_name
FROM Courses c
JOIN Departments d ON c.department_id = d.department_id;

-- 8. Instructor teaching details with courses and departments
SELECT i.instructor_name, c.course_name, d.department_name
FROM Instructors i
JOIN Courses c ON i.instructor_id = c.instructor_id
JOIN Departments d ON c.department_id = d.department_id;

-- 9. Students enrolled in courses with instructors
SELECT s.student_name, c.course_name, i.instructor_name
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
JOIN Instructors i ON c.instructor_id = i.instructor_id;

-- 10. Enrollments with student, course, instructor, and department
SELECT s.student_name, c.course_name, i.instructor_name, d.department_name
FROM Enrollments e
JOIN Students s ON e.student_id = s.student_id
JOIN Courses c ON e.course_id = c.course_id
JOIN Instructors i ON c.instructor_id = i.instructor_id
JOIN Departments d ON c.department_id = d.department_id;

~~10 Queries covering Aggregation, Group By, Having, Order By :-

-- 1. Average grade per course
SELECT c.course_name, AVG(e.grade) AS avg_grade
FROM Enrollments e
JOIN Courses c ON e.course_id = c.course_id
GROUP BY c.course_name;

-- 2. Number of students per department
SELECT d.department_name, COUNT(s.student_id) AS student_count
FROM Departments d
JOIN Students s ON d.department_id = s.department_id
GROUP BY d.department_name;

-- 3. Courses with more than 1 student enrolled
SELECT c.course_name, COUNT(e.student_id) AS enrollment_count
FROM Courses c
JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name
HAVING COUNT(e.student_id) > 1;

-- 4. Top 3 students with the highest grades
SELECT s.student_name, e.grade
FROM Enrollments e
JOIN Students s ON e.student_id = s.student_id
ORDER BY e.grade DESC
LIMIT 3;

-- 5. Department with average grades higher than 80
SELECT d.department_name, AVG(e.grade) AS avg_grade
FROM Departments d
JOIN Students s ON d.department_id = s.department_id
JOIN Enrollments e ON s.student_id = e.student_id
GROUP BY d.department_name
HAVING AVG(e.grade) > 80;

-- 6. Instructor with the highest average student grade
SELECT i.instructor_name, AVG(e.grade) AS avg_grade
FROM Instructors i
JOIN Courses c ON i.instructor_id = c.instructor_id
JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY i.instructor_name
ORDER BY avg_grade DESC
LIMIT 1;

-- 7. Students with average grade above 85
SELECT s.student_name, AVG(e.grade) AS avg_grade
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
GROUP BY s.student_name
HAVING AVG(e.grade) > 85;

-- 8. List of courses ordered by average grade
SELECT c.course_name, AVG(e.grade) AS avg_grade
FROM Courses c
JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name
ORDER BY avg_grade DESC;

-- 9. Count of courses per department
SELECT d.department_name, COUNT(c.course_id) AS course_count
FROM Departments d
JOIN Courses c ON d.department_id = c.department_id
GROUP BY d.department_name;

-- 10. Students who enrolled in more than 1 course
SELECT s.student_name, COUNT(e.course_id) AS course_count
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
GROUP BY s.student_name
HAVING COUNT(e.course_id) > 1;

