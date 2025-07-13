CREATE PROCEDURE AllocateSubjects
AS
BEGIN
    -- Declare variables to hold student and subject information during iteration
    DECLARE @StudentId INT;
    DECLARE @StudentGPA DECIMAL(3, 1);
    DECLARE @SubjectId NVARCHAR(50);
    DECLARE @Preference INT;
    DECLARE @RemainingSeats INT;
    DECLARE @Allocated BIT; -- Flag to check if the current student has been allotted a subject

    -- Cursor to iterate through students, ordered by GPA in descending order
    DECLARE StudentCursor CURSOR FOR
    SELECT StudentId, GPA
    FROM StudentDetails
    ORDER BY GPA DESC;

    OPEN StudentCursor;

    FETCH NEXT FROM StudentCursor INTO @StudentId, @StudentGPA;

    -- Loop through each student
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @Allocated = 0; -- Reset allocation flag for each new student

        -- Cursor to iterate through the current student's preferences, ordered by preference number
        DECLARE PreferenceCursor CURSOR FOR
        SELECT sp.SubjectId, sp.Preference
        FROM StudentPreference sp
        WHERE sp.StudentId = @StudentId
        ORDER BY sp.Preference ASC;

        OPEN PreferenceCursor;

        FETCH NEXT FROM PreferenceCursor INTO @SubjectId, @Preference;

        -- Loop through each preference for the current student
        WHILE @@FETCH_STATUS = 0 AND @Allocated = 0 -- Continue only if not yet allocated
        BEGIN
            -- Get the remaining seats for the current preferred subject
            SELECT @RemainingSeats = sd.RemainingSeats
            FROM SubjectDetails sd
            WHERE sd.SubjectId = @SubjectId;

            -- Check if seats are available
            IF @RemainingSeats > 0
            BEGIN
                -- Allocate the subject to the student 
                INSERT INTO Allotments (SubjectId, StudentId)
                VALUES (@SubjectId, @StudentId);

                -- Decrease the remaining seats for the subject 
                UPDATE SubjectDetails
                SET RemainingSeats = RemainingSeats - 1
                WHERE SubjectId = @SubjectId;

                SET @Allocated = 1; -- Mark student as allocated
            END;

            FETCH NEXT FROM PreferenceCursor INTO @SubjectId, @Preference;
        END;

        CLOSE PreferenceCursor;
        DEALLOCATE PreferenceCursor;

        -- If the student was not allocated any subject after checking all preferences 
        IF @Allocated = 0
        BEGIN
            INSERT INTO UnallottedStudents (StudentId)
            VALUES (@StudentId);
        END;

        FETCH NEXT FROM StudentCursor INTO @StudentId, @StudentGPA;
    END;

    CLOSE StudentCursor;
    DEALLOCATE StudentCursor;

END;