*&---------------------------------------------------------------------*
*& Include          SAPMZCBC_ARINVO01
*&---------------------------------------------------------------------*
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
*& Module STATUS_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
  SET PF-STATUS 'S200'.
  SET TITLEBAR 'T200'.
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
*& Module CLEAR_OKCODE OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE clear_okcode OUTPUT.
  CLEAR : ok_code.


ENDMODULE.
*&---------------------------------------------------------------------*
*& Module GET_SEL_DATA OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE get_sel_data OUTPUT.
*  CLEAR : gt_ord.
*  DATA : ls_emp    LIKE LINE OF gt_emp,
*         ls_ord_tp LIKE LINE OF gt_ord_tp,
*         ls_ord LIKE LINE OF rt_ord.
*
*
*  IF go_con_ord IS INITIAL.
*
*  ELSE.
*    SELECT *
*      INTO CORRESPONDING FIELDS OF @gs_ord
*      FROM ztc_md_ord_list AS a
*      WHERE a~ord_doc_num NOT IN (
*              SELECT doc_num
*              FROM ztc_fi_chit_h AS b
*              WHERE doc_num = a~ord_doc_num ) AND
*
*            a~ord_doc_num IN @rt_ord AND
*            a~ord_type IN @rt_tp AND
*            a~erdat IN @rt_date AND
*            a~del_flag NE 'X'.
*
*      gs_ord-stat = 1.
*
*      READ TABLE gt_ord_tp INTO ls_ord_tp WITH KEY  ord_tp_id =  gs_ord-ord_type.
*      MOVE ls_ord_tp-ord_tp_name TO gs_ord-ord_type_name.
*
*      READ TABLE gt_emp INTO ls_emp WITH KEY emp_id = gs_ord-ernam.
*      MOVE ls_emp-name TO gs_ord-ernam_name.
*      CLEAR ls_emp.
*
*      READ TABLE gt_emp INTO ls_emp WITH KEY emp_id = gs_ord-aenam.
*      MOVE ls_emp-name TO gs_ord-aenam_name.
*
*
*
*
*      APPEND gs_ord TO gt_ord.
*
*      CLEAR gs_ord.
*    ENDSELECT.
*
*  ENDIF.


ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ORDALV OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_ordalv OUTPUT.

  IF go_con_ord IS INITIAL .

    CREATE OBJECT go_con_ord
      EXPORTING
        container_name              = 'ORD_LIST'
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


    CREATE OBJECT go_alv_ord
      EXPORTING
        i_parent          = go_con_ord
*       i_appl_events     = SPACE
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

    PERFORM set_exclude_toolbar.

    SET HANDLER : lcl_event_handler=>on_hotspot_click FOR go_alv_ord.

    PERFORM set_ord_layo.
    PERFORM set_ord_fcat.
    PERFORM set_ord_sort.




    CALL METHOD go_alv_ord->set_table_for_first_display
      EXPORTING
*       i_buffer_active               =
*       i_bypassing_buffer            =
*       i_consistency_check           =
*       i_structure_name              = 'ztc_md_ord_list'
*       is_variant                    =
*       i_save                        =
*       i_default                     = 'X'
        is_layout                     = gs_layo_ord
*       is_print                      =
*       it_special_groups             =
        it_toolbar_excluding          = gt_exclude
*       it_hyperlink                  =
*       it_alv_graphics               =
*       it_except_qinfo               =
*       ir_salv_adapter               =
      CHANGING
        it_outtab                     = gt_ord
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






  ELSE.

    PERFORM refresh_ord.


  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0110 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0110 OUTPUT.
  SET PF-STATUS 'S110'.
  SET TITLEBAR 'T110'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module GET_INIT_DATA OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE get_init_data OUTPUT.

  IF go_con_ord IS INITIAL .
    SELECT * FROM ztc_md_emp INTO TABLE gt_emp.
    SELECT * FROM ztc_md_ord INTO TABLE gt_ord_tp.
    SELECT * FROM ztc_md_bp INTO TABLE gt_bp.
  ELSE.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_SKUALV OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_skualv OUTPUT.

  IF go_con_sku IS INITIAL .

    CREATE OBJECT go_con_sku
      EXPORTING
        container_name              = 'SKU_LIST'
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


    CREATE OBJECT go_alv_sku
      EXPORTING
        i_parent          = go_con_sku
*       i_appl_events     = SPACE
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

    PERFORM set_exclude_toolbar.

    PERFORM set_sku_layo.
    PERFORM set_sku_fcat.
    PERFORM set_sku_sort.

    PERFORM set_msrp_alv.






  ELSE.
    PERFORM refresh_sku.

  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ITEM_ALV OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_item_alv OUTPUT.

  IF  go_con_chiti IS INITIAL .

    CREATE OBJECT go_con_chiti
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


    CREATE OBJECT go_alv_chiti
      EXPORTING
*        i_appl_events     = 'X'
        i_parent          = go_con_chiti
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


*    SET HANDLER: lcl_event_handler=>handle_toolbar FOR go_itemalv,
*                 lcl_event_handler=>handle_user_command FOR go_itemalv.
*

**********************************************************************

    PERFORM set_exclude_toolbar.
    PERFORM set_layo_chit.
    PERFORM set_fcat_chit.
    PERFORM set_sort_chit.

**********************************************************************

**********************************************************************


    CALL METHOD go_alv_chiti->set_table_for_first_display
      EXPORTING
*       i_buffer_active               =
*       i_bypassing_buffer            =
*       i_consistency_check           =
*       i_structure_name              = 'ZTC_FI_CHIT_I'
*       is_variant                    =
*       i_save                        =
*       i_default                     = 'X'
        is_layout                     = gs_layo_chit
*       is_print                      =
*       it_special_groups             =
        it_toolbar_excluding          = gt_exclude
*       it_hyperlink                  =
*       it_alv_graphics               =
*       it_except_qinfo               =
*       ir_salv_adapter               =
      CHANGING
        it_outtab                     = gt_chit
        it_fieldcatalog               = gt_fcatc
        it_sort                       = gt_sortc
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
  CALL METHOD go_alv_chiti->refresh_table_display
    EXCEPTIONS
      finished = 1
      OTHERS   = 2.

  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module GET_CHIT_ITEM OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE get_chit_item OUTPUT.
  IF gv_cnt = 0 .

    CLEAR : gt_chit, gs_chit.
    CASE gs_ar_condition-ord_type .

      WHEN 'ZBAC'. " 반품                                              "*
*
*      gs_chith-chit_type = 'DG'.
        PERFORM get_bac.
        "*

      WHEN    'ZB2B'.  " 출고
*      gs_chith-chit_type = 'DA'.

        PERFORM get_del.
        "*
      WHEN    'ZEXP'.  " 출고s
*      gs_chith-chit_type = 'DA'.

        PERFORM get_del.
        "*

*
*    WHEN  'ZBUY'.  " 구매                                            "*
**      gs_chith-chit_type = 'KA'.                                    "*
*
*      "*
**      PERFORM get_mm.
*      "*
*    WHEN   'ZSAF'.  " 일반 생산                                        "*
**      gs_chith-chit_type = 'WN'.                                    "*
*
**      PERFORM get_pp.
*
    WHEN   'ZRMM'.  " 리사이클 판매                                   "*
*      gs_chith-chit_type = 'WN'.                                    "*

      PERFORM get_rmm.

    ENDCASE.                                                          "*
**********************************************************************



  ELSE.

  ENDIF.

  PERFORM get_sum.

    CLEAR : gs_ar_condition.
    add 1 to gv_cnt.
ENDMODULE.