# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir {C:/Users/Petrenciuc Amelia/OneDrive/Desktop/VERSIUNE_NOUA_MASINA/masina_spalat_vase/masina_spalat_vase.cache/wt} [current_project]
set_property parent.project_path {C:/Users/Petrenciuc Amelia/OneDrive/Desktop/VERSIUNE_NOUA_MASINA/masina_spalat_vase/masina_spalat_vase.xpr} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property ip_output_repo {c:/Users/Petrenciuc Amelia/OneDrive/Desktop/VERSIUNE_NOUA_MASINA/masina_spalat_vase/masina_spalat_vase.cache/ip} [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_vhdl -library xil_defaultlib {
  {C:/Users/Petrenciuc Amelia/OneDrive/Desktop/VERSIUNE_NOUA_MASINA/masina_spalat_vase/masina_spalat_vase.srcs/sources_1/new/AFIS_TIMP.vhd}
  {C:/Users/Petrenciuc Amelia/OneDrive/Desktop/VERSIUNE_NOUA_MASINA/masina_spalat_vase/masina_spalat_vase.srcs/sources_1/new/COUNTER_HM.vhd}
  {C:/Users/Petrenciuc Amelia/OneDrive/Desktop/VERSIUNE_NOUA_MASINA/masina_spalat_vase/masina_spalat_vase.srcs/sources_1/new/COUNT_DOWN_TIMP.vhd}
  {C:/Users/Petrenciuc Amelia/OneDrive/Desktop/VERSIUNE_NOUA_MASINA/masina_spalat_vase/masina_spalat_vase.srcs/sources_1/new/MEMORIE_PROGRAME.vhd}
  {C:/Users/Petrenciuc Amelia/OneDrive/Desktop/debouncer.vhd}
  {C:/Users/Petrenciuc Amelia/OneDrive/Desktop/counter_4_bits.vhd}
  {C:/Users/Petrenciuc Amelia/OneDrive/Desktop/VERSIUNE_NOUA_MASINA/masina_spalat_vase/masina_spalat_vase.srcs/sources_1/new/executare_program.vhd}
  {C:/Users/Petrenciuc Amelia/OneDrive/Desktop/VERSIUNE_NOUA_MASINA/masina_spalat_vase/masina_spalat_vase.srcs/sources_1/new/SETARE_PROGRAM.vhd}
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc {{C:/Users/Petrenciuc Amelia/OneDrive/Desktop/VERSIUNE_NOUA_MASINA/masina_spalat_vase/masina_spalat_vase.srcs/constrs_1/new/BASYS.xdc}}
set_property used_in_implementation false [get_files {{C:/Users/Petrenciuc Amelia/OneDrive/Desktop/VERSIUNE_NOUA_MASINA/masina_spalat_vase/masina_spalat_vase.srcs/constrs_1/new/BASYS.xdc}}]

set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top SETARE_PROGRAM -part xc7a35tcpg236-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef SETARE_PROGRAM.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file SETARE_PROGRAM_utilization_synth.rpt -pb SETARE_PROGRAM_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
