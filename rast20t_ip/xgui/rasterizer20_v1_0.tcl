# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "SCREEN_HEIGHT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SCREEN_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "TRIANGLE_COUNT" -parent ${Page_0}


}

proc update_PARAM_VALUE.SCREEN_HEIGHT { PARAM_VALUE.SCREEN_HEIGHT } {
	# Procedure called to update SCREEN_HEIGHT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SCREEN_HEIGHT { PARAM_VALUE.SCREEN_HEIGHT } {
	# Procedure called to validate SCREEN_HEIGHT
	return true
}

proc update_PARAM_VALUE.SCREEN_WIDTH { PARAM_VALUE.SCREEN_WIDTH } {
	# Procedure called to update SCREEN_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SCREEN_WIDTH { PARAM_VALUE.SCREEN_WIDTH } {
	# Procedure called to validate SCREEN_WIDTH
	return true
}

proc update_PARAM_VALUE.TRIANGLE_COUNT { PARAM_VALUE.TRIANGLE_COUNT } {
	# Procedure called to update TRIANGLE_COUNT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TRIANGLE_COUNT { PARAM_VALUE.TRIANGLE_COUNT } {
	# Procedure called to validate TRIANGLE_COUNT
	return true
}


proc update_MODELPARAM_VALUE.SCREEN_WIDTH { MODELPARAM_VALUE.SCREEN_WIDTH PARAM_VALUE.SCREEN_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SCREEN_WIDTH}] ${MODELPARAM_VALUE.SCREEN_WIDTH}
}

proc update_MODELPARAM_VALUE.SCREEN_HEIGHT { MODELPARAM_VALUE.SCREEN_HEIGHT PARAM_VALUE.SCREEN_HEIGHT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SCREEN_HEIGHT}] ${MODELPARAM_VALUE.SCREEN_HEIGHT}
}

proc update_MODELPARAM_VALUE.TRIANGLE_COUNT { MODELPARAM_VALUE.TRIANGLE_COUNT PARAM_VALUE.TRIANGLE_COUNT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TRIANGLE_COUNT}] ${MODELPARAM_VALUE.TRIANGLE_COUNT}
}

