
package require fileutil
source config.tcl

if { [info exists ::env(TOP)] && $::env(TOP) ne "" } {
    set top $::env(TOP)
} else {
    set top "${top_module}_tb"
}

if { [info exists ::env(RUNTIME)] && $::env(RUNTIME) ne "" } {
    set time $::env(RUNTIME)
} else {
    set time "-all"
}

puts "top: $top, time: $time"
set src_files {}

if { [file isdirectory $src_dir] } {
    lappend src_files {*}[fileutil::findByPattern $src_dir -glob *.v]
}

if { [file isdirectory $tb_dir] } {
    lappend src_files {*}[fileutil::findByPattern $tb_dir -glob *.sv]
}

set src_files [lsort -unique $src_files]
if { [llength $src_files] == 0 } {
    puts "No source files found in: $src_dir, $tb_dir"
    quit -f
}

puts "Found [llength $src_files] source files:"
foreach file $src_files { puts "  $file" }

set result [catch {
    qrun \
        -sv {*}$src_files -top $top -work $work_dir \
        -L pmi_work -L ovi_ice40up \
        -voptargs="+acc" -onfinish stop -gui \
        -do "log -r /*; add wave /*; run $time; view wave"
} message]

if {$result != 0} {
    puts stderr "Qrun failed: $message"
    quit -f -code 1
}

quit -f -code 0
