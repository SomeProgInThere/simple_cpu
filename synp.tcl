
source config.tcl

prj_open $proj_name.rdf
prj_run Synthesis -impl $proj_ver

cd "./build/$proj_ver"
exec synpwrap -gui -prj "${proj_name}_${proj_ver}_synplify.tcl"
cd [pwd]

prj_close