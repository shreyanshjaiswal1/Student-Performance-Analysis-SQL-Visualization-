-- Advanced SQL Analysis Queries
-- Student Performance Analysis Project
-- Window Functions, CTEs, and Advanced Analytics

-- =============================================================================
-- 1. STUDENT PERFORMANCE RANKING AND PERCENTILES
-- =============================================================================

-- Rank students by overall performance using window functions
WITH student_performance AS (
    SELECT 
        s.student_id,
        CONCAT(s.first_name, ' ', s.last_name) AS student_name,
        s.grade_level,
        s.parent_education,
        s.family_income_bracket,
        AVG(ss.score) AS avg_score,
        COUNT(ss.score_id) AS total_exams,
        AVG(ss.attendance_rate) AS avg_attendance
    FROM students s
    JOIN student_scores ss ON s.student_id = ss.student_id
    GROUP BY s.student_id, s.first_name, s.last_name, s.grade_level, 
             s.parent_education, s.family_income_bracket
)
SELECT 
    student_name,
    grade_level,
    avg_score,
    avg_attendance,
    -- Performance ranking
    ROW_NUMBER() OVER (ORDER BY avg_score DESC) AS performance_rank,
    RANK() OVER (ORDER BY avg_score DESC) AS performance_rank_with_ties,
    -- Percentile ranking
    PERCENT_RANK() OVER (ORDER BY avg_score) AS percentile_rank,
    NTILE(4) AS performance_quartile,
    -- Grade level comparison
    ROW_NUMBER() OVER (PARTITION BY grade_level ORDER BY avg_score DESC) AS rank_in_grade,
    AVG(avg_score) OVER (PARTITION BY grade_level) AS grade_avg,
    avg_score - AVG(avg_score) OVER (PARTITION BY grade_level) AS score_vs_grade_avg,
    -- Performance categories
    CASE 
        WHEN avg_score >= 90 THEN 'Excellent'
        WHEN avg_score >= 80 THEN 'Good'
        WHEN avg_score >= 70 THEN 'Average'
        ELSE 'Needs Improvement'
    END AS performance_category
FROM student_performance
ORDER BY avg_score DESC;

-- =============================================================================
-- 2. SUBJECT-WISE PERFORMANCE ANALYSIS WITH RUNNING STATISTICS
-- =============================================================================

-- Analyze performance trends by subject with running totals and moving averages
WITH subject_scores AS (
    SELECT 
        sub.subject_name,
        sub.subject_category,
        sub.difficulty_level,
        e.exam_date,
        e.exam_type,
        AVG(ss.score) AS avg_exam_score,
        COUNT(ss.student_id) AS students_count,
        STDDEV(ss.score) AS score_stddev,
        MIN(ss.score) AS min_score,
        MAX(ss.score) AS max_score
    FROM subjects sub
    JOIN exams e ON sub.subject_id = e.subject_id
    JOIN student_scores ss ON e.exam_id = ss.exam_id
    GROUP BY sub.subject_name, sub.subject_category, sub.difficulty_level,
             e.exam_date, e.exam_type, e.exam_id
)
SELECT 
    subject_name,
    subject_category,
    difficulty_level,
    exam_date,
    exam_type,
    avg_exam_score,
    students_count,
    score_stddev,
    -- Running statistics
    SUM(students_count) OVER (
        PARTITION BY subject_name 
        ORDER BY exam_date 
        ROWS UNBOUNDED PRECEDING
    ) AS cumulative_students,
    AVG(avg_exam_score) OVER (
        PARTITION BY subject_name 
        ORDER BY exam_date 
        ROWS 2 PRECEDING
    ) AS moving_avg_3_exams,
    -- Comparison with previous exam
    LAG(avg_exam_score) OVER (
        PARTITION BY subject_name 
        ORDER BY exam_date
    ) AS prev_exam_avg,
    avg_exam_score - LAG(avg_exam_score) OVER (
        PARTITION BY subject_name 
        ORDER BY exam_date
    ) AS score_change,
    -- Subject ranking
    DENSE_RANK() OVER (
        PARTITION BY exam_date 
        ORDER BY avg_exam_score DESC
    ) AS subject_rank_by_date
FROM subject_scores
ORDER BY subject_name, exam_date;

-- =============================================================================
-- 3. STUDENT IMPROVEMENT TRACKING WITH LEAD/LAG ANALYSIS
-- =============================================================================

-- Track individual student improvement over time
WITH student_exam_sequence AS (
    SELECT 
        s.student_id,
        CONCAT(s.first_name, ' ', s.last_name) AS student_name,
        sub.subject_name,
        e.exam_date,
        e.exam_type,
        ss.score,
        ss.attendance_rate,
        -- Sequence number for each student's exams
        ROW_NUMBER() OVER (
            PARTITION BY s.student_id, sub.subject_id 
            ORDER BY e.exam_date
        ) AS exam_sequence
    FROM students s
    JOIN student_scores ss ON s.student_id = ss.student_id
    JOIN exams e ON ss.exam_id = e.exam_id
    JOIN subjects sub ON e.subject_id = sub.subject_id
)
SELECT 
    student_name,
    subject_name,
    exam_date,
    exam_type,
    score,
    attendance_rate,
    exam_sequence,
    -- Performance comparison with previous exam
    LAG(score) OVER (
        PARTITION BY student_id, subject_name 
        ORDER BY exam_date
    ) AS prev_score,
    score - LAG(score) OVER (
        PARTITION BY student_id, subject_name 
        ORDER BY exam_date
    ) AS score_improvement,
    -- Performance comparison with next exam
    LEAD(score) OVER (
        PARTITION BY student_id, subject_name 
        ORDER BY exam_date
    ) AS next_score,
    -- Improvement trend analysis
    CASE 
        WHEN score > LAG(score) OVER (
            PARTITION BY student_id, subject_name 
            ORDER BY exam_date
        ) THEN 'Improving'
        WHEN score < LAG(score) OVER (
            PARTITION BY student_id, subject_name 
            ORDER BY exam_date
        ) THEN 'Declining'
        ELSE 'Stable'
    END AS trend,
    -- First and last exam comparison
    FIRST_VALUE(score) OVER (
        PARTITION BY student_id, subject_name 
        ORDER BY exam_date 
        ROWS UNBOUNDED PRECEDING
    ) AS first_exam_score,
    score - FIRST_VALUE(score) OVER (
        PARTITION BY student_id, subject_name 
        ORDER BY exam_date 
        ROWS UNBOUNDED PRECEDING
    ) AS total_improvement
FROM student_exam_sequence
ORDER BY student_name, subject_name, exam_date;

-- =============================================================================
-- 4. TEACHER EFFECTIVENESS ANALYSIS
-- =============================================================================

-- Analyze teacher performance and effectiveness
WITH teacher_performance AS (
    SELECT 
        t.teacher_id,
        CONCAT(t.first_name, ' ', t.last_name) AS teacher_name,
        t.department,
        t.years_experience,
        t.education_level,
        sub.subject_name,
        sub.difficulty_level,
        COUNT(DISTINCT ss.student_id) AS students_taught,
        COUNT(ss.score_id) AS total_exams_given,
        AVG(ss.score) AS avg_student_score,
        STDDEV(ss.score) AS score_variance,
        AVG(ss.attendance_rate) AS avg_attendance_rate,
        -- Grade distribution
        SUM(CASE WHEN ss.score >= 90 THEN 1 ELSE 0 END) AS a_grades,
        SUM(CASE WHEN ss.score >= 80 AND ss.score < 90 THEN 1 ELSE 0 END) AS b_grades,
        SUM(CASE WHEN ss.score >= 70 AND ss.score < 80 THEN 1 ELSE 0 END) AS c_grades,
        SUM(CASE WHEN ss.score < 70 THEN 1 ELSE 0 END) AS failing_grades
    FROM teachers t
    JOIN exams e ON t.teacher_id = e.teacher_id
    JOIN subjects sub ON e.subject_id = sub.subject_id
    JOIN student_scores ss ON e.exam_id = ss.exam_id
    GROUP BY t.teacher_id, t.first_name, t.last_name, t.department, 
             t.years_experience, t.education_level, sub.subject_name, sub.difficulty_level
)
SELECT 
    teacher_name,
    department,
    years_experience,
    education_level,
    subject_name,
    difficulty_level,
    students_taught,
    total_exams_given,
    ROUND(avg_student_score, 2) AS avg_student_score,
    ROUND(score_variance, 2) AS score_variance,
    ROUND(avg_attendance_rate, 2) AS avg_attendance_rate,
    -- Grade distribution percentages
    ROUND(a_grades * 100.0 / total_exams_given, 1) AS a_grade_percentage,
    ROUND(b_grades * 100.0 / total_exams_given, 1) AS b_grade_percentage,
    ROUND(c_grades * 100.0 / total_exams_given, 1) AS c_grade_percentage,
    ROUND(failing_grades * 100.0 / total_exams_given, 1) AS failing_percentage,
    -- Teacher ranking
    ROW_NUMBER() OVER (ORDER BY avg_student_score DESC) AS teacher_rank_by_scores,
    ROW_NUMBER() OVER (ORDER BY avg_attendance_rate DESC) AS teacher_rank_by_attendance,
    -- Experience vs Performance correlation
    CASE 
        WHEN years_experience > 10 AND avg_student_score > 85 THEN 'Highly Experienced & Effective'
        WHEN years_experience > 10 THEN 'Highly Experienced'
        WHEN avg_student_score > 85 THEN 'Highly Effective'
        ELSE 'Developing'
    END AS teacher_category
FROM teacher_performance
ORDER BY avg_student_score DESC;

-- =============================================================================
-- 5. COMPREHENSIVE PERFORMANCE DASHBOARD QUERY
-- =============================================================================

-- Main dashboard query combining multiple metrics
WITH performance_summary AS (
    SELECT 
        s.student_id,
        CONCAT(s.first_name, ' ', s.last_name) AS student_name,
        s.grade_level,
        s.parent_education,
        s.family_income_bracket,
        COUNT(DISTINCT e.subject_id) AS subjects_taken,
        COUNT(ss.score_id) AS total_exams,
        AVG(ss.score) AS overall_gpa,
        AVG(ss.attendance_rate) AS avg_attendance,
        MIN(ss.score) AS lowest_score,
        MAX(ss.score) AS highest_score,
        STDDEV(ss.score) AS score_consistency,
        -- STEM vs Non-STEM performance
        AVG(CASE WHEN sub.subject_category = 'STEM' THEN ss.score END) AS stem_avg,
        AVG(CASE WHEN sub.subject_category != 'STEM' THEN ss.score END) AS non_stem_avg
    FROM students s
    JOIN student_scores ss ON s.student_id = ss.student_id
    JOIN exams e ON ss.exam_id = e.exam_id
    JOIN subjects sub ON e.subject_id = sub.subject_id
    GROUP BY s.student_id, s.first_name, s.last_name, s.grade_level, 
             s.parent_education, s.family_income_bracket
)
SELECT 
    student_name,
    grade_level,
    parent_education,
    family_income_bracket,
    subjects_taken,
    total_exams,
    ROUND(overall_gpa, 2) AS overall_gpa,
    ROUND(avg_attendance, 1) AS avg_attendance,
    ROUND(lowest_score, 1) AS lowest_score,
    ROUND(highest_score, 1) AS highest_score,
    ROUND(score_consistency, 2) AS score_consistency,
    ROUND(stem_avg, 2) AS stem_average,
    ROUND(non_stem_avg, 2) AS non_stem_average,
    ROUND(stem_avg - non_stem_avg, 2) AS stem_vs_nonstem_diff,
    -- Performance indicators
    CASE 
        WHEN overall_gpa >= 95 THEN 'Outstanding'
        WHEN overall_gpa >= 90 THEN 'Excellent'
        WHEN overall_gpa >= 85 THEN 'Very Good'
        WHEN overall_gpa >= 80 THEN 'Good'
        WHEN overall_gpa >= 75 THEN 'Satisfactory'
        WHEN overall_gpa >= 70 THEN 'Needs Improvement'
        ELSE 'At Risk'
    END AS performance_level,
    -- Risk indicators
    CASE 
        WHEN avg_attendance < 85 OR overall_gpa < 70 THEN 'High Risk'
        WHEN avg_attendance < 90 OR overall_gpa < 80 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_level,
    -- Recommendations
    CASE 
        WHEN avg_attendance < 85 THEN 'Focus on Attendance'
        WHEN score_consistency > 15 THEN 'Improve Consistency'
        WHEN stem_avg < non_stem_avg - 10 THEN 'STEM Support Needed'
        WHEN overall_gpa < 75 THEN 'Academic Support Required'
        ELSE 'Continue Current Performance'
    END AS recommendation
FROM performance_summary
ORDER BY overall_gpa DESC;
