source ../../setup.tcl
set link_library [list $IGZO_LIB]
set target_library [list $IGZO_LIB]
set symbol_library [list $IGZO_LIB]

set tech "igzo"
set top "bch_decoder"
set rtl_dir "../../src/${top}/"
set res_dir "../../results/${tech}/${top}"
exec mkdir -p -- $res_dir

analyze -library WORK -format sverilog [glob "${rtl_dir}/*.v"]
set design_clk_freq_KHz 12.5

set design_period [expr 1000.0*1000.0 / $design_clk_freq_KHz]


for {set p 6} {$p < 7} {incr p} {
    puts "${p}"
    elaborate -work WORK  -parameters "NCHANNEL=1,DATA_BITS=128" ${top}
    create_clock -period $design_period -name clk clk
    compile_ultra
    uplevel #0 { report_area } >> "${res_dir}/area${p}.rpt"
    uplevel #0 { report_power -analysis_effort high } >> "${res_dir}/power${p}.rpt"
    uplevel #0 { report_reference -hierarchy  } >> "${res_dir}/cells${p}.rpt"
}
exit

