FORM routine_9998

  TABLES DATA_PACKAGE TYPE _ty_t_SC_1_full

    p_monitor         STRUCTURE rsmonitor

    p_monitor_recno   STRUCTURE rsmonitors

  CHANGING

    ABORT          LIKE sy-subrc

  RAISING

    cx_sy_arithmetic_error

    cx_sy_conversion_error.

* init variables

* fill the internal table "MONITOR", to make monitor entries

* see OSS note 571669

  LOOP AT DATA_PACKAGE.

    IF DATA_PACKAGE-stockcat EQ 'V' OR

       DATA_PACKAGE-stocktype EQ 'V'.

      DELETE DATA_PACKAGE.

    ENDIF.

  ENDLOOP.

* if abort is not equal zero, the update process will be canceled

  ABORT = 0.

  p_monitor[]       = MONITOR[].

  p_monitor_recno[] = MONITOR_RECNO[].

  CLEAR: MONITOR[],

         MONITOR_RECNO[].

 ENDFORM.                    "routine_9998
 

 
CLASS lcl_transform IMPLEMENTATION.
*----------------------------------------------------------------------*
*       Method start_routine
*----------------------------------------------------------------------*
*       Calculation of source package via start routine
*----------------------------------------------------------------------*
*   <-> source package
*----------------------------------------------------------------------*
  METHOD start_routine.
*=== Segments ===
    FIELD-SYMBOLS:
<SOURCE_FIELDS>    TYPE _ty_s_SC_1.
    DATA:
      MONITOR_REC     TYPE rstmonitor.
*$*$ begin of routine - insert your code only below this line        *-*
  Data:
   l_monitor       TYPE STANDARD TABLE OF rsmonitor,
   l_monitor_recno TYPE STANDARD TABLE OF rsmonitors,
*--
    l_subrc          type sy-tabix,
    l_abort          type sy-tabix,
    Ls_monitor       type rsmonitor,
    ls_monitor_recno type rsmonitors.
  Refresh:
    MONITOR,
    MONITOR_RECNO.
* Runtime attributs
    SOURCE_SYSTEM  = p_r_request->get_logsys( ).
*  Migrated update rule call
  Perform routine_9998
  TABLES
    SOURCE_PACKAGE
    l_monitor
    l_monitor_recno
  CHANGING
    l_abort.
*-- Convert Messages in Transformation format
    LOOP AT l_monitor_recno INTO ls_monitor_recno.
      move-CORRESPONDING ls_monitor_recno to MONITOR_REC.
      append monitor_rec to MONITOR.
    ENDLOOP.
    LOOP AT l_monitor   INTO ls_monitor.
      move-CORRESPONDING ls_monitor to MONITOR_REC.
      append monitor_rec to MONITOR.
    ENDLOOP.
    IF l_abort <> 0.
      RAISE EXCEPTION TYPE CX_RSROUT_ABORT.
    ENDIF.
*$*$ end of routine - insert your code only before this line         *-*
  ENDMETHOD.                    "start_routine