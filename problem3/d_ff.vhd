library ieee;
use ieee.std_logic_1164.all;

-- Positive-edge-triggered D Flip-Flop
-- Q is updated only on the rising edge of clk.
entity d_ff is
    port(
        d   : in  std_logic;
        clk : in  std_logic;
        q   : out std_logic;
        qn  : out std_logic
    );
end entity d_ff;

architecture bhv of d_ff is
    signal q_int : std_logic := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            q_int <= d;
        end if;
    end process;

    q  <= q_int;
    qn <= not q_int;
end architecture bhv;
