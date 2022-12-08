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
create_clock -period $design_period -name my_clk


for {set p 6} {$p < 128} {incr p} {
    puts "${p}"
    elaborate -work WORK  -parameters "${p}"
    create_clock -name CLK -period 10000 clk_i
    check_design >> design_check.rpt
    compile_ultra -exact_map
    uplevel #0 { report_area } >> "${report_dir}/area${p}.rpt"
    uplevel #0 { report_power -analysis_effort high } >> "${report_dir}/power${p}.rpt"
    uplevel #0 { report_reference -hierarchy  } >> "${report_dir}/cells${p}.rpt"
}
exit

#set modules { xors mix_columns aes_sbox }
#foreach module $modules {
#    elaborate -work WORK $module
#    create_clock -name CLK -period 10000 CLK
#    check_design >> design_check.rpt
#    compile_ultra
#    uplevel #0 { report_area } >> ${module}_area.rpt
#    uplevel #0 { report_power -analysis_effort high } >> ${module}_power.rpt
#    uplevel #0 { report_reference -hierarchy  } >> ${module}_cells.rpt
#}

# set module xors
# elaborate -work WORK $module
# set_max_delay 10000 -from DIN -to DOUT
# create_clock -name CLK -period 10000
# check_design >> ${module}_design_check.rpt
# compile_ultra
# uplevel #0 { report_area } >> ${module}_area.rpt
# uplevel #0 { report_power -analysis_effort high } >> ${module}_power.rpt
# uplevel #0 { report_reference -hierarchy  } >> ${module}_cells.rpt
# 
# set module mix_columns
# elaborate -work WORK $module
# set_max_delay 10000 -from DIN -to DOUT
# create_clock -name CLK -period 10000
# check_design >> ${module}_design_check.rpt
# compile_ultra
# uplevel #0 { report_area } >> ${module}_area.rpt
# uplevel #0 { report_power -analysis_effort high } >> ${module}_power.rpt
# uplevel #0 { report_reference -hierarchy  } >> ${module}_cells.rpt
# 
# set module aes_sbox
# elaborate -work WORK $module
# set_max_delay 10000 -from sboxw -to new_sboxw
# create_clock -name CLK -period 10000
# check_design >> ${module}_design_check.rpt
# compile_ultra
# uplevel #0 { report_area } >> ${module}_area.rpt
# uplevel #0 { report_power -analysis_effort high } >> ${module}_power.rpt
# uplevel #0 { report_reference -hierarchy  } >> ${module}_cells.rpt


exit
