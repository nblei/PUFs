source ../../setup.tcl
set link_library [list $IGZO_LIB]
set target_library [list $IGZO_LIB]
set symbol_library [list $IGZO_LIB]

set tech "igzo"
set top "arbiter_puf"
set rtl_dir "../../src/${top}/"
set res_dir "../../results/${tech}/${top}"
exec mkdir -p -- $res_dir

analyze -library WORK -format sverilog [glob "${rtl_dir}/*.sv"]
analyze -library WORK -format sverilog [glob ../rtl/*.sv]
set design_clk_freq_KHz 12.5

set design_period [expr 1000.0*1000.0 / $design_clk_freq_KHz]


for {set p 6} {$p < 64} {incr p} {
    puts "${p}"
    elaborate -work WORK  -parameters "${p}" ${top}
    set_dont_touch {"switch" "mux2"}
    create_clock -period $design_period -name my_clk
    compile_ultra -exact_map
    uplevel #0 { report_area } > "${res_dir}/area${p}.rpt"
    uplevel #0 { report_power -analysis_effort high } > "${res_dir}/power${p}.rpt"
    uplevel #0 { report_reference -hierarchy  } > "${res_dir}/cells${p}.rpt"
}
exit

