library ieee;
use ieee.std_logic_1164.all;

-- Positive-edge-triggered D Flip-Flop with asynchronous Set and Clear
--   clr = '1'           : Q = '0' immediately (highest priority)
--   set = '1', clr = '0': Q = '1' immediately
--   set = clr = '0'     : normal D Flip-Flop (Q <= D on rising edge of clk)
entity d_ff_sc is
    port(
        d   : in  std_logic;
        clk : in  std_logic;
        set : in  std_logic;
        clr : in  std_logic;
        q   : out std_logic;
        qn  : out std_logic
    );
end entity d_ff_sc;

architecture bhv of d_ff_sc is
    signal q_int : std_logic := '0';
begin
    process(clk, set, clr)
    begin
        if clr = '1' then
            q_int <= '0';
        elsif set = '1' then
            q_int <= '1';
        elsif rising_edge(clk) then
            q_int <= d;
        end if;
    end process;

    q  <= q_int;
    qn <= not q_int;
end architecture bhv;
