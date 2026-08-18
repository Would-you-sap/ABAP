*&---------------------------------------------------------------------*
*& Include YCM_AUTH_DEMO6_TOP - 전역 선언
*&---------------------------------------------------------------------*

TYPES: BEGIN OF gty_s_bukrs,
         bukrs TYPE bukrs,
         butxt TYPE butxt,
       END OF gty_s_bukrs,

       BEGIN OF gty_s_werks,
         werks TYPE werks_d,
         name1 TYPE name1,
       END OF gty_s_werks,

       BEGIN OF gty_s_kostl,
         kokrs TYPE kokrs,
         kostl TYPE kostl,
       END OF gty_s_kostl.

DATA: gv_bukrs  TYPE bukrs,
      gv_werks  TYPE werks_d,
      gv_kostl  TYPE kostl,
      gt_bukrs  TYPE TABLE OF gty_s_bukrs,
      gt_werks  TYPE TABLE OF gty_s_werks,
      gt_kostl  TYPE TABLE OF gty_s_kostl,
      gt_check  TYPE zcms0070t,
      gt_failed TYPE zcms0070t,
      gs_return TYPE bapiret2.
