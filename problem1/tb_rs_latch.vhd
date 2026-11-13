library ieee;
use ieee.std_logic_1164.all;

entity tb_rs_latch is
end entity tb_rs_latch;

architecture sim of tb_rs_latch is
    signal s, r  : std_logic := '0';
    signal q, qn : std_logic;
begin
    uut : entity work.rs_latch port map(s => s, r => r, q => q, qn => qn);

    stim : process
    begin
        s <= '0'; r <= '1'; wait for 20 ns;   -- Reset
        assert q = '0' and qn = '1' report "Reset failed" severity error;
        s <= '0'; r <= '0'; wait for 20 ns;   -- Hold (Q=0)
        assert q = '0' and qn = '1' report "Hold after reset failed" severity error;
        s <= '1'; r <= '0'; wait for 20 ns;   -- Set
        assert q = '1' and qn = '0' report "Set failed" severity error;
        s <= '0'; r <= '0'; wait for 20 ns;   -- Hold (Q=1)
        assert q = '1' and qn = '0' report "Hold after set failed" severity error;
        s <= '1'; r <= '1'; wait for 20 ns;   -- Forbidden: Q = Qn = 0
        assert q = '0' and qn = '0' report "Forbidden state check failed" severity error;
        s <= '0'; r <= '1'; wait for 20 ns;   -- leave forbidden state through Reset
        assert q = '0' and qn = '1' report "Reset after forbidden failed" severity error;
        report "tb_rs_latch finished" severity note;
        wait;
    end process;
end architecture sim;
