LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

library r65c02_tc;


ENTITY clock1mhz IS
  PORT (
    clk : in STD_LOGIC;
    reset_n : in STD_LOGIC;
    clk_1mhz_out : out STD_LOGIC);
  END ENTITY clock1mhz;


ARCHITECTURE Behavioral OF clock1mhz IS

  SIGNAL clk_sig1m : std_logic;

BEGIN
  process(reset_n,clk)
  variable cnt : integer;

BEGIN
  IF (reset_n='0') THEN
    clk_sig1m<='0';
    cnt:=0;
  ELSIF rising_edge(clk) THEN
    IF (cnt=24) THEN
      clk_sig1m <= NOT(clk_sig1m);
      cnt:=0;
    ELSE
      cnt:=cnt+1;
    END IF;
  END IF;
END PROCESS;


clk_1mhz_out <= clk_sig1m;


END Behavioral;