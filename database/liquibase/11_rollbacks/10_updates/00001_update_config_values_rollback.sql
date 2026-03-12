
--==========================================================================================
--| ROLLBACK SCRIPT                                                                        |
--| Author: Your Name                                                                      |
--| Name: update_config_values_rollback                                                    |
--| Description: Rollback for configuration value updates                                  |
--|                                                                                        |
--| Create date: 2025-11-11                                                                |
--| Ticket: TICKET-011                                                                     |
--==========================================================================================

-- Revert status changes back to original state
UPDATE example_table 
SET 
    status = 'inactive',
    updated_by = 'system',
    updated_at = CURRENT_TIMESTAMP
WHERE 
    email IN ('test@example.com', 'demo@example.com');

GO
