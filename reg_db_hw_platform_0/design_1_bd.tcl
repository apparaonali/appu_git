
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2015.3
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl

# If you do not already have a project created,
# you can create a project using the following command:
#    create_project project_1 myproj -part xc7z020clg484-1
#    set_property BOARD_PART xilinx.com:zc702:part0:1.2 [current_project]

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}



# CHANGE DESIGN NAME HERE
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "ERROR: Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      puts "INFO: Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   puts "INFO: Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   puts "INFO: Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   puts "INFO: Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

puts "INFO: Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   puts $errMsg
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]
  set gpio_sw [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio_sw ]
  set iic_main [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_main ]

  # Create ports
  set can_phy_rx [ create_bd_port -dir I can_phy_rx ]
  set can_phy_tx [ create_bd_port -dir O can_phy_tx ]

  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [ list CONFIG.C_INTERRUPT_PRESENT {1} CONFIG.GPIO_BOARD_INTERFACE {gpio_sw} CONFIG.USE_BOARD_FLOW {true}  ] $axi_gpio_0

  # Create instance: axi_iic_0, and set properties
  set axi_iic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_0 ]
  set_property -dict [ list CONFIG.IIC_BOARD_INTERFACE {iic_main} CONFIG.USE_BOARD_FLOW {true}  ] $axi_iic_0

  # Create instance: canfd_0, and set properties
  set canfd_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:canfd:1.0 canfd_0 ]

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list CONFIG.PCW_EN_CLK1_PORT {1} CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {100} CONFIG.PCW_IRQ_F2P_INTR {1} CONFIG.PCW_USE_FABRIC_INTERRUPT {1} CONFIG.preset {ZC702}  ] $processing_system7_0

  # Create instance: processing_system7_0_axi_periph, and set properties
  set processing_system7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 processing_system7_0_axi_periph ]
  set_property -dict [ list CONFIG.NUM_MI {3}  ] $processing_system7_0_axi_periph

  # Create instance: rst_processing_system7_0_100M, and set properties
  set rst_processing_system7_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processing_system7_0_100M ]

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list CONFIG.NUM_PORTS {3}  ] $xlconcat_0

  # Create interface connections
  connect_bd_intf_net -intf_net axi_gpio_0_GPIO [get_bd_intf_ports gpio_sw] [get_bd_intf_pins axi_gpio_0/GPIO]
  connect_bd_intf_net -intf_net axi_iic_0_IIC [get_bd_intf_ports iic_main] [get_bd_intf_pins axi_iic_0/IIC]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins processing_system7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M00_AXI [get_bd_intf_pins canfd_0/CAN_S_AXI_LITE] [get_bd_intf_pins processing_system7_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M01_AXI [get_bd_intf_pins axi_iic_0/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M02_AXI [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M02_AXI]

  # Create port connections
  connect_bd_net -net axi_gpio_0_ip2intc_irpt [get_bd_pins axi_gpio_0/ip2intc_irpt] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net axi_iic_0_iic2intc_irpt [get_bd_pins axi_iic_0/iic2intc_irpt] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net can_phy_rx_1 [get_bd_ports can_phy_rx] [get_bd_pins canfd_0/can_phy_rx]
  connect_bd_net -net canfd_0_can_phy_tx [get_bd_ports can_phy_tx] [get_bd_pins canfd_0/can_phy_tx]
  connect_bd_net -net canfd_0_ip2bus_intrevent [get_bd_pins canfd_0/ip2bus_intrevent] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins axi_iic_0/s_axi_aclk] [get_bd_pins canfd_0/s_axi_aclk] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0_axi_periph/ACLK] [get_bd_pins processing_system7_0_axi_periph/M00_ACLK] [get_bd_pins processing_system7_0_axi_periph/M01_ACLK] [get_bd_pins processing_system7_0_axi_periph/M02_ACLK] [get_bd_pins processing_system7_0_axi_periph/S00_ACLK] [get_bd_pins rst_processing_system7_0_100M/slowest_sync_clk]
  connect_bd_net -net processing_system7_0_FCLK_CLK1 [get_bd_pins canfd_0/can_clk] [get_bd_pins processing_system7_0/FCLK_CLK1]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_processing_system7_0_100M/ext_reset_in]
  connect_bd_net -net rst_processing_system7_0_100M_interconnect_aresetn [get_bd_pins processing_system7_0_axi_periph/ARESETN] [get_bd_pins rst_processing_system7_0_100M/interconnect_aresetn]
  connect_bd_net -net rst_processing_system7_0_100M_peripheral_aresetn [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins axi_iic_0/s_axi_aresetn] [get_bd_pins canfd_0/s_axi_aresetn] [get_bd_pins processing_system7_0_axi_periph/M00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M01_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M02_ARESETN] [get_bd_pins processing_system7_0_axi_periph/S00_ARESETN] [get_bd_pins rst_processing_system7_0_100M/peripheral_aresetn]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins processing_system7_0/IRQ_F2P] [get_bd_pins xlconcat_0/dout]

  # Create address segments
  create_bd_addr_seg -range 0x10000 -offset 0x41200000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] SEG_axi_gpio_0_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x41600000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_iic_0/S_AXI/Reg] SEG_axi_iic_0_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C00000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs canfd_0/S_AXI_LITE/Reg] SEG_canfd_0_Reg

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.5.4  2015-05-29 bk=1.3352 VDI=38 GEI=35 GUI=JA:1.8
#  -string -flagsOSRD
preplace port DDR -pg 1 -y 480 -defaultsOSRD
preplace port can_phy_rx -pg 1 -y 350 -defaultsOSRD
preplace port gpio_sw -pg 1 -y 200 -defaultsOSRD
preplace port iic_main -pg 1 -y 70 -defaultsOSRD
preplace port FIXED_IO -pg 1 -y 500 -defaultsOSRD
preplace port can_phy_tx -pg 1 -y 410 -defaultsOSRD
preplace portBus GPIO -pg 1 -y 690 -defaultsOSRD
preplace inst axi_iic_0 -pg 1 -lvl 4 -y 90 -defaultsOSRD
preplace inst xlconstant_0 -pg 1 -lvl 4 -y 690 -defaultsOSRD
preplace inst rst_processing_system7_0_100M -pg 1 -lvl 2 -y 240 -defaultsOSRD
preplace inst xlconcat_0 -pg 1 -lvl 1 -y 280 -defaultsOSRD
preplace inst axi_gpio_0 -pg 1 -lvl 4 -y 210 -defaultsOSRD
preplace inst canfd_0 -pg 1 -lvl 4 -y 390 -defaultsOSRD
preplace inst processing_system7_0_axi_periph -pg 1 -lvl 3 -y 170 -defaultsOSRD
preplace inst processing_system7_0 -pg 1 -lvl 2 -y 570 -defaultsOSRD
preplace netloc processing_system7_0_DDR 1 2 3 NJ 480 NJ 480 NJ
preplace netloc processing_system7_0_axi_periph_M00_AXI 1 3 1 980
preplace netloc axi_iic_0_iic2intc_irpt 1 0 5 20 10 NJ 10 NJ 10 NJ 10 1340
preplace netloc processing_system7_0_M_AXI_GP0 1 2 1 630
preplace netloc processing_system7_0_FCLK_RESET0_N 1 1 2 240 340 620
preplace netloc canfd_0_ip2bus_intrevent 1 0 5 40 360 NJ 360 NJ 360 NJ 300 1330
preplace netloc processing_system7_0_axi_periph_M02_AXI 1 3 1 N
preplace netloc rst_processing_system7_0_100M_peripheral_aresetn 1 2 2 670 340 1010
preplace netloc xlconcat_0_dout 1 1 1 220
preplace netloc xlconstant_0_dout 1 4 1 NJ
preplace netloc processing_system7_0_FIXED_IO 1 2 3 NJ 500 NJ 500 NJ
preplace netloc axi_iic_0_IIC 1 4 1 NJ
preplace netloc axi_gpio_0_GPIO 1 4 1 NJ
preplace netloc axi_gpio_0_ip2intc_irpt 1 0 5 30 150 NJ 150 NJ 330 NJ 280 1340
preplace netloc rst_processing_system7_0_100M_interconnect_aresetn 1 2 1 640
preplace netloc processing_system7_0_FCLK_CLK0 1 1 3 230 330 650 390 990
preplace netloc processing_system7_0_FCLK_CLK1 1 2 3 NJ 640 NJ 640 1320
preplace netloc canfd_0_can_phy_tx 1 4 1 NJ
preplace netloc can_phy_rx_1 1 0 5 NJ 350 NJ 350 NJ 350 NJ 290 1340
preplace netloc processing_system7_0_axi_periph_M01_AXI 1 3 1 970
levelinfo -pg 1 0 130 430 820 1170 1360 -top 0 -bot 740
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


