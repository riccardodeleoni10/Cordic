This folder contains all the RTL files,written in VHDL language.
A brief description of all the components is shown below:
- [XY_unit](https://github.com/riccardodeleoni10/Cordic/tree/main/RTL/XY_unit.vhd) : performs the iterative computation on the X,Y coordinates.
- Z_unit  : performs the iterative computation on the Z coordinate.
- CU: the control unit is the head of the system. It controls the initial value, the modes of the Cordic (rotational or vectoring) ,the control circuitry for the ALU and the computation of ROM's addresses (also managing multiple iterations reguired for the hyperbolic cooridinates)
- ROM: Custom and full reconfigurable ROM which stores all the precomputed angles used by the logic. See [generic_ROM.vhd](https://github.com/riccardodeleoni10/VHDL-IP/blob/main/Memory/ROM/generic_ROM.vhd) for a detailed explanation.
