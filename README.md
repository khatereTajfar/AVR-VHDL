# AVR-VHDL
Implementation of AVR Atmeg32 using VHDL
## Background
As we all are familiar with the AVR families from the microcontrollers and assembly language course, AVR is a family of microcontrollers which was developed by Atmel and in addition has numerous applications in the field of industry .put simply it has been used in various automotive applications such as security, safety, powertrain, and entertainment systems to name a few. With the growing popularity of FPGAs among the open source community, people have started developing open source processors compatible with the AVR instruction set. The main and the most significant difference between the microcontroller and the FPGA is that FPGA doesn’t have a fixed hardware structure, on the contrary, it is programmable according to user applications. However, processors have a fixed hardware structure. It means that all the transistors memory, peripheral structures, and the connections are constant. Operations which processor can do (addition, multiplication, I/O control, etc.) are predefined. And users make the processor do these operations "in a sequential manner" by using the software, in accordance with their own purposes.
Hardware structure in the FPGA is not fixed so it is defined by the user. Although logic cells are fixed in FPGA, functions they perform and the interconnections between them are determined by the user. So operations that FPGAs can do are not predefined. You can have the processes done according to the written HDL code "in parallel" which means simultaneously. The ability of parallel processing is one of the most important features that separate FPGA from a processor and make it superior in many areas. So having looked at the positives of FPGAs we are looking forward to implementing an AVR core using VHDL in order to achieve a higher speed of instruction execution via deeper pipelining.
## Objectives
·        Completely compatible with ATMega32 in terms of 32 KByte ROM, 2 KByte SRAM, 32 Byte GPR
·       Configurable enough to be able to simulate at least 20 key instructions of  AVR family controllers. 
· 	 Implement pipeline with a depth of two instructions.
·       Execute every instruction in one clock cycle.
·       Have two Words instructions.
·       Capable to execute the compiled instructions in the AVR Studio software.

## Steps
Our first step to reach our goal is to implement the ALU which gets two 8 bits inputs directly from the registers and doing the proper operation according to the controller bits. To improve the speed, this module will be designed in a combinational manner.
Our second important module is Controller Unit which will be designed in a behavioral manner and will be connected to ALU, PROM, SRAM  and other side modules.
PROM and SRAM will be also designed in a behavioral manner.



## Scope
Ultimately we expect to compile an assembly code in AVR Studio and give the HEX file which has been generated after compiling to the PROM and see the operation of the ALU with pipelining!

