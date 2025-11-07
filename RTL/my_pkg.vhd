----------------------------------------------------------------------------------
-- Company: 
-- Engineer:Riccardo De Leoni 
-- 
-- Create Date: 03.11.2025 16:01:44
-- Design Name: 
-- Module Name: my_pkg
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: A package containing custom functions and types
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
package my_pkg is 
--  CUSTOM FUNCTIONS
    function log2(i:natural) return natural;    --math function to compute ceil log2
    function arith_shift_right (                --function to compute arithmetic right shift
        to_shift : std_logic_vector;
        shift_val: std_logic_vector
    ) return std_logic_vector;
    function mux2(                              -- easy way to create a 2 input mux
        in1: std_logic_vector;
        in2: std_logic_vector;
        sel: std_logic
    )return std_logic_vector;
--  CUSTOM TYPES    
    --  "Memory array" : used to declare memories
    type memory_array is array (natural range <>) of std_logic_vector;   
end package ;

package body my_pkg is
----------------------------------------------------------------------------------
--LOG2
  -- Log2. Since the input is a positive integer,
  -- the return value is 'floor(log2(x))'.
    function log2(i  : natural) return natural is
        variable temp    : natural := i;
        variable ret_val : natural := 0;
    begin
        while temp > 1 loop
            ret_val := ret_val + 1;
            temp    := temp / 2;
        end loop;
        return ret_val;
    end function;
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
--ARITHMETIC RIGHT SHIFT  
   function arith_shift_right (
        to_shift : std_logic_vector;
        shift_val: std_logic_vector
    ) return std_logic_vector is
        variable shift_amount : integer;
        variable temp_signed  : signed(to_shift'range);
    begin
        shift_amount := to_integer(unsigned(shift_val));
        temp_signed  := signed(to_shift);
    return std_logic_vector(shift_right(temp_signed, shift_amount));
    end function;
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- MUX2
    function mux2 (
        in1: std_logic_vector;
        in2: std_logic_vector;
        sel: std_logic   
    ) return std_logic_vector is
    begin
        case sel is
            when '1'    => return(in1);
            when others => return(in2);
        end case;
    end function;
    
end package body;
