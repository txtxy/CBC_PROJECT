*&---------------------------------------------------------------------*
*& Include          ZCBC_FI_CHITF01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form read_chit
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM read_chit .

    SELECT * FROM ztc_fi_chit_i
     INTO CORRESPONDING FIELDS OF TABLE gt_chit_i.
  
  
    IF sy-subrc <> 0.
      MESSAGE TEXT-nod TYPE 'I'.
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_layo
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_layo .
  
  *  gs_layo-col_opt = 'X'.
    gs_layo-grid_title = '전표 라인'.
    gs_layo-sel_mode = 'A'.
    gs_layo-stylefname = 'CELLTAB'.
    gs_layo-zebra     = 'X'.
  *  gs_layo-ctab_fname = 'CELLCOL'.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_fcat
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_fcat .
    DATA : ls_fcat LIKE LINE OF gt_fcat,
           gt_f4   TYPE lvc_t_f4,
           gs_f4   TYPE lvc_s_f4.
  
  
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = 'ZTC_FI_CHIT_I'     " 해당 글로벌 스트럭쳐 타입의 필드카탈로그 형식을
      CHANGING
        ct_fieldcat            = gt_fcat     " 현재 ALV-GRID의 필드 카탈로그 형식으로 전달.
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.
  
    IF sy-subrc <> 0.
  *    * Implement suitable error handling here
    ENDIF.
  
    LOOP AT gt_fcat INTO ls_fcat.                           " 기타 설정이 필요한 사항은 반복문을 통해 설정
  
      CASE ls_fcat-fieldname.
        WHEN 'CHIT_NUM'.
          ls_fcat-tech = 'X'.
  
        WHEN 'BP_ID'.
  *        ls_fcat-f4availabl  = 'X'.
          ls_fcat-outputlen = 10.
          ls_fcat-coltext = '사업장'.
          ls_fcat-tech = 'X'.
  
          ls_fcat-col_pos = 3.
          ls_fcat-edit = 'X'.
          ls_fcat-just = 'C'.
  
  *      WHEN 'CANCELLED'.
  *        ls_fcat-icon = 'X'.
  *        ls_fcat-coltext = 'Cancelled'.
  
  
        WHEN 'LINE_NUM'.
          ls_fcat-col_pos = 1.
          ls_fcat-coltext = 'No.'.
          ls_fcat-outputlen = 3.
  
        WHEN 'FI_YEAR'.
          ls_fcat-col_pos = 2.
          ls_fcat-coltext = '회계연도'.
          ls_fcat-outputlen = 5.
          ls_fcat-just = 'C'.
  
        WHEN 'BP_FOR'.
          ls_fcat-edit = 'X'.
          ls_fcat-outputlen = 10.
          ls_fcat-coltext = '거래처'.
          ls_fcat-just = 'C'.
          ls_fcat-edit = 'X'.
  
        WHEN 'POST_KEY'.
          ls_fcat-edit = 'X'.
          ls_fcat-coltext = '전기키'.
          ls_fcat-outputlen = 5.
  
        WHEN 'RIGHT_ACC'.
          ls_fcat-edit = 'X'.
  
        WHEN 'EBIT_AMT'.
          ls_fcat-edit = 'X'.
          ls_fcat-cfieldname = 'EBIT_CURR'.
          ls_fcat-just = 'R'.
  
  
        WHEN 'CRED_AMT'.
          ls_fcat-cfieldname = 'CRED_CURR'.
          ls_fcat-just = 'R'.
          ls_fcat-edit = 'X'.
  
        WHEN 'EBIT_CURR'.
          ls_fcat-edit = 'X'.
          ls_fcat-coltext = '통화'.
          ls_fcat-just = 'C'.
  
        WHEN 'CRED_CURR'.
          ls_fcat-edit = 'X'.
          ls_fcat-coltext = '통화'.
          ls_fcat-just = 'C'.
  
        WHEN 'EXCHANGE'.
          ls_fcat-coltext = '기준환율'.
          ls_fcat-edit = 'X'.
          ls_fcat-just = 'R'.
  
        WHEN 'CO_CEN'.
          ls_fcat-f4availabl  = 'X'.
          ls_fcat-coltext = '코스트센터'.
          ls_fcat-just = 'C'.
  
        WHEN 'VAT_CODE'.
          ls_fcat-f4availabl  = 'X'.
          ls_fcat-edit = 'X'.
          ls_fcat-just = 'C'.
  
        WHEN 'BP_NUM'.
          ls_fcat-edit = 'X'.
          ls_fcat-outputlen = 10.
          ls_fcat-just = 'C'.
  
        WHEN 'BRIEFS'.
          ls_fcat-col_pos = 13.
          ls_fcat-outputlen = 50.
          ls_fcat-edit = 'X'.
          ls_fcat-just = 'L'.
  
        WHEN 'ERNAM'.
          ls_fcat-tech = 'X'.
  
        WHEN 'ERDAT'.
          ls_fcat-tech = 'X'.
        WHEN 'ERZET'.
          ls_fcat-tech = 'X'.
        WHEN 'AENAM'.
          ls_fcat-tech = 'X'.
        WHEN 'AEDAT'.
          ls_fcat-tech = 'X'.
        WHEN 'AEZET'.
          ls_fcat-tech = 'X'.
  
  
      ENDCASE.
  
  
  
  
  
  
  
      MODIFY gt_fcat FROM ls_fcat.
  
    ENDLOOP.
  
  *  * 서치헬프를 적용할 필드를 지정해준다.
    gs_f4-fieldname = 'BP_ID'.
    gs_f4-register = 'X'.
  
    INSERT gs_f4 INTO TABLE gt_f4.
  
  
  
    CALL METHOD go_itemalv->register_f4_for_fields
      EXPORTING
        it_f4 = gt_f4.
  
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form SAVE_HEADER
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM save_header .
  
  
    MOVE-CORRESPONDING ztc_fi_chit_h TO gs_chit_h .
  
  
    gs_chit_h-erdat = sy-datum.
    gs_chit_h-erzet = sy-timlo.
    gs_chit_h-fi_year = sy-datum(4).
  
    PERFORM set_editable USING:
          `LEFT_ACC`   cl_gui_alv_grid=>mc_style_disabled,
          `POST_KEY`    cl_gui_alv_grid=>mc_style_disabled,
          `RIGHT_ACC`   cl_gui_alv_grid=>mc_style_disabled,
          `EBIT_AMT`    cl_gui_alv_grid=>mc_style_disabled,
          `EBIT_CURR`   cl_gui_alv_grid=>mc_style_disabled,
          `CRED_AMT`    cl_gui_alv_grid=>mc_style_disabled,
          `CRED_CURR`    cl_gui_alv_grid=>mc_style_disabled,
          `EXCHANGE`     cl_gui_alv_grid=>mc_style_disabled,
          `CO_CEN`   cl_gui_alv_grid=>mc_style_disabled,
          `VAT_CODE`  cl_gui_alv_grid=>mc_style_disabled,
          `BP_NUM`    cl_gui_alv_grid=>mc_style_disabled,
          `BRIEFS`    cl_gui_alv_grid=>mc_style_disabled.
  
    ztc_fi_chit_i-post_key = 'C'.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form INSERT_ROW
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM insert_row .
    DATA : lv_value    TYPE char10,
           lv_bpname   LIKE gv_leftacc,
           lv_exchange LIKE ztc_fi_chit_i-exchange.
  
    CALL METHOD go_itemalv->set_ready_for_input
      EXPORTING
        i_ready_for_input = 0.
    CLEAR : gt_celltab.
  *  **********************************************************************
  * 에디터 잠금 해제 로직
  *  PERFORM set_editable USING :
  *        `LEFT_ACC`  cl_gui_alv_grid=>mc_style_enabled,
  *        `POST_KEY`     cl_gui_alv_grid=>mc_style_enabled,
  *        `RIGHT_ACC`   cl_gui_alv_grid=>mc_style_enabled,
  *        `EBIT_AMT`   cl_gui_alv_grid=>mc_style_enabled,
  *        `EBIT_CURR`     cl_gui_alv_grid=>mc_style_enabled,
  *        `CRED_AMT`  cl_gui_alv_grid=>mc_style_enabled,
  *        `CRED_CURR`        cl_gui_alv_grid=>mc_style_enabled,
  *        `EXCHANGE`     cl_gui_alv_grid=>mc_style_enabled,
  *        `CO_CEN`   cl_gui_alv_grid=>mc_style_enabled,
  *        `VAT_CODE`   cl_gui_alv_grid=>mc_style_enabled,
  *        `BP_NUM`   cl_gui_alv_grid=>mc_style_enabled,
  *        `BRIEFS`   cl_gui_alv_grid=>mc_style_enabled.
  *
  *  gs_chit_i-celltab = gt_celltab.
  *
  *  APPEND gs_chit_i TO gt_chit_i .
  **********************************************************************
  
    PERFORM check_chit_item.
  
  
  
    MOVE-CORRESPONDING ztc_fi_chit_i TO gs_chit_i.
    MOVE-CORRESPONDING gs_chit_h TO gs_chit_i .
  
    PERFORM define_cd_curr.
    APPEND gs_chit_i TO gt_chit_i.
  
  
  
    PERFORM sum_price.
    PERFORM get_rownum.
  
  **********************************************************************
    MOVE ztc_fi_chit_i-bp_for TO lv_value.
    MOVE gv_leftacc TO lv_bpname.
    MOVE ztc_fi_chit_i-exchange TO lv_exchange.
    CLEAR : ztc_fi_chit_i, gs_chit_i, gv_leftacc, gv_rightacc, gv_price.
    MOVE lv_exchange TO ztc_fi_chit_i-exchange.
  
    MOVE lv_value TO ztc_fi_chit_i-bp_for .
    MOVE lv_bpname TO gv_leftacc.
  
  
    LOOP AT SCREEN.
      IF screen-group1 = 'CUR'.
        screen-active = 0.
      ENDIF.
    ENDLOOP.
    PERFORM refresh.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form CHANGE_DATA
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM change_data .
  
    DATA: lv_cnt TYPE i.
  
    lv_cnt = go_itemalv->is_ready_for_input( ).   " 프로그램이 처음 시작될때 값은 0으로 설정해둠
  
  *  CASE lv_cnt.
  *    WHEN 0."Display mode
    CALL METHOD go_itemalv->set_ready_for_input
      EXPORTING
        i_ready_for_input = 1.
  
  *    WHEN 1.   "Change mode
  *      CALL METHOD go_itemalv->set_ready_for_input
  *        EXPORTING
  *          i_ready_for_input = 0.    " Change mode -> Display mode 변경하고
  
  *  ENDCASE.
    PERFORM get_rownum.
    PERFORM refresh.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form DEL_DATA
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM del_data .
    DATA : lt_row   TYPE lvc_t_row,
           ls_row   TYPE lvc_s_row,
           lv_lines TYPE i.
  
    CALL METHOD go_itemalv->get_selected_rows
      IMPORTING
        et_index_rows = lt_row.
  
    DESCRIBE TABLE lt_row LINES lv_lines.
  
    IF lt_row IS INITIAL.
  
      MESSAGE TEXT-nos TYPE 'I'.
  
    ELSEIF lv_lines > 1.
      MESSAGE TEXT-lot TYPE 'I'.
  
    ELSE.
      LOOP AT lt_row INTO ls_row.
  
        READ TABLE gt_chit_i INTO gs_chit_i  INDEX ls_row-index.
        DELETE TABLE gt_chit_i FROM gs_chit_i .
  
      ENDLOOP.
  
    ENDIF.
  
    PERFORM get_rownum.
    PERFORM refresh.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form SAVE_dATA
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM save_data .
  
    "Display mode
    CALL METHOD go_itemalv->set_ready_for_input
      EXPORTING
        i_ready_for_input = 0.
  
    PERFORM sum_price.
    PERFORM get_rownum.
  
  **********************************************************************
    CLEAR : ztc_fi_chit_i, gs_chit_i, gv_leftacc, gv_rightacc, gv_price.
    PERFORM refresh.
  
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
  *& Form set_editable
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> P_
  *&      --> CL_GUI_ALV_GRID=>MC_STYLE_ENAB
  *&---------------------------------------------------------------------*
  FORM set_editable  USING    pv_fieldname TYPE string
                              pv_mode TYPE raw4.
  
    DATA: ls_style TYPE lvc_s_styl.
  
    ls_style-fieldname = pv_fieldname.
    ls_style-style = pv_mode.
  
  *  APPEND ls_style TO gt_style.       " gt_style이 sorted table이기 때문에 append 구문을 쓰면 append로
    MODIFY TABLE gt_celltab FROM ls_style .  " 맨 마지막에 넣으려는 구문과 key 필드로 정렬하는 게 충돌이 되어 dump 발생함
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form refresh
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM refresh .
  
    CALL METHOD go_itemalv->refresh_table_display
      EXCEPTIONS
        finished = 1
        OTHERS   = 2.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form modi_chit
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM modi_chit .
  
    DATA : lt_chit_i TYPE TABLE OF ztc_fi_chit_i,
           ls_chit_i LIKE LINE OF lt_chit_i,
  
           ls_chit_h TYPE ztc_fi_chit_h.
  
  
    DATA : lv_docnum LIKE gs_chit_i-chit_num.
    DATA : lv_answer(1) TYPE c.
  
  
    IF gv_sum_debit <> gv_sum_credit  .
  
  *    MESSAGE '분개가 맞지않습니다.' TYPE 'E'.
      MESSAGE e081(zcbc_message) .
    ELSEIF  gv_sum_debit = 0 AND gv_sum_credit  = 0 .
  
  *    MESSAGE '금액이 입력되지 않았습니다.' TYPE 'E'.
      MESSAGE e082(zcbc_message) .
  
    ELSE.
  
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          titlebar              = 'Confirm'
  *       DIAGNOSE_OBJECT       = ' '
          text_question         = '전표 전기를 실행하시겠습니까?'
          text_button_1         = '예'(001)
  *       icon_button_1         = 'ICON_CHECKED'
          text_button_2         = '아니오'(002)
  *       icon_button_2         = 'ICON_INCOMPLETE'
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
  
  
        CALL FUNCTION 'NUMBER_GET_NEXT'
          EXPORTING
            nr_range_nr             = '07'
            object                  = 'ZCBC_RANG'
  *         QUANTITY                = '1'
  *         SUBOBJECT               = ' '
  *         TOYEAR                  = sy-datum(4)
  *         IGNORE_BUFFER           = ' '
          IMPORTING
            number                  = lv_docnum
  *         QUANTITY                =
  *         RETURNCODE              =
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
  *        MESSAGE '문서번호 생성에 실패하였습니다.' TYPE 'E'.
          MESSAGE e075(zcbc_message) .
        ENDIF.
  
  
  
  
  **********************************************************************
  *                          헤더  DB 입력
  **********************************************************************
  
        gs_chit_h-chit_doc_num = lv_docnum.
  
        MOVE-CORRESPONDING gs_chit_h TO ls_chit_h.
  
  
        MODIFY ztc_fi_chit_h FROM gs_chit_h.
  **********************************************************************
  *                       아이템 DB 입력
  **********************************************************************
        LOOP AT gt_chit_i INTO gs_chit_i.
          gs_chit_i-chit_num = gs_chit_h-chit_doc_num .
          IF gs_chit_i-cred_amt IS NOT INITIAL.
            gs_chit_i-cred_amt = gs_chit_i-cred_amt .
          ELSE.
            gs_chit_i-ebit_amt = gs_chit_i-ebit_amt .
  
          ENDIF.
          MOVE-CORRESPONDING gs_chit_i TO ls_chit_i.
          APPEND ls_chit_i TO lt_chit_i.
        ENDLOOP.
  
  
        MODIFY ztc_fi_chit_i FROM TABLE lt_chit_i.
  
  *      CALL FUNCTION 'ZFM_ORDER_REGI'
  *        EXPORTING
  *          iv_doc_num   = ls_chit_h-chit_doc_num
  *          iv_doc_tp_id = 'ZSAF'.
  *
  
  
        CLEAR : gv_sum_credit, gv_sum_debit, gt_chit_i,gs_chit_i, ztc_fi_chit_h,gs_chit_h.
  
  
  
  *      MESSAGE '전표 전기에 성공하였습니다.' TYPE 'I'.
        MESSAGE i076(zcbc_message) .
        LEAVE TO SCREEN 0.
      ELSE.
  
  
      ENDIF.
    ENDIF.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form get_rownum
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM get_rownum .
    CLEAR : gv_line.
    LOOP AT gt_chit_i INTO gs_chit_i.
  
  
      gv_line = sy-tabix.
      gs_chit_i-line_num = gv_line.
      MODIFY gt_chit_i FROM gs_chit_i TRANSPORTING line_num.
    ENDLOOP.
  
  ENDFORM.
  *** INCLUDE SAPMZCBC_FI_CHITF01
  *** INCLUDE SAPMZCBC_FI_CHITF01
  *&---------------------------------------------------------------------*
  *& Form define_cd
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM define_cd_curr .
  
  
  
    PERFORM exchange.
  
  
    CASE ztc_fi_chit_i-post_key.
  
      WHEN 'C'.
        MOVE gv_price TO gs_chit_i-cred_amt .
  
      WHEN 'D'.
        MOVE gv_price TO gs_chit_i-ebit_amt.
  
      WHEN OTHERS.
    ENDCASE.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form sum_price
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM sum_price .
    DATA : ls_item LIKE gs_chit_i.
    CLEAR : gv_sum_credit, gv_sum_debit.
    IF gv_curr = 'KRW'.
      gs_chit_i-cred_curr = 'KRW'.
      gs_chit_i-ebit_curr = 'KRW'.
    ELSEIF gv_curr = 'USD'.
      gs_chit_i-cred_curr = 'KRW'.
      gs_chit_i-ebit_curr = 'KRW'.
  
    ENDIF.
  
    LOOP AT gt_chit_i INTO ls_item.
  
      ADD ls_item-cred_amt TO gv_sum_credit.
      ADD ls_item-ebit_amt TO gv_sum_debit.
  
    ENDLOOP.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form SET_SORT
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_sort .
    DATA ls_sort TYPE lvc_s_sort.
  
    ls_sort-fieldname = 'LINE_NUM'.
    ls_sort-up = 'X'.
    ls_sort-spos = 1.
    APPEND ls_sort TO gt_sort.
    CLEAR ls_sort.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form Check_chit_item
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM check_chit_item .
  
    IF ztc_fi_chit_i-right_acc IS INITIAL .
  
  *    MESSAGE '계정과목을 입력해주세요' TYPE 'E'.
      MESSAGE e083(zcbc_message) .
  
      BREAK abap_true .
  
    ELSEIF gv_price IS NOT INITIAL AND ztc_fi_chit_i-post_key IS INITIAL .
      MESSAGE e084(zcbc_message) .
      BREAK abap_true .
  
    ELSEIF gv_price IS INITIAL AND ztc_fi_chit_i-post_key IS NOT INITIAL .
      MESSAGE e082(zcbc_message) .
      BREAK abap_true .
    ELSEIF gv_curr <> 'KRW' AND ztc_fi_chit_i-exchange IS INITIAL.
      MESSAGE e085(zcbc_message) .
      BREAK abap_true .
  
    ENDIF.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form check_item
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM check_item .
    DATA : lv_bp LIKE gs_chit_i-bp_for.
    LOOP AT gt_chit_i INTO gs_chit_i.
      IF lv_bp IS INITIAL.
  
        gs_chit_i-bp_for = lv_bp .
  
      ELSEIF lv_bp <> gs_chit_i-bp_for.
  
        ROLLBACK WORK.
  
        MESSAGE e086(zcbc_message) .
      ELSE.
      ENDIF.
  
    ENDLOOP.
  
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form exchange
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM exchange .
    IF gv_curr <> 'KRW'.
  
      gs_chit_i-cred_curr = 'KRW'.
      gs_chit_i-ebit_curr = 'KRW'.
      gv_price = gv_price * ztc_fi_chit_i-exchange.
  
  
    ELSE.
      MOVE gv_curr TO gs_chit_i-cred_curr .
      MOVE gv_curr TO gs_chit_i-ebit_curr .
    ENDIF.
  
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_layo_o
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_layo_o .
  
    gs_layo-grid_title = '원천 문서 목록'.
  *  gs_layo-sel_mode = 'A'.
  *  gs_layo-stylefname = 'CELLTAB'.
    gs_layo-zebra     = 'X'.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_fcato
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_fcato .
    DATA : ls_fcat LIKE LINE OF gt_fcat,
           gt_f4   TYPE lvc_t_f4,
           gs_f4   TYPE lvc_s_f4.
  
  
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = 'ZTC_MD_ORD_LIST'     " 해당 글로벌 스트럭쳐 타입의 필드카탈로그 형식을
      CHANGING
        ct_fieldcat            = gt_fcato    " 현재 ALV-GRID의 필드 카탈로그 형식으로 전달.
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.
  
    IF sy-subrc <> 0.
  *    * Implement suitable error ha
    ENDIF.
    LOOP AT gt_fcato INTO ls_fcat.
  
      CASE ls_fcat-fieldname.
        WHEN 'DEL_FLAG'.
          ls_fcat-tech = 'X'.
  
        WHEN 'ORD_DOC_NUM'.
          ls_fcat-hotspot = 'X'.
  
      ENDCASE.
  
  
      MODIFY gt_fcato FROM ls_fcat.
  
    ENDLOOP.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_sorto
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_sorto .
    DATA ls_sort TYPE lvc_s_sort.
  
    ls_sort-fieldname = 'ORD_DOC_NUM'.
    ls_sort-up = 'X'.
    ls_sort-spos = 1.
    APPEND ls_sort TO gt_sorto.
    CLEAR ls_sort.
  
  ENDFORM.