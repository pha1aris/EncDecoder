# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "CYCLES_PER_PAK" -parent ${Page_0}


}

proc update_PARAM_VALUE.CYCLES_PER_PAK { PARAM_VALUE.CYCLES_PER_PAK } {
	# Procedure called to update CYCLES_PER_PAK when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CYCLES_PER_PAK { PARAM_VALUE.CYCLES_PER_PAK } {
	# Procedure called to validate CYCLES_PER_PAK
	return true
}


proc update_MODELPARAM_VALUE.CYCLES_PER_PAK { MODELPARAM_VALUE.CYCLES_PER_PAK PARAM_VALUE.CYCLES_PER_PAK } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CYCLES_PER_PAK}] ${MODELPARAM_VALUE.CYCLES_PER_PAK}
}

