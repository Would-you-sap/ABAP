*&---------------------------------------------------------------------*
*& Include YCM_AUTH_DEMO6_F01 - 서브루틴
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Form GET_DATA
*&---------------------------------------------------------------------*
FORM get_data.

  " 입력한 축만 조회 - 빈 select-option 축은 검사 대상에서 제외
  IF s_bukrs[] IS NOT INITIAL.
    SELECT bukrs, butxt
      FROM t001
      INTO TABLE @gt_bukrs
      WHERE bukrs IN @s_bukrs.
  ENDIF.

  IF s_werks[] IS NOT INITIAL.
    SELECT werks, name1
      FROM t001w
      INTO TABLE @gt_werks
      WHERE werks IN @s_werks.
  ENDIF.

  IF s_kostl[] IS NOT INITIAL.
    SELECT DISTINCT kokrs, kostl
      FROM csks
      INTO TABLE @gt_kostl
      WHERE kostl IN @s_kostl.
  ENDIF.

  IF gt_bukrs IS INITIAL AND gt_werks IS INITIAL AND gt_kostl IS INITIAL.
    MESSAGE s033(zcmm01) DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form BUILD_CHECK
*&---------------------------------------------------------------------*
FORM build_check.

  " 조회 결과에서 축별 distinct 값 추출 - 조건이 아니라 실존 값만 검사
  DATA: lt_bukrs TYPE SORTED TABLE OF bukrs   WITH UNIQUE KEY table_line,
        lt_werks TYPE SORTED TABLE OF werks_d WITH UNIQUE KEY table_line,
        lt_kostl TYPE SORTED TABLE OF kostl   WITH UNIQUE KEY table_line,
        lt_kokrs TYPE SORTED TABLE OF kokrs   WITH UNIQUE KEY table_line.

  LOOP AT gt_bukrs ASSIGNING FIELD-SYMBOL(<ls_bukrs>).
    INSERT <ls_bukrs>-bukrs INTO TABLE lt_bukrs.
  ENDLOOP.
  LOOP AT gt_werks ASSIGNING FIELD-SYMBOL(<ls_werks>).
    INSERT <ls_werks>-werks INTO TABLE lt_werks.
  ENDLOOP.
  LOOP AT gt_kostl ASSIGNING FIELD-SYMBOL(<ls_kostl>).
    INSERT <ls_kostl>-kostl INTO TABLE lt_kostl.
    INSERT <ls_kostl>-kokrs INTO TABLE lt_kokrs.
  ENDLOOP.

  " 전 축을 한 번의 체크 요청으로 구성 (오브젝트/필드는 프로그램이 결정)
  gt_check = VALUE #( FOR lv_b IN lt_bukrs
    ( xuobject = 'F_BKPF_BUK' xufield = 'BUKRS' value = CONV #( lv_b ) ) ).
  gt_check = VALUE #( BASE gt_check FOR lv_w IN lt_werks
    ( xuobject = 'M_MATE_WRK' xufield = 'WERKS' value = CONV #( lv_w ) ) ).
  gt_check = VALUE #( BASE gt_check FOR lv_k IN lt_kostl
    ( xuobject = 'K_CSKS' xufield = 'KOSTL' value = CONV #( lv_k ) ) ).
  gt_check = VALUE #( BASE gt_check FOR lv_o IN lt_kokrs
    ( xuobject = 'K_CSKS' xufield = 'KOKRS' value = CONV #( lv_o ) ) ).

ENDFORM.

*&---------------------------------------------------------------------*
*& Form CHECK_AUTHORITY
*&---------------------------------------------------------------------*
FORM check_authority.

  " 한 번의 호출로 전 축 검사 - 하나라도 권한 없으면 전체 거부(차단형)
  zcmcl_auth_check=>check( EXPORTING it_check  = gt_check
                           IMPORTING es_return = gs_return
                                     et_failed = gt_failed ).

  IF gs_return-type = 'E'.
    " 부족 전량을 목록으로 표시 (실전 차단형은 MESSAGE ... TYPE 'E' 한 줄)
    WRITE: / TEXT-t06, lines( gt_failed ).
    LOOP AT gt_failed INTO DATA(ls_fail).
      WRITE: / '  ', TEXT-t04, ls_fail-xufield, ls_fail-value.
    ENDLOOP.
    MESSAGE gs_return-message TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form DISPLAY_RESULT
*&---------------------------------------------------------------------*
FORM display_result.

  " 여기 도달 = 요청한 전 값에 권한 있음
  WRITE: / TEXT-t11, lines( gt_bukrs ).
  LOOP AT gt_bukrs INTO DATA(ls_bukrs).
    WRITE: / '  ', ls_bukrs-bukrs, ls_bukrs-butxt.
  ENDLOOP.

  SKIP.
  WRITE: / TEXT-t12, lines( gt_werks ).
  LOOP AT gt_werks INTO DATA(ls_werks).
    WRITE: / '  ', ls_werks-werks, ls_werks-name1.
  ENDLOOP.

  SKIP.
  WRITE: / TEXT-t13, lines( gt_kostl ).
  LOOP AT gt_kostl INTO DATA(ls_kostl).
    WRITE: / '  ', ls_kostl-kokrs, ls_kostl-kostl.
  ENDLOOP.

ENDFORM.
