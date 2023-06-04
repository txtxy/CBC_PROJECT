*&---------------------------------------------------------------------*
*& Include          ZCBC_FI_CHITI01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  ESCAPE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE escape INPUT.
  CASE ok_code.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANCEL' .
      LEAVE TO SCREEN 0.
  ENDCASE.


ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'CREATE'.
      PERFORM save_header.
      CALL SCREEN 200.


  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.
  CASE ok_code.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'INSTROW'.

  PERFORM sum_price.
      PERFORM insert_row.

    WHEN 'SAVE'.
      PERFORM modi_chit.
    WHEN 'REFRESH'.

  PERFORM sum_price.
      PERFORM refresh.
  ENDCASE.
ENDMODULE.
*-------------------------------------------------------*
*&      Module  CHECK_DATE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_date INPUT.
  IF ztc_fi_chit_h-post_day < sy-datum.
            MESSAGE E077(zcbc_message) .

  ELSEIF  ztc_fi_chit_h-prf_day > ztc_fi_chit_h-post_day .
            MESSAGE E078(zcbc_message) .

  ENDIF.


ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  GET_ACCOUNT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get_bp_curr INPUT.

  DATA : ls_chit_i LIKE gs_chit_i.

  SELECT SINGLE bp_name currency
    INTO ( gv_leftacc, gv_curr )
  FROM ztc_md_bp
    WHERE bp_id = ztc_fi_chit_i-bp_for.



  LOOP AT gt_chit_i INTO ls_chit_i.

    IF ls_chit_i-bp_for IS NOT INITIAL AND ztc_fi_chit_i-bp_for <> ls_chit_i-bp_for .
            MESSAGE E079(zcbc_message) .


    ENDIF.

  ENDLOOP.



ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  GET_RIGHTACC  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get_acc INPUT.

  SELECT SINGLE acc_name
    INTO gv_rightacc
  FROM ztc_md_coa
    WHERE acc_id = ztc_fi_chit_i-right_acc.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_CURR  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_curr INPUT.

  IF gv_curr IS INITIAL .
            MESSAGE E080(zcbc_message) .

    BREAK abap_true .

  ENDIF.
ZTC_FI_CHIT_I-CRED_CURR = 'KRW'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0300  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0300 INPUT.
  CASE ok_code.
    WHEN 'BACk'.
      leave to SCREEN 0.
      when 'SELORD'.
  ENDCASE.

ENDMODULE.