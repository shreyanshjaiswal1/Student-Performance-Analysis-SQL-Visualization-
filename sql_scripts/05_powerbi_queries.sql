-- Power BI Data Export Queries
-- Optimized queries for Power BI dashboard consumption

-- =============================================================================
-- MAIN DASHBOARD QUERIES FOR POWER BI
-- =============================================================================

-- Query 1: Student Summary for Dashboard
SELECT 
    s.student_id,
    s.first_name + ' ' + s.last_name AS student_name,
    s.first_name,
    s.last_name,
    s.date_of_birth,
    s.gender,
    s.grade_level,
    s.enrollment_date,
    s.parent_education,
    s.family_income_bracket,
    DATEDIFF(YEAR, s.date_of_birth, GETDATE()) AS age,
    -- Performance metrics
    COUNT(ss.score_id) AS total_exams,
    AVG(ss.score) AS average_score,
    AVG(ss.attendance_rate) AS average_attendance,
    MIN(ss.score) AS lowest_score,
    MAX(ss.score) AS highest_score,
    STDEV(ss.score) AS score_consistency,
    -- Performance categories
    CASE 
        WHEN AVG(ss.score) >= 90 THEN 'Excellent'
        WHEN AVG(ss.score) >= 80 THEN 'Good'
        WHEN AVG(ss.score) >= 70 THEN 'Average'
        WHEN AVG(ss.score) >= 60 THEN 'Below Average'
        ELSE 'Failing'
    END AS performance_category,
    -- Risk assessment
    CASE 
        WHEN AVG(ss.score) < 70 OR AVG(ss.attendance_rate) < 85 THEN 'High Risk'
        WHEN AVG(ss.score) < 80 OR AVG(ss.attendance_rate) < 90 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_level,
    -- Current year/semester
    '2023-24' AS academic_year,
    'Fall' AS current_semester
FROM students s
LEFT JOIN student_scores ss ON s.student_id = ss.student_id
GROUP BY s.student_id, s.first_name, s.last_name, s.date_of_birth, 
         s.gender, s.grade_level, s.enrollment_date, s.parent_education, s.family_income_bracket;

-- Query 2: Detailed Score Records for Trending
SELECT 
    ss.score_id,
    ss.student_id,
    s.first_name + ' ' + s.last_name AS student_name,
    s.grade_level,
    ss.exam_id,
    e.exam_type,
    e.exam_date,
    e.semester,
    e.academic_year,
    e.max_score,
    sub.subject_id,
    sub.subject_name,
    sub.subject_category,
    sub.difficulty_level,
    sub.credit_hours,
    t.teacher_id,
    t.first_name + ' ' + t.last_name AS teacher_name,
    t.department,
    t.years_experience,
    ss.score,
    ss.attendance_rate,
    ss.submission_date,
    ss.time_spent_minutes,
    -- Calculated fields for Power BI
    CAST(ss.score AS DECIMAL(5,2)) / e.max_score * 100 AS score_percentage,
    CASE 
        WHEN ss.score >= 0.9 * e.max_score THEN 'A'
        WHEN ss.score >= 0.8 * e.max_score THEN 'B'
        WHEN ss.score >= 0.7 * e.max_score THEN 'C'
        WHEN ss.score >= 0.6 * e.max_score THEN 'D'
        ELSE 'F'
    END AS letter_grade,
    -- Date dimensions for time-based analysis
    YEAR(e.exam_date) AS exam_year,
    MONTH(e.exam_date) AS exam_month,
    DATENAME(MONTH, e.exam_date) AS exam_month_name,
    DATEPART(QUARTER, e.exam_date) AS exam_quarter
FROM student_scores ss
JOIN students s ON ss.student_id = s.student_id
JOIN exams e ON ss.exam_id = e.exam_id
JOIN subjects sub ON e.subject_id = sub.subject_id
JOIN teachers t ON e.teacher_id = t.teacher_id;

-- Query 3: Subject Performance Summary
SELECT 
    sub.subject_id,
    sub.subject_name,
    sub.subject_category,
    sub.difficulty_level,
    sub.credit_hours,
    COUNT(DISTINCT ss.student_id) AS students_enrolled,
    COUNT(ss.score_id) AS total_exams,
    AVG(ss.score) AS average_score,
    MIN(ss.score) AS min_score,
    MAX(ss.score) AS max_score,
    STDEV(ss.score) AS score_stddev,
    AVG(ss.attendance_rate) AS average_attendance,
    -- Grade distribution
    SUM(CASE WHEN ss.score >= 90 THEN 1 ELSE 0 END) AS a_count,
    SUM(CASE WHEN ss.score >= 80 AND ss.score < 90 THEN 1 ELSE 0 END) AS b_count,
    SUM(CASE WHEN ss.score >= 70 AND ss.score < 80 THEN 1 ELSE 0 END) AS c_count,
    SUM(CASE WHEN ss.score >= 60 AND ss.score < 70 THEN 1 ELSE 0 END) AS d_count,
    SUM(CASE WHEN ss.score < 60 THEN 1 ELSE 0 END) AS f_count,
    -- Success rates
    CAST(SUM(CASE WHEN ss.score >= 70 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(ss.score_id) * 100 AS pass_rate,
    CAST(SUM(CASE WHEN ss.score >= 90 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(ss.score_id) * 100 AS excellence_rate
FROM subjects sub
LEFT JOIN exams e ON sub.subject_id = e.subject_id
LEFT JOIN student_scores ss ON e.exam_id = ss.exam_id
GROUP BY sub.subject_id, sub.subject_name, sub.subject_category, 
         sub.difficulty_level, sub.credit_hours;

-- Query 4: Teacher Performance Summary
SELECT 
    t.teacher_id,
    t.first_name + ' ' + t.last_name AS teacher_name,
    t.first_name,
    t.last_name,
    t.department,
    t.years_experience,
    t.education_level,
    COUNT(DISTINCT ss.student_id) AS students_taught,
    COUNT(DISTINCT e.subject_id) AS subjects_taught,
    COUNT(ss.score_id) AS total_exams_given,
    AVG(ss.score) AS average_student_score,
    AVG(ss.attendance_rate) AS average_attendance_rate,
    STDEV(ss.score) AS score_consistency,
    -- Grade distribution
    SUM(CASE WHEN ss.score >= 90 THEN 1 ELSE 0 END) AS a_grades,
    SUM(CASE WHEN ss.score >= 80 AND ss.score < 90 THEN 1 ELSE 0 END) AS b_grades,
    SUM(CASE WHEN ss.score >= 70 AND ss.score < 80 THEN 1 ELSE 0 END) AS c_grades,
    SUM(CASE WHEN ss.score < 70 THEN 1 ELSE 0 END) AS failing_grades,
    -- Performance metrics
    CAST(SUM(CASE WHEN ss.score >= 70 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(ss.score_id) * 100 AS success_rate,
    CAST(SUM(CASE WHEN ss.score >= 90 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(ss.score_id) * 100 AS excellence_rate
FROM teachers t
LEFT JOIN exams e ON t.teacher_id = e.teacher_id
LEFT JOIN student_scores ss ON e.exam_id = ss.exam_id
GROUP BY t.teacher_id, t.first_name, t.last_name, t.department, 
         t.years_experience, t.education_level;

-- Query 5: Time Series Data for Trends
SELECT 
    e.exam_date,
    e.semester,
    e.academic_year,
    YEAR(e.exam_date) AS year,
    MONTH(e.exam_date) AS month,
    DATENAME(MONTH, e.exam_date) AS month_name,
    COUNT(ss.score_id) AS total_exams,
    AVG(ss.score) AS average_score,
    AVG(ss.attendance_rate) AS average_attendance,
    COUNT(DISTINCT ss.student_id) AS unique_students,
    -- Performance distribution
    SUM(CASE WHEN ss.score >= 90 THEN 1 ELSE 0 END) AS excellent_count,
    SUM(CASE WHEN ss.score >= 80 AND ss.score < 90 THEN 1 ELSE 0 END) AS good_count,
    SUM(CASE WHEN ss.score >= 70 AND ss.score < 80 THEN 1 ELSE 0 END) AS average_count,
    SUM(CASE WHEN ss.score < 70 THEN 1 ELSE 0 END) AS poor_count
FROM exams e
LEFT JOIN student_scores ss ON e.exam_id = ss.exam_id
GROUP BY e.exam_date, e.semester, e.academic_year
ORDER BY e.exam_date;

-- Query 6: Demographic Analysis
SELECT 
    s.family_income_bracket,
    s.parent_education,
    s.gender,
    s.grade_level,
    COUNT(DISTINCT s.student_id) AS student_count,
    AVG(ss.score) AS average_score,
    AVG(ss.attendance_rate) AS average_attendance,
    STDEV(ss.score) AS score_variation,
    -- Performance categories
    SUM(CASE WHEN ss.score >= 90 THEN 1 ELSE 0 END) AS excellent_performers,
    SUM(CASE WHEN ss.score >= 80 AND ss.score < 90 THEN 1 ELSE 0 END) AS good_performers,
    SUM(CASE WHEN ss.score >= 70 AND ss.score < 80 THEN 1 ELSE 0 END) AS average_performers,
    SUM(CASE WHEN ss.score < 70 THEN 1 ELSE 0 END) AS struggling_performers,
    -- Risk assessment
    SUM(CASE WHEN ss.score < 70 OR ss.attendance_rate < 85 THEN 1 ELSE 0 END) AS high_risk_count
FROM students s
LEFT JOIN student_scores ss ON s.student_id = ss.student_id
GROUP BY s.family_income_bracket, s.parent_education, s.gender, s.grade_level;

-- Query 7: Calendar/Date Dimension for Power BI
WITH DateSeries AS (
    SELECT 
        DATEADD(DAY, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1, '2023-01-01') AS calendar_date
    FROM sys.objects s1 CROSS JOIN sys.objects s2
)
SELECT 
    calendar_date,
    YEAR(calendar_date) AS calendar_year,
    MONTH(calendar_date) AS calendar_month,
    DAY(calendar_date) AS calendar_day,
    DATENAME(MONTH, calendar_date) AS month_name,
    DATENAME(WEEKDAY, calendar_date) AS day_name,
    DATEPART(QUARTER, calendar_date) AS calendar_quarter,
    DATEPART(WEEK, calendar_date) AS week_number,
    CASE 
        WHEN MONTH(calendar_date) IN (8, 9, 10, 11, 12) THEN 'Fall'
        WHEN MONTH(calendar_date) IN (1, 2, 3, 4, 5) THEN 'Spring'
        ELSE 'Summer'
    END AS academic_semester,
    CASE 
        WHEN MONTH(calendar_date) >= 8 THEN CAST(YEAR(calendar_date) AS VARCHAR) + '-' + CAST(YEAR(calendar_date) + 1 AS VARCHAR)
        ELSE CAST(YEAR(calendar_date) - 1 AS VARCHAR) + '-' + CAST(YEAR(calendar_date) AS VARCHAR)
    END AS academic_year
FROM DateSeries
WHERE calendar_date BETWEEN '2023-01-01' AND '2024-12-31';
