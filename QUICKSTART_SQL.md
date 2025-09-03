# SQL Database Setup Guide
## Student Performance Analysis Project

### Option A: PostgreSQL Setup (Recommended)

#### Step 1: Install PostgreSQL
**macOS (using Homebrew):**
```bash
# Install PostgreSQL
brew install postgresql

# Start PostgreSQL service
brew services start postgresql

# Create a database
createdb student_performance_analysis

# Connect to database
psql student_performance_analysis
```

#### Step 2: Run SQL Scripts
Execute the scripts in order:

```bash
# Navigate to sql_scripts folder
cd "/Users/shreyanshjaiswal/Desktop/Student Performance Analysis (SQL + Visualization)/sql_scripts"

# Execute scripts in order
psql student_performance_analysis -f 01_create_tables.sql
psql student_performance_analysis -f 02_insert_sample_data.sql
psql student_performance_analysis -f 03_advanced_analytics.sql
```

#### Step 3: Verify Setup
```sql
-- Check if tables exist
\dt

-- Check sample data
SELECT COUNT(*) FROM students;
SELECT COUNT(*) FROM student_scores;

-- Run a simple analysis
SELECT 
    grade_level,
    COUNT(*) as student_count,
    AVG(score) as avg_score
FROM students s
JOIN student_scores ss ON s.student_id = ss.student_id
GROUP BY grade_level
ORDER BY grade_level;
```

---

### Option B: MySQL Setup

#### Step 1: Install MySQL
**macOS (using Homebrew):**
```bash
# Install MySQL
brew install mysql

# Start MySQL service
brew services start mysql

# Secure installation
mysql_secure_installation

# Connect to MySQL
mysql -u root -p
```

#### Step 2: Create Database
```sql
CREATE DATABASE student_performance_analysis;
USE student_performance_analysis;
```

#### Step 3: Execute Scripts
```bash
# Navigate to sql_scripts folder
cd "/Users/shreyanshjaiswal/Desktop/Student Performance Analysis (SQL + Visualization)/sql_scripts"

# Execute scripts
mysql -u root -p student_performance_analysis < 01_create_tables.sql
mysql -u root -p student_performance_analysis < 02_insert_sample_data.sql
```

---

### Option C: SQLite Setup (Easiest)

#### Step 1: Create SQLite Database
```bash
# Navigate to project folder
cd "/Users/shreyanshjaiswal/Desktop/Student Performance Analysis (SQL + Visualization)"

# Create SQLite database
sqlite3 student_performance.db

# Execute scripts (modify slightly for SQLite syntax)
.read sql_scripts/01_create_tables.sql
.read sql_scripts/02_insert_sample_data.sql
```

---

## Running the Analysis Queries

Once your database is set up, you can run the analytical queries:

### Basic Performance Analysis
```sql
-- Execute the advanced analytics
\i sql_scripts/03_advanced_analytics.sql

-- Execute performance insights
\i sql_scripts/04_performance_insights.sql
```

### Key Queries to Try

#### 1. Student Performance Ranking
```sql
SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    s.grade_level,
    AVG(ss.score) AS avg_score,
    AVG(ss.attendance_rate) AS avg_attendance,
    ROW_NUMBER() OVER (ORDER BY AVG(ss.score) DESC) AS performance_rank
FROM students s
JOIN student_scores ss ON s.student_id = ss.student_id
GROUP BY s.student_id, s.first_name, s.last_name, s.grade_level
ORDER BY avg_score DESC;
```

#### 2. Subject Difficulty Analysis
```sql
SELECT 
    sub.subject_name,
    sub.difficulty_level,
    COUNT(ss.score_id) AS total_exams,
    AVG(ss.score) AS avg_score,
    STDDEV(ss.score) AS score_variance
FROM subjects sub
JOIN exams e ON sub.subject_id = e.subject_id
JOIN student_scores ss ON e.exam_id = ss.exam_id
GROUP BY sub.subject_name, sub.difficulty_level
ORDER BY avg_score DESC;
```

#### 3. Attendance vs Performance Correlation
```sql
SELECT 
    CASE 
        WHEN AVG(ss.attendance_rate) >= 95 THEN 'Excellent (95%+)'
        WHEN AVG(ss.attendance_rate) >= 90 THEN 'Good (90-94%)'
        WHEN AVG(ss.attendance_rate) >= 85 THEN 'Fair (85-89%)'
        ELSE 'Poor (<85%)'
    END AS attendance_category,
    COUNT(DISTINCT s.student_id) AS student_count,
    ROUND(AVG(ss.score), 2) AS avg_performance
FROM students s
JOIN student_scores ss ON s.student_id = ss.student_id
GROUP BY 
    CASE 
        WHEN AVG(ss.attendance_rate) >= 95 THEN 'Excellent (95%+)'
        WHEN AVG(ss.attendance_rate) >= 90 THEN 'Good (90-94%)'
        WHEN AVG(ss.attendance_rate) >= 85 THEN 'Fair (85-89%)'
        ELSE 'Poor (<85%)'
    END
ORDER BY avg_performance DESC;
```

---

## Connecting Power BI to Database

### Step 1: Get Database Connection Details
- **Server**: localhost (or your server address)
- **Database**: student_performance_analysis
- **Username**: your database username
- **Password**: your database password

### Step 2: Connect from Power BI
1. Open Power BI Desktop
2. Click **"Get Data"** → **"Database"** → Choose your database type
3. Enter connection details
4. Select **DirectQuery** or **Import** mode
5. Choose tables to import
6. Follow the Power BI setup guide

---

## Troubleshooting

### Common Database Issues:
```bash
# Check if PostgreSQL is running
brew services list | grep postgresql

# Restart PostgreSQL if needed
brew services restart postgresql

# Check MySQL status
brew services list | grep mysql

# Reset MySQL password if needed
mysql -u root -p
```

### SQL Execution Issues:
- Check for syntax errors in console output
- Verify table relationships are created correctly
- Ensure data types match between tables

### Connection Issues:
- Verify database service is running
- Check firewall settings
- Confirm username/password credentials

---

## Performance Tips

1. **Indexing**: The scripts include optimized indexes
2. **Query Optimization**: Use EXPLAIN to analyze query performance
3. **Data Partitioning**: Consider partitioning for large datasets
4. **Regular Maintenance**: Update statistics and analyze tables regularly

---

**You're now ready to run comprehensive SQL analysis on student performance data!** 📊
