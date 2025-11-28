set_property SRC_FILE_INFO {cfile:D:/2024_2/Vivado/2024.2/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl rfile:D:/2024_2/Vivado/2024.2/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl id:1 order:LATE scoped_inst:inst/u_fec_rx/u_deinterleaver/u_ram0 unmanaged:yes} [current_design]
set_property SRC_FILE_INFO {cfile:D:/2024_2/Vivado/2024.2/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl rfile:D:/2024_2/Vivado/2024.2/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl id:2 order:LATE scoped_inst:inst/u_fec_rx/u_deinterleaver/u_ram1 unmanaged:yes} [current_design]
current_instance inst/u_fec_rx/u_deinterleaver/u_ram0
set_property src_info {type:SCOPED_XDC file:1 line:55 export:INPUT save:NONE read:READ} [current_design]
set my_var [get_property dram_emb_xdc [get_cells -quiet -hier -filter {PRIMITIVE_SUBGROUP==LUTRAM || PRIMITIVE_SUBGROUP==dram || PRIMITIVE_SUBGROUP==uram || PRIMITIVE_SUBGROUP==BRAM}]]
current_instance
current_instance inst/u_fec_rx/u_deinterleaver/u_ram1
set_property src_info {type:SCOPED_XDC file:2 line:55 export:INPUT save:NONE read:READ} [current_design]
set my_var [get_property dram_emb_xdc [get_cells -quiet -hier -filter {PRIMITIVE_SUBGROUP==LUTRAM || PRIMITIVE_SUBGROUP==dram || PRIMITIVE_SUBGROUP==uram || PRIMITIVE_SUBGROUP==BRAM}]]
