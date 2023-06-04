*&---------------------------------------------------------------------*
*& Include          SAPMZCBC_ARINVC01
*&---------------------------------------------------------------------*

CLASS lcl_event_handler DEFINITION.
    PUBLIC SECTION.
      CLASS-METHODS:
        on_hotspot_click FOR EVENT hotspot_click OF cl_gui_alv_grid
          IMPORTING e_column_id es_row_no .
  
  ENDCLASS.
  CLASS lcl_event_handler IMPLEMENTATION.
    METHOD on_hotspot_click.
  clear : gs_ord, gs_ar_condition.
      CASE e_column_id-fieldname.
              WHEN 'ORD_DOC_NUM'.
  
        READ TABLE gt_ord INTO gs_ord INDEX es_row_no-row_id.
  
  
        PERFORM get_msrp.
  *      PERFORM set_msrp_alv.
        PERFORM force_PAI.
      ENDCASE.
  
    ENDMETHOD.
  ENDCLASS.