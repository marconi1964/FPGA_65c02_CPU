LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

library r65c02_tc;


ENTITY clock1hz IS
  PORT (
    clk : in STD_LOGIC;
    reset_n : in STD_LOGIC;
    clk_1hz_out : out STD_LOGIC);
  END ENTITY clock1hz;


ARCHITECTURE Behavioral OF clock1hz IS

  SIGNAL clk_sig : std_logic;

BEGIN
  process(reset_n,clk)
  variable cnt : integer;

BEGIN
  IF (reset_n='0') THEN
    clk_sig<='0';
    cnt:=0;
  ELSIF rising_edge(clk) THEN
    IF (cnt=24999999) THEN
      clk_sig<=NOT(clk_sig);
      cnt:=0;
    ELSE
      cnt:=cnt+1;
    END IF;
  END IF;
END PROCESS;


clk_1hz_out <= clk_sig;


END Behavioral;