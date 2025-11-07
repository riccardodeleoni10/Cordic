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
use std.textio.all;
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
        ROM_FILE : string   := "data.txt"; -- give the complete path, read REMIND down below;
        USE_OFFSET: string  := "yes" --or yes
      );
--REMIND : if the file.txt isn't in the same directory of the project and if you don't give the complete path,
--          is it possible to have scope issues and it won't be possible to read the file
      Port ( 
        clk,enable,reset: in std_logic;
        load            : in std_logic;
        addr_start      : in std_logic_vector (log2(natural(ROM_SIZE))-1 downto 0);
        offset          : in std_logic_vector(log2(natural(ROM_SIZE))-1 downto 0);
        data_out        : out std_logic_vector(DATA_WIDTH-1 downto 0)
      );
end generic_ROM;
-- The ROM self increment the addr_start, is it possible to set an offset to specify when the addresse must restart,
-- if you want to use the entire ROM modify the generic;
architecture Behavioral of generic_ROM is
--Function to read a file and fill the ROM
    impure function init_ROM(init_File: string) return memory_array is
            file     rom_File     : text open read_mode is init_FILE;
            variable file_Line    : line;
            variable rom          : memory_array(0 to ROM_SIZE-1)(DATA_WIDTH-1 downto 0);
            variable temp         : bit_vector(DATA_WIDTH-1 downto 0);
        begin
            for i in 0 to ROM_SIZE -1 loop
                readline(rom_File,file_Line);
                read(file_Line,temp);
                rom(i):= to_stdlogicvector(temp);
            end loop;
         return rom;
    end function;
--Signals
    signal ROM           : memory_array(0 to ROM_SIZE-1)(DATA_WIDTH-1 downto 0) := init_ROM(ROM_FILE);
    signal cnt           : unsigned(log2(natural(ROM_SIZE))-1 downto 0);
    signal last_addr     : unsigned(log2(natural(ROM_SIZE))-1 downto 0);
    signal offset_reg    : std_logic_vector(log2(natural(ROM_SIZE))-1 downto 0);
    signal addr_start_reg: std_logic_vector(log2(natural(ROM_SIZE))-1 downto 0); 
begin

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- ROM with custimizable start addresse and offset
 
WithOffset_GEN: if USE_OFFSET = "yes" generate
    init_process: process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then 
                addr_start_reg<=(others=> '0');
                offset_reg    <=(others => '0');
            elsif enable = '1' and load = '1' then
                addr_start_reg <= addr_start;
                offset_reg     <= offset;
            else
                addr_start_reg <= addr_start_reg;
                offset_reg     <= offset_reg;
            end if;
        end if;
    end process;
    last_addr <= unsigned(offset_reg) + unsigned(addr_start_reg);
    addr_gen_proc: process(clk)
    begin
        if rising_edge(clk) then 
            if reset = '1' then
               cnt<= unsigned(addr_start_reg);
            elsif enable = '1' and load = '1' then
                    cnt <= unsigned(addr_start_reg);
            elsif enable = '1' and load = '0' then 
                    if cnt = last_addr then
                        cnt <=unsigned(addr_start_reg);
                    else
                        cnt<= cnt + 1;
                end if;
            end if;
        end if;
    end process;
    data_out_proc:process(clk)
        begin
            if rising_edge (clk) then 
                if enable = '1' and load = '0' then
                    data_out <= rom(TO_INTEGER(cnt));
                end if;
            end if;
        end process;
end generate;
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Normal self incrementing ROM
    --You have to comment "offset" in the entity or stuck it at zero;
    --You have to comment "addr" in the entity;
    --You have to comment "load" in the entity;
Normal_ROM_GEN  : if USE_OFFSET = "no" generate
    
    addr_gen_proc: process(clk)
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
