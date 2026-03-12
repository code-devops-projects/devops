
--==========================================================================================
--| Author: Your Name                                                                      |
--| Name: mv_example_summary                                                               |
--| Description: Materialized view for user statistics                                     |
--|                                                                                        |
--| Create date: 2025-11-11                                                                |
--| Ticket: TICKET-004                                                                     |
--|                                                                                        |
--| =======================================================================================|
--| Change History:                                                                        |
--| =======================================================================================|
--| Date        | Ticket      | Author            | Description                          |
--|========================================================================================|
--| 2025-11-11  | TICKET-004  | Your Name         | Initial creation                     |
--==========================================================================================

CREATE MATERIALIZED VIEW IF NOT EXISTS mv_user_summary AS
SELECT 
    status,
    COUNT(*) as total_users,
    COUNT(CASE WHEN created_at >= CURRENT_DATE - INTERVAL '30 days' THEN 1 END) as new_users_last_30_days,
    MIN(created_at) as first_user_date,
    MAX(created_at) as latest_user_date
FROM 
    example_table
GROUP BY 
    status;

-- Create index on materialized view
CREATE UNIQUE INDEX idx_mv_user_summary_status ON mv_user_summary(status);

-- Add comment
COMMENT ON MATERIALIZED VIEW mv_user_summary IS 'Summary statistics of users by status';

GO
