library ieee;
use ieee.std_logic_1164.all;

entity tb_d_ff is
end entity tb_d_ff;

architecture sim of tb_d_ff is
    signal d, clk : std_logic := '0';
    signal q, qn  : std_logic;
begin
    uut : entity work.d_ff port map(d => d, clk => clk, q => q, qn => qn);

    -- 20 ns clock period, rising edges at 10, 30, 50, ... ns
    clk_gen : process
    begin
        for i in 0 to 9 loop
            clk <= '0'; wait for 10 ns;
            clk <= '1'; wait for 10 ns;
        end loop;
        wait;
    end process;

    stim : process
    begin
        d <= '1'; wait for 15 ns;   -- t=15 : Q=1 after edge at 10 ns
        assert q = '1' report "edge 1 failed" severity error;
        d <= '0'; wait for 10 ns;   -- t=25 : D changed, no rising edge yet, Q must stay 1
        assert q = '1' report "Q changed without a rising edge" severity error;
        wait for 10 ns;             -- t=35 : edge at 30 ns, Q=0
        assert q = '0' report "edge 2 failed" severity error;
        d <= '1'; wait for 3 ns;    -- glitch on D between edges
        d <= '0'; wait for 3 ns;
        d <= '1'; wait for 3 ns;
        d <= '0'; wait for 3 ns;    -- t=47 : Q still 0
        assert q = '0' report "Q followed D between edges" severity error;
        d <= '1'; wait for 8 ns;    -- t=55 : edge at 50 ns, Q=1
        assert q = '1' report "edge 3 failed" severity error;
        report "tb_d_ff finished" severity note;
        wait;
    end process;
end architecture sim;
