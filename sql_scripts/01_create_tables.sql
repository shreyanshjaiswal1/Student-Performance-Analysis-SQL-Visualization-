-- Database Setup and Table Creation Script
-- Student Performance Analysis Project

-- Create database (uncomment if creating new database)
-- CREATE DATABASE student_performance_analysis;
-- USE student_performance_analysis;

-- Drop tables if they exist (for clean setup)
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS performance_metrics;
DROP TABLE IF EXISTS student_scores;
DROP TABLE IF EXISTS exams;
DROP TABLE IF EXISTS teachers;
DROP TABLE IF EXISTS subjects;
DROP TABLE IF EXISTS students;

-- Create Students table
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    gender VARCHAR(10),
    grade_level INT CHECK (grade_level BETWEEN 9 AND 12),
    enrollment_date DATE,
    parent_education VARCHAR(50),
    family_income_bracket VARCHAR(20)
);

-- Create Subjects table
CREATE TABLE subjects (
    subject_id INT PRIMARY KEY,
    subject_name VARCHAR(100) NOT NULL,
    subject_category VARCHAR(50),
    credit_hours INT,
    difficulty_level VARCHAR(20)
);

-- Create Teachers table
CREATE TABLE teachers (
    teacher_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    department VARCHAR(50),
    years_experience INT,
    education_level VARCHAR(50)
);

-- Create Exams table
CREATE TABLE exams (
    exam_id INT PRIMARY KEY,
    subject_id INT,
    teacher_id INT,
    exam_type VARCHAR(20),
    exam_date DATE,
    max_score INT,
    semester VARCHAR(10),
    academic_year VARCHAR(10),
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id),
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
);

-- Create Student_Scores table
CREATE TABLE student_scores (
    score_id INT PRIMARY KEY,
    student_id INT,
    exam_id INT,
    score DECIMAL(5,2),
    attendance_rate DECIMAL(5,2),
    submission_date DATE,
    time_spent_minutes INT,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (exam_id) REFERENCES exams(exam_id)
);

-- Create Attendance table
CREATE TABLE attendance (
    attendance_id INT PRIMARY KEY,
    student_id INT,
    subject_id INT,
    attendance_date DATE,
    status VARCHAR(10),
    semester VARCHAR(10),
    academic_year VARCHAR(10),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

-- Create Performance_Metrics table
CREATE TABLE performance_metrics (
    metric_id INT PRIMARY KEY,
    student_id INT,
    subject_id INT,
    gpa DECIMAL(3,2),
    letter_grade VARCHAR(2),
    semester VARCHAR(10),
    academic_year VARCHAR(10),
    improvement_flag BOOLEAN,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

-- Create indexes for better performance
CREATE INDEX idx_student_scores_student_id ON student_scores(student_id);
CREATE INDEX idx_student_scores_exam_id ON student_scores(exam_id);
CREATE INDEX idx_exams_subject_id ON exams(subject_id);
CREATE INDEX idx_exams_teacher_id ON exams(teacher_id);
CREATE INDEX idx_attendance_student_id ON attendance(student_id);
CREATE INDEX idx_attendance_date ON attendance(attendance_date);
CREATE INDEX idx_performance_student_id ON performance_metrics(student_id);

-- Add comments to tables
COMMENT ON TABLE students IS 'Student demographic and enrollment information';
COMMENT ON TABLE subjects IS 'Academic subjects and their properties';
COMMENT ON TABLE teachers IS 'Teacher information and qualifications';
COMMENT ON TABLE exams IS 'Exam details and metadata';
COMMENT ON TABLE student_scores IS 'Individual student exam scores and performance data';
COMMENT ON TABLE attendance IS 'Daily attendance records for students';
COMMENT ON TABLE performance_metrics IS 'Calculated performance metrics and grades';

PRINT 'Database schema created successfully!';
