
--==========================================================================================
--| ROLLBACK SCRIPT                                                                        |
--| Author: Your Name                                                                      |
--| Name: example_table_rollback                                                           |
--| Description: Rollback for example_table creation                                       |
--|                                                                                        |
--| Create date: 2025-11-11                                                                |
--| Ticket: TICKET-001                                                                     |
--==========================================================================================

DROP TABLE IF EXISTS example_table CASCADE;

GO
