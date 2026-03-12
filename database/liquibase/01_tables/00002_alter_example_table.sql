
--==========================================================================================
--| Author: Your Name                                                                      |
--| Name: alter_example_table                                                              |
--| Description: Add phone column to example_table                                         |
--|                                                                                        |
--| Create date: 2025-11-11                                                                |
--| Ticket: TICKET-002                                                                     |
--|                                                                                        |
--| =======================================================================================|
--| Change History:                                                                        |
--| =======================================================================================|
--| Date        | Ticket      | Author            | Description                          |
--|========================================================================================|
--| 2025-11-11  | TICKET-002  | Your Name         | Add phone column                     |
--==========================================================================================

ALTER TABLE example_table
ADD COLUMN phone VARCHAR(20);

-- Add comment
COMMENT ON COLUMN example_table.phone IS 'User contact phone number';

GO
