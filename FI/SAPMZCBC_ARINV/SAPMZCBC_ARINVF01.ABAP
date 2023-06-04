*&---------------------------------------------------------------------*
*& Include          SAPMZCBC_ARINVF01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form refresh
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM refresh_ord .

    CALL METHOD go_alv_ord->refresh_table_display
      EXCEPTIONS
        finished = 1
        OTHERS   = 2.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_ord_fcat
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_ord_fcat .
  
    PERFORM edit_fieldcatalog USING :
          " 필드명          순서    제목          정렬   길이   no-out  핫스팟  key
          'STAT'          1     '전표생성여부'     'C'  8  'X' space space
         ,'ORD_DOC_NUM'   2     '문서번호'         'C'  10  space 'X' 'X'
         ,'ORD_TYPE'      3     '유형 ID'         'C'  5    space space space
         ,'ORD_TYPE_NAME' 4     '유형'            'C'  10  space space space
         ,'DEL_FLAG'      13      '삭제'           'C' 1     'X' space space
  
         ,'ERNAM'         5     '작성자'           'C'   10  space   space space
         ,'ERNAM_NAME'    6     '작성자명'          'C'   6   'X' space space
         ,'ERDAT'         7     '작성일자'          'C'  10 space space space
         ,'ERZET'         8     '작성시간'          'C'   10  space space space
  
         ,'AENAM'         9     '수정자'           'C'   10    'X' space space
         ,'AENAM_NAME'   10     '수정자명'          'C'   6   'X' space space
         ,'AEDAT'        11     '수정일자'          'C'  10   'X' space space
         ,'AEZET'        12     '수정시간'          'C'    10   'X' space space
  .
  
  
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_ord_layo
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_ord_layo .
    gs_layo_ord-zebra = 'X'.
    gs_layo_ord-excp_fname = 'STAT'.
    gs_layo_ord-excp_led = 'X'.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_ord_sort
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_ord_sort .
    DATA : ls_sroto LIKE LINE OF gt_sorto.
  
    ls_sroto-fieldname = 'ORD_DOC_NUM'.
  *  ls_sroto-up = 'X'.
    ls_sroto-down = 'X'.
    ls_sroto-spos = 2.
    APPEND ls_sroto TO gt_sorto.
    CLEAR ls_sroto.
  
    ls_sroto-fieldname = 'ORD_TYPE'.
  
    ls_sroto-up = 'X'.
    ls_sroto-spos = 1.
    APPEND ls_sroto TO gt_sorto.
  
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form sel_option
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM sel_option .
    DATA : rs_ord  LIKE LINE OF rt_ord,
           rs_date LIKE LINE OF rt_date,
           rs_tp   LIKE LINE OF rt_tp,
           rs_emp  LIKE LINE OF rt_emp,
           ls_emp  LIKE LINE OF gt_emp.
    CLEAR : rt_date, rt_ord, rt_tp,rt_emp.
  
  
  ***********************************************************************
  *                          문서 번호 조건 설정                            *
  ***********************************************************************
    IF ztc_md_ord_list-ord_doc_num IS INITIAL  .
  
    ELSE.
      rs_ord-sign = 'I'.
      rs_ord-option = 'EQ'.
      rs_ord-low = ztc_md_ord_list-ord_doc_num.
  
      APPEND rs_ord TO rt_ord.
    ENDIF.
  
  ***********************************************************************
  *                          작성 일자 조건 설정                            *
  ***********************************************************************
    IF gv_date_a IS INITIAL AND gv_date_b IS NOT INITIAL.
  
      rs_date-sign = 'I'.
      rs_date-option = 'EQ'.
      rs_date-low = gv_date_b.
  
      APPEND rs_date TO rt_date.
    ELSEIF gv_date_a IS NOT INITIAL AND gv_date_b IS INITIAL.
  
      rs_date-sign = 'I'.
      rs_date-option = 'EQ'.
      rs_date-low = gv_date_a.
  
      APPEND rs_date TO rt_date.
    ELSEIF gv_date_a IS NOT INITIAL AND gv_date_b IS NOT INITIAL.
  
      rs_date-sign = 'I'.
      rs_date-option = 'BT'.
      rs_date-low = gv_date_a.
      rs_date-high = gv_date_b.
  
      APPEND rs_date TO rt_date.
    ELSE.
    ENDIF.
  ***********************************************************************
  *                          오더 유형 조건 설정                            *
  ***********************************************************************
    rs_tp-sign = 'E'.
    rs_tp-option = 'BT'.
    rs_tp-low = 'TEST' .
    rs_tp-high = 'ZB2C' .
  
    APPEND rs_tp TO rt_tp.
  
    rs_tp-sign = 'E'.
    rs_tp-option = 'BT'.
    rs_tp-low = 'ZEXP' .
    rs_tp-high = 'ZSEE' .
    APPEND rs_tp TO rt_tp.
  
    IF ztc_md_ord_list-ord_type IS INITIAL .
  
    ELSE.
  
      rs_tp-sign = 'I'.
      rs_tp-option = 'EQ'.
      rs_tp-low = ztc_md_ord_list-ord_type .
  
      APPEND rs_tp TO rt_tp.
    ENDIF.
  
  ***********************************************************************
  *                          작성자명 조건  설정                            *
  ***********************************************************************
    IF gv_name IS INITIAL  .
  
    ELSE.
      READ TABLE gt_emp INTO ls_emp WITH KEY name = gv_name.
  
      rs_emp-sign = 'I'.
      rs_emp-option = 'EQ'.
      rs_emp-low = ls_emp-emp_id.
  
      APPEND rs_emp TO rt_emp.
    ENDIF.
  
  
  ***********************************************************************
  *                        조건 설정 완료 데이터 호출                        *
  ***********************************************************************
  
    PERFORM get_data.
  
  
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form edit_fieldcatalog
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> P_
  *&      --> P_1
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&---------------------------------------------------------------------*
  FORM edit_fieldcatalog  USING    pv_fieldname TYPE lvc_s_fcat-fieldname
                                   pv_colpos    TYPE lvc_s_fcat-col_pos
                                   pv_coltext   TYPE lvc_s_fcat-coltext
                                   pv_just      TYPE lvc_s_fcat-just
                                   pv_outputlen TYPE lvc_s_fcat-outputlen
                                   pv_noout     TYPE lvc_s_fcat-tech
                                   pv_hotspot  TYPE lvc_s_fcat-hotspot
                                   pv_key       TYPE lvc_s_fcat-key.
  
  
    DATA ls_fcat TYPE lvc_s_fcat.
  
  
    ls_fcat-fieldname = pv_fieldname.
    ls_fcat-col_pos   = pv_colpos.
    ls_fcat-coltext   = pv_coltext.
    ls_fcat-just      = pv_just.
    ls_fcat-outputlen = pv_outputlen.
    ls_fcat-tech = pv_noout.
    ls_fcat-hotspot = pv_hotspot.
    ls_fcat-key = pv_key.
    APPEND ls_fcat TO gt_fcato.
  
  
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_sku_fcat
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_sku_fcat .
    DATA : ls_fcat TYPE lvc_s_fcat.
  
    PERFORM edit_fcat_msrp USING :
          " 필드명        순서       제목          정렬   길이   no-out cField curr  sum  key
          'SKU_ID'    1     'SKU 코드'       'C'  10   space  space      space space 'X'
         ,'SKU_NAME'  2     'SKU 명'       'C'  20   space  space      space space 'X'
         ,'BATCH'     3     '배치'           'C'   3   space  space      space space space
         ,'BP_ID'     4     '거래처'          'C'  10   'X'   space      space space space
         ,'PRICE'     5      '판매가'         'C'  15   space 'CURRENCY' space space space
         ,'CURRENCY'  6      '단위'          'C'   4   space  space     'X' space space
         ,'QTY'       7    '수량'          'C'   4   space  space     space 'X' space
         ,'UNIT'      8      '단위'          'C'   4   space  space     space space space
  .
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_sku_layo
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_sku_layo .
  
    gs_layo_msrp-zebra = 'X'.
  
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_sku_sort
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_sku_sort .
    DATA : ls_sort TYPE lvc_s_sort.
    ls_sort-fieldname = 'SKU_ID'.
    ls_sort-up = 'X'.
    ls_sort-spos = 1.
  *  ls_sort-subtot = 'X'.
    APPEND ls_sort TO gt_sortm.
    CLEAR : ls_sort.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form get_msrp
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM get_msrp .
    CLEAR : gv_tabname,gs_ar_condition, lt_msrp.
  
    DATA : ls_emp LIKE LINE OF gt_emp.
  
    DATA : lv_doc_field TYPE string.
  
    DATA : lv_htabname TYPE string,
           lv_bp       TYPE string,
           lv_sku      TYPE string,
           lv_struct   TYPE string.
  
    DATA: lr_data TYPE REF TO data.
  
  
  **********************************************************************
  **********************************************************************
  
  **********************************************************************
  *1. 선택한 오더의 문서 정보 가져오기
    CASE gs_ord-ord_type .
  
      WHEN 'ZBAC'. " 반품
  
        SELECT * FROM ztc_md_msrp AS a
          INTO CORRESPONDING FIELDS OF TABLE @gt_msrp
          WHERE bp_id = ( SELECT b~bp_id
                FROM ztc_sd_rtn_ord AS b
                WHERE b~rtn_doc_num = @gs_ord-ord_doc_num ).
  
  
        SELECT * FROM ztc_sd_rtn_ord
          INTO CORRESPONDING FIELDS OF TABLE gt_rtn
          WHERE rtn_doc_num = gs_ord-ord_doc_num
          .
        IF  sy-subrc = 4.
          MESSAGE i074(zcbc_message) DISPLAY LIKE 'E'.
          CLEAR : gt_msrp, gt_rtn,gs_ord.
        ELSE.
          READ TABLE gt_rtn INTO gs_rtn INDEX 1.
          MOVE gs_rtn-bp_id TO gs_ar_condition-bp_id.
          MOVE gs_rtn-rtn_doc_num TO gs_ar_condition-doc_num.
          MOVE gs_rtn-ord_tp_id TO gs_ar_condition-ord_type.
  
          PERFORM get_etc_data_rtn.
  
          LOOP AT gt_rtn INTO gs_rtn.
  
            READ TABLE gt_msrp INTO gs_msrp WITH KEY sku_id = gs_rtn-sku_id
                                                     batch  = gs_rtn-batch.
            SELECT SINGLE a~sku_name
              INTO gs_msrp-sku_name
              FROM ztc_md_sku AS a
              WHERE sku_id = gs_msrp-sku_id AND
                    batch  = gs_msrp-batch .
  
            MOVE gs_rtn-currency TO gs_msrp-currency.
            MOVE gs_rtn-msrp TO gs_msrp-price.
            MOVE gs_rtn-real_unit TO gs_msrp-unit.
            MOVE gs_rtn-real_qty TO gs_msrp-qty.
  
            APPEND gs_msrp TO lt_msrp.
            CLEAR gs_msrp.
          ENDLOOP.
  
        ENDIF.
  
      WHEN 'ZDEL' OR 'ZRMM'.  " 출고
  ***********************************************************************
  
  
  
        SELECT SINGLE * FROM ztc_wm_out_h
          INTO CORRESPONDING FIELDS OF gs_del_h
          WHERE out_doc_num  = gs_ord-ord_doc_num
          .
        IF  sy-subrc = 4.
          MESSAGE i074(zcbc_message) DISPLAY LIKE 'E'.
          CLEAR : gt_msrp, gt_rtn,gs_ord.
        ELSE.
          PERFORM get_etc_data_out.
  
          SELECT * FROM ztc_md_msrp AS a
            INTO CORRESPONDING FIELDS OF TABLE gt_msrp
            WHERE bp_id = gs_ar_condition-bp_id.
  
  
          MOVE gs_ord-ord_doc_num TO gs_ar_condition-doc_num.
  
          gs_ar_condition-ord_type = 'ZDEL'.
  
  
          MOVE gs_del_h-out_doc_num TO gs_ar_condition-doc_num.
          MOVE gs_del_h-ord_tp_id TO gs_ar_condition-ord_type.
  
  
          SELECT * FROM ztc_wm_out_i
            INTO CORRESPONDING FIELDS OF gs_del_i
            WHERE out_doc_num = gs_del_h-out_doc_num.
  
  
            READ TABLE gt_msrp INTO gs_msrp WITH KEY sku_id = gs_del_i-sku_id
                                                      batch = gs_del_i-batch
                                                      bp_id = gs_ar_condition-bp_id .
  
  
            SELECT SINGLE a~sku_name
              INTO gs_msrp-sku_name
              FROM ztc_md_sku AS a
              WHERE sku_id = gs_msrp-sku_id AND
                    batch  = gs_msrp-batch .
  
            MOVE gs_del_i-unit TO gs_msrp-unit.
            MOVE gs_del_i-out_qty TO gs_msrp-qty.
  
            APPEND gs_msrp TO lt_msrp.
          ENDSELECT.
  
  
  
  
        ENDIF.
  ***********************************************************************
  ***********************************************************************
  *    WHEN 'ZBAC'. " 반품                                               *
  *      lv_doc_field = 'RTN_DOC_NUM = gs_ord-ord_doc_num'.             *
  *      gv_tabname = 'ZTC_SD_RTN_ORD'.                                 *
  *    WHEN    'ZDEL'.  " 출고                                           *
  *      gv_tabname  = 'ZTC_WM_OUT_'.                                   *
  *      lv_doc_field = 'OUT_DOC_NUM = gs_ord-ord_doc_num'.             *
  *    WHEN  'ZBUY'.  " 구매                                             *
  *      gv_tabname  = 'ZTC_MM_'.                                       *
  *      lv_doc_field = 'MM_DOC_NUM = gs_ord-ord_doc_num'.              *
  *                                                                     *
  *    WHEN   'ZSAF'.  " 일반 생산                                        *
  *      gv_tabname  = 'ZTC_PP_'.                                       *
  *      lv_doc_field = 'PP_DOC_NUM = gs_ord-ord_doc_num'.              *
  *                                                                     *
  *    WHEN   'ZREC'.  " 리사이클 생산                                     *
  *      gv_tabname  = 'ZTC_PP_'.                                       *
  *      lv_doc_field = 'PP_DOC_NUM = gs_ord-ord_doc_num'.              *
  *                                                                     *
  *    WHEN    'ZSEE'.  " 검수                                           *
  *      gv_tabname  = 'ZTC_QC_'.                                       *
  *      lv_doc_field = 'QC_DOC_NUM = gs_ord-ord_doc_num'.              *
  ***********************************************************************
  ***********************************************************************
    ENDCASE.
  
    gs_ar_condition-regi_date = sy-datum.
    gs_ar_condition-currecy = 'KRW'.
  
  
    PERFORM get_domain_name USING 'ZDC_BP_TYP'
                                   gs_ar_condition-bp_type
                                   gv_bptp_t.
  
    LOOP AT lt_msrp INTO gs_msrp.
  
      gs_ar_condition-price = gs_ar_condition-price + ( gs_msrp-price * gs_msrp-qty ).
  
    ENDLOOP.
  
    READ TABLE gt_emp INTO ls_emp WITH KEY login_id = sy-uname .
    MOVE ls_emp-name TO gv_lognam.
  
  
  
  **   필드 심벌 안에 루프돌릴 때 LOOP at <fs_itab> assign in <fs_struct>.
  *
  ***********************************************************************
  **2. 가져온 문서정보를 통해 아이템의 필요한 정보를 gs_ar_condition에 가져오기
  ***********************************************************************
  *    CASE gs_ord-ord_type.
  *      WHEN 'ZBAC'.
  *
  *        SELECT * FROM (gv_tabname)
  *          INTO CORRESPONDING FIELDS OF TABLE <fs_table>    " 헤더 데이터 저장
  *          WHERE (lv_doc_field).
  *
  *
  ***********************************************************************
  *      WHEN OTHERS.
  *        lv_htabname = gv_tabname  && 'H'.
  *
  *    CREATE DATA gr_table TYPE TABLE OF (lv_htabname).
  *    ASSIGN gr_table->* TO <fs_table>.
  *
  *    CREATE DATA lr_data TYPE (lv_htabname).
  *    ASSIGN lr_data->* TO <fs_strut>.
  *
  *        SELECT SINGLE * FROM (lv_htabname)
  *          INTO CORRESPONDING FIELDS OF <fs_strut>      " 헤더 데이터 저장
  *          WHERE (lv_doc_field).
  *
  *MOVE-CORRESPONDING <fs_strut> to gs_ar_condition.
  *
  *        gv_tabname = gv_tabname  && 'I'.
  *
  *
  *
  *      CREATE DATA gr_table TYPE TABLE OF (gv_tabname).
  *    ASSIGN gr_table->* TO <fs_table>.
  *
  *        SELECT * FROM (gv_tabname)
  *          INTO TABLE <fs_table>                           " 아이템 데이터 저장
  *          WHERE (lv_doc_field).
  *
  *    ENDCASE.
  ***********************************************************************
  *
  *
  **3. 아이템 정보를 통해 BP_ID 와 SKU 정보 매칭하기
  *
  **CASE gs_ar_condition-ord_type.
  **  WHEN 'ZBAC'.
  **    lv_BP = gv_tabname && '-BP_ID'.
  **    lv_sku = gv_tabname && '-SKU_ID'.
  **    ASSIGN (lv_BP) to <fs_bp>.
  **    ASSIGN (lv_sku) to <fs_sku>.
  **
  **  WHEN 'ZDEL'.
  **    lv_sku = gv_tabname && '-SKU_ID'.
  **    lv_BP = gv_tabname && '-BP_ID'.
  **    ASSIGN (lv_BP) to <fs_bp>.
  **    ASSIGN (lv_sku) to <fs_sku>.
  **ENDCASE.
  **    lv_bp = gv_tabname && '-BP_ID'.
  **    lv_sku = gv_tabname && '-SKU_ID'.
  **    ASSIGN (lv_bp) TO <fs_bp>.
  **    ASSIGN (lv_sku) TO <fs_sku>.
  *
  ** 반품 테이블과 출고 아이템에 MSRP가 존재함.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form edit_fcat_msrp
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> P_
  *&      --> P_1
  *&      --> P_
  *&      --> P_
  *&      --> P_8
  *&      --> SPACE
  *&---------------------------------------------------------------------*
  FORM edit_fcat_msrp  USING       pv_fieldname TYPE lvc_s_fcat-fieldname
                                   pv_colpos    TYPE lvc_s_fcat-col_pos
                                   pv_coltext   TYPE lvc_s_fcat-coltext
                                   pv_just      TYPE lvc_s_fcat-just
                                   pv_outputlen TYPE lvc_s_fcat-outputlen
                                   pv_noout     TYPE lvc_s_fcat-no_out
                                   pv_cfield    TYPE lvc_s_fcat-cfieldname
                                   pv_curr      TYPE lvc_s_fcat-currency
                                   pv_sum       TYPE lvc_s_fcat-do_sum
                                   pv_key       TYPE lvc_s_fcat-key.
  
    DATA ls_fcat TYPE lvc_s_fcat.
  
  
    ls_fcat-fieldname = pv_fieldname.
    ls_fcat-col_pos   = pv_colpos.
    ls_fcat-coltext   = pv_coltext.
    ls_fcat-just      = pv_just.
    ls_fcat-outputlen = pv_outputlen.
    ls_fcat-no_out = pv_noout.
    ls_fcat-cfieldname = pv_cfield.
    ls_fcat-currency = pv_curr.
    ls_fcat-do_sum    = pv_sum.
    ls_fcat-key       = pv_key.
  
    APPEND ls_fcat TO gt_fcatm.
  
  
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_msrp
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_msrp TABLES pt_tab
                USING ps_struct.
  
    LOOP AT pt_tab INTO ps_struct.
  
      MOVE-CORRESPONDING ps_struct TO gs_msrp.
  
      APPEND gs_msrp TO gt_msrp.
  
    ENDLOOP.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form get_etc_data_rtn
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM get_etc_data_rtn .
    DATA :ls_bp LIKE LINE OF gt_bp .
    READ TABLE gt_bp INTO ls_bp WITH KEY bp_id = gs_rtn-bp_id.
  
    MOVE-CORRESPONDING ls_bp TO gs_ar_condition.
    MOVE ls_bp-bp_name TO gv_bp_name.
    MOVE ls_bp-bank TO gs_ar_condition-bank_id.
    MOVE ls_bp-account TO gs_ar_condition-bank_num.
  
  
  *        *---------------------------------------------------------
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form get_etc_data_out
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM get_etc_data_out .
    DATA :ls_bp LIKE LINE OF gt_bp,
          lv_id LIKE gs_ar_condition-bp_id.
  
    SELECT SINGLE bp_id
      INTO lv_id
      FROM ztc_sd_ord_h
      WHERE ord_doc_num = gs_del_h-ord_doc_num.
  
    READ TABLE gt_bp INTO ls_bp WITH KEY bp_id = lv_id.
  
    MOVE-CORRESPONDING ls_bp TO gs_ar_condition.
    MOVE ls_bp-bp_name TO gv_bp_name.
    MOVE ls_bp-bank TO gs_ar_condition-bank_id.
    MOVE ls_bp-account TO gs_ar_condition-bank_num.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_msrp_alv
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_msrp_alv .
  
    CALL METHOD go_alv_sku->set_table_for_first_display
      EXPORTING
  *     i_buffer_active               =
  *     i_bypassing_buffer            =
  *     i_consistency_check           =
  *     i_structure_name              =
  *     is_variant                    =
  *     i_save                        =
  *     i_default                     = 'X'
        is_layout                     = gs_layo_msrp
  *     is_print                      =
  *     it_special_groups             =
        it_toolbar_excluding          = gt_exclude
  *     it_hyperlink                  =
  *     it_alv_graphics               =
  *     it_except_qinfo               =
  *     ir_salv_adapter               =
      CHANGING
        it_outtab                     = lt_msrp
        it_fieldcatalog               = gt_fcatm
        it_sort                       = gt_sortm
  *     it_filter                     =
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4.
    IF sy-subrc <> 0.
  * Implement suitable error handling here
    ENDIF.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form force_PAI
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM force_pai .
  
    CALL METHOD cl_gui_cfw=>set_new_ok_code
      EXPORTING
        new_code = 'ENTER'.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form make_chit
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM make_chit .
  * 사업장
    gs_chith-bp_id = gv_comp.
  * FI-year
    gs_chith-fi_year = sy-datum(4).
  * 전표 유형
    CASE gs_ord-ord_type .
      WHEN 'ZBUY'.
        gs_chith-chit_type = 'DA'.
      WHEN 'ZBAC'.
        gs_chith-chit_type = 'DG'.
      WHEN    'ZDEL'.  " 출고
        gs_chith-chit_type = 'DA'.
      WHEN    'ZRRM'.  " 리사이클 판매
        gs_chith-chit_type = 'DA'.
    ENDCASE.
  
  
  * 원청문서
  * 작성 정보
    SELECT SINGLE emp_id dept_id name
      INTO ( gs_chith-ernam, gs_chith-co_cen , gv_lognam )
       FROM ztc_md_emp
      WHERE login_id = sy-uname.
  
    gs_chith-erdat = sy-datum.
    gs_chith-erzet = sy-timlo.
    gs_chith-post_day = gs_chith-erdat.
    gs_chith-prf_day = gs_ord-erdat.
    gs_chith-doc_num = gs_ar_condition-doc_num.
  
    gs_chith-brief =
                     gv_bptp_t  && ' ' &&
                     gv_bp_name && '  ' &&
                     '매출 확정의 건'.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form GET_DOMAIN_NAME
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> P_
  *&      --> WA_SBOOK_CUSTTYPE
  *&      --> CUST_TYPE
  *&---------------------------------------------------------------------*
  FORM get_domain_name  USING    pv_domain TYPE domname
                                 pv_value  TYPE char1
                                 pv_text   TYPE text20.
  
    DATA: lt_value TYPE TABLE OF dd07v,
          ls_value LIKE LINE OF lt_value.
  
    CALL FUNCTION 'GET_DOMAIN_VALUES'
      EXPORTING
        domname         = pv_domain
      TABLES
        values_tab      = lt_value
      EXCEPTIONS
        no_values_found = 1
        OTHERS          = 2.
  
    IF sy-subrc <> 0.
  
    ENDIF.
  
    READ TABLE lt_value INTO ls_value
      WITH KEY domvalue_l = pv_value.
  
    IF sy-subrc = 0.
      pv_text = ls_value-ddtext.
    ENDIF.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form get_data
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM get_data .
    CLEAR : gt_ord.
    DATA : ls_emp    LIKE LINE OF gt_emp,
           ls_ord_tp LIKE LINE OF gt_ord_tp,
           ls_ord    LIKE LINE OF rt_ord.
  
  
    IF go_con_ord IS INITIAL.
  
    ELSE.
  
  *    **********************************************************************
  *                         전표가 없고, 선택조건을 만족하는 오더리스트 조회
  *    **********************************************************************
      SELECT *
        INTO CORRESPONDING FIELDS OF @gs_ord
        FROM ztc_md_ord_list AS a
        WHERE  a~ord_doc_num NOT IN (
                 SELECT doc_num
                FROM ztc_fi_chit_h AS b
                WHERE doc_num = a~ord_doc_num ) AND
  
              a~ord_doc_num IN @rt_ord AND
              a~ord_type IN @rt_tp AND
              a~ord_type <> @space and
  
              a~erdat IN @rt_date AND
              a~ernam IN @rt_emp AND
              a~del_flag NE 'X'.
  
        gs_ord-stat = 1.
  
        READ TABLE gt_ord_tp INTO ls_ord_tp WITH KEY  ord_tp_id =  gs_ord-ord_type.
        MOVE ls_ord_tp-ord_tp_name TO gs_ord-ord_type_name.
  
        READ TABLE gt_emp INTO ls_emp WITH KEY emp_id = gs_ord-ernam.
        MOVE ls_emp-name TO gs_ord-ernam_name.
        CLEAR ls_emp.
  
        READ TABLE gt_emp INTO ls_emp WITH KEY emp_id = gs_ord-aenam.
        MOVE ls_emp-name TO gs_ord-aenam_name.
  
  
        APPEND gs_ord TO gt_ord.
  
        CLEAR gs_ord.
      ENDSELECT.
  
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form clear_screen
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM clear_screen .
  
    CLEAR : gt_ord,gs_ord, gs_ar_condition, gt_msrp,gv_bp_name, gv_bptp_t,lt_msrp.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_exclude_toolbar
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_exclude_toolbar .
    DATA : ls_exclude TYPE ui_func.
  
    ls_exclude = cl_gui_alv_grid=>mc_fc_excl_all.  " toolbar의 모든 기본 버튼 제외
  
    APPEND ls_exclude TO gt_exclude.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form refresh_sku
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM refresh_sku .
  
  
  
  
    CALL METHOD go_alv_sku->refresh_table_display
      EXCEPTIONS
        finished = 1
        OTHERS   = 2.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_layo_chit
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_layo_chit .
  *  gs_layo-col_opt = 'X'.
    gs_layo_chit-grid_title = '전표 라인'.
  *  gs_layo_chit-sel_mode = 'A'.
  *  gs_layo_chit-stylefname = 'CELLTAB'.
    gs_layo_chit-zebra     = 'X'.
  *  gs_layo-ctab_fname = 'CELLCOL'.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_fcat_chit
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_fcat_chit .
    CLEAR : gt_fcatc.
    DATA : ls_fcat LIKE LINE OF gt_fcatc.
  
  
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = 'ZTC_FI_CHIT_I'     " 해당 글로벌 스트럭쳐 타입의 필드카탈로그 형식을
      CHANGING
        ct_fieldcat            = gt_fcatc     " 현재 ALV-GRID의 필드 카탈로그 형식으로 전달.
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.
  
    IF sy-subrc <> 0.
  *    * Implement suitable error handling here
    ENDIF.
  
    LOOP AT gt_fcatc INTO ls_fcat.                           " 기타 설정이 필요한 사항은 반복문을 통해 설정
  
      CASE ls_fcat-fieldname.
  
        WHEN  'LINE_NUM'.
          ls_fcat-col_pos = 1.
          ls_fcat-coltext = 'NO.'.
          ls_fcat-outputlen = 3.
  
        WHEN 'CHIT_NUM'.
          ls_fcat-no_out = 'X'.
  
        WHEN 'DOC_NUM'.
          ls_fcat-no_out = 'X'.
        WHEN 'BP_ID'.
          ls_fcat-no_out = 'X'.
  
        WHEN 'FI_YEAR'.
          ls_fcat-col_pos = 2.
          ls_fcat-coltext = '회계연도'.
          ls_fcat-outputlen = 5.
          ls_fcat-just = 'C'.
  
        WHEN  'BP_FOR'.
  *        LS_FCAT-EDIT = 'X'.
          ls_fcat-col_pos = 3.
          ls_fcat-outputlen = 10.
          ls_fcat-coltext = '거래처'.
          ls_fcat-just = 'C'.
  
  
  
        WHEN  'POST_KEY'.
          ls_fcat-col_pos = 4.
  *        LS_FCAT-EDIT = 'X'.
          ls_fcat-coltext = '전기키'.
          ls_fcat-outputlen = 5.
  
  
        WHEN  'RIGHT_ACC'.
  *        LS_FCAT-EDIT = 'X'.
          ls_fcat-coltext = '계정'.
          ls_fcat-col_pos = 5.
          ls_fcat-outputlen = 10.
  
        WHEN  'EBIT_AMT'.
          ls_fcat-col_pos = 6.
  *        LS_FCAT-EDIT = 'X'.
          ls_fcat-cfieldname = 'EBIT_CURR'.
          ls_fcat-coltext = '차변 금액'.
          ls_fcat-just = 'R'.
  
  
        WHEN 'EBIT_CURR'.
          ls_fcat-col_pos = 7.
          ls_fcat-coltext = '통화'.
          ls_fcat-just = 'C'.
  
  
        WHEN 'CRED_AMT'.
          ls_fcat-col_pos = 8.
          ls_fcat-cfieldname = 'CRED_CURR'.
          ls_fcat-coltext = '대변 금액'.
          ls_fcat-just = 'R'.
  
  
  
  
        WHEN  'CRED_CURR'.
          ls_fcat-col_pos = 9.
  *        LS_FCAT-EDIT = 'X'.
          ls_fcat-coltext = '통화'.
          ls_fcat-just = 'C'.
  
  
        WHEN  'EXCHANGE'.
          ls_fcat-col_pos = 12.
          ls_fcat-coltext = '기준 환율'.
  *        LS_FCAT-EDIT = 'X'.
          ls_fcat-just = 'R'.
  
        WHEN  'CO_CEN'.
  *        LS_FCAT-F4AVAILABL  = 'X'.
          ls_fcat-col_pos = 10.
          ls_fcat-coltext = '코스트센터'.
          ls_fcat-just = 'C'.
  
  
        WHEN  'VAT_CODE'.
          ls_fcat-f4availabl  = 'X'.
  *        LS_FCAT-EDIT = 'X'.
          ls_fcat-just = 'C'.
  
        WHEN  'BP_NUM'.
  *        LS_FCAT-EDIT = 'X'.
          ls_fcat-outputlen = 10.
          ls_fcat-just = 'C'.
  
        WHEN 'BRIEFS'.
          ls_fcat-coltext = '적요'.
          ls_fcat-col_pos = 11.
          ls_fcat-outputlen = 30.
  *        LS_FCAT-EDIT = 'X'.
          ls_fcat-just = 'L'.
  
        WHEN 'ERNAM'.
          ls_fcat-tech = 'X'.
  
        WHEN  'ERDAT'.
          ls_fcat-tech = 'X'.
  
        WHEN  'ERZET'.
          ls_fcat-tech = 'X'.
  
        WHEN  'AENAM'.
          ls_fcat-tech = 'X'.
  
        WHEN  'AEDAT'.
          ls_fcat-tech = 'X'.
  
        WHEN 'AEZET'.
          ls_fcat-tech = 'X'.
  
  *
      ENDCASE.
  
  
  
      MODIFY gt_fcatc FROM ls_fcat.
  
  
    ENDLOOP.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form SET_SORT_chit
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_sort_chit .
    DATA ls_sort TYPE lvc_s_sort.
  
    ls_sort-fieldname = 'LINE_NUM'.
    ls_sort-up = 'X'.
    ls_sort-spos = 1.
    APPEND ls_sort TO gt_sortc.
    CLEAR ls_sort.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form save_chit
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM save_chit .
  
    DATA : lt_chit_i TYPE TABLE OF ztc_fi_chit_i,
           ls_chit_i LIKE LINE OF lt_chit_i,
  
           ls_chit_h TYPE ztc_fi_chit_h.
  
  
    DATA : lv_docnum TYPE ztc_fi_chit_h-chit_doc_num.
    DATA : lv_answer(1) TYPE c.
  
  *
  *  IF gv_sum_debit <> gv_sum_credit  .
  *
  *    MESSAGE '분개가 맞지않습니다.' TYPE 'E'.
  *
  *  ELSEIF  gv_sum_debit = 0 AND gv_sum_credit  = 0 .
  *
  *    MESSAGE '금액이 입력되지 않았습니다.' TYPE 'E'.
  *
  *  ELSE.
  
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = 'Confirm'
  *     DIAGNOSE_OBJECT       = ' '
        text_question         = '전표 전기를 실행하시겠습니까?'
        text_button_1         = 'Yes'(001)
        text_button_2         = 'No'(002)
        default_button        = '1'
        display_cancel_button = 'X'
      IMPORTING
        answer                = lv_answer
      EXCEPTIONS
        text_not_found        = 1
        OTHERS                = 2.
    IF sy-subrc <> 0.
  * Implement suitable error handling here
    ENDIF.
  
    IF lv_answer = '1'.
  *
  
      CALL FUNCTION 'NUMBER_GET_NEXT'
        EXPORTING
          nr_range_nr             = '07'
          object                  = 'ZCBC_RANG'
  *       QUANTITY                = '1'
  *       SUBOBJECT               = ' '
  *       TOYEAR                  = sy-datum(4)
  *       IGNORE_BUFFER           = ' '
        IMPORTING
          number                  = lv_docnum
  *       QUANTITY                =
  *       RETURNCODE              =
        EXCEPTIONS
          interval_not_found      = 1
          number_range_not_intern = 2
          object_not_found        = 3
          quantity_is_0           = 4
          quantity_is_not_1       = 5
          interval_overflow       = 6
          buffer_overflow         = 7
          OTHERS                  = 8.
      IF sy-subrc <> 0.
        MESSAGE i075(zcbc_message) DISPLAY LIKE 'E'.
      ENDIF.
  
  
  
  
  **********************************************************************
  *                          헤더  DB 입력
  **********************************************************************
  
      gs_chith-chit_doc_num = lv_docnum.
  
      MOVE-CORRESPONDING gs_chith TO ls_chit_h.
  
  
      MODIFY ztc_fi_chit_h FROM ls_chit_h.
  ***********************************************************************
  **                       아이템 DB 입력
  ***********************************************************************
  
      LOOP AT gt_chit INTO gs_chit.
        MOVE-CORRESPONDING gs_chit TO ls_chit_i.
        ls_chit_i-chit_num = lv_docnum.
  
        MODIFY ztc_fi_chit_i FROM ls_chit_i.
      ENDLOOP.
  
  
  
      MESSAGE i076(zcbc_message) .
  
    ELSE.
    ENDIF.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form get_bac
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM  get_bac .
  
    DATA : lv_cost TYPE ztc_fi_chit_i-ebit_amt,
           gs_bac  TYPE ztc_sd_rtn_ord.
  
    SELECT SINGLE * FROM ztc_sd_rtn_ord
      INTO CORRESPONDING FIELDS OF gs_bac
      WHERE rtn_doc_num = gs_ar_condition-doc_num.                      "*
    lv_cost = ( gs_bac-msrp * gs_bac-real_qty ) .
  IF gs_ar_condition-currecy = 'USD'.
    lv_cost = lv_cost * 10000.
  ENDIF.
    SELECT SINGLE dept_id FROM ztc_md_emp INTO gs_chith-co_cen WHERE emp_id = gs_bac-ernam.
  
  *  매출 마이너스처리 및 매출외상금 마이너스
  
  
    gs_chit-line_num = 1.
    gs_chit-post_key = 'D'.    " 차변
    gs_chit-right_acc = '0040010101'.   " 제품 매출 수익
    gs_chit-ebit_curr = 'KRW'.
    gs_chit-ebit_amt = - lv_cost.
    gs_chit-co_cen = gs_chith-co_cen.
    IF gs_ar_condition-currecy = 'USD'.
    gs_chit-exchange = 1000.
  ENDIF.
  
  
    gs_chit-briefs = ' 반품 매출 반제' ." gs_bac-sku_id && ' 제품 ' && gs_bac-bp_id && ' 업체 반품 매출 반제' .
  
    APPEND gs_chit TO gt_chit .
    CLEAR gs_chit.
  
  
    gs_chit-line_num = 2.
    gs_chit-post_key = 'C'.    " 대변
    gs_chit-right_acc = '0010010105'.   " 외상매출금
    gs_chit-cred_curr = 'KRW'.
    gs_chit-cred_amt = - lv_cost.
    gs_chit-co_cen =  gs_chith-co_cen.
    IF gs_ar_condition-currecy = 'USD'.
  
    gs_chit-exchange = 1000.
  ENDIF.
  
    gs_chit-briefs = '반품 수익 반제'." gs_bac-sku_id && ' 제품 ' && gs_bac-bp_id && ' 업체 반품 수익 반체' .
  
  
    APPEND gs_chit TO gt_chit .
    CLEAR gs_chit.
  
  
  
  
  
  
  *     제품 재고 상승 및 매출원가 마이너스 처리
  
    gs_chit-line_num = 3.
  
    gs_chit-post_key = 'D'.    " 차변
    gs_chit-right_acc = '0010020105'.      " 제품
    gs_chit-ebit_curr = 'KRW'.
    gs_chit-co_cen =  gs_chith-co_cen .
  
    CALL FUNCTION 'ZFMC_CO_PROCOST'
      EXPORTING
        iv_skuid        = gs_bac-sku_id
        iv_batch        = gs_bac-batch
      IMPORTING
        ev_product_cost = gs_chit-ebit_amt.
  
    gs_chit-ebit_amt = - gs_chit-ebit_amt  * gs_bac-real_qty.
  
    gs_chit-briefs = '반품 제품 재고 인식'. "gs_bac-sku_id && ' 제품 ' && gs_bac-bp_id && ' ' .
  
  
    APPEND gs_chit TO gt_chit .
    CLEAR gs_chit.
  
  
    gs_chit-line_num = 4.
    gs_chit-post_key = 'C'.    " 대변
    gs_chit-right_acc = '0050010101'.   " 재료 원가
    gs_chit-cred_curr = 'KRW'.
  
    CALL FUNCTION 'ZFMC_CO_PROCOST'
      EXPORTING
        iv_skuid        = gs_bac-sku_id
        iv_batch        = gs_bac-batch
      IMPORTING
        ev_product_cost = gs_chit-cred_amt.
  
    gs_chit-cred_amt  = - gs_chit-cred_amt * gs_bac-real_qty .
    gs_chit-co_cen = gs_chith-co_cen.
    gs_chit-briefs = '반품 재고 매출 원가'."  gs_bac-sku_id && ' 제품 ' && gs_bac-bp_id && ' ' .
  
  
    APPEND gs_chit TO gt_chit .
  
  
  
    LOOP AT  gt_chit INTO gs_chit.
  
      gs_chit-chit_num = gs_chith-chit_doc_num.
      gs_chit-bp_id = gv_comp .
      gs_chit-bp_for = gs_bac-bp_id.
      gs_chit-ernam = gs_bac-ernam.
      gs_chit-erdat = gs_bac-erdat.
      gs_chit-erzet = gs_bac-erzet.
      gs_chit-fi_year = gs_bac-erdat(4).
  
      MODIFY gt_chit FROM gs_chit.
    ENDLOOP.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form get_del
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM get_del .
  
  *  DATA : lv_cost TYPE i.
  *  DATA : gv_out_doc   TYPE ztc_wm_out_h-out_doc_num,
  *         lv_proco_tmp TYPE zsc_pro_cost-pp_price,
  *         lv_proco     TYPE zsc_pro_cost-pp_price.
  *
  *
  *
  *  SELECT SINGLE * FROM ztc_wm_out_h
  *    INTO CORRESPONDING FIELDS OF gs_del_h
  *    WHERE out_doc_num  = gs_ar_condition-doc_num.
  *  "*
  *  SELECT  * FROM ztc_wm_out_i
  *    INTO   CORRESPONDING FIELDS OF gs_del_i
  *    WHERE out_doc_num = gs_ar_condition-doc_num.
  *
  *
  *
  *    CALL FUNCTION 'ZFMC_CO_PROCOST'
  *      EXPORTING
  *        iv_skuid        = gs_del_i-sku_id
  *        iv_batch        = gs_del_i-batch
  *      IMPORTING
  *        ev_product_cost = lv_proco_tmp.
  *
  *    lv_proco = lv_proco + ( lv_proco_tmp * gs_del_i-out_qty ).
  *
  *
  *
  *
  *  ENDSELECT.
  *
  *
  *
  *  SELECT SINGLE dept_id FROM ztc_md_emp INTO gs_chith-co_cen WHERE emp_id = gs_del_h-ernam.
  *
  **  매출 및 매출외상금 처리
  *
  *
  *  gs_chit-line_num = 1.
  *  gs_chit-post_key = 'D'.    " 차변
  *  gs_chit-right_acc = '0040010101'.   " 제품 매출 수익
  *  gs_chit-ebit_curr = 'KRW'.
  *  gs_chit-ebit_amt =  gs_ar_condition-price.
  *  gs_chit-co_cen = gs_chith-co_cen.
  *
  *
  *  gs_chit-briefs = ' 업체 매출 수익' ." gs_del_i-sku_id && ' 제품 ' && gs_sdord-bp_id && ' 업체 매출 수익' .
  *
  *  APPEND gs_chit TO gt_chit .
  *  CLEAR gs_chit.
  *
  *
  *  gs_chit-line_num = 2.
  *  gs_chit-post_key = 'C'.    " 대변
  *  gs_chit-right_acc = '0010010105'.   " 외상매출금
  *
  *  gs_chit-cred_curr = 'KRW'.
  *  gs_chit-cred_amt =  gs_ar_condition-price.
  *
  *  gs_chit-co_cen =  gs_chith-co_cen.
  *
  *
  *  gs_chit-briefs = ' 업체 외상 매출금'. " gs_del_i-sku_id && ' 제품 ' && gs_sdord-bp_id && ' 업체 외상 매출금' .
  *
  *
  *  APPEND gs_chit TO gt_chit .
  *  CLEAR gs_chit.
  *
  *
  **     제품 재고 및 매출원가 처리
  *
  *  gs_chit-line_num = 3.
  *
  *  gs_chit-post_key = 'D'.    " 차변
  *  gs_chit-right_acc = '0010020105'.      " 제품
  *  gs_chit-co_cen =  gs_chith-co_cen .
  *
  *  gs_chit-ebit_curr = 'KRW'.
  *  gs_chit-ebit_amt = lv_proco .
  *
  *  gs_chit-briefs = '제품 출고' . "  gs_del_i-sku_id && ' 제품 ' && gs_sdord-bp_id &&  ' 출고 ' .
  *
  *
  *  APPEND gs_chit TO gt_chit .
  *  CLEAR gs_chit.
  *
  *
  *  gs_chit-line_num = 4.
  *  gs_chit-post_key = 'C'.    " 대변
  *  gs_chit-right_acc = '0050010101'.   " 재료 원가
  *  gs_chit-cred_curr = 'KRW'.
  *
  *
  *  gs_chit-cred_amt  =  lv_proco .
  *  gs_chit-co_cen = gs_chith-co_cen.
  *  gs_chit-briefs = ' 제품 원가 ' ." gs_del_i-sku_id && ' 제품 ' && gs_sdord-bp_id &&  ' 제품 원가 ' .
  *
  *
  *  APPEND gs_chit TO gt_chit .
  *  CLEAR gs_chit.
  *
  *  gs_chit-line_num = 5.
  *
  *  gs_chit-post_key = 'D'.    " 차변
  *  gs_chit-right_acc = '0050020310'.      "
  *  gs_chit-co_cen =  gs_chith-co_cen .
  *
  *  gs_chit-ebit_curr = 'KRW'.
  *  gs_chit-ebit_amt =  gs_del_h-out_paysum.
  *
  *  gs_chit-briefs = '배송비' . " 운반비
  *
  *
  *  APPEND gs_chit TO gt_chit .
  *  CLEAR gs_chit.
  *
  *
  *  gs_chit-line_num = 6.
  *  gs_chit-post_key = 'C'.    " 대변
  *  gs_chit-right_acc = '0020010103'.   " 미지급금
  *  gs_chit-cred_curr = 'KRW'.
  *
  *
  *  gs_chit-cred_amt  =  gs_del_h-out_paysum .
  *  gs_chit-co_cen = gs_chith-co_cen.
  *  gs_chit-briefs = ' 배송비 지급금 ' ." gs_del_i-sku_id && ' 제품 ' && gs_sdord-bp_id &&  ' 제품 원가 ' .
  *
  *
  *  APPEND gs_chit TO gt_chit .
  *  CLEAR gs_chit.
  *
  *
  *  LOOP AT  gt_chit INTO gs_chit.
  *
  *    gs_chit-chit_num = gs_chith-chit_doc_num.
  *    gs_chit-bp_id = gv_comp .
  *    gs_chit-bp_for = gs_ar_condition-bp_id.
  *    gs_chit-ernam = gs_del_h-ernam.
  *    gs_chit-erdat = gs_del_h-erdat.
  *    gs_chit-erzet = gs_del_h-erzet.
  *    gs_chit-fi_year = gs_del_h-erdat(4).
  *
  *    MODIFY gt_chit FROM gs_chit.
  *  ENDLOOP.
  
    DATA : lv_cost TYPE i.
    DATA : gv_out_doc   TYPE ztc_wm_out_h-out_doc_num,
           lv_proco_tmp TYPE zsc_pro_cost-pp_price,
           lv_proco     TYPE zsc_pro_cost-pp_price.
  
  
  
    SELECT SINGLE * FROM ztc_wm_out_h
      INTO CORRESPONDING FIELDS OF gs_del_h
      WHERE out_doc_num  = gs_ar_condition-doc_num.
    "*
    SELECT  * FROM ztc_wm_out_i
      INTO   CORRESPONDING FIELDS OF gs_del_i
      WHERE out_doc_num = gs_ar_condition-doc_num.
  
  
  
      CALL FUNCTION 'ZFMC_CO_PROCOST'
        EXPORTING
          iv_skuid        = gs_del_i-sku_id
          iv_batch        = gs_del_i-batch
        IMPORTING
          ev_product_cost = lv_proco_tmp.
  
      lv_proco = lv_proco + ( lv_proco_tmp * gs_del_i-out_qty ).
  
  
  
  
    ENDSELECT.
    IF gs_ar_condition-currecy = 'USD'.
  
   gs_ar_condition-price = gs_ar_condition-price * 10000.
  ENDIF.
  
  
  *  매출 및 매출외상금 처리
  
  
    gs_chit-line_num = 1.
    gs_chit-post_key = 'D'.    " 차변
    gs_chit-right_acc = '0040010101'.   " 제품 매출 수익
    gs_chit-ebit_curr = 'KRW'.
    gs_chit-ebit_amt =  gs_ar_condition-price.
    gs_chit-co_cen = gs_chith-co_cen.
  
    IF gs_ar_condition-currecy = 'USD'.
  
    gs_chit-exchange = 1000.
  ENDIF.
    gs_chit-briefs = gs_del_i-sku_id && ' 제품 ' && gs_ar_condition-bp_id && ' 업체 매출 수익' .
  
    APPEND gs_chit TO gt_chit .
    CLEAR gs_chit.
  
  
    gs_chit-line_num = 2.
    gs_chit-post_key = 'C'.    " 대변
    gs_chit-right_acc = '0010010105'.   " 외상매출금
  
    gs_chit-cred_curr = 'KRW'.
    gs_chit-cred_amt =   gs_ar_condition-price.
  
    gs_chit-co_cen = gs_chith-co_cen.
  
    IF gs_ar_condition-currecy = 'USD'.
  
    gs_chit-exchange = 1000.
  ENDIF.
    gs_chit-briefs = gs_del_i-sku_id && ' 제품 ' && gs_ar_condition-bp_id && ' 업체 외상 매출금' .
  
  
    APPEND gs_chit TO gt_chit .
    CLEAR gs_chit.
  
  
  
  
  
  
  *     제품 재고 및 매출원가 처리
  
    gs_chit-line_num = 3.
  
    gs_chit-post_key = 'D'.    " 차변
    gs_chit-right_acc = '0010020105'.      " 제품
    gs_chit-co_cen =  gs_chith-co_cen.
  
    gs_chit-ebit_curr = 'KRW'.
    gs_chit-ebit_amt = lv_proco .
  
    gs_chit-briefs = gs_del_i-sku_id && ' 제품 ' && gs_ar_condition-bp_id &&  ' 출고 ' .
  
  
    APPEND gs_chit TO gt_chit .
    CLEAR gs_chit.
  
  
    gs_chit-line_num = 4.
    gs_chit-post_key = 'C'.    " 대변
    gs_chit-right_acc = '0050010101'.   " 재료 원가
    gs_chit-cred_curr = 'KRW'.
  
  
    gs_chit-cred_amt  =  lv_proco .
    gs_chit-co_cen = gs_chith-co_cen.
    gs_chit-briefs = gs_del_i-sku_id && ' 제품 ' && gs_ar_condition-bp_id &&  ' 제품 원가 ' .
  
  
    APPEND gs_chit TO gt_chit .
  
  
  
    LOOP AT  gt_chit INTO gs_chit.
  
      gs_chit-chit_num = gs_chith-chit_doc_num.
      gs_chit-bp_id = '1010000000' .
      gs_chit-bp_for = gs_ar_condition-bp_id.
      gs_chit-ernam = gs_del_h-ernam.
      gs_chit-erdat = gs_del_h-erdat.
      gs_chit-erzet = gs_del_h-erzet.
      gs_chit-fi_year = gs_del_h-erdat(4).
  
      MODIFY gt_chit FROM gs_chit.
  
    ENDLOOP.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form get_sum
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM get_sum .
    CLEAR : gv_sum_credit ,gv_sum_debit.
  
    LOOP AT gt_chit INTO gs_chit.
      ADD gs_chit-cred_amt TO gv_sum_credit.
      ADD gs_chit-ebit_amt TO gv_sum_debit.
  
    ENDLOOP.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form get_rmm
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM get_rmm .
  
    DATA : lv_cost TYPE zsc_pro_cost-pp_price.
    DATA : gv_out_doc   TYPE ztc_wm_out_h-out_doc_num,
           lv_proco     TYPE zsc_pro_cost-pp_price,
           ls_msrp     LIKE LINE OF lt_msrp.
  
  
  
    SELECT SINGLE * FROM ztc_wm_out_h
      INTO CORRESPONDING FIELDS OF gs_del_h
      WHERE out_doc_num  = gs_ar_condition-doc_num.
    "*
    SELECT  * FROM ztc_wm_out_i
      INTO   CORRESPONDING FIELDS OF gs_del_i
      WHERE out_doc_num = gs_ar_condition-doc_num.
  
  
  LOOP AT lt_msrp INTO ls_msrp.
  
      lv_cost = lv_cost + ( ls_msrp-price * ls_msrp-qty ).
  ENDLOOP.
  
  
  
  
  
    ENDSELECT.
    IF gs_ar_condition-currecy = 'USD'.
  
   gs_ar_condition-price = gs_ar_condition-price * 10000.
  ENDIF.
  
  *  매출 및 매출외상금 처리
  
  
    gs_chit-line_num = 1.
    gs_chit-post_key = 'D'.    " 차변
    gs_chit-right_acc = '0040010101'.   " 제품 매출 수익
    gs_chit-ebit_curr = 'KRW'.
    gs_chit-ebit_amt =  lv_cost.
    gs_chit-co_cen = gs_ar_condition-bp_id.
  
  
    gs_chit-briefs = gs_del_i-sku_id && ' 제품 ' && gs_ar_condition-bp_id && ' 리사이클 매출 수익' .
  
    APPEND gs_chit TO gt_chit .
    CLEAR gs_chit.
  
  
    gs_chit-line_num = 2.
    gs_chit-post_key = 'C'.    " 대변
    gs_chit-right_acc = '0010010105'.   " 외상매출금
  
    gs_chit-cred_curr = 'KRW'.
    gs_chit-cred_amt =  lv_cost.
  
    gs_chit-co_cen =  gs_ar_condition-bp_id.
  
  
    gs_chit-briefs = gs_del_i-sku_id && ' 제품 ' && gs_ar_condition-bp_id && ' 리사이클 외상 매출금' .
  
  
    APPEND gs_chit TO gt_chit .
    CLEAR gs_chit.
  
  
  
  
    LOOP AT  gt_chit INTO gs_chit.
  
      gs_chit-chit_num = gs_chith-chit_doc_num.
      gs_chit-bp_id = gv_comp .
      gs_chit-bp_for = gs_ar_condition-bp_id.
      gs_chit-ernam = gs_del_h-ernam.
      gs_chit-erdat = gs_del_h-erdat.
      gs_chit-erzet = gs_del_h-erzet.
      gs_chit-fi_year = gs_del_h-erdat(4).
  
      MODIFY gt_chit from gs_chit.
  
    ENDLOOP.
  ENDFORM.