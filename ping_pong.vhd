library IEEE;
use IEEE.std_logic_1164.all;

entity ping_pong is
port ( 	RB_in, LB_in				: in std_logic;
			CLK							: in std_logic;
			seven_R, seven_L			: out std_logic_vector(6 downto 0);
			seven_a, seven_b			: out std_logic_vector(6 downto 0);
			L0, L1, L2, L3, L4, L5, L6, L7 : out std_logic); -- test outputs
end ping_pong;

architecture behavior of ping_pong is
	
	component counter
	port ( input	: in std_logic;
		 a				: out std_logic_vector (6 downto 0));
	end component;
	
	component shift_register_dual4
	port(
			clk, clr	: in	std_logic;
			dsl, dsr : in 	std_logic;
			s0, s1	: in 	std_logic;
			d0, d1, d2, d3 : in std_logic;
			q0, q1, q2, q3 : out std_logic );
	end component;

	component register_2bit
	port ( 	d0, d1	: in std_logic;
			clk		: in std_logic;
			q0, q1	: out std_logic);
	end component;
	
	component down_clock is
		port (	in_clk : in std_logic;
					out_clk: out std_logic);
	end component;
	
	signal S0, S1, R0, R1 : std_logic; 		-- state and next state variables
	signal LL, RL			 : std_logic;		-- Left and Right light signals
	signal C2, C1			 : std_logic; 		-- cross connections for shift registers
	signal ML, MR			 : std_logic; 		-- move left and move right
	signal DCLK				 : std_logic; 		-- reduced frequency clock
	signal a1, a2			 : std_logic; 		-- into keep_reg
	signal b1, b2			 : std_logic; 		-- out of keep_reg
	signal t1, t2, t3, t4, t5, t6 : std_logic; -- lamp signals
	signal LB, RB			 : std_logic; 		-- inverted button signals
	signal L_win, R_win	 : std_logic;		-- win signals
	
begin
	seven_a <= "1111111";	-- clear middle seven segment displays
	seven_b <= "1111111";	-- clear middle seven segment displays
	
	RB <= not RB_in;
	LB <= not LB_in;
	
	MR <= (S1 and (not S0));
	ML <= (S1 and S0);
	
	downclk : down_clock port map (	in_clk => clk,
												out_clk => DClK);
	
	a1 <=  ((not S1) and S0);
	a2 <=  ((not S1) and (not S0));
	
	reg2 : shift_register_dual4 port map (	clk => DCLK,
														clr => '0',
														d0 => '0', d1 => '0',
														d2 => '0', d3 => '0',
														q0 => LL,
														q1 => t1, q2 => t2, 
														q3 => C1,
														s0 => MR,
														s1 => ML,
														dsl => C2,
														dsr => b2);
	L0 <= LL;
	L1 <= t1;
	L2 <= t2;
	L3 <= C1;
	
	reg1 : shift_register_dual4 port map (	clk => DCLK,
														clr => '0',
														d0 => '0', d1 => '0',
														d2 => '0', d3 => '0',
														q0 => C2,
														q1 => t5, q2 => t6, 
														q3 => RL,
														s0 => MR,
														s1 => ML,
														dsl => b1,
														dsr => C1);
	L4 <= C2;
	L5 <= t5;
	L6 <= t6;
	L7 <= RL;
	
	state_reg : register_2bit port map ( 	clk => DCLK,
														d0 => R0,
														d1 => R1,
														q0 => S0,
														q1 => S1);
	
	
	
	keep_reg : register_2bit port map (	clk => DCLK,
													d0 => a1,
													d1 => a2,
													q0 => b1,
													q1 => b2);

	L_counter : counter port map (input => L_win,
											a => seven_L);
	
	R_counter : counter port map (input => R_win,
											a => seven_R);

	
	R1 <= ((not s1) and (not s0) and (not LB)) or ((not s1) and s0 and (not RB))
			or ((not LL) and (not LB) and (s1 and s0) and (not RB))
			or ( s1 and (not s0) and (not RB) and (not LB) and (not RL));
	R0 <= ((not s1) and s0) or ((s1 and s0) and ((not RB) and (not (LB and LL))))
			or (s1 and (not s0) and (LB or (RB and (not LB) and RL)));
			
			-- (not RB) and (not LB) and (not LL))
	
	score: process ( DCLK )
	begin
		if(rising_edge(DCLK)) then
			R_win <= DCLK and ((ML and ((LB and not LL) or (LL and not LB))) or (MR and LB));
			L_win <= DCLK and ((MR and ((RB and not RL) or (RL and not RB))) or (ML and RB));
		end if;
	end process;
	
end behavior;