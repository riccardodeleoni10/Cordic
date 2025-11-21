----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.11.2025 14:44:19
-- Design Name: 
-- Module Name: Cordic_top - Structural
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
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
library work;
use work.my_pkg.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Cordic_top is
      Port ( 
        clk,reset,start: in std_logic;
        z_input: in std_logic_vector(15 downto 0);
        x_init: in std_logic_vector(15 downto 0);
        y_init: in std_logic_vector(15 downto 0);
        --init_sel: std_logic;
        dv: out std_logic;
        out_value1: out std_logic_vector(15 downto 0);
        out_value2: out std_logic_vector(15 downto 0);
        out_value3: out std_logic_vector(15 downto 0)
      );
end Cordic_top;

architecture Structural of Cordic_top is
signal sign_z_sig : std_logic;
signal alu_ctrl: std_logic_vector(1 downto 0);
signal from_cnt: std_logic_vector(3 downto 0);
signal from_rom_sig: std_logic_vector(15 downto 0);
begin
XY_unit: entity work.XY_Unit(Strutturale) port map(
        clk => clk,
        reset => reset,
        x_init => x_init,
        y_init => y_init,
        init_sel  => start,
        alu_ctrl  => alu_ctrl,
        mode      => '0',
        n_shift   => from_cnt,
        x_out => out_value1,
        y_out => out_value2
    );
Z_Unit: entity work.Z_Unit(Behavioral_Iterative) port map (
         clk      => clk,
        reset     => reset,
        value_sel => start,                      -- choose between init value or iterated value
        from_rom  => from_rom_sig ,    
        init_value => z_input,   -- initial value
        sign_z => sign_z_sig,                      -- Used by the CU to control the iterations
        z_out  => out_value3  
);
alu_ctrl<=(not(sign_z_sig), sign_z_sig);
counter_CU: entity work.counter_CU(Behavioral) port map (
        clk      => clk,
        reset   => reset,
        start    => start,
        hyp_mode => '0',
        dv      => dv,
        cnt_out => from_cnt
);
ROM: entity work.generic_ROM(Behavioral) generic map(
        DATA_WIDTH => 16,
        ROM_SIZE  => 16,
        ROM_FILE  =>  "C:\Users\Riccardo\Documents\Progetti_personali\Cordic\angles.txt", -- give the complete path, read REMIND down below;
        USE_OFFSET =>  "no" --or yes
        ) 
        port map (
        clk        => clk,
        enable      => '1',
        reset => reset,
        load   => '0',
        addr_start => (others => '0'),
        offset     => (others => '0'),
        data_out   => from_rom_sig
        );
end Structural;
