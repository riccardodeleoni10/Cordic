-- Corretto: XY_Unit.vhd
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Riccardo De Leoni
-- 
-- Create Date: 31.10.2025
-- Module Name: XY_Unit - Behavioral
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 
library work;
    use work.my_pkg.all;
entity XY_Unit is
    Port ( 
        clk        : in  std_logic;
        reset      : in  std_logic;
        value_sel  : in  std_logic;                       -- choose between init value or iterated value
        alu_sel    : in  std_logic;                       -- choose whether add ('1') or subtract ('0')
        init_value : in  std_logic_vector(15 downto 0);   -- initial value
        from_shift : in  std_logic_vector(15 downto 0);   -- shifted value coming from the other processing unit
        shift_value: in std_logic_vector(4 downto 0);
        shifted    : out std_logic_vector(15 downto 0);   -- itereted value shifted by shift_value positions
        xy_out     : out std_logic_vector(15 downto 0)    -- output value
    );
end XY_Unit;

architecture Behavioral_Iterative of XY_Unit is
    signal input_mux_out : std_logic_vector(15 downto 0);
    signal xy_iter       : std_logic_vector(15 downto 0);
    signal xy_reg        : std_logic_vector(15 downto 0);
begin
-- input mux
input_mux_out <= init_value when value_sel = '1' else xy_iter;
Sequencial_Unit: process(clk)
begin
        if rising_edge(clk) then
            if reset = '1' then
                xy_reg <= (others => '0');
            else
                xy_reg <= input_mux_out;
            end if;
        end if;
end process Sequencial_Unit;

Logic_unit_1: process(xy_reg, alu_sel, from_shift)
    variable tmp_unsigned : unsigned(15 downto 0);
begin
    case alu_sel is
        when '1' =>  -- add
            tmp_unsigned := unsigned(xy_reg) + unsigned(from_shift);
            xy_iter <= std_logic_vector(tmp_unsigned);
        when '0' =>  -- subtract
            tmp_unsigned := unsigned(xy_reg) - unsigned(from_shift);
            xy_iter <= std_logic_vector(tmp_unsigned);
        when others =>
            xy_iter <= (others => '-');
    end case;
end process Logic_unit_1;
xy_out <= xy_iter;
Logic_unit_2: process(shift_value, xy_reg)
begin
    shifted <= arith_shift_right(xy_reg,shift_value);
end process;
end Behavioral_Iterative;
