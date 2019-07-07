----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:32:08 12/07/2019 
-- Design Name: 
-- Module Name:    AVR_ALU - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity AVR_ALU is port(

              Rr_in   : in std_logic_vector(7 downto 0):=x"00";
              Rd_in   : in std_logic_vector(7 downto 0):=x"00";
              
              c_flag_in   : in std_logic:='0';
              z_flag_in   : in std_logic:='0';
				  n_flag_in   : in std_logic:='0';
				  v_flag_in   : in std_logic:='0';
				  s_flag_in   : in std_logic:='0';
				  h_flag_in   : in std_logic:='0';
				  t_flag_in   : in std_logic:='0';
				  i_flag_in   : in std_logic:='0';
				  
				  alu_oc   : in std_logic:='0';
				  alu_out_sel   : in std_logic:='0';


-- OPERATION SIGNALS INPUTS
              idc_add         :in std_logic:='0';
              idc_adc         :in std_logic:='0';
              idc_sub         :in std_logic:='0';
              idc_sbc         :in std_logic:='0';

              idc_and         :in std_logic:='0';
              idc_or          :in std_logic:='0';
              idc_eor         :in std_logic:='0';                          

              idc_inc         :in std_logic:='0';
              idc_dec         :in std_logic:='0';

              idc_cp          :in std_logic:='0';              
              idc_cpc         :in std_logic:='0';                           

              idc_lsr         :in std_logic:='0';
				  idc_lsl         :in std_logic:='0';
				  
				  idc_bset			:in std_logic:='0';
				  idc_bclr			:in std_logic:='0';



-- DATA OUTPUT
              data_out    : out std_logic_vector(7 downto 0):=x"00";

-- FLAGS OUTPUT
              c_flag_out  : out std_logic:='0';
              z_flag_out  : out std_logic:='0';
              n_flag_out  : out std_logic:='0';
              v_flag_out  : out std_logic:='0';
              s_flag_out  : out std_logic:='0';
              h_flag_out  : out std_logic:='0';
				  t_flag_out  : out std_logic:='0';
				  i_flag_out  : out std_logic:='0'
);
end AVR_ALU;

architecture Behavioral of AVR_ALU is

-- Internal Signals For Outputs
signal data_out_int,data_comp_int    :std_logic_vector(7 downto 0):=x"00";		--Internal ALU Result
signal c_flag_int,z_flag_int,n_flag_int,v_flag_int,s_flag_int,h_flag_int,t_flag_int,i_flag_int	:std_logic:='0';

begin

	ALU:process(
			idc_add,      
			idc_adc,  
			idc_sub,    
			idc_sbc,        

			idc_and,                
			idc_or,                 
			idc_eor,                                  

			idc_inc,         
			idc_dec,         

			idc_cp,                       
			idc_cpc,                                          

			idc_lsl,         
			idc_lsr,
			
			idc_bclr,         
			idc_bset,
			
			c_flag_int,
			z_flag_int,
			n_flag_int,
			v_flag_int,
			s_flag_int,
			h_flag_int,
			t_flag_int,
			i_flag_int,
			
			Rd_in,
			Rr_in,
			alu_out_sel,
			
			c_flag_in,
			z_flag_in,
			n_flag_in,
			v_flag_in,
			s_flag_in,
			h_flag_in,
			t_flag_in,
			i_flag_in,
			
			
			
			data_out_int,
			data_comp_int)
				
				begin
					
					if idc_add = '1' then
						data_comp_int <= Rd_in;
						data_out_int <= Rd_in + Rr_in;													--Calculating The Result
						h_flag_int <= ( Rd_in(3) and Rr_in(3) ) or 									--Calculating The H Flag
							( Rr_in(3) and not(data_out_int(3)) ) or
							( not(data_out_int(3)) and Rd_in(3) );
						v_flag_int <= ( Rd_in(7) and Rr_in(7) and not(data_out_int(7)) ) or	--Calculating The V Flag	
								( not(Rd_in(7)) and not(Rr_in(7)) and not(data_out_int(7)) );
						n_flag_int <= data_out_int(7);													--Calculating The N Flag
						if data_out_int = X"00" then														--Calculating The Z Flag
							z_flag_int<='1';
						else
							z_flag_int<='0';
						end if;
						c_flag_int <= ( Rd_in(7) and Rr_in(7) ) or									--Calculating The C Flag 
							( Rr_in(7) and not(data_out_int(7)) ) or
							( not(data_out_int(7)) and Rd_in(7) );
						t_flag_int<=t_flag_in;
						i_flag_int<=i_flag_in;
						s_flag_int<=n_flag_int xor v_flag_int;
					
					elsif idc_adc = '1' then
						data_comp_int <= Rd_in;
						data_out_int <= Rd_in + Rr_in + c_flag_in;									--Calculating The Result
						h_flag_int <= ( Rd_in(3) and Rr_in(3) ) or 									--Calculating The H Flag
							( Rr_in(3) and not(data_out_int(3)) ) or
							( not(data_out_int(3)) and Rd_in(3) );
						v_flag_int <= ( Rd_in(7) and Rr_in(7) and not(data_out_int(7)) ) or	--Calculating The V Flag	
								( not(Rd_in(7)) and not(Rr_in(7)) and not(data_out_int(7)) );
						n_flag_int <= data_out_int(7);													--Calculating The N Flag
						if data_out_int = X"00" then														--Calculating The Z Flag
							z_flag_int<='1';
						else
							z_flag_int<='0';
						end if;
						c_flag_int <= ( Rd_in(7) and Rr_in(7) ) or									--Calculating The C Flag 
							( Rr_in(7) and not(data_out_int(7)) ) or
							( not(data_out_int(7)) and Rd_in(7) );
						t_flag_int<=t_flag_in;
						i_flag_int<=i_flag_in;
						s_flag_int<=n_flag_int xor v_flag_int;
					
					elsif idc_sub = '1' then
						data_comp_int <= Rd_in;
						data_out_int <= Rd_in - Rr_in;													--Calculating The Result
						h_flag_int <= ( not(Rd_in(3)) and Rr_in(3) ) or 							--Calculating The H Flag
							( Rr_in(3) and data_out_int(3) ) or
							( data_out_int(3) and not(Rd_in(3)) );
						v_flag_int <= ( Rd_in(7) and not(Rr_in(7)) and not(data_out_int(7)) ) or	--Calculating The V Flag	
								( not(Rd_in(7)) and Rr_in(7) and data_out_int(7) );
						n_flag_int <= data_out_int(7);													--Calculating The N Flag
						if data_out_int = X"00" then														--Calculating The Z Flag
							z_flag_int<='1';
						else
							z_flag_int<='0';
						end if;
						c_flag_int <= ( not(Rd_in(7)) and Rr_in(7) ) or									--Calculating The C Flag 
							( Rr_in(7) and data_out_int(7) ) or
							( data_out_int(7) and not(Rd_in(7)) );
						t_flag_int<=t_flag_in;
						i_flag_int<=i_flag_in;
						s_flag_int<=n_flag_int xor v_flag_int;
					
					elsif idc_sbc = '1' then
						data_comp_int <= Rd_in;
						data_out_int <= Rd_in - Rr_in - c_flag_in;									--Calculating The Result
						h_flag_int <= ( not(Rd_in(3)) and Rr_in(3) ) or 							--Calculating The H Flag
							( Rr_in(3) and data_out_int(3) ) or
							( data_out_int(3) and not(Rd_in(3)) );
						v_flag_int <= ( Rd_in(7) and not(Rr_in(7)) and not(data_out_int(7)) ) or	--Calculating The V Flag	
								( not(Rd_in(7)) and Rr_in(7) and data_out_int(7) );
						n_flag_int <= data_out_int(7);													--Calculating The N Flag
						if data_out_int = X"00" and z_flag_in = '1' then														--Calculating The Z Flag
							z_flag_int<='1';
						else
							z_flag_int<='0';
						end if;
						c_flag_int <= ( not(Rd_in(7)) and Rr_in(7) ) or									--Calculating The C Flag 
							( Rr_in(7) and data_out_int(7) ) or
							( data_out_int(7) and not(Rd_in(7)) );
						t_flag_int<=t_flag_in;
						i_flag_int<=i_flag_in;
						s_flag_int<=n_flag_int xor v_flag_int; 
					
					elsif idc_and = '1' then
						data_comp_int <= Rd_in;
						data_out_int <= Rd_in and Rr_in;													--Calculating The Result
						h_flag_int <= h_flag_in; 															--Calculating The H Flag
						v_flag_int <= '0';																	--Calculating The V Flag	
						n_flag_int <= data_out_int(7);													--Calculating The N Flag
						if data_out_int = X"00" then														--Calculating The Z Flag
							z_flag_int<='1';
						else
							z_flag_int<='0';
						end if;
						c_flag_int <= c_flag_in;
						t_flag_int<=t_flag_in;
						i_flag_int<=i_flag_in;
						s_flag_int<=n_flag_int xor v_flag_int;															--Calculating The C Flag 
					
					elsif idc_or = '1' then
						data_comp_int <= Rd_in;
						data_out_int <= Rd_in or Rr_in;													--Calculating The Result
						h_flag_int <= h_flag_in; 															--Calculating The H Flag
						v_flag_int <= '0';																	--Calculating The V Flag	
						n_flag_int <= data_out_int(7);													--Calculating The N Flag
						if data_out_int = X"00" then														--Calculating The Z Flag
							z_flag_int<='1';
						else
							z_flag_int<='0';
						end if;
						c_flag_int <= c_flag_in;
						t_flag_int<=t_flag_in;
						i_flag_int<=i_flag_in;
						s_flag_int<=n_flag_int xor v_flag_int;
						
					elsif idc_eor = '1' then
						data_comp_int <= Rd_in;
						data_out_int <= Rd_in xor Rr_in;													--Calculating The Result
						h_flag_int <= h_flag_in; 															--Calculating The H Flag
						v_flag_int <= '0';																	--Calculating The V Flag	
						n_flag_int <= data_out_int(7);													--Calculating The N Flag
						if data_out_int = X"00" then														--Calculating The Z Flag
							z_flag_int<='1';
						else
							z_flag_int<='0';
						end if;
						c_flag_int <= c_flag_in;
						t_flag_int<=t_flag_in;
						i_flag_int<=i_flag_in;
						s_flag_int<=n_flag_int xor v_flag_int;
						
					elsif idc_inc = '1' then
						data_comp_int <= Rd_in;
						data_out_int <= Rd_in + 1;															--Calculating The Result
						h_flag_int <= h_flag_in; 															--Calculating The H Flag
						v_flag_int <= data_out_int(7) and not(data_out_int(6)) and				--Calculating The V Flag	
								not(data_out_int(5)) and not(data_out_int(4)) and
								not(data_out_int(3)) and not(data_out_int(2)) and
								not(data_out_int(1)) and not(data_out_int(0));
						n_flag_int <= data_out_int(7);													--Calculating The N Flag
						if data_out_int = X"00" then														--Calculating The Z Flag
							z_flag_int<='1';
						else
							z_flag_int<='0';
						end if;
						c_flag_int <= c_flag_in;
						t_flag_int<=t_flag_in;
						i_flag_int<=i_flag_in;
						s_flag_int<=n_flag_int xor v_flag_int;
						
					elsif idc_dec = '1' then
						data_comp_int <= Rd_in;
						data_out_int <= Rd_in - 1;															--Calculating The Result
						h_flag_int <= h_flag_in; 															--Calculating The H Flag
						v_flag_int <= not(data_out_int(7)) and data_out_int(6) and			--Calculating The V Flag	
								data_out_int(5) and data_out_int(4) and
								data_out_int(3) and data_out_int(2) and
								data_out_int(1) and data_out_int(0);
						n_flag_int <= data_out_int(7);													--Calculating The N Flag
						if data_out_int = X"00" then														--Calculating The Z Flag
							z_flag_int<='1';
						else
							z_flag_int<='0';
						end if;
						c_flag_int <= c_flag_in;
						t_flag_int<=t_flag_in;
						i_flag_int<=i_flag_in;
						s_flag_int<=n_flag_int xor v_flag_int;
						
					elsif idc_cp = '1' then
						data_comp_int <= Rd_in - Rr_in;													--Calculating The Result
						data_out_int <= Rd_in;
						h_flag_int <= ( not(Rd_in(3)) and Rr_in(3) ) or 							--Calculating The H Flag
							( Rr_in(3) and data_comp_int(3) ) or
							( data_comp_int(3) and not(Rd_in(3)) );
						v_flag_int <= ( Rd_in(7) and not(Rr_in(7)) and not(data_comp_int(7)) ) or	--Calculating The V Flag	
								( not(Rd_in(7)) and Rr_in(7) and data_comp_int(7) );
						n_flag_int <= data_comp_int(7);													--Calculating The N Flag
						if data_comp_int = X"00" then														--Calculating The Z Flag
							z_flag_int<='1';
						else
							z_flag_int<='0';
						end if;
						c_flag_int <= ( not(Rd_in(7)) and Rr_in(7) ) or									--Calculating The C Flag 
							( Rr_in(7) and data_comp_int(7) ) or
							( data_comp_int(7) and not(Rd_in(7)) );
						t_flag_int<=t_flag_in;
						i_flag_int<=i_flag_in;
						s_flag_int<=n_flag_int xor v_flag_int;
							
					elsif idc_cpc = '1' then
						data_comp_int <= Rd_in - Rr_in - c_flag_in;									--Calculating The Result
						data_out_int <= Rd_in;
						h_flag_int <= ( not(Rd_in(3)) and Rr_in(3) ) or 							--Calculating The H Flag
							( Rr_in(3) and data_comp_int(3) ) or
							( data_comp_int(3) and not(Rd_in(3)) );
						v_flag_int <= ( Rd_in(7) and not(Rr_in(7)) and not(data_comp_int(7)) ) or	--Calculating The V Flag	
								( not(Rd_in(7)) and Rr_in(7) and data_comp_int(7) );
						n_flag_int <= data_comp_int(7);													--Calculating The N Flag
						if data_comp_int = X"00" and z_flag_in = '1' then							--Calculating The Z Flag
							z_flag_int<='1';
						else
							z_flag_int<='0';
						end if;
						c_flag_int <= ( not(Rd_in(7)) and Rr_in(7) ) or									--Calculating The C Flag 
							( Rr_in(7) and data_comp_int(7) ) or
							( data_comp_int(7) and not(Rd_in(7)) );
						t_flag_int<=t_flag_in;
						i_flag_int<=i_flag_in;
						s_flag_int<=n_flag_int xor v_flag_int;
					
					elsif idc_lsl = '1' then
						data_comp_int <= Rd_in;
						data_out_int <= Rd_in(6 downto 0) & '0';										--Calculating The Result
						h_flag_int <= RD_in(3); 															--Calculating The H Flag
						v_flag_int <= Rd_in(7) xor data_out_int(7);									--Calculating The V Flag	
						n_flag_int <= data_out_int(7);													--Calculating The N Flag
						if data_out_int = X"00" then														--Calculating The Z Flag
							z_flag_int<='1';
						else
							z_flag_int<='0';
						end if;
						c_flag_int <= Rd_in(7);
						t_flag_int<=t_flag_in;
						i_flag_int<=i_flag_in;
						s_flag_int<=n_flag_int xor v_flag_int;
					
					elsif idc_lsr = '1' then
						data_comp_int <= Rd_in;
						data_out_int <= '0' & Rd_in(7 downto 1);										--Calculating The Result
						h_flag_int <= h_flag_in; 															--Calculating The H Flag
						v_flag_int <= Rd_in(0) xor '0';									--Calculating The V Flag	
						n_flag_int <= '0';													--Calculating The N Flag
						if data_out_int = X"00" then														--Calculating The Z Flag
							z_flag_int<='1';
						else
							z_flag_int<='0';
						end if;
						c_flag_int <= Rd_in(0);
						t_flag_int<=t_flag_in;
						i_flag_int<=i_flag_in;
						s_flag_int<=n_flag_int xor v_flag_int;
					
					elsif idc_bclr = '1' then
						data_comp_int <= Rd_in;
						data_out_int <= Rd_in;
						case Rr_in is
							when x"00" =>		
								c_flag_int <= '0'; 
								z_flag_int <= z_flag_in; 
								n_flag_int <= n_flag_in; 
								v_flag_int <= v_flag_in;
								s_flag_int <= s_flag_in;
								h_flag_int <= h_flag_in; 
								t_flag_int <= t_flag_in;
								i_flag_int <= i_flag_in;
							when x"01" =>		
								c_flag_int <= c_flag_in; 
								z_flag_int <= '0'; 
								n_flag_int <= n_flag_in; 
								v_flag_int <= v_flag_in;
								s_flag_int <= s_flag_in;
								h_flag_int <= h_flag_in; 
								t_flag_int <= t_flag_in;
								i_flag_int <= i_flag_in;
							when x"02" =>		
								c_flag_int <= c_flag_in; 
								z_flag_int <= z_flag_in; 
								n_flag_int <= '0'; 
								v_flag_int <= v_flag_in;
								s_flag_int <= s_flag_in;
								h_flag_int <= h_flag_in; 
								t_flag_int <= t_flag_in;
								i_flag_int <= i_flag_in;
							when x"03" =>		
								c_flag_int <= c_flag_in; 
								z_flag_int <= z_flag_in; 
								n_flag_int <= n_flag_in; 
								v_flag_int <= '0';
								s_flag_int <= s_flag_in;
								h_flag_int <= h_flag_in; 
								t_flag_int <= t_flag_in;
								i_flag_int <= i_flag_in;
							when x"04" =>		
								c_flag_int <= c_flag_in; 
								z_flag_int <= z_flag_in; 
								n_flag_int <= n_flag_in; 
								v_flag_int <= v_flag_in;
								s_flag_int <= '0';
								h_flag_int <= h_flag_in; 
								t_flag_int <= t_flag_in;
								i_flag_int <= i_flag_in;
							when x"05" =>		
								c_flag_int <= c_flag_in; 
								z_flag_int <= z_flag_in; 
								n_flag_int <= n_flag_in; 
								v_flag_int <= v_flag_in;
								s_flag_int <= s_flag_in;
								h_flag_int <= '0'; 
								t_flag_int <= t_flag_in;
								i_flag_int <= i_flag_in;
							when x"06" =>		
								c_flag_int <= c_flag_in; 
								z_flag_int <= z_flag_in; 
								n_flag_int <= n_flag_in; 
								v_flag_int <= v_flag_in;
								s_flag_int <= s_flag_in;
								h_flag_int <= h_flag_in; 
								t_flag_int <= '0';
								i_flag_int <= i_flag_in;
							when x"07" =>		
								c_flag_int <= c_flag_in; 
								z_flag_int <= z_flag_in; 
								n_flag_int <= n_flag_in; 
								v_flag_int <= v_flag_in;
								s_flag_int <= s_flag_in;
								h_flag_int <= h_flag_in; 
								t_flag_int <= t_flag_in;
								i_flag_int <= '0';
							when others =>		
								c_flag_int <= c_flag_in; 
								z_flag_int <= z_flag_in; 
								n_flag_int <= n_flag_in; 
								v_flag_int <= v_flag_in;
								s_flag_int <= s_flag_in;
								h_flag_int <= h_flag_in; 
								t_flag_int <= t_flag_in;
								i_flag_int <= i_flag_in;
						end case;
						
					elsif idc_bset = '1' then
						data_comp_int <= Rd_in;
						data_out_int <= Rd_in;
						case Rr_in is
							when x"00" =>		
								c_flag_int <= '1'; 
								z_flag_int <= z_flag_in; 
								n_flag_int <= n_flag_in; 
								v_flag_int <= v_flag_in;
								s_flag_int <= s_flag_in;
								h_flag_int <= h_flag_in; 
								t_flag_int <= t_flag_in;
								i_flag_int <= i_flag_in;
							when x"01" =>		
								c_flag_int <= c_flag_in; 
								z_flag_int <= '1'; 
								n_flag_int <= n_flag_in; 
								v_flag_int <= v_flag_in;
								s_flag_int <= s_flag_in;
								h_flag_int <= h_flag_in; 
								t_flag_int <= t_flag_in;
								i_flag_int <= i_flag_in;
							when x"02" =>		
								c_flag_int <= c_flag_in; 
								z_flag_int <= z_flag_in; 
								n_flag_int <= '1'; 
								v_flag_int <= v_flag_in;
								s_flag_int <= s_flag_in;
								h_flag_int <= h_flag_in; 
								t_flag_int <= t_flag_in;
								i_flag_int <= i_flag_in;
							when x"03" =>		
								c_flag_int <= c_flag_in; 
								z_flag_int <= z_flag_in; 
								n_flag_int <= n_flag_in; 
								v_flag_int <= '1';
								s_flag_int <= s_flag_in;
								h_flag_int <= h_flag_in; 
								t_flag_int <= t_flag_in;
								i_flag_int <= i_flag_in;
							when x"04" =>		
								c_flag_int <= c_flag_in; 
								z_flag_int <= z_flag_in; 
								n_flag_int <= n_flag_in; 
								v_flag_int <= v_flag_in;
								s_flag_int <= '1';
								h_flag_int <= h_flag_in; 
								t_flag_int <= t_flag_in;
								i_flag_int <= i_flag_in;
							when x"05" =>		
								c_flag_int <= c_flag_in; 
								z_flag_int <= z_flag_in; 
								n_flag_int <= n_flag_in; 
								v_flag_int <= v_flag_in;
								s_flag_int <= s_flag_in;
								h_flag_int <= '1'; 
								t_flag_int <= t_flag_in;
								i_flag_int <= i_flag_in;
							when x"06" =>		
								c_flag_int <= c_flag_in; 
								z_flag_int <= z_flag_in; 
								n_flag_int <= n_flag_in; 
								v_flag_int <= v_flag_in;
								s_flag_int <= s_flag_in;
								h_flag_int <= h_flag_in; 
								t_flag_int <= '1';
								i_flag_int <= i_flag_in;
							when x"07" =>		
								c_flag_int <= c_flag_in; 
								z_flag_int <= z_flag_in; 
								n_flag_int <= n_flag_in; 
								v_flag_int <= v_flag_in;
								s_flag_int <= s_flag_in;
								h_flag_int <= h_flag_in; 
								t_flag_int <= t_flag_in;
								i_flag_int <= '1';
							when others =>		
								c_flag_int <= c_flag_in; 
								z_flag_int <= z_flag_in; 
								n_flag_int <= n_flag_in; 
								v_flag_int <= v_flag_in;
								s_flag_int <= s_flag_in;
								h_flag_int <= h_flag_in; 
								t_flag_int <= t_flag_in;
								i_flag_int <= i_flag_in;
						end case;
							
					else
						if (alu_out_sel = '0') then
							data_comp_int <= Rd_in;
							data_out_int <= Rd_in;
						else
							data_comp_int <= Rr_in;
							data_out_int <= Rr_in;
						end if;
						c_flag_int <= c_flag_in; 
						z_flag_int <= z_flag_in; 
						n_flag_int <= n_flag_in; 
						v_flag_int <= v_flag_in;
						h_flag_int <= h_flag_in;
						s_flag_int <= s_flag_in; 
						t_flag_int <= t_flag_in;
						i_flag_int <= i_flag_in;
						
					
					end if;
					
		end process;
		c_flag_out<=c_flag_int;
		z_flag_out<=z_flag_int;
		n_flag_out<=n_flag_int;
		v_flag_out<=v_flag_int;
		s_flag_out<=s_flag_int;
		h_flag_out<=h_flag_int;
		t_flag_out<=t_flag_int;
		i_flag_out<=i_flag_int;
		
		data_out<=data_out_int when alu_oc = '1' else
				  "ZZZZZZZZ";

end Behavioral; 
