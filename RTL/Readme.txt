This folder contains all the RTL files,written in VHDL language.
A brief description of all the components is shown below:
- XY_unit : performs the iterative computation on the X,Y coordinates.
- Z_unit  : performs the iterative computation on the X,Y coordinates.
- CU: the control unit is the head of the system. It controlls the initial value, the mode of the Cordic (rotational or vectoring) and the controll circuitry for the   ALU
- ROM: Custom and full reconfigurable ROM which stores all the precomputed angles used by the logic. See Generic_ROM.vhd for a detailed explanation.
