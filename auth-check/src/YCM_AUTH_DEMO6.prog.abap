*&--------------------------------------------------------------------*
*& Module      : CM
*& Program ID  : YCM_AUTH_DEMO6
*& Title       : CBO Authorization Check - Filtering Reference
*& Author      : SWDEV01
*& Create Date : 2026.08.07
*&--------------------------------------------------------------------*
*& MODIFICATION LOG
*&--------------------------------------------------------------------*
*& No.  Date.        Author.  Description.
*&--------------------------------------------------------------------*
*& 001  2026.08.07   SWDEV01  Initial Coding
*&--------------------------------------------------------------------*
REPORT ycm_auth_demo6.

INCLUDE ycm_auth_demo6_top.
INCLUDE ycm_auth_demo6_scr.
INCLUDE ycm_auth_demo6_f01.

START-OF-SELECTION.

  PERFORM get_data.
  PERFORM build_check.
  PERFORM check_authority.
  IF gs_return-type = 'S'.
    PERFORM display_result.
  ENDIF.
