library IEEE;
use IEEE.std_logic_1164.all;

entity register_2bit is
port ( 	d0, d1	: in std_logic;
			clk		: in std_logic;
			q0, q1	: out std_logic);
end register_2bit;

architecture register_2bit_arch of register_2bit is
begin
	store : process (clk)
	begin
		if (rising_edge(clk)) then
			q0 <= d0;
			q1 <= d1;
		end if;
	end process store;
end register_2bit_arch;