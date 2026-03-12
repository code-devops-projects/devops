
--==========================================================================================
--| Author: Your Name                                                                      |
--| Name: update_config_values                                                             |
--| Description: Update existing configuration values                                      |
--|                                                                                        |
--| Create date: 2025-11-11                                                                |
--| Ticket: TICKET-011                                                                     |
--|                                                                                        |
--| =======================================================================================|
--| Change History:                                                                        |
--| =======================================================================================|
--| Date        | Ticket      | Author            | Description                          |
--|========================================================================================|
--| 2025-11-11  | TICKET-011  | Your Name         | Update user statuses                 |
--==========================================================================================

-- Update specific users
UPDATE example_table 
SET 
    status = 'active',
    updated_by = 'system',
    updated_at = CURRENT_TIMESTAMP
WHERE 
    email IN ('test@example.com', 'demo@example.com')
    AND status != 'active';

GO
