library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

entity controller_FSM is
port( 
	  inst_type 		: in std_logic_vector(1 downto 0);
      immidiate 		: in std_logic;
      ldr_or_str        : in std_logic;   --  0=str ;; 1=ldr    
      MUL  				: in std_logic;
      hwDT 				: in std_logic;
      pre_or_post       : in std_logic;   --0->pre and 1->post
      writeback         : in std_logic;  
      clock             : in std_logic;
      reset             : in std_logic;
      state 			: inout std_logic_vector(3 downto 0);
      stop              : in std_logic
	);
end controller_FSM;

Architecture Behavioral of controller_FSM is
signal wt : std_logic_vector(1 downto 0);

Begin
process(clock)
begin
if(clock='1' and clock 'event) then
    if (reset='1') then
        state <= "0000";
        wt <= "00";
    
	elsif (state="0000") then
	if stop='0' then
	   if(wt="00") then wt <="01"; 
	   elsif(wt="01") then wt <= "10";
	   elsif(wt="10") then
	       if (inst_type="00") then
	           state <= "0001";
		   elsif (inst_type="01") then
			   state <= "0001";
		   elsif (inst_type="10") then
			   state <= "0001";
	       end if;
	   wt <="00";
	   end if;
	 end if;
		
	elsif (state="0001") then
		if (inst_type="00") then
			if (MUL='1') then
				state <= "0110";
			elsif (hwDT='1') then
				state <= "1011";
			elsif (immidiate='1') then
				state <= "0101";
			elsif (immidiate='0') then
				state <= "0010";
			end if;
		elsif (inst_type="01") then
			state <= "1011";
		elsif (inst_type="10") then
			state <= "1001";
		end if;
	elsif (state="0010") then
		if (inst_type="00") then
			state <= "0011";
		end if;
	elsif (state="0011") then
		if (inst_type="00") then
			state <="0100"; 
		end if;
	elsif (state="0100") then
		if (inst_type="00") then
			state <="0000"; 
		end if;
	elsif (state="0101") then
		if (inst_type="00") then
			state <= "0100";
		end if;
	elsif (state="0110") then
		if (inst_type="00") then
			state <= "0111";
		end if;
	elsif (state="0111") then
		if (inst_type="00") then
			state <= "1000";
		end if;	
	elsif (state="1000") then
		if (inst_type="00") then
			state <= "0000";
		end if;
	elsif (state="1001") then
		if (inst_type="10") then
			state <= "1010";
		end if;
	elsif (state="1010") then
		if (inst_type="10") then
			state <= "0000";
		end if;	
	elsif (state="1011") then
		if (inst_type="00" or inst_type="01") then
			state <= "1100";
		end if;	
	elsif (state="1100") then
		if (inst_type="00" or inst_type="01") then
			state <= "1101";
		end if;
	elsif (state="1101") then
	    if(wt="00") then wt <="01"; 
        elsif(wt="01") then wt <= "10";
        elsif(wt="10") then wt <= "11";
        elsif(wt="11") then
	       if (inst_type="00" or inst_type="01") then
	           if(ldr_or_str='0' and writeback='0') then
			 	   state <= "0000";
	           elsif(ldr_or_str='1') then
				   state <= "1110";
	           elsif ((ldr_or_str='0' and pre_or_post='1') or (ldr_or_str='0' and pre_or_post='0' and writeback='1')) then
				   state <= "1111";				
	           end if;
	       end if;
         wt <="00";
         end if;
		
	elsif (state="1110") then
		if (inst_type="00" or inst_type="01") then
			if(writeback='1') then
				state <= "1111";
			elsif (writeback='0') then
				state <= "0000";
			end if;			
		end if;
	elsif (state="1111") then
		if (inst_type="00" or inst_type="01") then
			state <= "0000";
		end if;
	end if;
end if;
end process ; -- 
end Behavioral;