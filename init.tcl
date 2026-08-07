
package require fileutil
source config.tcl

prj_create \
    -name $proj_name \
    -dev $device \
    -performance $performance \
    -impl $proj_ver \
    -impl_dir ./build/$proj_ver \
    -synthesis synplify

set sources [::fileutil::findByPattern "./src/$proj_ver" -glob {*.v}]

foreach file $sources {
    if { $file ne "./src/$proj_ver/$top_module.v" } {
        puts "Adding source: $file"
        prj_add_source $file
    }
}

puts "Adding source: ./src/$proj_ver/$top_module.v"
prj_add_source ./src/$proj_ver/$top_module.v

foreach file [glob ./constraints/*.pdc] {
    puts "Adding constraint: $file"
    prj_add_source $file
}

prj_set_top_module $top_module
prj_save $proj_name.rdf