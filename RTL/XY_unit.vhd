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
-- Description: Hardware to compute iteration for angle coordinate
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.my_pkg.all;

entity GenericXY_Unit is
  port (
     clk,reset  : in std_logic;
     init_value : in std_logic_vector(15 downto 0);
     init_sel   : in std_logic;
     alu_ctrl   : in std_logic;
     n_shift    : in std_logic_vector(5 downto 0);
     twin_input : in std_logic_vector(15 downto 0);
     shifted    : out std_logic_vector(15 downto 0);
     value_out  : out std_logic_vector(15 downto 0)
   ); 
end entity GenericXY_Unit;

architecture Behavioral_Iterative of GenericXY_Unit is
signal input_mux_out,value_iter,value_reg: std_logic_vector(15 downto 0);
begin
    input_mux_out<=mux2(init_value,value_iter,init_sel);
iteration_PROC: process(clk)
begin
    if rising_edge(clk) then
        if reset = '1' then
            value_reg <= (others => '0');
        else
            value_reg<= input_mux_out;
        end if;  
    end if;
end process;
ALU_Logic: process(alu_ctrl,twin_input,value_reg)
    variable signed_temp : signed(15 downto 0);
begin
    case alu_ctrl is 
        when '0'    => signed_temp := signed(value_reg) + signed(twin_input);
        when '1'    => signed_temp := signed(value_reg) - signed(twin_input);
        when others => signed_temp := (others => '-');
    end case;
    value_iter <= std_logic_vector(signed_temp);
end process;
value_out <= value_iter;
Shift_logic: process(value_reg,n_shift)
begin
    shifted <= arith_shift_right(value_reg,n_shift);
end process;
end Behavioral_Iterative;
-- End of the general architecture
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Structural
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.my_pkg.all;
entity XY_Unit is 
    port (
        clk,reset     : in std_logic;
        x_init,y_init : in std_logic_vector (15 downto 0);
        init_sel      : in std_logic;
        alu_ctrl      : in std_logic_vector(1 downto 0);
        mode          : in std_logic;
        n_shift       : in std_logic_vector(5 downto 0);
        x_out,y_out   : out std_logic_vector (15 downto 0)
    );
end entity XY_Unit;
architecture Strutturale of XY_Unit is 
signal fx2y, fy2x,y_shifted: std_logic_vector(15 downto 0);
begin

X_unit: entity work.GenericXY_Unit(Behavioral_Iterative) port map (
     clk        => clk,
     reset      => reset,
     init_value => x_init,
     init_sel   => init_sel,
     alu_ctrl   => alu_ctrl(0),
     n_shift    => n_shift,
     twin_input => fy2x,
     shifted    => fx2y,
     value_out  => x_out
);
Y_unit: entity work.GenericXY_Unit(Behavioral_Iterative) port map (
     clk        => clk,
     reset      => reset,
     init_value => y_init,
     init_sel   => init_sel,
     alu_ctrl   => alu_ctrl(1),
     n_shift    => n_shift,
     twin_input => fx2y,
     shifted    => y_shifted,
     value_out  => y_out
);
mode_control: process(mode,y_shifted)
    variable zeros :std_logic_vector(15 downto 0) := (others => '0');
begin
    fy2x<= mux2(y_shifted,zeros,mode);
end process;
end Strutturale;
