*&--------------------------------------------------------------------*
*& Module      : CM
*& Program ID  : YCM_AUTH_DEMO6
*& Title       : CBO Authorization Check - Filtering Reference
*& Author      : (작성자)
*& Create Date : (작성일)
*&--------------------------------------------------------------------*
*& MODIFICATION LOG
*&--------------------------------------------------------------------*
*& No.  Date.        Author.  Description.
*&--------------------------------------------------------------------*
*& 001  (일자)       (ID)     Initial Coding
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
