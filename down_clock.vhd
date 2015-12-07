library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity down_clock is
port (	in_clk : in std_logic;
			out_clk: out std_logic);
end down_clock;

architecture down_clock_arch of down_clock is
	
begin
	down : process (in_clk)
	variable count : integer := 67500000;
	begin
		if(rising_edge(in_clk)) then
			if( count > 0 ) then
				count := count - 1;
				out_clk <= '0';
			else 
				count := 13500000;
				out_clk <= '1';
			end if;
		end if;
	end process;
end down_clock_arch;