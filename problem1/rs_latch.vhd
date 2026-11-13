library ieee;
use ieee.std_logic_1164.all;

-- RS Latch built from two cross-coupled NOR gates
--   S R | Q   Qn
--   0 0 | hold
--   1 0 | 1   0   (Set)
--   0 1 | 0   1   (Reset)
--   1 1 | 0   0   (Forbidden)
entity rs_latch is
    port(
        s  : in  std_logic;
        r  : in  std_logic;
        q  : out std_logic;
        qn : out std_logic
    );
end entity rs_latch;

architecture gate of rs_latch is
    signal q_int  : std_logic;
    signal qn_int : std_logic;
begin
    q_int  <= r nor qn_int;
    qn_int <= s nor q_int;

    q  <= q_int;
    qn <= qn_int;
end architecture gate;
