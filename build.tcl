
source config.tcl

prj_open $proj_name.rdf

prj_run Synthesis   -impl $proj_ver
prj_run Map         -impl $proj_ver
prj_run PAR         -impl $proj_ver
prj_run Export      -impl $proj_ver

prj_close