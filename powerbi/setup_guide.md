# Power BI Setup Guide
## Student Performance Analysis Dashboard

### Prerequisites
1. **Power BI Desktop** (latest version)
2. **Database Access** (SQL Server/MySQL/PostgreSQL)
3. **Power BI Pro License** (for sharing and collaboration)
4. **Sample Data** (provided in the data folder)

### Step 1: Data Source Connection

#### Option A: Direct Database Connection
1. Open Power BI Desktop
2. Click "Get Data" → "SQL Server" (or your database type)
3. Enter server details:
   - **Server**: your-server-name
   - **Database**: student_performance_analysis
4. Select "DirectQuery" for real-time data or "Import" for better performance
5. Choose authentication method (Windows/SQL Server)

#### Option B: CSV File Import (for demonstration)
1. Use the provided CSV files in the `/data` folder
2. Click "Get Data" → "Text/CSV"
3. Navigate to each CSV file and import
4. Ensure proper data types are set during import

### Step 2: Data Model Setup

#### Relationships
Create the following relationships in Model view:
```
students (student_id) → student_scores (student_id) [1:many]
exams (exam_id) → student_scores (exam_id) [1:many]
subjects (subject_id) → exams (subject_id) [1:many]
teachers (teacher_id) → exams (teacher_id) [1:many]
```

#### Calculated Columns
Add these calculated columns to enhance analysis:

**Students Table:**
```dax
Age = DATEDIFF(students[date_of_birth], TODAY(), YEAR)
Full Name = students[first_name] & " " & students[last_name]
```

**Student_Scores Table:**
```dax
Score Category = 
SWITCH(
    TRUE(),
    student_scores[score] >= 90, "Excellent (A)",
    student_scores[score] >= 80, "Good (B)",
    student_scores[score] >= 70, "Average (C)",
    student_scores[score] >= 60, "Below Average (D)",
    "Failing (F)"
)

Performance Level = 
IF(
    student_scores[score] >= 80 && student_scores[attendance_rate] >= 90,
    "High Performer",
    IF(
        student_scores[score] >= 70 && student_scores[attendance_rate] >= 85,
        "Average Performer",
        "At Risk"
    )
)
```

#### Measures
Create these DAX measures for calculations:

**Basic Metrics:**
```dax
Total Students = DISTINCTCOUNT(students[student_id])
Average Score = AVERAGE(student_scores[score])
Average Attendance = AVERAGE(student_scores[attendance_rate])
Total Exams = COUNT(student_scores[score_id])
Pass Rate = 
DIVIDE(
    COUNTROWS(FILTER(student_scores, student_scores[score] >= 70)),
    COUNTROWS(student_scores)
) * 100
```

**Advanced Metrics:**
```dax
Performance Trend = 
VAR CurrentPeriod = [Average Score]
VAR PreviousPeriod = 
CALCULATE(
    [Average Score],
    DATEADD('Calendar'[Date], -1, MONTH)
)
RETURN CurrentPeriod - PreviousPeriod

Top Quartile Percentage = 
VAR TopQuartileThreshold = PERCENTILE.INC(student_scores[score], 0.75)
RETURN 
DIVIDE(
    COUNTROWS(FILTER(student_scores, student_scores[score] >= TopQuartileThreshold)),
    COUNTROWS(student_scores)
) * 100

Subject Performance Rank = 
RANKX(
    ALL(subjects[subject_name]),
    [Average Score],
    ,
    DESC
)
```

**Risk Assessment Measures:**
```dax
High Risk Students = 
COUNTROWS(
    FILTER(
        ADDCOLUMNS(
            SUMMARIZE(
                student_scores,
                students[student_id],
                students[first_name],
                students[last_name]
            ),
            "AvgScore", [Average Score],
            "AvgAttendance", [Average Attendance]
        ),
        [AvgScore] < 70 || [AvgAttendance] < 85
    )
)

Intervention Needed = 
IF(
    [High Risk Students] > 0,
    "Immediate Attention Required",
    "Monitoring Sufficient"
)
```

### Step 3: Dashboard Creation

#### Page Layout Standards
- **Header**: 100px height with title and navigation
- **KPI Section**: Top 150px for key metrics
- **Main Content**: Remaining space for visualizations
- **Footer**: 50px for refresh time and source info

#### Visual Recommendations

**Executive Summary Page:**
1. **KPI Cards** (4 across top):
   - Total Students
   - Average GPA
   - Overall Attendance Rate
   - Pass Rate
2. **Gauge Chart**: Performance vs Target
3. **Line Chart**: Trend over time
4. **Donut Charts**: Performance distribution

**Student Analysis Page:**
1. **Scatter Plot**: Attendance vs Performance
2. **Box Plot**: Score distribution by grade
3. **Heat Map**: Student performance matrix
4. **Bar Chart**: Performance by demographics

**Subject/Teacher Page:**
1. **Clustered Column**: Subject performance
2. **Stacked Bar**: Grade distribution by teacher
3. **Matrix Table**: Teacher effectiveness
4. **Line Chart**: Subject trends

### Step 4: Formatting and Styling

#### Theme Configuration
1. Go to View → Themes → Browse for themes
2. Apply consistent color scheme:
   - Primary: #2E75B6
   - Secondary: #FF7F00
   - Success: #28A745
   - Warning: #FFC107
   - Danger: #DC3545

#### Visual Formatting
```
Font Family: Segoe UI
Header Font Size: 16pt
Body Font Size: 11pt
Grid Lines: Light gray (#E0E0E0)
Background: White (#FFFFFF)
```

### Step 5: Interactive Features

#### Slicers Setup
1. **Academic Year**: List slicer
2. **Semester**: Dropdown slicer
3. **Grade Level**: Button slicer
4. **Subject Category**: Checkbox slicer

#### Drill-Through Configuration
1. Create detail pages for Student, Teacher, and Subject
2. Set up drill-through fields
3. Configure back button navigation

### Step 6: Publication and Sharing

#### Power BI Service Setup
1. Save the .pbix file
2. Publish to Power BI Service
3. Create a workspace for the organization
4. Set up data refresh schedule

#### Security Configuration
1. Set up Row-Level Security (RLS)
2. Configure user roles:
   - **Administrator**: Full access
   - **Teacher**: Limited to their classes
   - **Student**: Personal data only
3. Test security with different user accounts

#### Mobile Configuration
1. Create mobile layouts for key pages
2. Optimize visual sizes for mobile screens
3. Test on various device sizes

### Step 7: Maintenance

#### Regular Tasks
- **Daily**: Monitor data refresh status
- **Weekly**: Review dashboard performance
- **Monthly**: Update calculations if needed
- **Quarterly**: Review user feedback and update

#### Performance Optimization
- Use DirectQuery sparingly
- Optimize DAX measures
- Remove unused columns
- Implement data source caching

### Troubleshooting Common Issues

#### Data Refresh Failures
1. Check database connectivity
2. Verify table relationships
3. Review data source permissions

#### Performance Issues
1. Reduce visual complexity
2. Optimize DAX calculations
3. Consider data aggregation
4. Use performance analyzer

#### Security Problems
1. Verify RLS configuration
2. Check workspace permissions
3. Test with different user roles

### Additional Resources
- Power BI Learning Path: [Microsoft Learn](https://docs.microsoft.com/learn/powerbi/)
- DAX Guide: [dax.guide](https://dax.guide)
- Power BI Community: [community.powerbi.com](https://community.powerbi.com)
- Sample Files: Available in project repository
