*&---------------------------------------------------------------------*
*& Include          ZCBC_FI_CHITO01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
  SET PF-STATUS 'S200'.
  SET TITLEBAR 'T200'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CLEAR_OKCODE OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE clear_okcode OUTPUT.

  CLEAR : ok_code.


ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_HEADER_ALV OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_item_alv OUTPUT.

  IF  go_itemcon IS INITIAL .

    CREATE OBJECT go_itemcon
      EXPORTING
        container_name              = 'ITEM_AREA'
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.


    CREATE OBJECT go_itemalv
      EXPORTING
        i_appl_events     = 'X'
        i_parent          = go_itemcon
      EXCEPTIONS
        error_cntl_create = 1
        error_cntl_init   = 2
        error_cntl_link   = 3
        error_dp_create   = 4
        OTHERS            = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
**********************************************************************

    CREATE OBJECT go_event_receiver .
*    SET HANDLER: go_event_receiver->handle_on_f4 FOR go_itemalv.

    SET HANDLER: lcl_event_handler=>handle_toolbar FOR go_itemalv,
                 lcl_event_handler=>handle_user_command FOR go_itemalv.


**********************************************************************

    PERFORM set_exclude_toolbar.
    PERFORM set_layo.
    PERFORM set_fcat.
    PERFORM set_sort.

**********************************************************************

    CALL METHOD go_itemalv->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_enter
      EXCEPTIONS
        error      = 1
        OTHERS     = 2.

    IF sy-subrc <> 0.
*     Implement suitable error handling here
    ENDIF.

    CALL METHOD go_itemalv->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified
      EXCEPTIONS
        error      = 1
        OTHERS     = 2.

    IF sy-subrc <> 0.
*     Implement suitable error handling here
    ENDIF.




**********************************************************************


    CALL METHOD go_itemalv->set_table_for_first_display
      EXPORTING
*       i_buffer_active               =
*       i_bypassing_buffer            =
*       i_consistency_check           =
*       i_structure_name              = 'ZTC_FI_CHIT_I'
*       is_variant                    =
*       i_save                        =
*       i_default                     = 'X'
        is_layout                     = gs_layo
*       is_print                      =
*       it_special_groups             =
        it_toolbar_excluding          = gt_exclude
*       it_hyperlink                  =
*       it_alv_graphics               =
*       it_except_qinfo               =
*       ir_salv_adapter               =
      CHANGING
        it_outtab                     = gt_chit_i
        it_fieldcatalog               = gt_fcat
        it_sort                       = gt_sort
*       it_filter                     =
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

**********************************************************************
  ELSE.
    PERFORM refresh.

  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S100'.
  SET TITLEBAR 'T100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_DATA OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_data OUTPUT.

**********************************************************************
*     텍스트 테이블 이용시 사용
**********************************************************************
  SELECT SINGLE a~name a~emp_id a~dept_id
    INTO ( gv_ernam, ztc_fi_chit_h-ernam, ztc_fi_chit_h-co_cen )
    FROM zvc_md_emp AS a
    WHERE login_id = sy-uname.
**********************************************************************
*     기본 테이블만 이용시 사용
**********************************************************************
*  SELECT SINGLE a~name a~emp_id b~dept_id
*    INTO ( gv_ernam, ztc_fi_chit_h-ernam, ztc_fi_chit_h-co_cen )
*    FROM ztc_md_emp AS a
*    JOIN ztc_md_dept AS b
*    ON a~dept_id = b~dept_id
*    WHERE login_id = sy-uname.


***********************************************************************
  ztc_fi_chit_h-bp_id = '1010000000'.  " 헤더에는 전표가 적용되는 회사코드가 와야함. 즉, 우리회사.

  ztc_fi_chit_h-post_day = sy-datum.
  ztc_fi_chit_h-prf_day = sy-datum.



ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ITEM_DATA OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_item_data OUTPUT.
  ztc_fi_chit_i-co_cen = gs_chit_h-co_cen.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MODI_SCREEN OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE modi_screen OUTPUT.
  IF gv_curr = 'KRW'.
    LOOP AT SCREEN.

      IF  screen-group1 = 'EXC'  .
        screen-input = space.
        screen-output = space.
      ENDIF.
      MODIFY SCREEN.
    ENDLOOP.

  ELSEIF gv_curr = 'USD' AND ztc_fi_chit_i-exchange IS NOT INITIAL .
    LOOP AT SCREEN.

      IF  screen-group1 = 'EXC'  .
        screen-input = space.
      ENDIF.
      MODIFY SCREEN.
    ENDLOOP.



  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0300 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0300 OUTPUT.
  SET PF-STATUS 'S300'.
  SET TITLEBAR 'T300'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ORD_LIST OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_ord_list OUTPUT.

  IF go_listcon IS INITIAL .


    CREATE OBJECT go_listcon
      EXPORTING
        container_name              = 'LIST_AREA'
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.


    CREATE OBJECT go_listalv
      EXPORTING
        i_appl_events     = 'X'
        i_parent          = go_listcon
      EXCEPTIONS
        error_cntl_create = 1
        error_cntl_init   = 2
        error_cntl_link   = 3
        error_dp_create   = 4
        OTHERS            = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.


**********************************************************************

*    CREATE OBJECT go_event_receiver .
*    SET HANDLER: go_event_receiver->handle_on_f4 FOR go_itemalv.

    SET HANDLER: lcl_event_handler=>on_hotspot_click for go_listalv.
*                  lcl_event_handler=>handle_toolbar FOR go_listalv.
*                 lcl_event_handler=>handle_user_command FOR go_listalv.


**********************************************************************

    PERFORM set_exclude_toolbar.
    PERFORM set_layo_o.
    PERFORM set_fcato.
    PERFORM set_sorto.

**********************************************************************


    CALL METHOD go_listalv->set_table_for_first_display
      EXPORTING
*       i_buffer_active               =
*       i_bypassing_buffer            =
*       i_consistency_check           =
*       i_structure_name              =
*       is_variant                    =
*       i_save                        =
*       i_default                     = 'X'
        is_layout                     = gs_layo_o
*       is_print                      =
*       it_special_groups             =
        it_toolbar_excluding          = gt_exclude
*       it_hyperlink                  =
*       it_alv_graphics               =
*       it_except_qinfo               =
*       ir_salv_adapter               =
      CHANGING
        it_outtab                     = gt_ord_list
        it_fieldcatalog               = gt_fcato
        it_sort                       = gt_sorto
*       it_filter                     =
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

**********************************************************************


  ELSE.
    CALL METHOD go_listalv->refresh_table_display
      EXCEPTIONS
        finished = 1
        OTHERS   = 2.

  ENDIF.







ENDMODULE.
*&---------------------------------------------------------------------*
*& Module GET_ORD_LIST OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE get_ord_list OUTPUT.

  SELECT * FROM zvc_md_ord
    into CORRESPONDING FIELDS OF TABLE @gt_ord_list
    where ord_doc_num not in (
          SELECT doc_num
            from ztc_fi_chit_h
    ).





ENDMODULE.