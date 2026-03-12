
--==========================================================================================
--| Author: Your Name                                                                      |
--| Name: tr_example_trigger                                                               |
--| Description: Trigger to update the updated_at timestamp                                |
--|                                                                                        |
--| Create date: 2025-11-11                                                                |
--| Ticket: TICKET-007                                                                     |
--|                                                                                        |
--| =======================================================================================|
--| Change History:                                                                        |
--| =======================================================================================|
--| Date        | Ticket      | Author            | Description                          |
--|========================================================================================|
--| 2025-11-11  | TICKET-007  | Your Name         | Initial creation                     |
--==========================================================================================

-- Create trigger function
CREATE OR REPLACE FUNCTION f_update_timestamp()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;

-- Create trigger
CREATE TRIGGER tr_update_example_table_timestamp
    BEFORE UPDATE ON example_table
    FOR EACH ROW
    EXECUTE FUNCTION f_update_timestamp();

-- Add comments
COMMENT ON FUNCTION f_update_timestamp IS 'Updates the updated_at column to current timestamp';
COMMENT ON TRIGGER tr_update_example_table_timestamp ON example_table IS 'Automatically updates updated_at on row update';

GO
