library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter_CU is
    Port (
        clk      : in  std_logic;
        reset    : in  std_logic;
        start    : in  std_logic;
        hyp_mode : in  std_logic;
        dv       : out std_logic;
        cnt_out  : out std_logic_vector(15 downto 0)
    );
end counter_CU;

architecture Behavioral of counter_CU is
    type t_state is (IDLE, CNT_till3, CNT_4, CNT_till12, CNT_13, END_CNT, DONE);
    signal state, next_state : t_state;

    signal cnt, next_cnt : unsigned(15 downto 0);
    signal double_cnt, next_double_cnt : unsigned(1 downto 0);
    signal dv_reg, next_dv : std_logic;
begin
seq_proc: process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state        <= IDLE;
                cnt          <= (others => '0');
                double_cnt   <= (others => '0');
                dv_reg       <= '0';
            else
                state        <= next_state;
                cnt          <= next_cnt;
                double_cnt   <= next_double_cnt;
                dv_reg       <= next_dv;
            end if;
        end if;
    end process;
comb_proc: process(all)
begin
    next_state         <= state;
    next_cnt           <= cnt;
    next_double_cnt    <= double_cnt;
    next_dv            <= '0';  

    case state is
        when IDLE        =>   next_dv <= '0';
                              if start = '1' then
                                  next_state <= CNT_till3;
                              else
                                  next_state <= IDLE;
                              end if;
            
        when CNT_till3   =>   if to_integer(cnt) = 3 then
                                    next_state <= CNT_4;
                                    next_cnt <= cnt+1;
                                else
                                    next_cnt <= cnt + 1;
                                    next_state <= CNT_till3;
                                end if;
                    
        when CNT_4       =>   if hyp_mode = '0' then
                                    next_cnt <= cnt + 1;
                                    next_state <= CNT_till12;
                                else
                                    if to_integer(double_cnt) = 1 then
                                        next_state <= CNT_till12;
                                        next_cnt <= cnt + 1;
                                    else
                                        next_double_cnt <= double_cnt + 1;
                                        next_state <= CNT_4;
                                    end if;
                                end if;
        
        when CNT_till12  =>     if to_integer(cnt) = 12 then
                                    next_state <= CNT_13;
                                    next_cnt <= cnt+1;
                                else
                                    next_cnt <= cnt + 1;
                                    next_state <= CNT_till12;
                                end if;

        when CNT_13      =>       if hyp_mode = '0' then
                                    next_cnt <= cnt + 1;
                                    next_state <= END_CNT;
                                elsif
                                     to_integer(double_cnt) = 2 then
                                        next_double_cnt <= (others => '0');
                                        next_state <= END_CNT;
                                        next_cnt <= cnt + 1; -- se vuoi avanzare qui
                                    else
                                        next_double_cnt <= double_cnt + 1;
                                        next_state <= CNT_13;
                                 end if;
                                 
        when END_CNT     =>     if to_integer(cnt) = 15 then
                                    next_state <= DONE;
                                    next_cnt <= (others => '0');
                                else
                                    next_cnt <= cnt + 1;
                                    next_state <= END_CNT;
                                end if;

        when DONE        =>     next_dv <= '1';
                                next_state <= IDLE;
                                next_cnt <= (others => '0');
                                next_double_cnt <= (others => '0');
                    
        when others      =>     next_state <= IDLE;
                                next_cnt <= (others => '0');
                                next_double_cnt <= (others => '0');
                                next_dv <= '0';
    end case;
end process ;

cnt_out <= std_logic_vector(cnt);
dv <= dv_reg;

end Behavioral;
