*&---------------------------------------------------------------------*
*& Include ZCBC_FI_CHITTOP                          - Module Pool      ZCBC_FI_CHIT
*&---------------------------------------------------------------------*

program zcbc_fi_chit.

TABLES : ztc_fi_chit_h ,ztc_fi_chit_i.

**********************************************************************
* 컨테이너 선언
**********************************************************************

DATA :
  go_itemcon TYPE REF TO cl_gui_custom_container,
  go_itemalv TYPE REF TO cl_gui_alv_grid,
  go_listcon TYPE REF TO cl_gui_custom_container,
  go_listalv TYPE REF TO cl_gui_alv_grid.



**********************************************************************
* 기본 변수 선언
**********************************************************************

DATA : ok_code    TYPE sy-ucomm,
       gs_layo    TYPE lvc_s_layo,
       gs_layo_o    TYPE lvc_s_layo,
       gt_fcat    TYPE lvc_t_fcat,
       gt_fcato    TYPE lvc_t_fcat,
       GT_SORT    TYPE LVC_T_SORT,
       GT_SORTo    TYPE LVC_T_SORT,
       gt_exclude TYPE ui_functions,
       gt_celltab TYPE lvc_t_styl.


DATA: gv_row    TYPE i,
      gv_MOD    TYPE c,
      gv_col    TYPE i,
      gs_row_id TYPE lvc_s_row,
      gs_col_id TYPE lvc_s_col,
      gs_row_no TYPE lvc_s_roid.



**********************************************************************
* 테이블 변수 선언
**********************************************************************

DATA : BEGIN OF gs_chit_i .
         INCLUDE STRUCTURE ztc_fi_chit_i.
DATA :   celltab TYPE lvc_t_styl,
       END OF gs_chit_i.

DATA : gt_chit_i LIKE TABLE OF gs_chit_i.

DATA : gs_chit_h TYPE ztc_fi_chit_h.

DATA : BEGIN OF gs_ord_list  .
         INCLUDE STRUCTURE ztc_md_ord_list.

DATA :   celltab TYPE lvc_t_styl,
       END OF gs_ord_list .

DATA : gt_ord_list LIKE TABLE OF gs_ord_list.


**********************************************************************
* 기타 변수 선언
**********************************************************************

DATA : gv_price like gs_chit_i-cred_amt ,
       gv_curr  TYPE S_CURR.

DATA : gv_line  TYPE i,
       gv_ernam TYPE ztc_md_emp_t-text.

DATA : gv_leftacc  TYPE ztc_md_coa-acc_name,
       gv_rightacc LIKE gv_leftacc.

DATA : gv_sum_credit like gs_chit_i-cred_amt ,
       gv_sum_debit  like gs_chit_i-cred_amt .