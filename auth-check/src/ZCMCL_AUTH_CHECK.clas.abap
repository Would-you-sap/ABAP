class ZCMCL_AUTH_CHECK definition
  public
  final
  create public .

public section.

  class-methods CHECK
    importing
      !IT_CHECK type ZCMS0070T
    exporting
      value(ES_RETURN) type BAPIRET2
      value(ET_FAILED) type ZCMS0070T .
protected section.
private section.

  class-methods GET_DEFAULT_OBJECT
    importing
      !IV_FIELD type XUFIELD
    returning
      value(RV_OBJECT) type XUOBJECT .
ENDCLASS.



CLASS ZCMCL_AUTH_CHECK IMPLEMENTATION.


  METHOD check.

    CLEAR: es_return, et_failed.

    " 전달된 전 행을 끝까지 체크, 실패는 모아서 전량 리턴
    LOOP AT it_check INTO DATA(ls_check).

*      " 오브젝트 미지정시 필드별 기본 오브젝트 적용 (지정시 그대로 사용)
*      IF ls_check-xuobject IS INITIAL.
*        ls_check-xuobject = get_default_object( ls_check-xufield ).
*      ENDIF.

      " 오브젝트 미결정(미등록 필드)/필드/값 누락 행은 실패로 계산 (fail-closed)
      IF ls_check-xuobject IS INITIAL
         OR ls_check-xufield IS INITIAL
         OR ls_check-value IS INITIAL.
        APPEND ls_check TO et_failed.
        CONTINUE.
      ENDIF.

      " 필드 값만 비교 - ACTVT 등 미지정 필드는 검사되지 않음
      AUTHORITY-CHECK OBJECT ls_check-xuobject
        ID ls_check-xufield FIELD ls_check-value.

      IF sy-subrc <> 0.
        APPEND ls_check TO et_failed.
      ENDIF.

    ENDLOOP.

    DATA(lv_cnt) = lines( et_failed ).
    IF lv_cnt = 0.
      es_return-type = 'S'.
      RETURN.
    ENDIF.

    " 실패: 상태 E + 표준 메시지 조립 (단건 080 / 복수 081)
    " MESSAGE ... INTO는 로그온 언어의 텍스트로 조립됨 (EN/KO 자동)
    es_return-type = 'E'.
    es_return-id   = 'ZCMM01'.
    DATA(ls_first) = et_failed[ 1 ].
    DATA(lv_v1)    = CONV symsgv( |{ ls_first-xufield } { ls_first-value }| ).
    IF lv_cnt = 1.
      es_return-number     = '080'.
      es_return-message_v1 = lv_v1.
      MESSAGE ID 'ZCMM01' TYPE 'E' NUMBER '080'
        WITH lv_v1 INTO es_return-message.
    ELSE.
      es_return-number     = '081'.
      DATA(lv_rest)        = lv_cnt - 1.
      es_return-message_v1 = lv_v1.
      es_return-message_v2 = lv_rest.
      MESSAGE ID 'ZCMM01' TYPE 'E' NUMBER '081'
        WITH lv_v1 lv_rest INTO es_return-message.
    ENDIF.

  ENDMETHOD.


  METHOD get_default_object.

    " 축(필드)별 대표 권한 오브젝트 - 전사 표준 매핑 (합의 후 확정)
    rv_object = SWITCH #( iv_field
      WHEN 'BUKRS' THEN 'F_BKPF_BUK'
      WHEN 'WERKS' THEN 'M_MATE_WRK'
      WHEN 'KOSTL' THEN 'K_CSKS'
      WHEN 'KOKRS' THEN 'K_CSKS'
      WHEN 'VKORG' THEN 'V_VBAK_VKO'
      WHEN 'EKGRP' THEN 'M_BEST_EKG'
      ELSE '' ).

  ENDMETHOD.
ENDCLASS.
