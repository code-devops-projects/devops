
--==========================================================================================
--| ROLLBACK SCRIPT                                                                        |
--| Author: Your Name                                                                      |
--| Name: insert_config_data_rollback                                                      |
--| Description: Rollback for initial configuration data                                   |
--|                                                                                        |
--| Create date: 2025-11-11                                                                |
--| Ticket: TICKET-010                                                                     |
--==========================================================================================

-- Delete inserted seed data
DELETE FROM example_table 
WHERE email IN (
    'admin@example.com',
    'test@example.com',
    'demo@example.com'
)
AND created_by = 'system';

GO
