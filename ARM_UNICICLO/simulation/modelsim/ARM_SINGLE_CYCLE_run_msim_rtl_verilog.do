transcript on
if ![file isdirectory verilog_libs] {
	file mkdir verilog_libs
}

vlib verilog_libs/altera_ver
vmap altera_ver ./verilog_libs/altera_ver
vlog -vlog01compat -work altera_ver {c:/intelfpga_lite/21.1/quartus/eda/sim_lib/altera_primitives.v}

vlib verilog_libs/lpm_ver
vmap lpm_ver ./verilog_libs/lpm_ver
vlog -vlog01compat -work lpm_ver {c:/intelfpga_lite/21.1/quartus/eda/sim_lib/220model.v}

vlib verilog_libs/sgate_ver
vmap sgate_ver ./verilog_libs/sgate_ver
vlog -vlog01compat -work sgate_ver {c:/intelfpga_lite/21.1/quartus/eda/sim_lib/sgate.v}

vlib verilog_libs/altera_mf_ver
vmap altera_mf_ver ./verilog_libs/altera_mf_ver
vlog -vlog01compat -work altera_mf_ver {c:/intelfpga_lite/21.1/quartus/eda/sim_lib/altera_mf.v}

vlib verilog_libs/altera_lnsim_ver
vmap altera_lnsim_ver ./verilog_libs/altera_lnsim_ver
vlog -sv -work altera_lnsim_ver {c:/intelfpga_lite/21.1/quartus/eda/sim_lib/altera_lnsim.sv}

vlib verilog_libs/cyclonev_ver
vmap cyclonev_ver ./verilog_libs/cyclonev_ver
vlog -vlog01compat -work cyclonev_ver {c:/intelfpga_lite/21.1/quartus/eda/sim_lib/mentor/cyclonev_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_ver {c:/intelfpga_lite/21.1/quartus/eda/sim_lib/mentor/cyclonev_hmi_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_ver {c:/intelfpga_lite/21.1/quartus/eda/sim_lib/cyclonev_atoms.v}

vlib verilog_libs/cyclonev_hssi_ver
vmap cyclonev_hssi_ver ./verilog_libs/cyclonev_hssi_ver
vlog -vlog01compat -work cyclonev_hssi_ver {c:/intelfpga_lite/21.1/quartus/eda/sim_lib/mentor/cyclonev_hssi_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_hssi_ver {c:/intelfpga_lite/21.1/quartus/eda/sim_lib/cyclonev_hssi_atoms.v}

vlib verilog_libs/cyclonev_pcie_hip_ver
vmap cyclonev_pcie_hip_ver ./verilog_libs/cyclonev_pcie_hip_ver
vlog -vlog01compat -work cyclonev_pcie_hip_ver {c:/intelfpga_lite/21.1/quartus/eda/sim_lib/mentor/cyclonev_pcie_hip_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_pcie_hip_ver {c:/intelfpga_lite/21.1/quartus/eda/sim_lib/cyclonev_pcie_hip_atoms.v}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/carlo/OneDrive/Escritorio/proyectogrupal1/ARM_UNICICLO {C:/Users/carlo/OneDrive/Escritorio/proyectogrupal1/ARM_UNICICLO/alu_defs.sv}
vlog -sv -work work +incdir+C:/Users/carlo/OneDrive/Escritorio/proyectogrupal1/ARM_UNICICLO {C:/Users/carlo/OneDrive/Escritorio/proyectogrupal1/ARM_UNICICLO/arm.sv}
vlog -sv -work work +incdir+C:/Users/carlo/OneDrive/Escritorio/proyectogrupal1/ARM_UNICICLO {C:/Users/carlo/OneDrive/Escritorio/proyectogrupal1/ARM_UNICICLO/controller.sv}
vlog -sv -work work +incdir+C:/Users/carlo/OneDrive/Escritorio/proyectogrupal1/ARM_UNICICLO {C:/Users/carlo/OneDrive/Escritorio/proyectogrupal1/ARM_UNICICLO/decoder.sv}
vlog -sv -work work +incdir+C:/Users/carlo/OneDrive/Escritorio/proyectogrupal1/ARM_UNICICLO {C:/Users/carlo/OneDrive/Escritorio/proyectogrupal1/ARM_UNICICLO/condlogic.sv}
vlog -sv -work work +incdir+C:/Users/carlo/OneDrive/Escritorio/proyectogrupal1/ARM_UNICICLO {C:/Users/carlo/OneDrive/Escritorio/proyectogrupal1/ARM_UNICICLO/condcheck.sv}
vlog -sv -work work +incdir+C:/Users/carlo/OneDrive/Escritorio/proyectogrupal1/ARM_UNICICLO {C:/Users/carlo/OneDrive/Escritorio/proyectogrupal1/ARM_UNICICLO/datapath.sv}
vlog -sv -work work +incdir+C:/Users/carlo/OneDrive/Escritorio/proyectogrupal1/ARM_UNICICLO {C:/Users/carlo/OneDrive/Escritorio/proyectogrupal1/ARM_UNICICLO/regfile.sv}
vlog -sv -work work +incdir+C:/Users/carlo/OneDrive/Escritorio/proyectogrupal1/ARM_UNICICLO {C:/Users/carlo/OneDrive/Escritorio/proyectogrupal1/ARM_UNICICLO/adder.sv}
vlog -sv -work work +incdir+C:/Users/carlo/OneDrive/Escritorio/proyectogrupal1/ARM_UNICICLO {C:/Users/carlo/OneDrive/Escritorio/proyectogrupal1/ARM_UNICICLO/extend.sv}
vlog -sv -work work +incdir+C:/Users/carlo/OneDrive/Escritorio/proyectogrupal1/ARM_UNICICLO {C:/Users/carlo/OneDrive/Escritorio/proyectogrupal1/ARM_UNICICLO/flopr.sv}
vlog -sv -work work +incdir+C:/Users/carlo/OneDrive/Escritorio/proyectogrupal1/ARM_UNICICLO {C:/Users/carlo/OneDrive/Escritorio/proyectogrupal1/ARM_UNICICLO/mux2.sv}
vlog -sv -work work +incdir+C:/Users/carlo/OneDrive/Escritorio/proyectogrupal1/ARM_UNICICLO {C:/Users/carlo/OneDrive/Escritorio/proyectogrupal1/ARM_UNICICLO/top.sv}
vlog -sv -work work +incdir+C:/Users/carlo/OneDrive/Escritorio/proyectogrupal1/ARM_UNICICLO {C:/Users/carlo/OneDrive/Escritorio/proyectogrupal1/ARM_UNICICLO/flopenr.sv}
vlog -sv -work work +incdir+C:/Users/carlo/OneDrive/Escritorio/proyectogrupal1/ARM_UNICICLO {C:/Users/carlo/OneDrive/Escritorio/proyectogrupal1/ARM_UNICICLO/arith_unit.sv}
vlog -sv -work work +incdir+C:/Users/carlo/OneDrive/Escritorio/proyectogrupal1/ARM_UNICICLO {C:/Users/carlo/OneDrive/Escritorio/proyectogrupal1/ARM_UNICICLO/alu.sv}
vlog -sv -work work +incdir+C:/Users/carlo/OneDrive/Escritorio/proyectogrupal1/ARM_UNICICLO {C:/Users/carlo/OneDrive/Escritorio/proyectogrupal1/ARM_UNICICLO/dmem.sv}
vlog -sv -work work +incdir+C:/Users/carlo/OneDrive/Escritorio/proyectogrupal1/ARM_UNICICLO {C:/Users/carlo/OneDrive/Escritorio/proyectogrupal1/ARM_UNICICLO/imem.sv}

vlog -sv -work work +incdir+C:/Users/carlo/OneDrive/Escritorio/proyectogrupal1/ARM_UNICICLO {C:/Users/carlo/OneDrive/Escritorio/proyectogrupal1/ARM_UNICICLO/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run -all
