*&---------------------------------------------------------------------*
*& Include YCM_AUTH_DEMO5_F01 - 서브루틴
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Form CHECK_REQUIRED
*&---------------------------------------------------------------------*
FORM check_required.

  " 화면 검증
  IF p_bukrs IS INITIAL.
    MESSAGE e057(zcmm01) WITH TEXT-f01.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form BUILD_CHECK
*&---------------------------------------------------------------------*
FORM build_check.

  " 이 프로그램이 체크할 오브젝트+필드+값을 직접 구성 (입력된 축만 체크)
  " 오브젝트/필드는 프로그램이 결정
  gt_check = VALUE #(
    ( xuobject = 'F_BKPF_BUK' xufield = 'BUKRS' value = CONV #( p_bukrs ) )
    ( xuobject = 'M_MATE_WRK' xufield = 'WERKS' value = CONV #( p_werks ) )
    ( xuobject = 'K_CSKS'     xufield = 'KOSTL' value = CONV #( p_kostl ) ) ).
  DELETE gt_check WHERE value IS INITIAL.

  " 코스트센터 입력시 관리영역(KOKRS)도 함께 체크 - 같은 오브젝트, 행 2개
  IF p_kostl IS NOT INITIAL.
    gt_check = VALUE #( BASE gt_check
      ( xuobject = 'K_CSKS' xufield = 'KOKRS' value = '1000' ) ).
  ENDIF.

*  " 이 프로그램이 체크할 필드+값만 구성 (입력된 축만 체크)
*  " 오브젝트는 공통 클래스의 축별 표준 매핑이 결정
*  gt_check = VALUE #(
*    ( xufield = 'BUKRS' value = CONV #( p_bukrs ) )
*    ( xufield = 'WERKS' value = CONV #( p_werks ) )
*    ( xufield = 'KOSTL' value = CONV #( p_kostl ) ) ).
*  DELETE gt_check WHERE value IS INITIAL.
*
*  " 코스트센터 입력시 관리영역(KOKRS)도 함께 체크
*  IF p_kostl IS NOT INITIAL.
*    gt_check = VALUE #( BASE gt_check
*      ( xufield = 'KOKRS' value = '1000' ) ).
*  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_RESULT
*&---------------------------------------------------------------------*
FORM display_result.

  IF gs_return-type = 'S'.
    WRITE: / TEXT-t01, '-', sy-uname.
    LOOP AT gt_check INTO DATA(ls_check).
      WRITE: / ' ', TEXT-t03, ls_check-xuobject, ls_check-xufield,
               ls_check-value.
    ENDLOOP.
    RETURN.
  ENDIF.

  " 실패: 상세 목록은 et_failed, 메시지는 클래스가 조립한 것 그대로
  " 실전 진입 차단형은 목록 표시 없이 MESSAGE gs_return-message TYPE 'E' 한 줄
  WRITE: / TEXT-t02, lines( gt_failed ), '-', sy-uname.
  LOOP AT gt_failed INTO DATA(ls_fail).
    WRITE: / ' ', TEXT-t04, ls_fail-xuobject, ls_fail-xufield,
             ls_fail-value.
  ENDLOOP.

  MESSAGE gs_return-message TYPE 'S' DISPLAY LIKE 'E'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form check_authority
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM check_authority .

  " 공통 클래스 호출
  " 상세 목록(et_failed)은 표시용 - 단순 차단형 프로그램은 수신 생략 가능
  zcmcl_auth_check=>check(
    EXPORTING it_check  = gt_check
    IMPORTING es_return = gs_return
              et_failed = gt_failed ).

ENDFORM.
