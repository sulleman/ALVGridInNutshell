*&---------------------------------------------------------------------*
*& Report zdemo_ain_cl22
*&---------------------------------------------------------------------*
*& This is the demo program written for book:
*& ALV grid in nutshell by Łukasz Pęgiel
*&---------------------------------------------------------------------*
report zdemo_ain_cl22.

include zdemo_ain_include_screen.

parameters: p_nozero type lvc_s_fcat-no_zero as checkbox.


start-of-selection.

  types: begin of t_data,
           carrid   type spfli-carrid,
           connid   type spfli-connid,
           distance type spfli-distance,
           distid   type spfli-distid,
         end of t_data.
  data flights type standard table of t_data.

  select carrid, connid, ( case when distance > 1000 and distance < 5000 then 0
                                else distance
                                end ) as distance, distid
    up to 50 rows from spfli
    into corresponding fields of table @flights.

  data(grid) = new cl_gui_alv_grid(
                    i_parent = new cl_gui_custom_container( container_name = 'CC' )
                                   ).
  data(fcat) = value lvc_t_fcat(
                                 ( fieldname = 'CARRID' )
                                 ( fieldname = 'CONNID' )
                                 ( fieldname = 'DISTANCE' qfieldname = 'DISTID' no_zero = p_nozero )
                                 ( fieldname = 'DISTID' )
                               ).

  grid->set_table_for_first_display(
    changing
      it_fieldcatalog               = fcat
      it_outtab                     = flights
    exceptions
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      others                        = 4
  ).
  if sy-subrc eq 0.
    call screen 0100.
  endif.
