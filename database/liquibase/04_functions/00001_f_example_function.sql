
--==========================================================================================
--| Author: Your Name                                                                      |
--| Name: f_example_function                                                               |
--| Description: Function to validate email format                                         |
--|                                                                                        |
--| Create date: 2025-11-11                                                                |
--| Ticket: TICKET-005                                                                     |
--|                                                                                        |
--| =======================================================================================|
--| Change History:                                                                        |
--| =======================================================================================|
--| Date        | Ticket      | Author            | Description                          |
--|========================================================================================|
--| 2025-11-11  | TICKET-005  | Your Name         | Initial creation                     |
--==========================================================================================

CREATE OR REPLACE FUNCTION f_is_valid_email(email_address VARCHAR)
RETURNS BOOLEAN
LANGUAGE plpgsql
IMMUTABLE
AS $$
BEGIN
    -- Simple email validation using regex
    RETURN email_address ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';
END;
$$;

-- Add comment
COMMENT ON FUNCTION f_is_valid_email IS 'Validates email format using regex pattern';

GO
