# Data Dictionary

## Students Table
| Column | Data Type | Description |
|--------|-----------|-------------|
| student_id | INT | Unique identifier for each student |
| first_name | VARCHAR(50) | Student's first name |
| last_name | VARCHAR(50) | Student's last name |
| date_of_birth | DATE | Student's birth date |
| gender | VARCHAR(10) | Student's gender (M/F/Other) |
| grade_level | INT | Current grade level (9-12) |
| enrollment_date | DATE | Date of enrollment |
| parent_education | VARCHAR(50) | Highest parent education level |
| family_income_bracket | VARCHAR(20) | Family income range |

## Subjects Table
| Column | Data Type | Description |
|--------|-----------|-------------|
| subject_id | INT | Unique identifier for each subject |
| subject_name | VARCHAR(100) | Name of the subject |
| subject_category | VARCHAR(50) | Category (STEM, Arts, Languages, etc.) |
| credit_hours | INT | Number of credit hours |
| difficulty_level | VARCHAR(20) | Easy, Medium, Hard |

## Teachers Table
| Column | Data Type | Description |
|--------|-----------|-------------|
| teacher_id | INT | Unique identifier for each teacher |
| first_name | VARCHAR(50) | Teacher's first name |
| last_name | VARCHAR(50) | Teacher's last name |
| department | VARCHAR(50) | Department name |
| years_experience | INT | Years of teaching experience |
| education_level | VARCHAR(50) | Teacher's education level |

## Exams Table
| Column | Data Type | Description |
|--------|-----------|-------------|
| exam_id | INT | Unique identifier for each exam |
| subject_id | INT | Foreign key to subjects table |
| teacher_id | INT | Foreign key to teachers table |
| exam_type | VARCHAR(20) | Type (Midterm, Final, Quiz, Assignment) |
| exam_date | DATE | Date of the exam |
| max_score | INT | Maximum possible score |
| semester | VARCHAR(10) | Semester (Fall, Spring, Summer) |
| academic_year | VARCHAR(10) | Academic year (2023-24, etc.) |

## Student_Scores Table
| Column | Data Type | Description |
|--------|-----------|-------------|
| score_id | INT | Unique identifier for each score record |
| student_id | INT | Foreign key to students table |
| exam_id | INT | Foreign key to exams table |
| score | DECIMAL(5,2) | Score achieved by student |
| attendance_rate | DECIMAL(5,2) | Attendance percentage for the subject |
| submission_date | DATE | Date of exam submission |
| time_spent_minutes | INT | Time spent on exam in minutes |

## Attendance Table
| Column | Data Type | Description |
|--------|-----------|-------------|
| attendance_id | INT | Unique identifier |
| student_id | INT | Foreign key to students table |
| subject_id | INT | Foreign key to subjects table |
| attendance_date | DATE | Date of attendance record |
| status | VARCHAR(10) | Present, Absent, Late |
| semester | VARCHAR(10) | Semester |
| academic_year | VARCHAR(10) | Academic year |

## Performance_Metrics Table
| Column | Data Type | Description |
|--------|-----------|-------------|
| metric_id | INT | Unique identifier |
| student_id | INT | Foreign key to students table |
| subject_id | INT | Foreign key to subjects table |
| gpa | DECIMAL(3,2) | Grade Point Average |
| letter_grade | VARCHAR(2) | Letter grade (A, B, C, D, F) |
| semester | VARCHAR(10) | Semester |
| academic_year | VARCHAR(10) | Academic year |
| improvement_flag | BOOLEAN | True if improved from previous semester |
