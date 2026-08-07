
.SILENT:
init:
	$(info Initializing Radiant Project)
	radiantc init.tcl

synp: init
	$(info Running Synplify Pro)
	radiantc synp.tcl

build: init
	$(info Building Radiant Project)
	radiantc build.tcl

qrun:
	$(info Running testbench with qrun)
	set TOP=$(top)&&set RUNTIME=$(time)&&vsim -c -do qrun.tcl

clean:
	$(info Cleaning Radiant Project)
	del /q *.rdf *.sty *.ini *.pfl *.xml *.wlf *.log
	del /q .recovery transcript
	rd /s /q build qrun.out
	