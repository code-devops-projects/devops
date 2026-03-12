
--==========================================================================================
--| Author: Your Name                                                                      |
--| Name: example_table                                                                    |
--| Description: Example table for storing user information                                |
--|                                                                                        |
--| Create date: 2025-11-11                                                                |
--| Ticket: TICKET-001                                                                     |
--|                                                                                        |
--| =======================================================================================|
--| Change History:                                                                        |
--| =======================================================================================|
--| Date        | Ticket      | Author            | Description                          |
--|========================================================================================|
--| 2025-11-11  | TICKET-001  | Your Name         | Initial creation                     |
--==========================================================================================

CREATE TABLE IF NOT EXISTS example_table (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    status VARCHAR(50) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100),
    updated_by VARCHAR(100)
);

-- Add comments for documentation
COMMENT ON TABLE example_table IS 'Stores user information';
COMMENT ON COLUMN example_table.id IS 'Unique identifier for the record';
COMMENT ON COLUMN example_table.name IS 'User full name';
COMMENT ON COLUMN example_table.email IS 'User email address (unique)';
COMMENT ON COLUMN example_table.status IS 'Current status: active, inactive, suspended';

GO
