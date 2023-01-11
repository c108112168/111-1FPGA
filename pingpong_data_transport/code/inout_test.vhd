library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity inout_test is
port(
	clk : in STD_LOGIC;
	rst : in STD_LOGIC;
	LED			:out std_logic_vector(7 downto 0);
	Button, start_btn 		:in  std_logic;
	SW	: in std_logic_vector(7 downto 0);
	data : inout STD_LOGIC
);
end inout_test;

architecture arc_dir of inout_test is
type pingpong_s is (pp_start, pp_wait, pp_in, pp_out);
signal pingpong_FSM :pingpong_s;


signal L_point_reg1, R_point_reg1 , L_point_reg2, R_point_reg2 , L_point_reg3, R_point_reg3                                  :std_logic_vector(3 downto 0);

signal new_clk											:std_logic_vector(30 downto 0);
signal new_clk_1										:std_logic;
signal new_clk_2										:std_logic;
signal new_clk_3										:std_logic;

signal temp		                                       	:std_logic_vector(3 downto 0);
signal random                                           :integer range 0 to 25;




signal data_in : STD_LOGIC;
signal data_out, data_out2, SW_reg, SW_reg2: STD_LOGIC;
signal time_cnt1, time_cnt2, time_cnt3 					:std_logic_vector(2 downto 0);
signal LED_reg1, LED_reg2  :std_logic_vector(7 downto 0);
signal DeBug_1, DeBug_2  :std_logic_vector(3 downto 0);
signal data_in_reg, start_btn_reg : std_logic;
signal time_cnt4 : integer range 0 to 200;


type data_in_check_s is (check0, check01, check1, check2, check3, check4, data_0, data_1, data_2, data_3, data_4, data_5, data_6, data_7, wait_1, wait_2, wait_3, wait_4);
signal data_in_check, data_in_check2 :data_in_check_s;

signal password : std_logic_vector(3 downto 0);

begin

	--LED <= LED_reg1;
	LED <= LED_reg2;
	--LED <= DeBug_1 & DeBug_2;
	password <= "1101";
	clk_cnt:process(clk, rst)
	begin
		if rst = '1' then
			
			new_clk <=(others =>'0');
		elsif(Rising_edge(clk))then
			new_clk <= new_clk +1;
		end if;
	end process;
	new_clk_1<= new_clk(3);
	
	LED_time_cnt1:process(new_clk_1, rst)
	begin
	   if rst = '1' then
	       time_cnt1	    <= "000";
	   elsif(Rising_edge(new_clk_1))then
	       case pingpong_FSM is			
				when pp_in =>
					time_cnt1	    <= "000";
				when pp_out =>
					time_cnt1	    <= "000";
			    when pp_wait=>
					 if time_cnt1<"011"then
						 time_cnt1	    <= time_cnt1 +1;
					 end if;
			    when others =>
					if time_cnt1<"011"then
			             time_cnt1	    <= time_cnt1 +1;
					end if;  
				
				end case;
	   end if;
	
	end process; 
LED_reg1_cnt:process(new_clk_1, rst)
	begin
	    if rst = '1' then
	       LED_reg1	    <= "00000000";
	    elsif(Rising_edge(new_clk_1))then
	        case pingpong_FSM is
			    when pp_start =>
					LED_reg1	<= "00000000";	
				when pp_wait =>
					LED_reg1	<= "00000001";	
				when pp_in =>
					if LED_reg1 = "00000000"then
						LED_reg1 <= "10000000";
					elsif LED_reg1>"00000001"then
						LED_reg1	<= LED_reg1(0)&LED_reg1(7 downto 1);
					end if;
				when pp_out =>
					if LED_reg1 = "00000000"then
						LED_reg1 <= "00000001";
					elsif LED_reg1<"10000000"then
						LED_reg1	<= LED_reg1(6 downto 0)& LED_reg1(7);
					end if;
					
				when others =>
					null;
				
				end case;
	    end if;
	
	end process;
	
	process(clk, rst)
	begin
	    if rst = '1' then
			pingpong_FSM	<=pp_start;
			SW_reg 	<= '0';
			data_out <= '0';
	    elsif(Rising_edge(clk))then
	        case pingpong_FSM is
			    when pp_start =>
					if start_btn = '1'then
						pingpong_FSM <= pp_out;
					
					elsif data_in_reg = '1' and time_cnt1>="001"then
						pingpong_FSM <= pp_in;
						
					end if;
					SW_reg 	<= '0';
					data_out <= '0';
				when pp_wait =>
					if Button = '1' and LED_reg1 = "00000001"and time_cnt1<="011"then
						pingpong_FSM <= pp_out;
					elsif time_cnt1>"001"then
						pingpong_FSM <= pp_start;
					end if; 
					SW_reg 	<= '1';
					data_out <= '0';
				when pp_in =>
					if LED_reg1 = "00000001"then
						pingpong_FSM <= pp_wait;
					elsif Button = '1'then
						pingpong_FSM <= pp_start;	
						
					end if;
					SW_reg 	<= '1';
					data_out <= '0';
				when pp_out =>
					if LED_reg1 = "10000000"then
						pingpong_FSM <= pp_start;	
						data_out <= '1';
					else	
						data_out <= '0';
					end if;
					SW_reg 	<= '1';
				when others =>
					null;
				
				end case;
	    end if;
	
	end process;
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	process(new_clk_1, rst)
	begin
	    if rst = '1' then
			data_in_check	<=check0;
			LED_reg2 <= not LED_reg2;
			DeBug_1 <= "0000";
	    elsif(Rising_edge(new_clk_1))then
	        case data_in_check is
			    when check0=>
					if data_in_reg = '0' then
						data_in_check <= check01;
					
					else
						data_in_check <= check0;
						
					end if;
					
					DeBug_1 <= "0001";
			    when check01=>
					if data_in_reg = '1' then
						data_in_check <= check1;
					
					else
--						data_in_check <= check0;
						
					end if;
					DeBug_1 <= "0010";
					
			    when check1=>
					if data_in_reg = password(3) then
						data_in_check <= check2;
					
					else
						data_in_check <= check0;
						
					end if;
					DeBug_1 <= "0011";
			    when check2=>
					if data_in_reg = password(2)then
						data_in_check <= check3;
					
					else
						data_in_check <= check0;
						
					end if;
					DeBug_1 <= "0100";
			    when check3=>
					if data_in_reg = password(1)then
						data_in_check <= check4;
					
					else
						data_in_check <= check0;
						
					end if;
					DeBug_1 <= "0101";
			    when check4=>
					if data_in_reg = password(0)then
						data_in_check <= data_0;
					
					else
						data_in_check <= check0;
						
					end if;
					DeBug_1 <= "0110";
					
					
					
			    when data_0=>
					LED_reg2(7) <= data_in_reg;
					data_in_check <= data_1;
					DeBug_1 <= "0111";
			    when data_1=>
					LED_reg2(6) <= data_in_reg;
					data_in_check <= data_2;
					DeBug_1 <= "1000";
			    when data_2=>
					LED_reg2(5) <= data_in_reg;
					data_in_check <= data_3;
					DeBug_1 <= "1001";
			    when data_3=>
					LED_reg2(4) <= data_in_reg;
					data_in_check <= data_4;
					DeBug_1 <= "1010";
			    when data_4=>
					LED_reg2(3) <= data_in_reg;
					data_in_check <= data_5;
					DeBug_1 <= "1011";
			    when data_5=>
					LED_reg2(2) <= data_in_reg;
					data_in_check <= data_6;
					DeBug_1 <= "1100";
			    when data_6=>
					LED_reg2(1) <= data_in_reg;
					data_in_check <= data_7;
					DeBug_1 <= "1101";
			    when data_7=>
					LED_reg2(0) <= data_in_reg;
					data_in_check <= wait_1;
					DeBug_1 <= "1110";
						
				when wait_1=>
					if data_in_reg = password(3) then
						data_in_check <= wait_2;
					
					else
						data_in_check <= check0;
						
					end if;
					DeBug_1 <= "1111";
			    when wait_2=>
					if data_in_reg = password(2)then
						data_in_check <= wait_3;
					
					else
						data_in_check <= check0;
						
					end if;
			    when wait_3=>
					if data_in_reg = password(1)then
						data_in_check <= wait_4;
					
					else
						data_in_check <= check0;
						
					end if;
			    when wait_4=>
					if data_in_reg = password(0)then
						data_in_check <= check0;
					
					else
						data_in_check <= check0;
						
					end if;	
					
				when others =>
					null;
				
				end case;
	    end if;
	
	end process;
	
	
	
	output:process(new_clk_1, rst)
	begin
	    if rst = '1' then
			data_in_check2	<=check0;
			SW_reg2 	<= '0';
			data_out2   <= '0';
			start_btn_reg <= '0';
			time_cnt4 <= 0;
			DeBug_2 <= "0000";
	    elsif(Rising_edge(new_clk_1))then
	        case data_in_check2 is
			    when check0=>
					if start_btn = '1'= '1' then
						data_out2 <= '0';
						SW_reg2 <= '1';
						data_in_check2 <= check01;
						
					else
						SW_reg2 <= '0';
						
					end if;
					DeBug_2 <= "0001";
			    when check01=>
					if time_cnt4 <= 25 then
						time_cnt4 <= time_cnt4 +1;
						data_out2 <= '0';
						SW_reg2 <= '1';
					else
						data_in_check2 <= check1;
						time_cnt4 <= 0;
						data_out2 <= '1';
						SW_reg2 <= '1';
						
					end if;
					DeBug_2 <= "0010";
					
			    when check1=>
					
					data_in_check2 <= check2;
					data_out2 <= password(3);
					SW_reg2 <= '1';
					DeBug_2 <= "0011";
					
			    when check2=>
					data_in_check2 <= check3;
					data_out2 <= password(2);
					SW_reg2 <= '1';
					DeBug_2 <= "0100";
			    when check3=>
					data_in_check2 <= check4;
					data_out2 <= password(1);
					SW_reg2 <= '1';
					DeBug_2 <= "0101";
			    when check4=>
					data_in_check2 <= data_0;
					data_out2 <= password(0);
					SW_reg2 <= '1';
					DeBug_2 <= "0110";
					
					
					
			    when data_0=>
					data_out2 <= SW(7);
					data_in_check2 <= data_1;
					SW_reg2 <= '1';
					DeBug_2 <= "0111";
			    when data_1=>
					data_out2 <= SW(6);
					data_in_check2 <= data_2;
					SW_reg2 <= '1';
					DeBug_2 <= "1000";
			    when data_2=>
					data_out2 <= SW(5);
					data_in_check2 <= data_3;
					SW_reg2 <= '1';
					DeBug_2 <= "1001";
			    when data_3=>
					data_out2 <= SW(4);
					data_in_check2 <= data_4;
					SW_reg2 <= '1';
					DeBug_2 <= "1010";
			    when data_4=>
					data_out2 <= SW(3);
					data_in_check2 <= data_5;
					SW_reg2 <= '1';
					DeBug_2 <= "1011";
			    when data_5=>
					data_out2 <= SW(2);
					data_in_check2 <= data_6;
					SW_reg2 <= '1';
					DeBug_2 <= "1100";
			    when data_6=>
					data_out2 <= SW(1);
					data_in_check2 <= data_7;
					SW_reg2 <= '1';
					DeBug_2 <= "1101";
			    when data_7=>
					data_out2 <= SW(0);
					data_in_check2 <= wait_1;
					SW_reg2 <= '1';
					DeBug_2 <= "1110";
						
				when wait_1=>
					
					data_in_check2 <= wait_2;
					data_out2 <= password(3);
					SW_reg2 <= '1';
					DeBug_2 <= "1111";
					
			    when wait_2=>
					data_in_check2 <= wait_3;
					data_out2 <= password(2);
					SW_reg2 <= '1';
			    when wait_3=>
					data_in_check2 <= wait_4;
					data_out2 <= password(1);
					SW_reg2 <= '1';
			    when wait_4=>
					data_in_check2 <= check0;
					data_out2 <= password(0);
					SW_reg2 <= '1';
			        start_btn_reg <= '0';
				
					
				when others =>
					null;
				
				end case;
	    end if;
	
	end process;
	
	
	
	
	
	data_in<=data;
d1:process(clk,rst,SW_reg2)
begin
	if rst='1' then
		data_in_reg<= '0';
	elsif clk'event and clk='1' then
		if SW_reg2='0' then
			data_in_reg <= data_in;

		else 
			data_in_reg<= '0';
		end if;
	else 
		null;
	end if;
end process d1;


data<=data_out2 when (SW_reg2='1') else
'Z';

end arc_dir;