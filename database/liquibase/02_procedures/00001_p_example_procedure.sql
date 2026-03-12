
--==========================================================================================
--| Author: Your Name                                                                      |
--| Name: p_example_procedure                                                              |
--| Description: Stored procedure to get user by email                                     |
--|                                                                                        |
--| Create date: 2025-11-11                                                                |
--| Ticket: TICKET-003                                                                     |
--|                                                                                        |
--| =======================================================================================|
--| Change History:                                                                        |
--| =======================================================================================|
--| Date        | Ticket      | Author            | Description                          |
--|========================================================================================|
--| 2025-11-11  | TICKET-003  | Your Name         | Initial creation                     |
--==========================================================================================

CREATE OR REPLACE PROCEDURE p_get_user_by_email(
    IN p_email VARCHAR(255),
    OUT p_user_id INTEGER,
    OUT p_user_name VARCHAR(255),
    OUT p_status VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT 
        id,
        name,
        status
    INTO 
        p_user_id,
        p_user_name,
        p_status
    FROM 
        example_table
    WHERE 
        email = p_email;
    
    IF NOT FOUND THEN
        RAISE NOTICE 'User with email % not found', p_email;
    END IF;
END;
$$;

-- Add comment
COMMENT ON PROCEDURE p_get_user_by_email IS 'Retrieves user information by email address';

GO
