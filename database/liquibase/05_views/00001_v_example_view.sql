
--==========================================================================================
--| Author: Your Name                                                                      |
--| Name: v_example_view                                                                   |
--| Description: View to show active users only                                            |
--|                                                                                        |
--| Create date: 2025-11-11                                                                |
--| Ticket: TICKET-006                                                                     |
--|                                                                                        |
--| =======================================================================================|
--| Change History:                                                                        |
--| =======================================================================================|
--| Date        | Ticket      | Author            | Description                          |
--|========================================================================================|
--| 2025-11-11  | TICKET-006  | Your Name         | Initial creation                     |
--==========================================================================================

CREATE OR REPLACE VIEW v_active_users AS
SELECT 
    id,
    name,
    email,
    phone,
    created_at,
    updated_at
FROM 
    example_table
WHERE 
    status = 'active'
ORDER BY 
    created_at DESC;

-- Add comment
COMMENT ON VIEW v_active_users IS 'Shows only active users from example_table';

GO
