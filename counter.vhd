 library IEEE;
use IEEE.std_logic_1164.all;

entity counter is
port ( input	: in std_logic;
		 a			: out std_logic_vector (6 downto 0) := "1000000");
end counter;

architecture counter_arch of counter is
	
begin
	
	process ( input )
		type limited is range 0 to 9;
		variable c : limited := 0;
	begin
		if( rising_edge(input)) then
			c := c + 1;
			
			if ( c > 9 ) then
				c := 0;
			end if;
			
			case c is
				when 0 => a <= "1000000";
				when 1 => a <= "1111001";
				when 2 => a <= "0100100";
				when 3 => a <= "0110000";
				when 4 => a <= "0011001";
				when 5 => a <= "0010010";
				when 6 => a <= "0000010";
				when 7 => a <= "1111000";
				when 8 => a <= "0000000";
				when 9 => a <= "0011000";
			end case;
		end if;
	end process;
end counter_arch;
			