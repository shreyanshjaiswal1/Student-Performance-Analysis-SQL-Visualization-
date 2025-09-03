# Quick Start Guide - Power BI Implementation
## Student Performance Analysis Dashboard

### Prerequisites
- Power BI Desktop (free download from Microsoft)
- CSV files in the data folder

---

## Step-by-Step Implementation

### Step 1: Open Power BI Desktop
1. Launch Power BI Desktop
2. Close any welcome screens
3. You should see a blank canvas

### Step 2: Import Data Files

#### Import Students Data
1. Click **"Get Data"** → **"Text/CSV"**
2. Navigate to: `/data/students.csv`
3. Click **"Open"**
4. Preview the data and click **"Transform Data"**
5. Verify data types:
   - student_id: Whole Number
   - date_of_birth: Date
   - enrollment_date: Date
   - All other text fields: Text
6. Click **"Close & Apply"**

#### Import Subjects Data
1. Click **"Get Data"** → **"Text/CSV"**
2. Navigate to: `/data/subjects.csv`
3. Click **"Open"** → **"Transform Data"**
4. Verify data types:
   - subject_id: Whole Number
   - credit_hours: Whole Number
   - All other fields: Text
5. Click **"Close & Apply"**

#### Import Teachers Data
1. Click **"Get Data"** → **"Text/CSV"**
2. Navigate to: `/data/teachers.csv`
3. Click **"Open"** → **"Transform Data"**
4. Verify data types:
   - teacher_id: Whole Number
   - years_experience: Whole Number
   - All other fields: Text
5. Click **"Close & Apply"**

#### Import Exams Data
1. Click **"Get Data"** → **"Text/CSV"**
2. Navigate to: `/data/exams.csv`
3. Click **"Open"** → **"Transform Data"**
4. Verify data types:
   - exam_id: Whole Number
   - subject_id: Whole Number
   - teacher_id: Whole Number
   - exam_date: Date
   - max_score: Whole Number
   - All other fields: Text
5. Click **"Close & Apply"**

#### Import Student Scores Data
1. Click **"Get Data"** → **"Text/CSV"**
2. Navigate to: `/data/student_scores.csv`
3. Click **"Open"** → **"Transform Data"**
4. Verify data types:
   - score_id: Whole Number
   - student_id: Whole Number
   - exam_id: Whole Number
   - score: Decimal Number
   - attendance_rate: Decimal Number
   - submission_date: Date
   - time_spent_minutes: Whole Number
5. Click **"Close & Apply"**

### Step 3: Create Data Model Relationships

1. Click on **"Model"** view (left sidebar)
2. Create the following relationships by dragging fields:

**Primary Relationships:**
- `students[student_id]` → `student_scores[student_id]` (1:Many)
- `exams[exam_id]` → `student_scores[exam_id]` (1:Many)
- `subjects[subject_id]` → `exams[subject_id]` (1:Many)
- `teachers[teacher_id]` → `exams[teacher_id]` (1:Many)

3. Verify all relationships are active (solid lines)

### Step 4: Create Key Measures

1. Click on **"Data"** view
2. Right-click on any table → **"New measure"**

#### Create these measures one by one:

```dax
Total Students = DISTINCTCOUNT(students[student_id])
```

```dax
Average Score = AVERAGE(student_scores[score])
```

```dax
Average Attendance = AVERAGE(student_scores[attendance_rate])
```

```dax
Pass Rate = 
DIVIDE(
    COUNTROWS(FILTER(student_scores, student_scores[score] >= 70)),
    COUNTROWS(student_scores)
) * 100
```

```dax
High Risk Students = 
COUNTROWS(
    FILTER(
        ADDCOLUMNS(
            SUMMARIZE(student_scores, students[student_id]),
            "AvgScore", [Average Score],
            "AvgAttendance", [Average Attendance]
        ),
        [AvgScore] < 70 || [AvgAttendance] < 85
    )
)
```

### Step 5: Create Your First Dashboard Page

1. Click on **"Report"** view
2. Add these visualizations:

#### KPI Cards (Top Row):
1. **Card Visual**: Drag `Total Students` measure
2. **Card Visual**: Drag `Average Score` measure
3. **Card Visual**: Drag `Average Attendance` measure
4. **Card Visual**: Drag `Pass Rate` measure

#### Main Visualizations:
1. **Clustered Column Chart**:
   - Axis: `subjects[subject_name]`
   - Values: `Average Score`

2. **Scatter Chart**:
   - X-Axis: `student_scores[attendance_rate]`
   - Y-Axis: `student_scores[score]`
   - Details: `students[student_id]`

3. **Donut Chart**:
   - Legend: Create a calculated column for performance categories
   - Values: Count of students

#### Add Slicers:
1. **Slicer**: `subjects[subject_category]`
2. **Slicer**: `students[grade_level]`
3. **Slicer**: `exams[semester]`

### Step 6: Format and Style

1. **Apply Theme**:
   - View → Themes → Choose a professional theme

2. **Format Visuals**:
   - Click on each visual
   - Use Format pane to adjust colors, fonts, titles
   - Add descriptive titles to each visual

3. **Layout**:
   - Arrange visuals in a logical flow
   - Ensure adequate spacing
   - Add a page title

### Step 7: Test Interactivity

1. Click on different elements in your visuals
2. Verify that other visuals filter accordingly
3. Test slicer functionality
4. Ensure all interactions work as expected

---

## What You Should See

After completing these steps, you should have:
- ✅ A functional dashboard with student performance data
- ✅ Interactive charts showing performance by subject
- ✅ Attendance vs performance correlation
- ✅ Key performance indicators
- ✅ Working filters and slicers

## Next Steps

1. **Add More Pages**: Create additional pages for detailed analysis
2. **Enhanced Visuals**: Add more sophisticated charts
3. **Advanced Measures**: Implement trend analysis and predictions
4. **Mobile Layout**: Create mobile-optimized views

## Troubleshooting

### Common Issues:
- **Data not loading**: Check file paths and data types
- **Relationships not working**: Verify column names match exactly
- **Measures showing errors**: Check DAX syntax
- **Visuals not filtering**: Verify relationships are active

### Getting Help:
- Check the setup guide in `/powerbi/setup_guide.md`
- Review technical documentation in `/documentation/`
- Power BI Community: community.powerbi.com

---

**Congratulations!** You now have a working Student Performance Analysis dashboard! 🎉
