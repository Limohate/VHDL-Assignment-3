library ieee;
use ieee.std_logic_1164.all;

-- Positive-edge-triggered JK Flip-Flop (with asynchronous clear for initialization)
--   clr = '1' : Q = '0' immediately
--   J K | Q(next) on rising edge of clk
--   0 0 | Q      (Hold)
--   0 1 | 0      (Reset)
--   1 0 | 1      (Set)
--   1 1 | not Q  (Toggle)
entity jk_ff is
    port(
        j   : in  std_logic;
        k   : in  std_logic;
        clk : in  std_logic;
        clr : in  std_logic;
        q   : out std_logic;
        qn  : out std_logic
    );
end entity jk_ff;

architecture bhv of jk_ff is
    signal q_int : std_logic := '0';
begin
    process(clk, clr)
        variable jk : std_logic_vector(1 downto 0);
    begin
        if clr = '1' then
            q_int <= '0';
        elsif rising_edge(clk) then
            jk := j & k;
            case jk is
                when "00"   => q_int <= q_int;      -- Hold
                when "01"   => q_int <= '0';        -- Reset
                when "10"   => q_int <= '1';        -- Set
                when "11"   => q_int <= not q_int;  -- Toggle
                when others => q_int <= q_int;
            end case;
        end if;
    end process;

    q  <= q_int;
    qn <= not q_int;
end architecture bhv;
