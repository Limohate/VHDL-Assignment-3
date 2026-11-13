library ieee;
use ieee.std_logic_1164.all;

-- Gated D Latch
--   en = '1' : Q follows D (transparent)
--   en = '0' : Q holds its previous value
entity d_latch is
    port(
        d  : in  std_logic;
        en : in  std_logic;
        q  : out std_logic;
        qn : out std_logic
    );
end entity d_latch;

architecture bhv of d_latch is
    signal q_int : std_logic := '0';
begin
    process(d, en)
    begin
        if en = '1' then
            q_int <= d;
        end if;
    end process;

    q  <= q_int;
    qn <= not q_int;
end architecture bhv;
