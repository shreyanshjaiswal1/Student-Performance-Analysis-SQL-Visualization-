-- Performance Insights and Statistical Analysis
-- Student Performance Analysis Project
-- Advanced Statistical Queries and Insights

-- =============================================================================
-- 1. CORRELATION ANALYSIS - ATTENDANCE VS PERFORMANCE
-- =============================================================================

-- Analyze the correlation between attendance and academic performance
WITH attendance_performance AS (
    SELECT 
        s.student_id,
        CONCAT(s.first_name, ' ', s.last_name) AS student_name,
        s.family_income_bracket,
        s.parent_education,
        AVG(ss.score) AS avg_score,
        AVG(ss.attendance_rate) AS avg_attendance,
        -- Attendance categories
        CASE 
            WHEN AVG(ss.attendance_rate) >= 95 THEN 'Excellent Attendance (95%+)'
            WHEN AVG(ss.attendance_rate) >= 90 THEN 'Good Attendance (90-94%)'
            WHEN AVG(ss.attendance_rate) >= 85 THEN 'Fair Attendance (85-89%)'
            ELSE 'Poor Attendance (<85%)'
        END AS attendance_category
    FROM students s
    JOIN student_scores ss ON s.student_id = ss.student_id
    GROUP BY s.student_id, s.first_name, s.last_name, s.family_income_bracket, s.parent_education
)
SELECT 
    attendance_category,
    COUNT(*) AS student_count,
    ROUND(AVG(avg_score), 2) AS avg_performance,
    ROUND(MIN(avg_score), 2) AS min_performance,
    ROUND(MAX(avg_score), 2) AS max_performance,
    ROUND(STDDEV(avg_score), 2) AS performance_stddev,
    -- Performance distribution by attendance
    COUNT(CASE WHEN avg_score >= 90 THEN 1 END) AS excellent_performers,
    COUNT(CASE WHEN avg_score >= 80 AND avg_score < 90 THEN 1 END) AS good_performers,
    COUNT(CASE WHEN avg_score >= 70 AND avg_score < 80 THEN 1 END) AS average_performers,
    COUNT(CASE WHEN avg_score < 70 THEN 1 END) AS poor_performers,
    -- Percentage calculations
    ROUND(COUNT(CASE WHEN avg_score >= 90 THEN 1 END) * 100.0 / COUNT(*), 1) AS excellent_percentage
FROM attendance_performance
GROUP BY attendance_category
ORDER BY avg_performance DESC;

-- =============================================================================
-- 2. SOCIOECONOMIC IMPACT ANALYSIS
-- =============================================================================

-- Analyze the impact of family income and parent education on student performance
WITH socioeconomic_analysis AS (
    SELECT 
        s.family_income_bracket,
        s.parent_education,
        COUNT(DISTINCT s.student_id) AS student_count,
        AVG(ss.score) AS avg_score,
        AVG(ss.attendance_rate) AS avg_attendance,
        STDDEV(ss.score) AS score_stddev,
        -- Subject category performance
        AVG(CASE WHEN sub.subject_category = 'STEM' THEN ss.score END) AS stem_avg,
        AVG(CASE WHEN sub.subject_category = 'Arts' THEN ss.score END) AS arts_avg,
        AVG(CASE WHEN sub.subject_category = 'Social Studies' THEN ss.score END) AS social_avg,
        AVG(CASE WHEN sub.subject_category = 'Languages' THEN ss.score END) AS language_avg
    FROM students s
    JOIN student_scores ss ON s.student_id = ss.student_id
    JOIN exams e ON ss.exam_id = e.exam_id
    JOIN subjects sub ON e.subject_id = sub.subject_id
    GROUP BY s.family_income_bracket, s.parent_education
)
SELECT 
    family_income_bracket,
    parent_education,
    student_count,
    ROUND(avg_score, 2) AS overall_average,
    ROUND(avg_attendance, 1) AS attendance_rate,
    ROUND(score_stddev, 2) AS score_variation,
    ROUND(stem_avg, 2) AS stem_average,
    ROUND(arts_avg, 2) AS arts_average,
    ROUND(social_avg, 2) AS social_studies_average,
    ROUND(language_avg, 2) AS languages_average,
    -- Performance gaps
    ROUND(stem_avg - arts_avg, 2) AS stem_arts_gap,
    -- Income bracket ranking
    ROW_NUMBER() OVER (ORDER BY avg_score DESC) AS performance_rank,
    -- Categories
    CASE 
        WHEN avg_score >= 90 THEN 'High Achieving Group'
        WHEN avg_score >= 80 THEN 'Above Average Group'
        WHEN avg_score >= 75 THEN 'Average Group'
        ELSE 'Below Average Group'
    END AS performance_category
FROM socioeconomic_analysis
ORDER BY avg_score DESC;

-- =============================================================================
-- 3. SUBJECT DIFFICULTY AND SUCCESS RATE ANALYSIS
-- =============================================================================

-- Analyze success rates and difficulty patterns across subjects
WITH subject_analysis AS (
    SELECT 
        sub.subject_name,
        sub.subject_category,
        sub.difficulty_level,
        sub.credit_hours,
        COUNT(ss.score_id) AS total_attempts,
        AVG(ss.score) AS avg_score,
        STDDEV(ss.score) AS score_stddev,
        MIN(ss.score) AS min_score,
        MAX(ss.score) AS max_score,
        -- Success rate calculations (assuming 70+ is passing)
        COUNT(CASE WHEN ss.score >= 90 THEN 1 END) AS a_grades,
        COUNT(CASE WHEN ss.score >= 80 AND ss.score < 90 THEN 1 END) AS b_grades,
        COUNT(CASE WHEN ss.score >= 70 AND ss.score < 80 THEN 1 END) AS c_grades,
        COUNT(CASE WHEN ss.score >= 60 AND ss.score < 70 THEN 1 END) AS d_grades,
        COUNT(CASE WHEN ss.score < 60 THEN 1 END) AS f_grades,
        COUNT(CASE WHEN ss.score >= 70 THEN 1 END) AS passing_count,
        AVG(ss.attendance_rate) AS avg_attendance
    FROM subjects sub
    JOIN exams e ON sub.subject_id = e.subject_id
    JOIN student_scores ss ON e.exam_id = ss.exam_id
    GROUP BY sub.subject_id, sub.subject_name, sub.subject_category, 
             sub.difficulty_level, sub.credit_hours
)
SELECT 
    subject_name,
    subject_category,
    difficulty_level,
    credit_hours,
    total_attempts,
    ROUND(avg_score, 2) AS average_score,
    ROUND(score_stddev, 2) AS score_deviation,
    min_score,
    max_score,
    -- Grade distribution
    a_grades,
    b_grades,
    c_grades,
    d_grades,
    f_grades,
    -- Success metrics
    ROUND(passing_count * 100.0 / total_attempts, 1) AS pass_rate_percentage,
    ROUND(a_grades * 100.0 / total_attempts, 1) AS a_grade_percentage,
    ROUND((a_grades + b_grades) * 100.0 / total_attempts, 1) AS ab_grade_percentage,
    ROUND(avg_attendance, 1) AS attendance_rate,
    -- Difficulty validation
    CASE 
        WHEN difficulty_level = 'Hard' AND avg_score > 85 THEN 'Easier than expected'
        WHEN difficulty_level = 'Easy' AND avg_score < 75 THEN 'Harder than expected'
        ELSE 'As expected'
    END AS difficulty_assessment,
    -- Performance ranking
    ROW_NUMBER() OVER (ORDER BY avg_score DESC) AS subject_rank,
    ROW_NUMBER() OVER (PARTITION BY subject_category ORDER BY avg_score DESC) AS rank_in_category
FROM subject_analysis
ORDER BY avg_score DESC;

-- =============================================================================
-- 4. PREDICTIVE PERFORMANCE INDICATORS
-- =============================================================================

-- Identify early warning indicators and success predictors
WITH early_indicators AS (
    SELECT 
        s.student_id,
        CONCAT(s.first_name, ' ', s.last_name) AS student_name,
        s.grade_level,
        s.family_income_bracket,
        s.parent_education,
        -- Early performance metrics (first 3 exams)
        AVG(CASE WHEN exam_sequence <= 3 THEN ss.score END) AS early_avg_score,
        AVG(CASE WHEN exam_sequence <= 3 THEN ss.attendance_rate END) AS early_attendance,
        -- Overall performance metrics
        AVG(ss.score) AS overall_avg_score,
        AVG(ss.attendance_rate) AS overall_attendance,
        -- Improvement metrics
        AVG(CASE WHEN exam_sequence > 3 THEN ss.score END) AS later_avg_score,
        COUNT(ss.score_id) AS total_exams
    FROM students s
    JOIN student_scores ss ON s.student_id = ss.student_id
    JOIN (
        SELECT 
            student_id,
            exam_id,
            ROW_NUMBER() OVER (PARTITION BY student_id ORDER BY exam_id) AS exam_sequence
        FROM student_scores
    ) seq ON ss.student_id = seq.student_id AND ss.exam_id = seq.exam_id
    GROUP BY s.student_id, s.first_name, s.last_name, s.grade_level, 
             s.family_income_bracket, s.parent_education
    HAVING COUNT(ss.score_id) >= 3  -- Only students with at least 3 exams
)
SELECT 
    student_name,
    grade_level,
    family_income_bracket,
    parent_education,
    total_exams,
    ROUND(early_avg_score, 2) AS early_performance,
    ROUND(early_attendance, 1) AS early_attendance,
    ROUND(overall_avg_score, 2) AS final_performance,
    ROUND(overall_attendance, 1) AS final_attendance,
    ROUND(later_avg_score, 2) AS later_performance,
    ROUND(later_avg_score - early_avg_score, 2) AS improvement_score,
    -- Prediction accuracy
    CASE 
        WHEN early_avg_score >= 85 AND overall_avg_score >= 85 THEN 'Correctly Predicted High'
        WHEN early_avg_score < 75 AND overall_avg_score < 75 THEN 'Correctly Predicted Low'
        WHEN early_avg_score >= 85 AND overall_avg_score < 75 THEN 'False Positive'
        WHEN early_avg_score < 75 AND overall_avg_score >= 85 THEN 'False Negative'
        ELSE 'Average Trajectory'
    END AS prediction_accuracy,
    -- Risk assessment
    CASE 
        WHEN early_avg_score < 70 OR early_attendance < 85 THEN 'High Risk'
        WHEN early_avg_score < 80 OR early_attendance < 90 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS early_risk_assessment,
    -- Intervention recommendations
    CASE 
        WHEN early_avg_score < 70 AND early_attendance < 85 THEN 'Intensive Academic & Attendance Support'
        WHEN early_avg_score < 70 THEN 'Academic Tutoring Needed'
        WHEN early_attendance < 85 THEN 'Attendance Intervention Required'
        WHEN early_avg_score BETWEEN 70 AND 80 THEN 'Monitoring and Support'
        ELSE 'Continue Current Path'
    END AS intervention_recommendation
FROM early_indicators
ORDER BY early_avg_score ASC;

-- =============================================================================
-- 5. TEACHER-STUDENT MATCH ANALYSIS
-- =============================================================================

-- Analyze which teacher characteristics correlate with better student outcomes
WITH teacher_student_outcomes AS (
    SELECT 
        t.teacher_id,
        CONCAT(t.first_name, ' ', t.last_name) AS teacher_name,
        t.years_experience,
        t.education_level,
        t.department,
        sub.subject_name,
        sub.difficulty_level,
        s.family_income_bracket,
        s.parent_education,
        s.grade_level,
        AVG(ss.score) AS avg_student_score,
        AVG(ss.attendance_rate) AS avg_attendance,
        COUNT(DISTINCT s.student_id) AS students_taught,
        STDDEV(ss.score) AS score_consistency
    FROM teachers t
    JOIN exams e ON t.teacher_id = e.teacher_id
    JOIN subjects sub ON e.subject_id = sub.subject_id
    JOIN student_scores ss ON e.exam_id = ss.exam_id
    JOIN students s ON ss.student_id = s.student_id
    GROUP BY t.teacher_id, t.first_name, t.last_name, t.years_experience, 
             t.education_level, t.department, sub.subject_name, sub.difficulty_level,
             s.family_income_bracket, s.parent_education, s.grade_level
)
SELECT 
    teacher_name,
    years_experience,
    education_level,
    department,
    subject_name,
    difficulty_level,
    students_taught,
    ROUND(avg_student_score, 2) AS average_score,
    ROUND(avg_attendance, 1) AS attendance_rate,
    ROUND(score_consistency, 2) AS score_variation,
    -- Experience effectiveness
    CASE 
        WHEN years_experience > 15 AND avg_student_score > 85 THEN 'Highly Experienced & Effective'
        WHEN years_experience > 10 AND avg_student_score > 80 THEN 'Experienced & Effective'
        WHEN years_experience <= 5 AND avg_student_score > 85 THEN 'Naturally Gifted'
        WHEN years_experience > 15 AND avg_student_score < 75 THEN 'Experienced but Struggling'
        ELSE 'Developing'
    END AS teacher_profile,
    -- Consistency rating
    CASE 
        WHEN score_consistency < 10 THEN 'Highly Consistent'
        WHEN score_consistency < 15 THEN 'Consistent'
        WHEN score_consistency < 20 THEN 'Moderately Consistent'
        ELSE 'Inconsistent Results'
    END AS consistency_rating,
    -- Performance vs department average
    avg_student_score - AVG(avg_student_score) OVER (PARTITION BY department) AS vs_dept_avg,
    -- Ranking within department
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY avg_student_score DESC) AS dept_rank
FROM teacher_student_outcomes
ORDER BY department, avg_student_score DESC;
