This folder contains all the RTL files,written in VHDL language.
A brief description of all the components is shown below:
- [XY_unit](https://github.com/riccardodeleoni10/Cordic/tree/main/RTL/XY_unit.vhd) : performs the iterative computation on the X,Y coordinates.
- [Z_unit](https://github.com/riccardodeleoni10/Cordic/edit/main/RTL/Z_Unit.vhd)  : performs the iterative computation on the Z coordinate.
- [CU](https://github.com/riccardodeleoni10/Cordic/edit/main/RTL/counter.vhd): the control unit is the head of the system. It controls the initial value, the modes of the Cordic (rotational or vectoring) ,the control circuitry for the ALU and the computation of ROM's addresses (also managing multiple iterations reguired for the hyperbolic cooridinates)
- [Precomputed Angles ROM](https://github.com/riccardodeleoni10/Cordic/edit/main/RTL/Generic_ROM.vhd): Custom and full reconfigurable ROM which stores all the precomputed angles used by the logic. See [generic_ROM.vhd](https://github.com/riccardodeleoni10/VHDL-IP/blob/main/Memory/ROM/generic_ROM.vhd) in  repository for a detailed explanation.
