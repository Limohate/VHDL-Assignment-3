library ieee;
use ieee.std_logic_1164.all;

entity tb_d_ff_sc is
end entity tb_d_ff_sc;

architecture sim of tb_d_ff_sc is
    signal d, clk, set, clr : std_logic := '0';
    signal q, qn            : std_logic;
begin
    uut : entity work.d_ff_sc
        port map(d => d, clk => clk, set => set, clr => clr, q => q, qn => qn);

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
        -- 1) normal D FF operation
        d <= '1'; wait for 15 ns;              -- t=15 : edge 10 -> Q=1
        assert q = '1' report "normal D=1 failed" severity error;
        d <= '0'; wait for 20 ns;              -- t=35 : edge 30 -> Q=0
        assert q = '0' report "normal D=0 failed" severity error;

        -- 2) asynchronous Set (between clock edges, clk = '1')
        set <= '1'; wait for 2 ns;             -- t=37 : Q=1 immediately
        assert q = '1' report "async set failed" severity error;
        wait for 18 ns;                        -- t=55 : edge 50 ignored (D=0), Q stays 1
        assert q = '1' report "set did not override clock" severity error;
        set <= '0'; wait for 3 ns;             -- t=58

        -- 3) asynchronous Clear (clk = '1')
        d <= '1';
        clr <= '1'; wait for 2 ns;             -- t=60 : Q=0 immediately
        assert q = '0' report "async clear failed" severity error;
        wait for 15 ns;                        -- t=75 : edge 70 ignored (D=1), Q stays 0
        assert q = '0' report "clear did not override clock" severity error;

        -- 4) Set and Clear both active: Clear has priority
        set <= '1'; wait for 5 ns;             -- t=80
        assert q = '0' report "clear priority failed" severity error;
        clr <= '0'; wait for 2 ns;             -- t=82 : only Set left -> Q=1
        assert q = '1' report "set after clear release failed" severity error;
        set <= '0';

        -- 5) back to normal operation
        d <= '0'; wait for 13 ns;              -- t=95 : edge 90 -> Q=0
        assert q = '0' report "normal operation after set/clr failed" severity error;
        report "tb_d_ff_sc finished" severity note;
        wait;
    end process;
end architecture sim;
