-- VHDL Entity clock_choices
--
-- Created:
--          by - Marconi Jiang
--          at - 2021/08/08
--
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

entity clock_choices is
   port( 
      clk                   : IN     STD_LOGIC;   --input clock
      reset_n                : IN     STD_LOGIC;   --asynchronous active low reset
      single_step_button     : IN     STD_LOGIC;
      single_step_latch      : OUT    STD_LOGIC;   -- debounced signal
      sw1_in                 : IN     STD_LOGIC;   -- '1' = single step, '0' = clock 
      sw2_in                 : IN     STD_LOGIC;   -- '1' = 1Hz, '0' = 1MHz
      clock_out              : OUT    STD_LOGIC    -- clock output to CPU

   );

-- Declarations

end clock_choices;

-- (C) 2021 Marconi Jiang
-- (email: marconi.jiang@gmail.com)
-- 
-- Versions:
-- Revision 1.00  2021/08/08
-- clock_out definition
-- - sw1 = 1              : single step
-- - sw1 = 0 AND sw2 = 1  : 1Hz
-- - sw1 = 0 AND sw2 = 0  : 1MHz
-- 
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

library r65c02_tc;

architecture struct of clock_choices is

   -- Architecture declarations

   -- Internal signal declarations

   component debounce
   port (
      clk          : IN     STD_LOGIC;  --input clock
      reset_n      : IN     STD_LOGIC;  --asynchronous active low reset
      button       : IN     STD_LOGIC;  --input signal to be debounced
      result       : OUT    STD_LOGIC   --debounced signal
   );
   end component;

   component clock1hz
   port (
      clk          : IN     STD_LOGIC;  --input clock
      reset_n      : IN     STD_LOGIC;  --asynchronous active low reset
      clk_1hz_out  : OUT    STD_LOGIC   --debounced signal
   );
   end component;

   component clock1mhz
   port (
      clk          : IN     STD_LOGIC;  --input clock
      reset_n      : IN     STD_LOGIC;  --asynchronous active low reset
      clk_1mhz_out : OUT    STD_LOGIC   --debounced signal
   );
   end component;


   -- Optional embedded configurations
   -- pragma synthesis_off
   for all : core use entity r65c02_tc.core;

   --- added by Marconi for clock sources
   for all : debounce use entity r65c02_tc.bounce;
   for all : clock1hz use entity r65c02_tc.clock1hz;
   for all : clock1mhz use entity r65c02_tc.clock1mhz;
   -- pragma synthesis_on


   signal sw1_out, sw1_out_n          : STD_LOGIC;
   signal sw2_out, sw2_out_n          : STD_LOGIC;
   signal clk_1hz_enabled, clk_1mhz_enabled   : STD_LOGIC;
   signal clk_1hz_1mhz                        : STD_LOGIC;
   signal step_enabled, clk_1hz_1mhz_enabled  : STD_LOGIC;
   signal clk_1hz_internal, clk_1mhz_internal : STD_LOGIC; 
   signal debounce_result                     : STD_LOGIC;   -- can be removed
   signal single_step_latch_extern            : STD_LOGIC;
   signal clk_clk_in, clock_out_internal      : STD_LOGIC;


   signal single_step_button_in               : STD_LOGIC;
   signal clk_1hz_out                         : STD_LOGIC;
   signal clk_1mhz_out                        : STD_LOGIC;


begin

   module_single_step : debounce
      port map (
         clk        => clk,
         reset_n    => reset_n,
         button     => single_step_button_in, 
         result     => single_step_latch_extern);             -- modified from result

   module1hz : clock1hz
      port map (
         clk        => clk,
         reset_n    => reset_n,
         clk_1hz_out => clk_1hz_internal);   -- modified from clk_1hz_out

   module1mhz : clock1mhz
      port map (
         clk        => clk,
         reset_n    => reset_n,
         clk_1mhz_out => clk_1mhz_internal);  -- modified from clk_1mhz_out

   moduledebouce_sw1 : debounce
      port map (
         clk        => clk,
         reset_n    => reset_n,
         button     => sw1_in, 
         result     => sw1_out);

   moduledebouce_sw2 : debounce
      port map (
         clk        => clk,
         reset_n    => reset_n,
         button     => sw2_in, 
         result     => sw2_out);


   single_step_button_in   <= single_step_button;
   single_step_latch       <= single_step_latch_extern;
   clk_1hz_out      <= clk_1hz_internal;
   clk_1mhz_out     <= clk_1mhz_internal;

   sw1_out_n        <= not sw1_out;
   sw2_out_n        <= not sw2_out;

   clk_1hz_enabled  <= sw2_out and clk_1hz_internal;
   clk_1mhz_enabled <= sw2_out_n and clk_1mhz_internal;
   clk_1hz_1mhz     <= clk_1hz_enabled or clk_1mhz_enabled;

   step_enabled     <= single_step_latch_extern and sw1_out;
   clk_1hz_1mhz_enabled <= clk_1hz_1mhz and sw1_out_n;

   clock_out_internal  <= step_enabled or clk_1hz_1mhz_enabled;

   clock_out        <= clock_out_internal;

 
end struct;
