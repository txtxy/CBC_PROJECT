*&---------------------------------------------------------------------*
*& Include          ZCBC_FI_CHITC01
*&---------------------------------------------------------------------*

CLASS lcl_event_handler DEFINITION.
    PUBLIC SECTION.
  
  *    METHODS: handle_on_f4
  *      FOR EVENT onf4 OF cl_gui_alv_grid
  *      IMPORTING sender
  *                e_fieldname
  *                e_fieldvalue
  *                es_row_no
  *                er_event_data
  *                e_display.
  
  
  
      CLASS-METHODS:
  
        on_hotspot_click
          FOR EVENT hotspot_click
          OF cl_gui_alv_grid
          IMPORTING e_column_id es_row_no ,
  
        handle_toolbar
          FOR EVENT toolbar OF cl_gui_alv_grid
          IMPORTING e_object,
  *                  e_interactive.
  
        handle_user_command
          FOR EVENT user_command OF cl_gui_alv_grid
          IMPORTING e_ucomm.
  
  
  ENDCLASS.
  DATA : go_event_receiver TYPE REF TO lcl_event_handler.
  CLASS lcl_event_handler IMPLEMENTATION.
  
    METHOD : handle_toolbar.
  
      DATA: ls_toolbar TYPE stb_button.
      CLEAR ls_toolbar.
      ls_toolbar-butn_type = 3.
      APPEND ls_toolbar TO e_object->mt_toolbar.
  
  *    CLEAR ls_toolbar.
  *    ls_toolbar-function = 'INSERT'.
  *    ls_toolbar-icon = icon_insert_row.
  *    ls_toolbar-quickinfo = '데이터를 추가합니다.'.
  *    ls_toolbar-text = '추가'.
  *
  *
  *    APPEND ls_toolbar TO e_object->mt_toolbar.
  
  *
  *    CLEAR ls_toolbar.
  *    ls_toolbar-function = 'CHANGE'.
  *    ls_toolbar-icon = icon_change.
  *    ls_toolbar-quickinfo = '데이터를 수정합니다.'.
  *    ls_toolbar-text = '수정'.
  
  *    APPEND ls_toolbar TO e_object->mt_toolbar.
  
      CLEAR ls_toolbar.
      ls_toolbar-butn_type = 3.
  
      APPEND ls_toolbar TO e_object->mt_toolbar.
  
  
      CLEAR ls_toolbar.
      ls_toolbar-function = 'DELETE'.
      ls_toolbar-icon = icon_delete.
      ls_toolbar-quickinfo = '아이템 데이터를 삭제합니다.'.
      ls_toolbar-text = '삭제'.
  
      APPEND ls_toolbar TO e_object->mt_toolbar.
  
      CLEAR ls_toolbar.
      ls_toolbar-butn_type = 3.
  
      APPEND ls_toolbar TO e_object->mt_toolbar.
  
  *
  *
  *    CLEAR ls_toolbar.
  *    ls_toolbar-function = 'SAVEROW'.
  *    ls_toolbar-icon = icon_system_save.
  *    ls_toolbar-quickinfo = '아이템 데이터를 저장합니다.'.
  *    ls_toolbar-text = '저장'.
  
  *    APPEND ls_toolbar TO e_object->mt_toolbar.
  
  
    ENDMETHOD.
  
    METHOD : handle_user_command.
  
  
      CASE e_ucomm.
  
        WHEN 'CHANGE'.
          PERFORM change_data.
        WHEN 'DELETE'.
          PERFORM del_data.
        WHEN 'SAVEROW'.
          PERFORM save_data.
  
      ENDCASE.
  
  
  
    ENDMETHOD.
    METHOD on_hotspot_click.
  
      CASE e_column_id-fieldname.
        WHEN 'ORD_DOC_NUM'.
          READ TABLE gt_ord_list INTO gs_ord_list INDEX es_row_no-row_id.
  
        CALL TRANSACTION 'ZCBC_FI_CHIT' "USING gt_ord_list
              .
      ENDCASE.
  
    ENDMETHOD.
  *  METHOD handle_on_f4.
  *
  *    CALL METHOD go_itemalv->get_current_cell
  *      IMPORTING
  *        e_row     = gv_row
  *        e_value   = gv_value
  *        e_col     = gv_col
  *        es_row_id = gs_row_id
  *        es_col_id = gs_col_id
  *        es_row_no = gs_row_no.
  *
  *    READ TABLE gt_chit_i INTO gs_chit_i INDEX gv_row.
  *
  **    PERFORM handle_help_f4 USING e_fieldname
  **                                 e_fieldvalue
  **                                 es_row_no
  **                                 er_event_data
  **                                 et_bad_cells
  **                                 e_display.
  *  ENDMETHOD. "HANDLE_HELP_F4
  ENDCLASS.