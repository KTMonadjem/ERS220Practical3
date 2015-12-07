 library IEEE;
use IEEE.std_logic_1164.all;

-- 4 bit Bi-directional shift register
entity shift_register_dual4 is
	port(
			clk, clr	: in	std_logic;
			dsl, dsr : in 	std_logic;
			s0, s1	: in 	std_logic;
			d0, d1, d2, d3 : in std_logic;
			q0, q1, q2, q3 : out std_logic );
end shift_register_dual4;

architecture shift_dual4_arch of shift_register_dual4 is
	type state_type is (L,R,P,H); -- left, right, paralell, hold
	signal ps, ns : state_type;
	signal i0, i1, i2, i3 : std_logic;
begin
	
	shift: process (clk)
	begin
	
		if(rising_edge(clk)) then
			case ps is
				when L =>
					i0 <= i1;
					i1 <= i2;
					i2 <= i3;
					i3 <= dsl;
				when R =>
					i3 <= i2;
					i2 <= i1;
					i1 <= i0;
					i0 <= dsr;
				when P =>
					i0 <= d0;
					i1 <= d1;
					i2 <= d2;
					i3 <= d3;
				when others =>
					-- assume hold. Do nothing
			end case;

		end if;
		
	end process shift;
	
	q0 <= i0;
	q1 <= i1;
	q2 <= i2;
	q3 <= i3;
	
	state: process(s0, s1)
	begin
		if (s0 = '1' and s1 = '1') then
			ps <= P;
		elsif (s0 = '1' and s1 = '0') then
			ps <= R;
		elsif (s0 = '0' and s1 = '1') then
			ps <= L;
		else
			ps <= P;
		end if;
	end process state;
	
	
end shift_dual4_arch;
	