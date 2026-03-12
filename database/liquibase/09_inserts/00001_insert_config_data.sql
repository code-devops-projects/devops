
--==========================================================================================
--| Author: Your Name                                                                      |
--| Name: insert_config_data                                                               |
--| Description: Insert initial configuration data                                         |
--|                                                                                        |
--| Create date: 2025-11-11                                                                |
--| Ticket: TICKET-010                                                                     |
--|                                                                                        |
--| =======================================================================================|
--| Change History:                                                                        |
--| =======================================================================================|
--| Date        | Ticket      | Author            | Description                          |
--|========================================================================================|
--| 2025-11-11  | TICKET-010  | Your Name         | Initial seed data                    |
--==========================================================================================

-- Insert sample users
INSERT INTO example_table (name, email, phone, status, created_by) 
VALUES 
    ('Admin User', 'admin@example.com', '+1234567890', 'active', 'system'),
    ('Test User', 'test@example.com', '+1234567891', 'active', 'system'),
    ('Demo User', 'demo@example.com', '+1234567892', 'inactive', 'system')
ON CONFLICT (email) DO NOTHING;

GO
