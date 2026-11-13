library ieee;
use ieee.std_logic_1164.all;

entity tb_jk_ff is
end entity tb_jk_ff;

architecture sim of tb_jk_ff is
    signal j, k, clk : std_logic := '0';
    signal clr       : std_logic := '1';
    signal q, qn     : std_logic;
begin
    uut : entity work.jk_ff port map(j => j, k => k, clk => clk, clr => clr, q => q, qn => qn);

    -- 20 ns clock period, rising edges at 10, 30, 50, ... ns
    clk_gen : process
    begin
        for i in 0 to 9 loop
            clk <= '0'; wait for 10 ns;
            clk <= '1'; wait for 10 ns;
        end loop;
        wait;
    end process;

    -- inputs change while clk = '0', between rising edges
    stim : process
    begin
        clr <= '1'; wait for 5 ns;            -- t=5   : initial clear -> Q=0
        assert q = '0' report "Clear failed" severity error;
        clr <= '0';
        j <= '1'; k <= '0'; wait for 20 ns;   -- edge 10 : Set     -> Q=1
        assert q = '1' report "Set failed" severity error;
        j <= '0'; k <= '0'; wait for 20 ns;   -- edge 30 : Hold    -> Q=1
        assert q = '1' report "Hold failed" severity error;
        j <= '0'; k <= '1'; wait for 20 ns;   -- edge 50 : Reset   -> Q=0
        assert q = '0' report "Reset failed" severity error;
        j <= '1'; k <= '1'; wait for 20 ns;   -- edge 70 : Toggle  -> Q=1
        assert q = '1' report "Toggle 1 failed" severity error;
        wait for 20 ns;                       -- edge 90 : Toggle  -> Q=0
        assert q = '0' report "Toggle 2 failed" severity error;
        wait for 20 ns;                       -- edge 110: Toggle  -> Q=1
        assert q = '1' report "Toggle 3 failed" severity error;
        j <= '0'; k <= '0'; wait for 20 ns;   -- edge 130: Hold    -> Q=1
        assert q = '1' report "Hold 2 failed" severity error;
        report "tb_jk_ff finished" severity note;
        wait;
    end process;
end architecture sim;
