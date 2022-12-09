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


for {set db 4} {$db < 130} {incr db 4} {
    for {set t 8} {$t < 16 && $t < $db} {incr t} {
        puts "${db}"
        elaborate -work WORK  -parameters "NCHANNEL=1,DATA_BITS=${db},T=${t}" ${top}
        create_clock -period $design_period -name clk clk
        compile_ultra
        set suffix "t_${t}_db_${db}"
        uplevel #0 { report_area } >> "${res_dir}/area_${suffix}.rpt"
        uplevel #0 { report_power -analysis_effort high } >> "${res_dir}/power_${suffix}.rpt"
        uplevel #0 { report_reference -hierarchy  } >> "${res_dir}/cells_${suffix}.rpt"
    }
}
exit

