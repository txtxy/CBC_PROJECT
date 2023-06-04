*&---------------------------------------------------------------------*
*& Include          SAPMZCBC_ARINVI01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.

    WHEN 'BACK'.


      LEAVE TO SCREEN 0.

    WHEN 'SEARCH' .

      PERFORM clear_screen.
      PERFORM sel_option.

    WHEN 'REGIAR'.

      IF gs_ar_condition-doc_num <> 0.
        gv_cnt = space.
        PERFORM make_chit.
        CALL SCREEN 200.
      ELSE.
        MESSAGE 'AR송장을 발행할 문서를 선택해주세요.' TYPE 'I' DISPLAY LIKE 'E'.
      ENDIF.

    WHEN 'REFRESH'.

      PERFORM clear_screen.
      PERFORM refresh_ord.
      PERFORM refresh_sku.
      PERFORM force_pai.

  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  ESCAPE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE escape INPUT.
  CASE ok_code.
    WHEN 'EXIT'.
      LEAVE PROGRAM .
    WHEN 'CANCEL'.
      LEAVE TO SCREEN 0.
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
      PERFORM clear_screen.
      PERFORM refresh_ord.
      PERFORM refresh_sku.
      CLEAR : lt_msrp,GV_BP_NAME,gv_bptp_t,lt_msrp,gt_chit,gt_chith,gv_sum_credit, gv_sum_debit.
      LEAVE TO SCREEN 0.
    WHEN 'SAVE'.
      PERFORM save_chit.

  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0300  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0300 INPUT.
  CASE ok_code.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.

  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  GET_SELD_ORD  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get_seld_ord INPUT.


  SELECT * FROM ztc_md_ord_list
    INTO CORRESPONDING FIELDS OF TABLE gt_ord
    WHERE ord_doc_num IN rt_ord AND
          ord_type IN rt_tp AND
          erdat IN rt_date .


ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_ORD_TP  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_ord_tp INPUT.

  CASE ztc_md_ord_list-ord_type.
    WHEN ''.

    WHEN 'ZBAC'.
    WHEN 'ZBUY'.
    WHEN 'ZDEL'.
    WHEN OTHERS.
      MESSAGE '오더타입을 확인해 주세요.' TYPE 'E'.
  ENDCASE.

ENDMODULE.