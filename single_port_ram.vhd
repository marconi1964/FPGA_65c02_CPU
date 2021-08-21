library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity single_port_ram is
	port
	(
		data	: in std_logic_vector(7 downto 0);
		-- addr	: in std_logic_vector(14 downto 0);     
		addr	: in std_logic_vector(13 downto 0);          -- 12bitsonly    
		-- addr    : in natural range 0 to 32767;            -- original design
		we		: in std_logic := '1';
		clk		: in std_logic;
		q		: out std_logic_vector(7 downto 0)
	);
	
end entity;

architecture rtl of single_port_ram is

	-- Build a 2-D array type for the RAM
	subtype word_t is std_logic_vector(7 downto 0);
	-- type memory_t is array(32767 downto 0) of word_t;
	type memory_t is array(16381 downto 0) of word_t;          -- 12bitsonly
	
	-- Declare the RAM signal.
	signal ram : memory_t;
	
	-- Register to hold the address
	-- signal addr_reg : natural range 0 to 32767;	             -- original design  
	-- signal addr_reg: std_logic_vector(14 downto 0);
	signal addr_reg: std_logic_vector(13 downto 0);           -- 12bitsonly

begin

	process(clk)
	begin
		if(rising_edge(clk)) then
			if(we = '1') then
			    -- ram(addr) <= data;
				ram(to_integer(unsigned(addr))) <= data;
			end if;
			
			-- Register the address for reading
			addr_reg <= addr;
		end if;
	
	end process;
	
	-- q <= ram(addr_reg);                                         -- original design
	q <= ram(to_integer(unsigned(addr_reg)));
	
end rtl;
