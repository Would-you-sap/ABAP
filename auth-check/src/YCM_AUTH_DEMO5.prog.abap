*&---------------------------------------------------------------------*
*& Report YCM_AUTH_DEMO5
*&---------------------------------------------------------------------*
*& CBO 권한체크 데모5 - 전역 클래스 호출 버전 (상태+메시지 리턴)
*&---------------------------------------------------------------------*
REPORT ycm_auth_demo5.

INCLUDE ycm_auth_demo5_top.
INCLUDE ycm_auth_demo5_scr.
INCLUDE ycm_auth_demo5_f01.

AT SELECTION-SCREEN.
  PERFORM check_required.

START-OF-SELECTION.
  PERFORM build_check.
  PERFORM check_authority.
  PERFORM display_result.
