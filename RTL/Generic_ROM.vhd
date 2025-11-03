----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.11.2025 13:38:42
-- Design Name: 
-- Module Name: generic_ROM - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
library work;
    use work.my_pkg.all;
entity generic_ROM is
      generic (
        DATA_WIDTH: integer := 16;
        ROM_SIZE  : integer := 16;
        FILE_PATH : string := "rom_init.txt";
        USE_OFFSET: string := "no" --or yes
      );
      Port ( 
        clk,enable,reset: in std_logic;
        addr_start: in std_logic_vector (log2(natural(ROM_SIZE))-1 downto 0);
        offset    : in std_logic_vector(log2(natural(ROM_SIZE))-1 downto 0);
        data_out  : out std_logic_vector(DATA_WIDTH-1 downto 0)
      );
end generic_ROM;
-- The ROM self increment the addr_start, is it possible to set an offset to specify when the addresse must restart,
-- if you want to use the entire ROM modify the generic;
architecture Behavioral of generic_ROM is
    signal ROM: memory_array(0 to ROM_SIZE-1)(DATA_WIDTH-1 downto 0);
    signal cnt: unsigned(log2(natural(ROM_SIZE))-1 downto 0);  
begin
-- Normal self incrementing ROM
    --You can comment "offset" in the entity or stuck it at zero;
Normal_ROM_GEN  : if USE_OFFSET = "no" generate
    
    addr_gen: process(clk)
    begin
        if rising_edge(clk) then 
            if reset = '1' then
               cnt<=(others => '0');
            elsif enable = '1' then
                if cnt = ROM_SIZE-1 then
                    cnt<=(others => '0');
                else
                    cnt<= cnt + 1;
                end if;
            end if;
        end if;
    end process;
    data_out_proc: process(clk)
    begin
        if rising_edge(clk) then
            if enable = '1' then
                data_out<= ROM(TO_INTEGER(cnt));
            end if; 
        end if;
    end process;
end generate;

end Behavioral;
