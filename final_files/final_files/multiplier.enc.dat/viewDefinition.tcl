if {![namespace exists ::IMEX]} { namespace eval ::IMEX {} }
set ::IMEX::dataVar [file dirname [file normalize [info script]]]
set ::IMEX::libVar ${::IMEX::dataVar}/libs

create_library_set -name fast\
   -timing\
    [list ${::IMEX::libVar}/mmmc/fast.lib]
create_library_set -name slow\
   -timing\
    [list ${::IMEX::libVar}/mmmc/slow.lib]
create_rc_corner -name RC\
   -cap_table ${::IMEX::libVar}/mmmc/t018s6mlv.capTbl\
   -preRoute_res 1\
   -postRoute_res 1\
   -preRoute_cap 1\
   -postRoute_cap 1\
   -postRoute_xcap 1\
   -preRoute_clkres 0\
   -preRoute_clkcap 0\
   -qx_tech_file ${::IMEX::libVar}/mmmc/RC/t018s6mm.tch
create_delay_corner -name min\
   -library_set fast\
   -rc_corner RC
create_delay_corner -name max\
   -library_set slow\
   -rc_corner RC
create_constraint_mode -name constraint\
   -sdc_files\
    [list ${::IMEX::dataVar}/mmmc/modes/constraint/constraint.sdc]
create_analysis_view -name WC -constraint_mode constraint -delay_corner max -latency_file ${::IMEX::dataVar}/mmmc/views/WC/latency.sdc
create_analysis_view -name BC -constraint_mode constraint -delay_corner min
set_analysis_view -setup [list WC] -hold [list WC]
