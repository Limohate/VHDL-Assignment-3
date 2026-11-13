library ieee;
use ieee.std_logic_1164.all;

entity tb_d_latch is
end entity tb_d_latch;

architecture sim of tb_d_latch is
    signal d, en : std_logic := '0';
    signal q, qn : std_logic;
begin
    uut : entity work.d_latch port map(d => d, en => en, q => q, qn => qn);

    stim : process
    begin
        en <= '1'; d <= '0'; wait for 20 ns;  -- transparent, Q=0
        assert q = '0' report "en=1, d=0 failed" severity error;
        d <= '1'; wait for 20 ns;             -- transparent, Q=1
        assert q = '1' report "en=1, d=1 failed" severity error;
        d <= '0'; wait for 10 ns;             -- Q follows immediately
        assert q = '0' report "Q did not follow D" severity error;
        d <= '1'; wait for 10 ns;
        en <= '0'; wait for 10 ns;            -- latch Q=1
        d <= '0'; wait for 20 ns;             -- D changes, Q must hold 1
        assert q = '1' report "Hold (Q=1) failed" severity error;
        d <= '1'; wait for 10 ns;
        d <= '0'; wait for 10 ns;
        assert q = '1' report "Hold (Q=1) failed" severity error;
        en <= '1'; wait for 20 ns;            -- transparent again, Q=0
        assert q = '0' report "en=1 again failed" severity error;
        en <= '0'; wait for 10 ns;            -- latch Q=0
        d <= '1'; wait for 20 ns;
        assert q = '0' report "Hold (Q=0) failed" severity error;
        report "tb_d_latch finished" severity note;
        wait;
    end process;
end architecture sim;
