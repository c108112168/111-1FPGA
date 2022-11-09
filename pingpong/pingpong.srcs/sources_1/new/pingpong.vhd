library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pingpong is
port(
	--Data_IN :in  std_logic;
	clk 			:in  std_logic;
	rst 	  		:in  std_logic;
	LED 			:out std_logic_vector(7 downto 0);
	--L_point		:out std_logic_vector(7 downto 0);
	--R_point		:out std_logic_vector(7 downto 0);
	Button_L 		:in  std_logic;
	Button_R 		:in  std_logic;
	L_mode3 		:in  std_logic;
	R_mode3 		:in  std_logic;
	mode 			:in  std_logic_vector(1 downto 0)
	--PWM				:out std_logic
);
end pingpong;

architecture Behavioral of pingpong is

type pingpong_s is (pp_right,pp_left,pp_r_l,pp_l_r,wait_r, wait_l, print_right, print_left);
signal pingpong_FSM , pingpong_FSM_2			:pingpong_s;

type pingpong_s3 is (pp_right,pp_left,pp_r_l,pp_l_r,pp_r_l2,pp_l_r2,wait_r, wait_l, print_right, print_left);
signal pingpong_FSM_3			:pingpong_s3;

signal L_point_reg1, R_point_reg1 , L_point_reg2, R_point_reg2 , L_point_reg3, R_point_reg3                                  :std_logic_vector(3 downto 0);

signal new_clk											:std_logic_vector(30 downto 0);
signal new_clk_1										:std_logic;
signal new_clk_2										:std_logic;
signal new_clk_3										:std_logic;

signal temp		                                       	:std_logic_vector(3 downto 0);
signal random                                           :integer range 0 to 25;

signal LED_reg1, LED_reg2, LED_reg3, LED_reg4 			:std_logic_vector(7 downto 0);
signal time_cnt1, time_cnt2, time_cnt3 					:std_logic_vector(2 downto 0);


begin	
	clk_cnt:process(clk, rst)
	begin
		if rst = '1' then
			
			new_clk <=(others =>'0');
		elsif(Rising_edge(clk))then
			new_clk <= new_clk +1;
		end if;
	end process;	 
process(new_clk_1,rst)  
  begin   
     if rst='1' then 
        temp<="0000";  
     elsif (new_clk_1'event and new_clk_1='1') then  
         if temp="0000" then 
            temp<="0001";  
         else  
            temp(0)<=temp(0) xor temp(3);  --?ων????  
            temp(1)<=temp(0);     
            temp(2)<=temp(1);  
            temp(3)<=temp(2);    
         end if;  
     end if;  
  end process;  
	random <= 22+ conv_integer(temp(1 downto 0));
	new_clk_2<= new_clk(random);
	
	new_clk_1<= new_clk(25);
	
	pp_FSM:process(clk, rst)
	begin
		if rst = '1' then
			
			LED <=(others =>'0');
		elsif(Rising_edge(clk))then
			case mode is
				when "00" =>
					LED		<= LED_reg1;
					
				when "01" =>
					LED		<= LED_reg2;
					
				when "10" =>
					LED		<= LED_reg3;
					
				when others =>
					LED		<= LED_reg4;
					
				end case;
		end if;
	end process;	
	LED_time_cnt1:process(new_clk_1, rst)
	begin
	   if rst = '1' then
	       time_cnt1	    <= "000";
	   elsif(Rising_edge(new_clk_1))then
	       case pingpong_FSM is
				when pp_right =>
			         if time_cnt1<"011"then
			             time_cnt1	    <= time_cnt1 +1;
			         end if;
				when pp_left =>
			         if time_cnt1<"011"then
			             time_cnt1	    <= time_cnt1 +1;
			         end if;
				when pp_l_r =>
					time_cnt1	    <= "000";
				when pp_r_l =>
					time_cnt1	    <= "000";
			    when print_left=>
			         if time_cnt1<"011"then
			             time_cnt1	    <= time_cnt1 +1;
			         end if;
			    when print_right=>
			         if time_cnt1<"011"then
			             time_cnt1	    <= time_cnt1 +1;
			         end if;
				when wait_r =>
					if time_cnt1<"011"then
			             time_cnt1	    <= time_cnt1 +1;
			         end if;
				when wait_l =>
					if time_cnt1<"011"then
			             time_cnt1	    <= time_cnt1 +1;
			         end if;
				
				end case;
	   end if;
	
	end process;
LED_reg1_cnt:process(new_clk_1, rst)
	begin
	   if rst = '1' then
	       LED_reg1	    <= "00000001";
	   elsif(Rising_edge(new_clk_1))then
	       case pingpong_FSM is
				when pp_right =>
					LED_reg1	<= "00000001";	
				when pp_left =>
					LED_reg1	<= "10000000";
				when pp_l_r =>
					LED_reg1	<= LED_reg1(0)&LED_reg1(7 downto 1);
				when pp_r_l =>
					LED_reg1	<= LED_reg1(6 downto 0)& LED_reg1(7);
			    when print_left=>
			        if (new_clk(25) = '1')then
			            LED_reg1    <= L_point_reg1(0)&L_point_reg1(1)&L_point_reg1(2)&L_point_reg1(3)&R_point_reg1(3 downto 0);
			        else
			            LED_reg1 <= (others => '0');
			        end if;
			    when print_right=>
			        if (new_clk(25) = '1')then
			            LED_reg1    <= L_point_reg1(0)&L_point_reg1(1)&L_point_reg1(2)&L_point_reg1(3)&R_point_reg1(3 downto 0);
			        else
			            LED_reg1 <= (others => '0');
			        end if;
				when others =>
					null;
				
				end case;
	   end if;
	
	end process;
	
	--L_point <= L_point_reg;
	LED_reg1_state:process(clk, rst)
	begin
		if rst = '1' then
			
			pingpong_FSM	<=pp_right;
			L_point_reg1			<= (others =>'0');		
			R_point_reg1			<= (others =>'0');
		elsif(Rising_edge(clk))then
		   if mode = "00"then
                case pingpong_FSM is
                    when pp_right =>
                        --LED_reg1	<= "00000001";	
                        if Button_R = '1' and LED_reg1 = "00000001"and time_cnt1>="011"then
                            pingpong_FSM <= pp_r_l;
                        end if; 
                    
                    when pp_left =>
                        --LED_reg1	<= "10000000";
                        if Button_L = '1'and LED_reg1 = "10000000"and time_cnt1>="011" then
                            pingpong_FSM <= pp_l_r;
                        end if;
                        
                    when pp_l_r =>
                        
                        --LED_reg1	<= LED_reg1(0)&LED_reg1(7 downto 1);
                        if LED_reg1(0)='1' then
                            pingpong_FSM <= wait_r;
                        elsif Button_R = '1'then
                            pingpong_FSM 	<= print_right;
                            L_point_reg1			<= L_point_reg1 +1;
                        end if;
                        
                    when pp_r_l =>
                        --LED_reg1	<= LED_reg1(6 downto 0)& LED_reg1(7);
                        
                        if LED_reg1(7)='1' then
                            pingpong_FSM <= wait_l;
                        elsif Button_L = '1'then
                            pingpong_FSM	<= print_left;
                            R_point_reg1			<= R_point_reg1 +1;
                        end if;
                        
                    when wait_r =>
                        if Button_R = '1'then
                            pingpong_FSM <= pp_r_l;
                        elsif time_cnt1>="001"then
                            pingpong_FSM <= print_right;
                            L_point_reg1			<= L_point_reg1 +1;
                        end if; 
                    
                    when wait_l =>
                        if Button_L = '1'then
                            pingpong_FSM <= pp_l_r;
                        elsif time_cnt1>="001"then
                            pingpong_FSM <= print_left;
                            R_point_reg1			<= R_point_reg1 +1;
                            
                        end if;
                    when print_left =>
                        if Button_L = '1'and time_cnt1>="011"then
                            pingpong_FSM <= pp_left;
                            
                        end if;
                    when print_right =>
                        if Button_R = '1'and time_cnt1>="011"then
                            pingpong_FSM <= pp_right;
                        end if;
                    end case;
              end if;
		end if;
	end process;
	LED_time_cnt2:process(new_clk_1, rst)
	begin
	   if rst = '1' then
	       time_cnt2	    <= "000";
	   elsif(Rising_edge(new_clk_1))then
	       case pingpong_FSM_2 is
				when pp_right =>
			         if time_cnt2<"011"then
			             time_cnt2	    <= time_cnt2 +1;
			         end if;
				when pp_left =>
			         if time_cnt2<"011"then
			             time_cnt2	    <= time_cnt2 +1;
			         end if;
				when pp_l_r =>
					time_cnt2	    <= "000";
				when pp_r_l =>
					time_cnt2	    <= "000";
			    when print_left=>
			         if time_cnt2<"011"then
			             time_cnt2	    <= time_cnt2 +1;
			         end if;
			    when print_right=>
			         if time_cnt2<"011"then
			             time_cnt2	    <= time_cnt2 +1;
			         end if;
				when wait_r =>
					if time_cnt2<"011"then
			             time_cnt2	    <= time_cnt2 +1;
			         end if;
				when wait_l =>
					if time_cnt2<"011"then
			             time_cnt2	    <= time_cnt2 +1;
			         end if;
				
				end case;
	   end if;
	
	end process;
LED_reg2_cnt:process(new_clk_2, rst)
	begin
	   if rst = '1' then
	       LED_reg2	    <= "00000001";
	   elsif(Rising_edge(new_clk_2))then
	       case pingpong_FSM_2 is
				when pp_right =>
					LED_reg2	<= "00000001";	
				when pp_left =>
					LED_reg2	<= "10000000";
				when pp_l_r =>
					LED_reg2	<= LED_reg2(0)&LED_reg2(7 downto 1);
				when pp_r_l =>
					LED_reg2	<= LED_reg2(6 downto 0)& LED_reg2(7);
			    when print_left=>
			        --LED_reg2    <= L_point_reg2(0)&L_point_reg2(1)&L_point_reg2(2)&L_point_reg2(3)&R_point_reg2(3 downto 0);
			        if (new_clk(25) = '1')then
			            LED_reg2    <= L_point_reg2(0)&L_point_reg2(1)&L_point_reg2(2)&L_point_reg2(3)&R_point_reg2(3 downto 0);
			        else
			            LED_reg2 <= (others => '0');
			        end if;
			    when print_right=>
			        if (new_clk(25) = '1')then
			            LED_reg2    <= L_point_reg2(0)&L_point_reg2(1)&L_point_reg2(2)&L_point_reg2(3)&R_point_reg2(3 downto 0);
			        else
			            LED_reg2 <= (others => '0');
			        end if;
				when others =>
					null;
				
				end case;
	   end if;
	
	end process;
	LED_reg2_state:process(clk, rst, LED_reg2)
	begin
		if rst = '1' then
			
			pingpong_FSM_2	<=pp_right;
			L_point_reg2			<= (others =>'0');		
            R_point_reg2			<= (others =>'0');
		elsif(Rising_edge(clk))then
		   if mode = "01"then
                case pingpong_FSM_2 is
                    when pp_right =>
                        --LED_reg1	<= "00000001";	
                        if Button_R = '1' and LED_reg2 = "00000001"and time_cnt2>="011" then
                            pingpong_FSM_2 <= pp_r_l;
                        end if; 
                    
                    when pp_left =>
                        --LED_reg1	<= "10000000";
                        if Button_L = '1'and LED_reg2 = "10000000" and time_cnt2>="011" then
                            pingpong_FSM_2 <= pp_l_r;
                        end if;
                        
                    when pp_l_r =>
                        
                        --LED_reg1	<= LED_reg1(0)&LED_reg1(7 downto 1);
                        if LED_reg2(0)='1' then
                            pingpong_FSM_2 <= wait_r;
                        elsif Button_R = '1'then
                            pingpong_FSM_2 	<= print_right;
                            L_point_reg2			<= L_point_reg2 +1;
                        end if;
                        
                    when pp_r_l =>
                        --LED_reg1	<= LED_reg1(6 downto 0)& LED_reg1(7);
                        
                        if LED_reg2(7)='1' then
                            pingpong_FSM_2 <= wait_l;
                        elsif Button_L = '1'then
                            pingpong_FSM_2	<= print_left;
                            R_point_reg2			<= R_point_reg2 +1;
                        end if;
                        
                    when wait_r =>
                        if Button_R = '1'then
                            pingpong_FSM_2 <= pp_r_l;
                        elsif time_cnt2>="001"then
                            pingpong_FSM_2 <= print_right;
                            L_point_reg2			<= L_point_reg2 +1;
                        end if; 
                    
                    when wait_l =>
                        if Button_L = '1'then
                            pingpong_FSM_2 <= pp_l_r;
                        elsif time_cnt2>="001"then
                            pingpong_FSM_2 <= print_left;
                            R_point_reg2			<= R_point_reg2 +1;
                            
                        end if;
                    when print_left =>
                        if Button_L = '1'and time_cnt2>="011" then
                            pingpong_FSM_2 <= pp_left;
                            
                        end if;
                    when print_right =>
                        if Button_R = '1'and time_cnt2>="011" then
                            pingpong_FSM_2 <= pp_right;
                        end if;
                    
                    end case;
               end if;
            end if;
	end process;
	
	
		LED_time_cnt3:process(new_clk_1, rst)
	begin
	   if rst = '1' then
	       time_cnt3	    <= "000";
	   elsif(Rising_edge(new_clk_1))then
	       case pingpong_FSM_3 is
				when pp_right =>
			         if time_cnt3<="011"then
			             time_cnt3	    <= time_cnt3 +1;
			         end if;
				when pp_left =>
			         if time_cnt3<="011"then
			             time_cnt3	    <= time_cnt3 +1;
			         end if;
				when pp_l_r =>
					time_cnt3	    <= "000";
				when pp_r_l =>
					time_cnt3	    <= "000";
				when pp_l_r2 =>
					time_cnt3	    <= "000";
				when pp_r_l2 =>
					time_cnt3	    <= "000";
			    when print_left=>
			         if time_cnt3<="011"then
			             time_cnt3	    <= time_cnt3 +1;
			         end if;
			    when print_right=>
			         if time_cnt3<="011"then
			             time_cnt3	    <= time_cnt3 +1;
			         end if;
				when wait_r =>
					if time_cnt3<="011"then
			             time_cnt3	    <= time_cnt3 +1;
			         end if;
				when wait_l =>
					if time_cnt3<="011"then
			             time_cnt3	    <= time_cnt3 +1;
			         end if;
				when others =>
					time_cnt3	    <= "000";
				end case;
	   end if;
	
	end process;
	
	new_clk_3_cnt:process(new_clk, rst)
	begin
	   if rst = '1' then
					new_clk_3 <= new_clk(25);	
	   else
	       case pingpong_FSM_3 is
				
				when pp_l_r =>
					new_clk_3 <= new_clk(23);
					
				when pp_r_l =>
					new_clk_3 <= new_clk(23);
					
				when pp_l_r2 =>
					new_clk_3 <= new_clk(25);
					
				when pp_r_l2 =>
					new_clk_3 <= new_clk(25);					
			    
				when others =>
					
					new_clk_3 <= new_clk(25);	
				
				end case;
	   end if;
	
	end process;
LED_reg3_cnt:process(new_clk_3, rst)
	begin
	   if rst = '1' then
	       LED_reg3	    <= "00000001";
	   elsif(Rising_edge(new_clk_3))then
	       case pingpong_FSM_3 is
				when pp_right =>
					LED_reg3	<= "00000001";	
				when pp_left =>
					LED_reg3	<= "10000000";
				when pp_l_r =>
					LED_reg3	<= LED_reg3(0)&LED_reg3(7 downto 1);
				when pp_r_l =>
					LED_reg3	<= LED_reg3(6 downto 0)& LED_reg3(7);
				when pp_l_r2 =>
					LED_reg3	<= LED_reg3(0)&LED_reg3(7 downto 1);
				when pp_r_l2 =>
					LED_reg3	<= LED_reg3(6 downto 0)& LED_reg3(7);
			    when print_left=>
			        --LED_reg3    <= L_point_reg3(0)&L_point_reg3(1)&L_point_reg3(2)&L_point_reg3(3)&R_point_reg3(3 downto 0);
			        if (new_clk(25) = '1')then
			            LED_reg3    <= L_point_reg3(0)&L_point_reg3(1)&L_point_reg3(2)&L_point_reg3(3)&R_point_reg3(3 downto 0);
			        else
			            LED_reg3 <= (others => '0');
			        end if;
			    when print_right=>
			        if (new_clk(25) = '1')then
			            LED_reg3    <= L_point_reg3(0)&L_point_reg3(1)&L_point_reg3(2)&L_point_reg3(3)&R_point_reg3(3 downto 0);
			        else
			            LED_reg3 <= (others => '0');
			        end if;
				when others =>
					null;
				
				end case;
	   end if;
	
	end process;
	LED_reg3_state:process(clk, rst, LED_reg3)
	begin
		if rst = '1' then
			
			pingpong_FSM_3	<=pp_right;
			L_point_reg3			<= (others =>'0');		
            R_point_reg3			<= (others =>'0');
		elsif(Rising_edge(clk))then
		   if mode = "10"then
                case pingpong_FSM_3 is
                    when pp_right =>
                        --LED_reg1	<= "00000001";	
                        -- if Button_R = '1' and LED_reg3 = "00000001"and time_cnt3>="011" then
                            -- pingpong_FSM_3 <= pp_r_l;
                        -- end if; 
						if Button_R = '1'and LED_reg3 = "00000001" and time_cnt3>="001" and R_mode3 = '0' then
                            pingpong_FSM_3 <= pp_r_l;
						elsif Button_R = '1'and LED_reg3 = "00000001" and time_cnt3>="001" and R_mode3 = '1'  then
                            pingpong_FSM_3 <= pp_r_l2;
                        end if;
                    
                    when pp_left =>
                        --LED_reg1	<= "10000000";
                        if Button_L = '1'and LED_reg3 = "10000000" and time_cnt3>="001" and L_mode3 = '0' then
                            pingpong_FSM_3 <= pp_l_r;
						elsif Button_L = '1'and LED_reg3 = "10000000" and time_cnt3>="001" and L_mode3 = '1'  then
                            pingpong_FSM_3 <= pp_l_r2;
                        end if;
                        
                    when pp_l_r =>
                        
                        --LED_reg1	<= LED_reg1(0)&LED_reg1(7 downto 1);
                        if LED_reg3(0)='1' then
                            pingpong_FSM_3 <= wait_r;
                        elsif Button_R = '1'then
                            pingpong_FSM_3 	<= print_right;
                            L_point_reg3			<= L_point_reg3 +1;
                        end if;
                        
                    when pp_r_l =>
                        --LED_reg1	<= LED_reg1(6 downto 0)& LED_reg1(7);
                        
                        if LED_reg3(7)='1' then
                            pingpong_FSM_3 <= wait_l;
                        elsif Button_L = '1'then
                            pingpong_FSM_3	<= print_left;
                            R_point_reg3			<= R_point_reg3 +1;
                        end if;
                        
                    when pp_l_r2 =>
                        
                        --LED_reg1	<= LED_reg1(0)&LED_reg1(7 downto 1);
                        if LED_reg3(0)='1' then
                            pingpong_FSM_3 <= wait_r;
                        elsif Button_R = '1'then
                            pingpong_FSM_3 	<= print_right;
                            L_point_reg3			<= L_point_reg3 +1;
                        end if;
                        
                    when pp_r_l2 =>
                        --LED_reg1	<= LED_reg1(6 downto 0)& LED_reg1(7);
                        
                        if LED_reg3(7)='1' then
                            pingpong_FSM_3 <= wait_l;
                        elsif Button_L = '1'then
                            pingpong_FSM_3	<= print_left;
                            R_point_reg3			<= R_point_reg3 +1;
                        end if;
                        
                    when wait_r =>
                        
                        if time_cnt3>="010"then
                            pingpong_FSM_3 <= print_right;
                            L_point_reg3			<= L_point_reg3 +1;
                        elsif Button_R = '1'then
                            if  R_mode3 = '0' then
                                pingpong_FSM_3 <= pp_r_l;                            
                            else
                                pingpong_FSM_3 <= pp_r_l2;                            
                            end if;
                        end if;
                    when wait_l =>
                        
                        if time_cnt3>="010"then
                            pingpong_FSM_3 <= print_left;
                            R_point_reg3			<= R_point_reg3 +1;
                        elsif Button_L = '1'then
                            if  L_mode3 = '0' then
                                pingpong_FSM_3 <= pp_l_r;                            
                            else
                                pingpong_FSM_3 <= pp_l_r2;                            
                            end if;
                        end if;
                    when print_left =>
                        if Button_L = '1'and time_cnt3>="001" then
                            pingpong_FSM_3 <= pp_left;
                            
                        end if;
                    when print_right =>
                        if Button_R = '1'and time_cnt3>="001" then
                            pingpong_FSM_3 <= pp_right;
                        end if;
                    
                    end case;
               end if;
            end if;
	end process;

LED_reg4    <= L_point_reg3(0)&L_point_reg3(1)&L_point_reg3(2)&L_point_reg3(3)&R_point_reg3(3 downto 0);
end Behavioral;

