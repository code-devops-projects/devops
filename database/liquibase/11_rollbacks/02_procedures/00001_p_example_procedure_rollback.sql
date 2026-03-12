
--==========================================================================================
--| ROLLBACK SCRIPT                                                                        |
--| Author: Your Name                                                                      |
--| Name: p_example_procedure_rollback                                                     |
--| Description: Rollback for stored procedure                                             |
--|                                                                                        |
--| Create date: 2025-11-11                                                                |
--| Ticket: TICKET-003                                                                     |
--==========================================================================================

DROP PROCEDURE IF EXISTS p_get_user_by_email(VARCHAR, INTEGER, VARCHAR, VARCHAR) CASCADE;

GO
