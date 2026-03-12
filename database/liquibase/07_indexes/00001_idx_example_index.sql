
--==========================================================================================
--| Author: Your Name                                                                      |
--| Name: idx_example_index                                                                |
--| Description: Create indexes for performance optimization                               |
--|                                                                                        |
--| Create date: 2025-11-11                                                                |
--| Ticket: TICKET-008                                                                     |
--|                                                                                        |
--| =======================================================================================|
--| Change History:                                                                        |
--| =======================================================================================|
--| Date        | Ticket      | Author            | Description                          |
--|========================================================================================|
--| 2025-11-11  | TICKET-008  | Your Name         | Initial creation                     |
--==========================================================================================

-- Index on email for faster lookups
CREATE INDEX IF NOT EXISTS idx_example_table_email 
ON example_table(email);

-- Index on status for filtering
CREATE INDEX IF NOT EXISTS idx_example_table_status 
ON example_table(status);

-- Composite index for common queries
CREATE INDEX IF NOT EXISTS idx_example_table_status_created 
ON example_table(status, created_at DESC);

-- Partial index for active users only
CREATE INDEX IF NOT EXISTS idx_example_table_active_users 
ON example_table(created_at DESC) 
WHERE status = 'active';

GO
