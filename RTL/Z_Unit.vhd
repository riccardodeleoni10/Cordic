----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Riccardo De Leoni
-- 
-- Create Date: 02.11.2025 21:12:13
-- Design Name: 
-- Module Name: Z_Unit - Behavioral_Iterative
-- Project Name: Cordic
-- Target Devices: 
-- Tool Versions: 2023.2
-- Description: Hardware to compute iteration for the angle coordinate
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

entity Z_Unit is
      Port ( 
        clk        : in  std_logic;
        reset      : in  std_logic;
        value_sel  : in  std_logic;                       -- choose between init value or iterated value
        alu_sel    : in  std_logic;                       -- choose whether add ('1') or subtract ('0')
        from_rom   : in std_logic_vector(15 downto 0);      
        init_value : in  std_logic_vector(15 downto 0);   -- initial value
        ctrl_bit_z : out std_logic;                       -- Used by the CU to control the iterations
        z_out      : out std_logic_vector(15 downto 0)    -- output value
      );
end Z_Unit;

architecture Behavioral_Iterative of Z_Unit is
    signal z_reg: std_logic_vector(15 downto 0);
    signal input_mux_out: std_logic_vector(15 downto 0);
    signal z_iter: std_logic_vector(15 downto 0);
begin
    --input mux
    input_mux_out <= init_value when value_sel = '1' else z_iter;
Sequencial_Unit: process(clk)
begin
    if rising_edge(clk) then
        if reset = '1' then
            z_reg <= (others => '0');
        else 
            z_reg <= input_mux_out;
        end if;
    end if;
end process Sequencial_unit;
Logic_unit: process(z_reg,alu_sel,from_rom)
    variable unsigned_tmp: unsigned(15 downto 0) := (others => '0');
begin
    case alu_sel is
        when '1' => unsigned_tmp := unsigned(z_reg) + unsigned(from_rom);
        when '0' => unsigned_tmp := unsigned(z_reg) - unsigned(from_rom);
        when others => unsigned_tmp := (others => '-');
    end case;
        z_iter <= std_logic_vector(unsigned_tmp);
end process Logic_unit;
z_out<= z_iter;                                             --z_out assignment
ctrl_bit_z <= z_iter(15);                                   --control bit assignment
end Behavioral_Iterative;
