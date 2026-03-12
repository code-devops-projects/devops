
--==========================================================================================
--| Author: Your Name                                                                      |
--| Name: type_example_custom_type                                                         |
--| Description: Custom composite type for address information                             |
--|                                                                                        |
--| Create date: 2025-11-11                                                                |
--| Ticket: TICKET-009                                                                     |
--|                                                                                        |
--| =======================================================================================|
--| Change History:                                                                        |
--| =======================================================================================|
--| Date        | Ticket      | Author            | Description                          |
--|========================================================================================|
--| 2025-11-11  | TICKET-009  | Your Name         | Initial creation                     |
--==========================================================================================

-- Create ENUM type for user status
CREATE TYPE user_status_enum AS ENUM ('active', 'inactive', 'suspended', 'pending');

-- Create composite type for address
CREATE TYPE address_type AS (
    street VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    postal_code VARCHAR(20)
);

-- Add comments
COMMENT ON TYPE user_status_enum IS 'Enumeration of possible user statuses';
COMMENT ON TYPE address_type IS 'Composite type for storing address information';

GO
