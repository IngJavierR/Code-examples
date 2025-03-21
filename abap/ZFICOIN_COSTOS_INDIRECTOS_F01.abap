*&---------------------------------------------------------------------*
* Projecto          : S/4 ALL                                          *
* Requerimiento N°. : FI-044                                           *
* Programa          : ZFICOIN_COSTOS_INDIRECTOS_F01                    *
* Creado por        : Ma. de Lourdes Raña Gómez                        *
* Fecha creación    : 22/11/2018                                       *
* Descripcion       : Subritinas de Reporte de Costos Indirectos       *
* Transporte        : S4DK902353                                       *
* ---------------------------------------------------------------------*
* LOG DE MODIFICACIÓN                                                  *
*----------------------------------------------------------------------*
* Modificado por    :                                                  *
* Requirimiento N°  :                                                  *
* ID modificación   :                                                  *
* Fecha             :                                                  *
* Descripción       :                                                  *
* Transporte        :                                                  *
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form F0050_OBTENER_TVARVS
*&---------------------------------------------------------------------*
*& Obtiene las variables TVARV necesarias para el desarrollo
*&---------------------------------------------------------------------*
FORM f0050_obtener_tvarvs .

  PERFORM f0051_obtener_tvarv TABLES tg_ind_cc
                              USING c_ind_cc.

  PERFORM f0051_obtener_tvarv TABLES tg_ind_oi
                              USING c_ind_oi.

  PERFORM f0051_obtener_tvarv TABLES tg_ind_ce
                              USING c_ind_ce.

  PERFORM f0051_obtener_tvarv TABLES tg_ind_goi
                              USING c_ind_goi.

  PERFORM f0051_obtener_tvarv TABLES tg_ind_gcc
                              USING c_ind_gcc.

  PERFORM f0051_obtener_tvarv TABLES tg_ind_ko
                              USING c_ind_ko.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form F0051_OBTENER_TVARV
*&---------------------------------------------------------------------*
*& Lógica para la obtención de la variable TVARV
*&---------------------------------------------------------------------*
FORM f0051_obtener_tvarv  TABLES pt_tabla ##PERF_NO_TYPE
                          USING  p_name TYPE rvari_vnam.

  CONCATENATE c_zcostos p_name INTO DATA(vl_name).

  SELECT sign
         opti
         low
         high
    FROM tvarvc
      INTO TABLE pt_tabla
        WHERE name = vl_name
          AND type = c_s.

  IF sy-subrc NE 0.

    MESSAGE s368(00) WITH TEXT-e01 vl_name DISPLAY LIKE c_e.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form F0060_LLENAR_MATCHCODE_AUART
*&---------------------------------------------------------------------*
*& Llena ayuda para búsqueda de parámetro SO_AUART
*&---------------------------------------------------------------------*
FORM f0060_llenar_matchcode_auart CHANGING p_auart TYPE auart.

  DATA: tl_auart    TYPE STANDARD TABLE OF ty_auart,
        sl_auart    LIKE LINE OF tl_auart,
        tl_return   TYPE STANDARD TABLE OF ddshretval,
        tl_fieldtab TYPE STANDARD TABLE OF dfies,
        sl_fieldtab LIKE LINE OF tl_fieldtab.

  LOOP AT tg_ind_goi
    ASSIGNING FIELD-SYMBOL(<sl_ind_goi>).

    sl_auart-auart = <sl_ind_goi>-low.
    APPEND sl_auart TO tl_auart.

    IF <sl_ind_goi>-high IS NOT INITIAL.

      sl_auart-auart = <sl_ind_goi>-high.
      APPEND sl_auart TO tl_auart.

    ENDIF.

  ENDLOOP.

  sl_fieldtab-tabname   = 'TL_AUART'.
  sl_fieldtab-fieldname = 'AUART'.
  sl_fieldtab-domname   = 'AUART'.
  sl_fieldtab-intlen    = 8.
  sl_fieldtab-outputlen = 8.
  sl_fieldtab-datatype  = 'CHAR'.
  sl_fieldtab-reptext   = TEXT-001.
  APPEND sl_fieldtab TO tl_fieldtab.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'AUART'
      window_title    = TEXT-001
    TABLES
      value_tab       = tl_auart
      field_tab       = tl_fieldtab
      return_tab      = tl_return
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.
  IF sy-subrc = 0
    AND tl_return IS NOT INITIAL.
    DATA(sl_return) = tl_return[ 1 ].
    IF sy-subrc EQ 0.
      p_auart = sl_return-fieldval.
    ENDIF.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form F0060_LLENAR_MATCHCODE_KHINR
*&---------------------------------------------------------------------*
*& Llena ayuda para búsqueda para campo SO_KHINR
*&---------------------------------------------------------------------*
FORM f0060_llenar_matchcode_khinr  CHANGING p_khinr TYPE setnamenew.

  DATA: tl_khinr    TYPE STANDARD TABLE OF ty_khinr,
        sl_khinr    LIKE LINE OF tl_khinr,
        tl_return   TYPE STANDARD TABLE OF ddshretval,
        tl_fieldtab TYPE STANDARD TABLE OF dfies,
        sl_fieldtab LIKE LINE OF tl_fieldtab.

  LOOP AT tg_ind_gcc
    ASSIGNING FIELD-SYMBOL(<sl_ind_gcc>).

    sl_khinr-khinr = <sl_ind_gcc>-low.
    APPEND sl_khinr TO tl_khinr.

    IF <sl_ind_gcc>-high IS NOT INITIAL.

      sl_khinr-khinr = <sl_ind_gcc>-high.
      APPEND sl_khinr TO tl_khinr.

    ENDIF.

  ENDLOOP.

  sl_fieldtab-tabname   = 'TL_KHINR'.
  sl_fieldtab-fieldname = 'KHINR'.
  sl_fieldtab-domname   = 'SETNR'.
  sl_fieldtab-intlen    = 24.
  sl_fieldtab-outputlen = 24.
  sl_fieldtab-datatype  = 'CHAR'.
  sl_fieldtab-reptext   = TEXT-002.
  APPEND sl_fieldtab TO tl_fieldtab.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'KHINR'
      window_title    = TEXT-002
    TABLES
      value_tab       = tl_khinr
      field_tab       = tl_fieldtab
      return_tab      = tl_return
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.
  IF sy-subrc = 0
    AND tl_return IS NOT INITIAL.
    DATA(sl_return) = tl_return[ 1 ].
    IF sy-subrc EQ 0.
      p_khinr = sl_return-fieldval.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form F0100_OBTENER_DATOS
*&---------------------------------------------------------------------*
*& Obtiene datos de costos indirectos
*&---------------------------------------------------------------------*
FORM f0100_obtener_datos .

*Rangos
  DATA: rl_ceco  TYPE RANGE OF kostl,
        rl_racct TYPE RANGE OF racct,
        rl_rcomp TYPE RANGE OF rcomp_d.

*Estructuras locales
  DATA: sl_rcomp LIKE LINE OF rl_rcomp.


*Obtiene grupos de CeCos a partir de el set de datos
  PERFORM f0110_obtener_grupo_ceco TABLES rl_ceco.
*Obtiene grupos de cuentas a partir de el set de datos
  PERFORM f0120_obtener_grupo_ctas TABLES rl_racct.

*Obtiene datos de costos indirectos
  SELECT a~rbukrs,
         a~gjahr,
         a~belnr,
         a~racct,
         a~rcntr,
         a~rassc,
         a~tsl,
         a~rtcur,
         a~poper,
         a~budat,
         a~blart,
         a~aufnr,
         b~auart,
         b~ktext
    FROM acdoca AS a
      INNER JOIN coas AS b
        ON a~aufnr = b~aufnr
      INTO TABLE @DATA(tl_acdoca)
        WHERE a~rldnr  EQ @c_rldnr
          AND a~rbukrs IN @so_rbukr
          AND a~gjahr  EQ @p_gjahr
          AND a~belnr  IN @so_belnr
          AND a~racct  IN @rl_racct
          AND a~rcntr  IN @so_rcntr
          AND a~rcntr  IN @rl_ceco
          AND a~kokrs  IN @so_kokrs
          AND a~rhcur IN @so_waers
          AND a~poper IN @so_poper
*          AND a~kokrs  EQ @p_kokrs
          AND a~aufnr  IN @so_aufnr
          AND b~auart  IN @so_auart ##DB_FEATURE_MODE[TABLE_LEN_MAX1].

  IF sy-subrc = 0.

*Obtiene texto de sociedad
    SELECT bukrs,
           butxt
      FROM t001
      CLIENT SPECIFIED
        INTO TABLE @DATA(tl_t001)
            WHERE mandt EQ @sy-mandt
              AND bukrs IN @so_rbukr.

    IF sy-subrc NE 0.

      REFRESH tl_t001.

    ENDIF.

*Obtiene texto de Sociedad GL

    DATA(tl_acdoca_aux) = tl_acdoca.

    DELETE ADJACENT DUPLICATES FROM tl_acdoca_aux
      COMPARING rassc.

    LOOP AT tl_acdoca_aux
      ASSIGNING FIELD-SYMBOL(<sl_acdoca>).

      sl_rcomp-sign = c_i.
      sl_rcomp-option = c_eq.
      sl_rcomp-low    = <sl_acdoca>-rassc.

      APPEND sl_rcomp TO rl_rcomp.

    ENDLOOP.

    SELECT rcomp,
           name1
      FROM t880
        CLIENT SPECIFIED
          INTO TABLE @DATA(tl_t880)
            WHERE mandt EQ @sy-mandt
              AND rcomp IN @rl_rcomp.

    IF sy-subrc NE 0.

      REFRESH tl_t880.

    ENDIF.

    PERFORM f0200_armar_final TABLES tl_acdoca
                                     tl_t001
                                     tl_t880.

  ELSE.

    MESSAGE s208(00) WITH TEXT-e03 DISPLAY LIKE c_e.

  ENDIF.

  IF tg_final IS NOT INITIAL.

    PERFORM f0300_desplegar_reporte.

  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form F0300_DESPLEGAR_REPORTE
*&---------------------------------------------------------------------*
*& Muestra el reporte ALV con los datos obtenidos
*&---------------------------------------------------------------------*
FORM f0300_desplegar_reporte .

*Tablas internas locales
  DATA: tl_fcat TYPE slis_t_fieldcat_alv,
        tl_sort TYPE slis_t_sortinfo_alv.

*Estructuras locales
  DATA: sl_layo TYPE slis_layout_alv,
        sl_sort LIKE LINE OF tl_sort.

  SORT tg_final BY aufnr.

  sl_layo-zebra = c_x.
  sl_layo-colwidth_optimize = c_x.

  sl_sort-fieldname = 'AUFNR'.
  sl_sort-subtot    = c_x.

  APPEND sl_sort TO tl_sort.

*Arma catálogo de campos
  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = c_struct
    CHANGING
      ct_fieldcat            = tl_fcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  IF sy-subrc = 0.

    LOOP AT tl_fcat
      ASSIGNING FIELD-SYMBOL(<sl_fcat>).

      <sl_fcat>-fix_column = c_x.

      CASE <sl_fcat>-fieldname.
        WHEN 'BUTXT'.

          <sl_fcat>-seltext_l =
          <sl_fcat>-seltext_m =
          <sl_fcat>-seltext_s =
          <sl_fcat>-reptext_ddic = TEXT-c01.

        WHEN 'TXT50'.

          <sl_fcat>-seltext_l =
          <sl_fcat>-seltext_m =
          <sl_fcat>-seltext_s =
          <sl_fcat>-reptext_ddic = TEXT-c02.

        WHEN 'KTEXT'.

          <sl_fcat>-seltext_l =
          <sl_fcat>-seltext_m =
          <sl_fcat>-seltext_s =
          <sl_fcat>-reptext_ddic = TEXT-c03.

        WHEN 'LTEXT'.

          <sl_fcat>-seltext_l =
          <sl_fcat>-seltext_m =
          <sl_fcat>-seltext_s =
          <sl_fcat>-reptext_ddic = TEXT-c04.
        WHEN 'TSL'.
          <sl_fcat>-do_sum = c_x.
      ENDCASE.

    ENDLOOP.

    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        i_structure_name = c_struct
        is_layout        = sl_layo
        it_fieldcat      = tl_fcat
        it_sort          = tl_sort
      TABLES
        t_outtab         = tg_final
      EXCEPTIONS
        program_error    = 1
        OTHERS           = 2.
    IF sy-subrc <> 0.
      MESSAGE s208(00) WITH TEXT-e02 DISPLAY LIKE c_e.
    ENDIF.


  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form F0200_ARMAR_FINAL
*&---------------------------------------------------------------------*
*&Arma la tabla que se mostrará en el ALV
*&---------------------------------------------------------------------*
FORM f0200_armar_final  TABLES pt_acdoca TYPE tt_acdoca
                               pt_t001   TYPE tt_t001
                               pt_t880   TYPE tt_t880.

  DATA: sl_final TYPE zficoes_rep_costos_indirectos.

  LOOP AT pt_acdoca
    ASSIGNING FIELD-SYMBOL(<sl_acdoca>).
*Sociedad
    sl_final-rbukrs = <sl_acdoca>-rbukrs.
*Texto de la sociedad
    TRY.

        ASSIGN pt_t001[ bukrs = <sl_acdoca>-rbukrs ]
          TO FIELD-SYMBOL(<sl_t001>).
      CATCH cx_sy_itab_line_not_found.
        CLEAR sl_final-butxt.
    ENDTRY.

    IF sy-subrc = 0.
      sl_final-butxt = <sl_t001>-butxt.
    ENDIF.
*Sociedad GL
    sl_final-rassc = <sl_acdoca>-rassc.
*Texto de la sociedad GL
    TRY.

        ASSIGN pt_t880[ rcomp = <sl_acdoca>-rassc ]
          TO FIELD-SYMBOL(<sl_t880>).
      CATCH cx_sy_itab_line_not_found.
        CLEAR sl_final-name1.
    ENDTRY.

    IF sy-subrc = 0.
      sl_final-name1 = <sl_t880>-name1.
    ENDIF.
*Ejercicio
    sl_final-gjahr  = <sl_acdoca>-gjahr.
*Periodo contable
    sl_final-poper  = <sl_acdoca>-poper.
*Fecha de contabilización
    sl_final-budat  = <sl_acdoca>-budat.
*
    sl_final-blart  = <sl_acdoca>-blart.
    sl_final-belnr  = <sl_acdoca>-belnr.
*Cuenta contable
    sl_final-racct  = <sl_acdoca>-racct.

*Descripción Cuenta contable
    SELECT SINGLE txt50
      FROM skat
        CLIENT SPECIFIED
          INTO @DATA(vl_txt50)
             WHERE mandt EQ @sy-mandt
               AND spras EQ @c_s
               AND ktopl EQ @c_corp
               AND saknr EQ @<sl_acdoca>-racct.         "#EC CI_GENBUFF

    IF sy-subrc = 0.

      sl_final-txt50 = vl_txt50.

    ENDIF.

*Número de órden
    sl_final-aufnr  = <sl_acdoca>-aufnr.
*Descripción órden
    sl_final-ktext = <sl_acdoca>-ktext.
*Centro de Costo
    sl_final-rcntr  = <sl_acdoca>-rcntr.
*Descripción Centro de Costo
    SELECT ltext
      FROM cskt
        UP TO 1 ROWS
*      CLIENT SPECIFIED
          INTO TABLE @DATA(tl_ltext)
*            WHERE mandt eq @sy-mandt
              WHERE spras EQ @c_s
*              AND kokrs EQ @p_kokrs
              AND kokrs IN @so_kokrs
              AND kostl EQ @<sl_acdoca>-rcntr.          "#EC CI_GENBUFF

    IF sy-subrc = 0.

      DATA(sl_ltext) = tl_ltext[ 1 ].

      sl_final-ltext = sl_ltext-ltext.

    ENDIF.
    sl_final-hsl    = <sl_acdoca>-hsl.
    sl_final-rtcur    = <sl_acdoca>-rtcur.

    APPEND sl_final TO tg_final.
    CLEAR sl_final.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form F0110_OBTENER_GRUPO_CECO
*&---------------------------------------------------------------------*
*& Obtiene CeCo's que pertenezcan a la jerarquía a partir de TVARV
*  ZCOSTOS_IND_GCC
*&---------------------------------------------------------------------*
FORM f0110_obtener_grupo_ceco  TABLES pt_ceco TYPE tt_ceco.

*Tablas internas locales
  DATA: tl_lines TYPE STANDARD TABLE OF rgsb1,
        tl_basic TYPE STANDARD TABLE OF rgsbv.
*Estructuras locales
  DATA: sl_ceco LIKE LINE OF pt_ceco.
*Variables locales
  DATA: vl_setnr TYPE setnamenew.

  LOOP AT tg_ind_gcc
    ASSIGNING FIELD-SYMBOL(<sl_ind_gcc>).

    IF <sl_ind_gcc>-low IN so_khinr.

      CONCATENATE c_gcec so_kokrs-low <sl_ind_gcc>-low "p_kokrss
        INTO vl_setnr.

      CALL FUNCTION 'G_SET_FETCH'
        EXPORTING
          langu            = c_s
          setnr            = vl_setnr
        TABLES
          set_lines_single = tl_lines
          set_lines_basic  = tl_basic
        EXCEPTIONS
          no_authority     = 1
          set_is_broken    = 2
          set_not_found    = 3
          OTHERS           = 4.

      IF sy-subrc = 0.
        IF tl_lines IS NOT INITIAL.
          LOOP AT tl_lines
            ASSIGNING FIELD-SYMBOL(<sl_lines>).

            sl_ceco-sign   = c_i.
            sl_ceco-option = c_eq.

            sl_ceco-low = <sl_lines>-setnr+8.

            APPEND sl_ceco TO pt_ceco.

          ENDLOOP.
        ELSEIF tl_basic IS NOT INITIAL.
          LOOP AT tl_basic
            ASSIGNING FIELD-SYMBOL(<sl_basic>).

            sl_ceco-sign   = c_i.
            sl_ceco-option = c_bt.

            sl_ceco-low = <sl_basic>-from.
            sl_ceco-high = <sl_basic>-to.

            APPEND sl_ceco TO pt_ceco.

          ENDLOOP.

        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.

  IF pt_ceco[] IS NOT INITIAL
    AND tl_lines IS NOT INITIAL.

    SELECT kostl
      FROM csks
       CLIENT SPECIFIED
         INTO TABLE @DATA(tl_kostl)
      WHERE mandt EQ @sy-mandt
        AND kokrs IN @so_kokrs "@p_kokrs
        AND kostl IN @so_rcntr
        AND datbi GE @sy-datum
        AND kosar IN @tg_ind_cc
        AND khinr IN @pt_ceco.                          "#EC CI_GENBUFF

    IF sy-subrc = 0.

      REFRESH pt_ceco[].

      SORT tl_kostl BY kostl.
      DELETE ADJACENT DUPLICATES FROM tl_kostl COMPARING kostl.

      LOOP AT tl_kostl
        ASSIGNING FIELD-SYMBOL(<sl_kostl>).

        sl_ceco-low = <sl_kostl>-kostl.

        APPEND sl_ceco TO pt_ceco.

      ENDLOOP.

    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form F0120_OBTENER_GRUPO_CTAS
*&---------------------------------------------------------------------*
*& Obtiene la jerarquía de cuentas a partir de la TVARV
*&---------------------------------------------------------------------*
FORM f0120_obtener_grupo_ctas  TABLES   p_racct TYPE tt_racct.


*Tablas internas locales
  DATA: tl_lines TYPE STANDARD TABLE OF rgsbv.
*Estructuras locales
  DATA: sl_racct LIKE LINE OF p_racct.

*Variables locales
  DATA: vl_setnr TYPE setnamenew.

  sl_racct-sign   = c_i.
  sl_racct-option = c_bt.

  LOOP AT tg_ind_ce
    ASSIGNING FIELD-SYMBOL(<sl_ind_ce>).

    CONCATENATE c_0000 <sl_ind_ce>-low
      INTO vl_setnr.

    CALL FUNCTION 'G_SET_FETCH'
      EXPORTING
        langu           = c_s
        setnr           = vl_setnr
      TABLES
        set_lines_basic = tl_lines
      EXCEPTIONS
        no_authority    = 1
        set_is_broken   = 2
        set_not_found   = 3
        OTHERS          = 4.
    IF sy-subrc = 0.
      LOOP AT tl_lines
        ASSIGNING FIELD-SYMBOL(<sl_lines>).

        sl_racct-low = <sl_lines>-from.
        sl_racct-high = <sl_lines>-to.

        APPEND sl_racct TO p_racct.

      ENDLOOP.
    ENDIF.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form F0060_LLENAR_MATCHCODE_BUKRS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
FORM f0060_llenar_matchcode_bukrs  CHANGING p_bukrs.

  DATA: tl_bukrs    TYPE STANDARD TABLE OF ty_t001 WITH HEADER LINE,
        sl_bukrs    LIKE LINE OF tl_bukrs,
        tl_return   TYPE STANDARD TABLE OF ddshretval,
        tl_fieldtab TYPE STANDARD TABLE OF dfies,
        sl_fieldtab LIKE LINE OF tl_fieldtab.

*  SELECT a~bukrs
*         b~butxt
*    INTO TABLE tl_bukrs
*      FROM tka02 AS a
*        INNER JOIN t001 AS b
*          ON b~bukrs = a~bukrs
*          WHERE a~kokrs EQ p_kokrs.
* INI FI-044. --------------------------------------- JGONZALEZ 2019.04.12

  IF so_kokrs[] IS NOT INITIAL.
    SELECT a~bukrs
           b~butxt
      INTO TABLE tl_bukrs
        FROM tka02 AS a
          INNER JOIN t001 AS b
            ON b~bukrs = a~bukrs
      WHERE kokrs IN so_kokrs.

  ELSE.
    SELECT a~bukrs
      b~butxt
 INTO TABLE tl_bukrs
   FROM tka02 AS a
     INNER JOIN t001 AS b
       ON b~bukrs = a~bukrs
 WHERE kokrs IN tg_kokrs.




  ENDIF.
* FIN FI-044. --------------------------------------- JGONZALEZ 2019.04.12



  IF sy-subrc = 0.

    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = 'BUKRS'
        window_title    = TEXT-003
        value_org       = 'S'
      TABLES
        value_tab       = tl_bukrs
        return_tab      = tl_return
      EXCEPTIONS
        parameter_error = 1
        no_values_found = 2
        OTHERS          = 3.
    IF sy-subrc = 0
      AND tl_return IS NOT INITIAL.
      DATA(sl_return) = tl_return[ 1 ].
      IF sy-subrc EQ 0.
        p_bukrs = sl_return-fieldval.
      ENDIF.
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form F0060_LLENAR_MATCHCODE_KOKRS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*      <--P_SO_KOKRS_LOW  text
*&---------------------------------------------------------------------*
FORM f0060_llenar_matchcode_kokrs  CHANGING p_kokrs TYPE kokrs.

  DATA: tl_kokrs    TYPE STANDARD TABLE OF ty_kokrs,
        sl_kokrs    LIKE LINE OF tl_kokrs,
        tl_return   TYPE STANDARD TABLE OF ddshretval,
        tl_fieldtab TYPE STANDARD TABLE OF dfies,
        sl_fieldtab LIKE LINE OF tl_fieldtab.

  REFRESH : tg_kokrs.
  LOOP AT tg_ind_ko
    ASSIGNING FIELD-SYMBOL(<sl_ind_ko>).

    sl_kokrs-kokrs = <sl_ind_ko>-low.
    APPEND sl_kokrs TO tl_kokrs.

    IF <sl_ind_ko>-high IS NOT INITIAL.

      sl_kokrs-kokrs = <sl_ind_ko>-high.
      APPEND sl_kokrs TO tl_kokrs.

    ENDIF.

  ENDLOOP.

  sl_fieldtab-tabname   = 'TL_KOKRS'.
  sl_fieldtab-fieldname = 'KOKRS'.
  sl_fieldtab-domname   = 'KOKRS'.
  sl_fieldtab-intlen    = 8.
  sl_fieldtab-outputlen = 8.
  sl_fieldtab-datatype  = 'CHAR'.
  sl_fieldtab-reptext   = TEXT-004.
  APPEND sl_fieldtab TO tl_fieldtab.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'KOKRS'
      window_title    = TEXT-004
    TABLES
      value_tab       = tl_kokrs
      field_tab       = tl_fieldtab
      return_tab      = tl_return
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.
  IF sy-subrc = 0
    AND tl_return IS NOT INITIAL.
    DATA(sl_return) = tl_return[ 1 ].
    IF sy-subrc EQ 0.
      p_kokrs = sl_return-fieldval.

      tg_kokrs-sign = 'I'.
      tg_kokrs-option = 'EQ'.
      tg_kokrs-low = p_kokrs.
      APPEND tg_kokrs.
    ENDIF.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form F0060_LLENAR_MATCHCODE_WAERS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*      <--P_SO_WAERS_LOW  text
*&---------------------------------------------------------------------*
FORM f0060_llenar_matchcode_waers  CHANGING p_waers TYPE waers.
  DATA: tl_waers    TYPE STANDARD TABLE OF ty_waers WITH HEADER LINE,
        sl_waers    LIKE LINE OF tl_waers,
        tl_return   TYPE STANDARD TABLE OF ddshretval,
        tl_fieldtab TYPE STANDARD TABLE OF dfies,
        sl_fieldtab LIKE LINE OF tl_fieldtab.

*  SELECT a~bukrs
*         b~butxt
*    INTO TABLE tl_bukrs
*      FROM tka02 AS a
*        INNER JOIN t001 AS b
*          ON b~bukrs = a~bukrs
*          WHERE a~kokrs EQ p_kokrs.
* INI FI-044. --------------------------------------- JGONZALEZ 2019.04.12

  IF so_kokrs[] IS NOT INITIAL.
    SELECT waers
      INTO TABLE tl_waers
        FROM tka01
      WHERE kokrs IN so_kokrs.

  ELSE.
    SELECT waers
       INTO TABLE tl_waers
         FROM tka01
  WHERE kokrs IN tg_kokrs.




  ENDIF.
* FIN FI-044. --------------------------------------- JGONZALEZ 2019.04.12



  IF sy-subrc = 0.

    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = 'WAERS'
        window_title    = TEXT-003
        value_org       = 'S'
      TABLES
        value_tab       = tl_waers
        return_tab      = tl_return
      EXCEPTIONS
        parameter_error = 1
        no_values_found = 2
        OTHERS          = 3.
    IF sy-subrc = 0
      AND tl_return IS NOT INITIAL.
      DATA(sl_return) = tl_return[ 1 ].
      IF sy-subrc EQ 0.
        p_waers = sl_return-fieldval.
      ENDIF.
    ENDIF.

  ENDIF.
ENDFORM.
