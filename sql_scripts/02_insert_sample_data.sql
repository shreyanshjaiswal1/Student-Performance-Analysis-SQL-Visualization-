-- Sample Data Insert Script
-- Student Performance Analysis Project

-- Insert Students data
INSERT INTO students (student_id, first_name, last_name, date_of_birth, gender, grade_level, enrollment_date, parent_education, family_income_bracket) VALUES
(1, 'Emily', 'Johnson', '2007-03-15', 'F', 11, '2022-08-15', 'Bachelor Degree', '50-75k'),
(2, 'Michael', 'Chen', '2006-11-22', 'M', 12, '2021-08-15', 'Master Degree', '75-100k'),
(3, 'Sarah', 'Williams', '2008-01-08', 'F', 10, '2023-08-15', 'High School', '25-50k'),
(4, 'David', 'Brown', '2007-07-30', 'M', 11, '2022-08-15', 'PhD', '100k+'),
(5, 'Jessica', 'Davis', '2006-05-12', 'F', 12, '2021-08-15', 'Bachelor Degree', '50-75k'),
(6, 'Ryan', 'Miller', '2008-09-03', 'M', 10, '2023-08-15', 'Associate Degree', '25-50k'),
(7, 'Amanda', 'Wilson', '2007-12-18', 'F', 11, '2022-08-15', 'Master Degree', '75-100k'),
(8, 'Kevin', 'Moore', '2006-08-25', 'M', 12, '2021-08-15', 'High School', 'Under 25k'),
(9, 'Lisa', 'Taylor', '2008-04-07', 'F', 10, '2023-08-15', 'Bachelor Degree', '50-75k'),
(10, 'Brandon', 'Anderson', '2007-10-14', 'M', 11, '2022-08-15', 'Master Degree', '75-100k'),
(11, 'Natalie', 'Thomas', '2006-02-28', 'F', 12, '2021-08-15', 'PhD', '100k+'),
(12, 'Christopher', 'Jackson', '2008-06-19', 'M', 10, '2023-08-15', 'High School', '25-50k'),
(13, 'Ashley', 'White', '2007-11-05', 'F', 11, '2022-08-15', 'Bachelor Degree', '50-75k'),
(14, 'Daniel', 'Harris', '2006-09-16', 'M', 12, '2021-08-15', 'Associate Degree', '25-50k'),
(15, 'Megan', 'Clark', '2008-03-23', 'F', 10, '2023-08-15', 'Master Degree', '75-100k'),
(16, 'Joshua', 'Lewis', '2007-05-11', 'M', 11, '2022-08-15', 'Bachelor Degree', '50-75k'),
(17, 'Rachel', 'Lee', '2006-12-02', 'F', 12, '2021-08-15', 'PhD', '100k+'),
(18, 'Tyler', 'Walker', '2008-07-27', 'M', 10, '2023-08-15', 'High School', 'Under 25k'),
(19, 'Stephanie', 'Hall', '2007-01-13', 'F', 11, '2022-08-15', 'Bachelor Degree', '50-75k'),
(20, 'Nicholas', 'Allen', '2006-04-09', 'M', 12, '2021-08-15', 'Master Degree', '75-100k');

-- Insert Subjects data
INSERT INTO subjects (subject_id, subject_name, subject_category, credit_hours, difficulty_level) VALUES
(1, 'Advanced Mathematics', 'STEM', 4, 'Hard'),
(2, 'Physics', 'STEM', 4, 'Hard'),
(3, 'Chemistry', 'STEM', 4, 'Medium'),
(4, 'Biology', 'STEM', 3, 'Medium'),
(5, 'English Literature', 'Arts', 3, 'Medium'),
(6, 'History', 'Social Studies', 3, 'Medium'),
(7, 'Spanish', 'Languages', 3, 'Easy'),
(8, 'Art', 'Arts', 2, 'Easy'),
(9, 'Computer Science', 'STEM', 4, 'Hard'),
(10, 'Economics', 'Social Studies', 3, 'Medium'),
(11, 'Geography', 'Social Studies', 2, 'Easy'),
(12, 'Music', 'Arts', 2, 'Easy');

-- Insert Teachers data
INSERT INTO teachers (teacher_id, first_name, last_name, department, years_experience, education_level) VALUES
(1, 'Dr. Robert', 'Smith', 'Mathematics', 15, 'PhD'),
(2, 'Ms. Jennifer', 'Garcia', 'Science', 8, 'Master Degree'),
(3, 'Mr. William', 'Martinez', 'Science', 12, 'Master Degree'),
(4, 'Dr. Linda', 'Rodriguez', 'Science', 20, 'PhD'),
(5, 'Ms. Mary', 'Lopez', 'English', 10, 'Master Degree'),
(6, 'Mr. James', 'Gonzalez', 'Social Studies', 7, 'Master Degree'),
(7, 'Ms. Patricia', 'Wilson', 'Languages', 5, 'Master Degree'),
(8, 'Mr. Richard', 'Anderson', 'Arts', 9, 'Bachelor Degree'),
(9, 'Dr. Barbara', 'Thomas', 'Computer Science', 18, 'PhD'),
(10, 'Ms. Elizabeth', 'Taylor', 'Social Studies', 6, 'Master Degree'),
(11, 'Mr. Charles', 'Moore', 'Social Studies', 11, 'Master Degree'),
(12, 'Ms. Susan', 'Jackson', 'Arts', 4, 'Bachelor Degree');

-- Insert Exams data for Fall 2023
INSERT INTO exams (exam_id, subject_id, teacher_id, exam_type, exam_date, max_score, semester, academic_year) VALUES
-- Mathematics
(1, 1, 1, 'Midterm', '2023-10-15', 100, 'Fall', '2023-24'),
(2, 1, 1, 'Final', '2023-12-15', 100, 'Fall', '2023-24'),
(3, 1, 1, 'Quiz', '2023-09-20', 50, 'Fall', '2023-24'),
-- Physics
(4, 2, 2, 'Midterm', '2023-10-18', 100, 'Fall', '2023-24'),
(5, 2, 2, 'Final', '2023-12-18', 100, 'Fall', '2023-24'),
(6, 2, 2, 'Assignment', '2023-11-01', 75, 'Fall', '2023-24'),
-- Chemistry
(7, 3, 3, 'Midterm', '2023-10-20', 100, 'Fall', '2023-24'),
(8, 3, 3, 'Final', '2023-12-20', 100, 'Fall', '2023-24'),
(9, 3, 3, 'Quiz', '2023-09-25', 50, 'Fall', '2023-24'),
-- Biology
(10, 4, 4, 'Midterm', '2023-10-12', 100, 'Fall', '2023-24'),
(11, 4, 4, 'Final', '2023-12-12', 100, 'Fall', '2023-24'),
-- English Literature
(12, 5, 5, 'Midterm', '2023-10-25', 100, 'Fall', '2023-24'),
(13, 5, 5, 'Final', '2023-12-14', 100, 'Fall', '2023-24'),
(14, 5, 5, 'Assignment', '2023-11-15', 80, 'Fall', '2023-24'),
-- History
(15, 6, 6, 'Midterm', '2023-10-22', 100, 'Fall', '2023-24'),
(16, 6, 6, 'Final', '2023-12-16', 100, 'Fall', '2023-24');

-- Insert Student Scores (sample data for analysis)
INSERT INTO student_scores (score_id, student_id, exam_id, score, attendance_rate, submission_date, time_spent_minutes) VALUES
-- Student 1 scores
(1, 1, 1, 88.5, 95.0, '2023-10-15', 120),
(2, 1, 2, 92.0, 95.0, '2023-12-15', 180),
(3, 1, 3, 45.0, 95.0, '2023-09-20', 45),
(4, 1, 4, 85.5, 93.0, '2023-10-18', 125),
(5, 1, 5, 89.0, 93.0, '2023-12-18', 175),
-- Student 2 scores
(6, 2, 1, 95.5, 98.0, '2023-10-15', 110),
(7, 2, 2, 97.0, 98.0, '2023-12-15', 170),
(8, 2, 3, 48.5, 98.0, '2023-09-20', 40),
(9, 2, 4, 93.0, 96.0, '2023-10-18', 115),
(10, 2, 5, 96.5, 96.0, '2023-12-18', 160),
-- Student 3 scores
(11, 3, 1, 72.0, 87.0, '2023-10-15', 135),
(12, 3, 2, 75.5, 87.0, '2023-12-15', 190),
(13, 3, 3, 35.0, 87.0, '2023-09-20', 50),
(14, 3, 4, 68.5, 85.0, '2023-10-18', 140),
(15, 3, 5, 71.0, 85.0, '2023-12-18', 185),
-- Student 4 scores
(16, 4, 1, 98.0, 99.0, '2023-10-15', 105),
(17, 4, 2, 99.5, 99.0, '2023-12-15', 155),
(18, 4, 3, 49.5, 99.0, '2023-09-20', 35),
(19, 4, 4, 97.5, 97.0, '2023-10-18', 108),
(20, 4, 5, 98.0, 97.0, '2023-12-18', 150),
-- Student 5 scores
(21, 5, 1, 91.0, 94.0, '2023-10-15', 118),
(22, 5, 2, 93.5, 94.0, '2023-12-15', 165),
(23, 5, 3, 46.5, 94.0, '2023-09-20', 42),
(24, 5, 4, 87.0, 92.0, '2023-10-18', 122),
(25, 5, 5, 90.5, 92.0, '2023-12-18', 168);

PRINT 'Sample data inserted successfully!';
