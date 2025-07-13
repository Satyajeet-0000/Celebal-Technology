CREATE PROCEDURE ProcessSubjectChangeRequest
AS
BEGIN
    SET NOCOUNT ON; -- Prevents extra result sets from interfering with application logic

    DECLARE @student_id_val VARCHAR(255);
    DECLARE @requested_subject_id_val VARCHAR(255);
    DECLARE @current_valid_subject_id_val VARCHAR(255);

    -- Declare a cursor
    DECLARE cur CURSOR FOR
        SELECT StudentId, SubjectId
        FROM SubjectRequest;

    -- Open the cursor
    OPEN cur;

    -- Fetch the first row from the cursor
    FETCH NEXT FROM cur INTO @student_id_val, @requested_subject_id_val;

    -- Loop through the rows until no more rows are found
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @current_valid_subject_id_val = NULL; -- Reset for each iteration

        -- Check if the student exists in SubjectAllotments and get their current valid subject
        SELECT @current_valid_subject_id_val = SubjectId
        FROM SubjectAllotments
        WHERE StudentId = @student_id_val AND Is_valid = 1;

        -- If student exists in SubjectAllotments
        IF @current_valid_subject_id_val IS NOT NULL
        BEGIN
            -- Check if the current valid subject is different from the requested subject
            IF @current_valid_subject_id_val <> @requested_subject_id_val
            BEGIN
                -- Invalidate the previously valid record
                UPDATE SubjectAllotments
                SET Is_valid = 0
                WHERE StudentId = @student_id_val AND Is_valid = 1;

                -- Insert the new valid record
                INSERT INTO SubjectAllotments (StudentId, SubjectId, Is_valid)
                VALUES (@student_id_val, @requested_subject_id_val, 1);
            END;
        END
        ELSE -- If the student does not exist in SubjectAllotments
        BEGIN
            -- Simply insert the requested subject as a valid record
            INSERT INTO SubjectAllotments (StudentId, SubjectId, Is_valid)
            VALUES (@student_id_val, @requested_subject_id_val, 1);
        END;

        -- Fetch the next row
        FETCH NEXT FROM cur INTO @student_id_val, @requested_subject_id_val;
    END;

    -- Close and deallocate the cursor
    CLOSE cur;
    DEALLOCATE cur;

    -- Clear the SubjectRequest table after processing (optional)
    TRUNCate TABLE SubjectRequest;
END;