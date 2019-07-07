----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:   10:55:11 18/07/2019 
-- Design Name: 
-- Module Name:    AVR_Core - Behavioral 
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
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity AVR_Core is port(
				
					ireset   : in std_logic;
					iclk   : in std_logic;
					
					-- I/O REGISTERS PORTS
					adr      : out std_logic_vector (5 downto 0);
					iore     : out std_logic;                   
					iowe     : out std_logic;					
					
					-- INTERRUPTS PORT
					irqlines : in std_logic_vector (22 downto 0);
					irqack   : out std_logic;
					irqackad : out std_logic_vector(4 downto 0)
					);
end AVR_Core;

architecture Behavioral of AVR_Core is
attribute KEEP : string;
--	ALU Component
component AVR_ALU is port(

              Rr_in   : in std_logic_vector(7 downto 0);
              Rd_in   : in std_logic_vector(7 downto 0);
              
              c_flag_in   : in std_logic;
              z_flag_in   : in std_logic;
				  n_flag_in   : in std_logic;
				  v_flag_in   : in std_logic;
				  s_flag_in   : in std_logic;
				  h_flag_in   : in std_logic;
				  t_flag_in   : in std_logic;
				  i_flag_in   : in std_logic;
				  
				  alu_oc   : in std_logic;
				  alu_out_sel   : in std_logic;


-- OPERATION SIGNALS INPUTS
              idc_add         :in std_logic;
              idc_adc         :in std_logic;
              idc_sub         :in std_logic;
              idc_sbc         :in std_logic;

              idc_and         :in std_logic;
              idc_or          :in std_logic;
              idc_eor         :in std_logic;                          

              idc_inc         :in std_logic;
              idc_dec         :in std_logic;

              idc_cp          :in std_logic;              
              idc_cpc         :in std_logic;                           

              idc_lsr         :in std_logic;
				  idc_lsl         :in std_logic;
				  
				  idc_bset			:in std_logic;
				  idc_bclr			:in std_logic;



-- DATA OUTPUT
              data_out    : out std_logic_vector(7 downto 0);

-- FLAGS OUTPUT
              c_flag_out  : out std_logic;
              z_flag_out  : out std_logic;
              n_flag_out  : out std_logic;
              v_flag_out  : out std_logic;
              s_flag_out  : out std_logic;
              h_flag_out  : out std_logic;
				  t_flag_out  : out std_logic;
				  i_flag_out  : out std_logic
);
end component;
--	SRAM Component
component AVR_SRAM is port(
					clk     : in std_logic;
					address : in  std_logic_vector (10 downto 0);
					sram_we : in  std_logic;
					din     : in  std_logic_vector (7 downto 0);
					dout    : out	std_logic_vector (7 downto 0)
					   );
end component;
--PROM Component
component AVR_PROM is port (
						address_in : in  std_logic_vector (13 downto 0);
						data_out   : out std_logic_vector (15 downto 0));
end component;
--PipeLines States
type pipeline	is (fetch,ex_add,ex_adc,ex_sub,ex_sbc,ex_and,ex_or,ex_eor,
						ex_inc,ex_dec,ex_cp,ex_cpc,ex_lsr,ex_lsl,ex_bset,ex_bclr,ex_nop,
						ex_jmp,ex_lds,ex_sts,ex_brb,ex_mov,ex_ldi);
signal pipe1	:	pipeline	:=fetch;
signal pipe2	:	pipeline	:=ex_nop;

-- General Units
type GPR_type is array (0 to 31) of std_logic_vector(7 downto 0);

signal	PC	: std_logic_vector(13 downto 0):="00000000000000";
signal 	IR	: std_logic_vector(15 downto 0):="0000000000000000";
signal	SREG	:	std_logic_vector(7 downto 0):="00000000";
signal	GPR	:	GPR_type	:= (others => x"00");
signal	Rd_adr_save	:	std_logic_vector(4 downto 0):="00000";
signal	k_adr_save	:	std_logic_vector(6 downto 0):="0000000";
--attribute KEEP of PC :signal is "TRUE";

-- ALU Signals
signal	alu_rr,alu_rd,alu_out	:	std_logic_vector(7 downto 0):=x"00";
signal	alu_out_sel,alu_add,alu_adc,alu_sub,alu_sbc,alu_and,alu_or,alu_eor,alu_inc,alu_dec,
			alu_cp,alu_cpc,alu_lsr,alu_lsl,alu_bset,alu_bclr,
			alu_c_flag,alu_z_flag,alu_n_flag,alu_v_flag,alu_s_flag,alu_h_flag,alu_t_flag,alu_i_flag
				:	std_logic	:='0';
--	SRAM Signals				
signal	sram_adr	:	std_logic_vector(10 downto 0):="00000000000";
signal	sram_din,sram_dout	:	std_logic_vector(7 downto 0):=x"00";
signal	sram_we	:	std_logic:='0';

--PROM Signal
--signal	PROM_adr	:	std_logic_vector(13 downto 0);


begin

PROM	:	AVR_PROM	port map(
					PC,IR
									);

SRAM	:	AVR_SRAM port map(
					iclk,sram_adr,sram_we,sram_din,sram_dout
									);

ALU 	: 	AVR_ALU port map(
					alu_rr,alu_rd,
					SREG(0),SREG(1),SREG(2),SREG(3),SREG(4),SREG(5),SREG(6),SREG(7),
					'1',alu_out_sel,
					alu_add,alu_adc,alu_sub,alu_sbc,alu_and,alu_or,alu_eor,alu_inc,alu_dec,
					alu_cp,alu_cpc,alu_lsr,alu_lsl,alu_bset,alu_bclr,
					alu_out,alu_c_flag,alu_z_flag,alu_n_flag,alu_v_flag,alu_s_flag,alu_h_flag,alu_t_flag,alu_i_flag
									);

process(ireset,iclk)
	begin
	if ireset = '1' then
		PC<="00000000000000";
		SREG<=x"00";
	else
		if (iclk'event and iclk = '1') then
			if pipe1 = ex_jmp then														--JMP Execution Pipe_1
				pipe1 <= fetch;
				PC <= IR(13 downto 0);
			
			elsif pipe1 = ex_brb then													--BRBS and BRBC Execution Pipe_1
				pipe1 <= fetch;
				if(k_adr_save(6) = '1') then
					PC <= PC - not(k_adr_save-1);
				else
					PC <= PC + k_adr_save;
				end if;
				
			elsif pipe1 = ex_lds then													--LDS Execution Pipe_1
				pipe1 <= fetch;
			
			elsif pipe1 = ex_sts then													--STS Execution Pipe_1
				pipe1 <= fetch;
				
			elsif pipe2 = ex_jmp then													--JMP Execution Pipe_2
				pipe2 <= fetch;
				PC <= IR(13 downto 0);
			
			elsif pipe2 = ex_brb then													--BRBS and BRBC Execution Pipe_2
				pipe2 <= fetch;
				if(k_adr_save(6) = '1') then
					PC <= PC - not(k_adr_save-1);
				else
					PC <= PC + k_adr_save;
				end if;
				
			elsif pipe2 = ex_lds then													--LDS Execution Pipe_2
				pipe1 <= fetch;
			
			elsif pipe2 = ex_sts then													--STS Execution Pipe_2
				pipe1 <= fetch;
			
			else
				
				PC<=PC+1;
				
				if pipe1 = fetch  and pipe2 /= fetch then													--Fetch Pipe_1
					
					case pipe2 is
						when ex_add =>
							pipe2 <= fetch;
							alu_add <='0';
							GPR(conv_integer(Rd_adr_save)) <= alu_out;
							SREG(0) <= alu_c_flag;SREG(1) <= alu_z_flag;SREG(2) <= alu_n_flag;SREG(3) <= alu_v_flag;SREG(4) <= alu_s_flag;SREG(5) <= alu_h_flag;SREG(6) <= alu_t_flag;SREG(7) <= alu_i_flag;
						when ex_adc =>
							pipe2 <= fetch;
							alu_adc <='0';
							GPR(conv_integer(Rd_adr_save)) <= alu_out;
							SREG(0) <= alu_c_flag;SREG(1) <= alu_z_flag;SREG(2) <= alu_n_flag;SREG(3) <= alu_v_flag;SREG(4) <= alu_s_flag;SREG(5) <= alu_h_flag;SREG(6) <= alu_t_flag;SREG(7) <= alu_i_flag;
						when ex_sub =>
							pipe2 <= fetch;
							alu_sub <='0';
							GPR(conv_integer(Rd_adr_save)) <= alu_out;
							SREG(0) <= alu_c_flag;SREG(1) <= alu_z_flag;SREG(2) <= alu_n_flag;SREG(3) <= alu_v_flag;SREG(4) <= alu_s_flag;SREG(5) <= alu_h_flag;SREG(6) <= alu_t_flag;SREG(7) <= alu_i_flag;
						when ex_sbc =>
							pipe2 <= fetch;
							alu_sbc <='0';
							GPR(conv_integer(Rd_adr_save)) <= alu_out;
							SREG(0) <= alu_c_flag;SREG(1) <= alu_z_flag;SREG(2) <= alu_n_flag;SREG(3) <= alu_v_flag;SREG(4) <= alu_s_flag;SREG(5) <= alu_h_flag;SREG(6) <= alu_t_flag;SREG(7) <= alu_i_flag;
						when ex_and =>
							pipe2 <= fetch;
							alu_and <='0';
							GPR(conv_integer(Rd_adr_save)) <= alu_out;
							SREG(0) <= alu_c_flag;SREG(1) <= alu_z_flag;SREG(2) <= alu_n_flag;SREG(3) <= alu_v_flag;SREG(4) <= alu_s_flag;SREG(5) <= alu_h_flag;SREG(6) <= alu_t_flag;SREG(7) <= alu_i_flag;
						when ex_or =>
							pipe2 <= fetch;
							alu_or <='0';
							GPR(conv_integer(Rd_adr_save)) <= alu_out;
							SREG(0) <= alu_c_flag;SREG(1) <= alu_z_flag;SREG(2) <= alu_n_flag;SREG(3) <= alu_v_flag;SREG(4) <= alu_s_flag;SREG(5) <= alu_h_flag;SREG(6) <= alu_t_flag;SREG(7) <= alu_i_flag;
						when ex_eor =>
							pipe2 <= fetch;
							alu_eor <='0';
							GPR(conv_integer(Rd_adr_save)) <= alu_out;
							SREG(0) <= alu_c_flag;SREG(1) <= alu_z_flag;SREG(2) <= alu_n_flag;SREG(3) <= alu_v_flag;SREG(4) <= alu_s_flag;SREG(5) <= alu_h_flag;SREG(6) <= alu_t_flag;SREG(7) <= alu_i_flag;
						when ex_inc =>
							pipe2 <= fetch;
							alu_inc <='0';
							GPR(conv_integer(Rd_adr_save)) <= alu_out;
							SREG(0) <= alu_c_flag;SREG(1) <= alu_z_flag;SREG(2) <= alu_n_flag;SREG(3) <= alu_v_flag;SREG(4) <= alu_s_flag;SREG(5) <= alu_h_flag;SREG(6) <= alu_t_flag;SREG(7) <= alu_i_flag;
						when ex_dec =>
							pipe2 <= fetch;
							alu_dec <='0';
							GPR(conv_integer(Rd_adr_save)) <= alu_out;
							SREG(0) <= alu_c_flag;SREG(1) <= alu_z_flag;SREG(2) <= alu_n_flag;SREG(3) <= alu_v_flag;SREG(4) <= alu_s_flag;SREG(5) <= alu_h_flag;SREG(6) <= alu_t_flag;SREG(7) <= alu_i_flag;
						when ex_cp =>
							pipe2 <= fetch;
							alu_cp <='0';
							SREG(0) <= alu_c_flag;SREG(1) <= alu_z_flag;SREG(2) <= alu_n_flag;SREG(3) <= alu_v_flag;SREG(4) <= alu_s_flag;SREG(5) <= alu_h_flag;SREG(6) <= alu_t_flag;SREG(7) <= alu_i_flag;
						when ex_cpc =>
							pipe2 <= fetch;
							alu_cpc <='0';
							SREG(0) <= alu_c_flag;SREG(1) <= alu_z_flag;SREG(2) <= alu_n_flag;SREG(3) <= alu_v_flag;SREG(4) <= alu_s_flag;SREG(5) <= alu_h_flag;SREG(6) <= alu_t_flag;SREG(7) <= alu_i_flag;
						when ex_lsr =>
							pipe2 <= fetch;
							alu_lsr <='0';
							GPR(conv_integer(Rd_adr_save)) <= alu_out;
							SREG(0) <= alu_c_flag;SREG(1) <= alu_z_flag;SREG(2) <= alu_n_flag;SREG(3) <= alu_v_flag;SREG(4) <= alu_s_flag;SREG(5) <= alu_h_flag;SREG(6) <= alu_t_flag;SREG(7) <= alu_i_flag;
						when ex_lsl =>
							pipe2 <= fetch;
							alu_lsl <='0';
							GPR(conv_integer(Rd_adr_save)) <= alu_out;
							SREG(0) <= alu_c_flag;SREG(1) <= alu_z_flag;SREG(2) <= alu_n_flag;SREG(3) <= alu_v_flag;SREG(4) <= alu_s_flag;SREG(5) <= alu_h_flag;SREG(6) <= alu_t_flag;SREG(7) <= alu_i_flag;
						when ex_bset =>
							pipe2 <= fetch;
							alu_bset <='0';
							SREG(0) <= alu_c_flag;SREG(1) <= alu_z_flag;SREG(2) <= alu_n_flag;SREG(3) <= alu_v_flag;SREG(4) <= alu_s_flag;SREG(5) <= alu_h_flag;SREG(6) <= alu_t_flag;SREG(7) <= alu_i_flag;
						when ex_bclr =>
							pipe2 <= fetch;
							alu_bclr <='0';
							SREG(0) <= alu_c_flag;SREG(1) <= alu_z_flag;SREG(2) <= alu_n_flag;SREG(3) <= alu_v_flag;SREG(4) <= alu_s_flag;SREG(5) <= alu_h_flag;SREG(6) <= alu_t_flag;SREG(7) <= alu_i_flag;
						when ex_mov =>
							pipe2 <= fetch;
							alu_out_sel <='0';
							GPR(conv_integer(Rd_adr_save)) <= alu_out;
							SREG(0) <= alu_c_flag;SREG(1) <= alu_z_flag;SREG(2) <= alu_n_flag;SREG(3) <= alu_v_flag;SREG(4) <= alu_s_flag;SREG(5) <= alu_h_flag;SREG(6) <= alu_t_flag;SREG(7) <= alu_i_flag;
						when ex_ldi =>
							pipe2 <= fetch;
							alu_out_sel <='0';
							GPR(conv_integer(Rd_adr_save)) <= alu_out;
							SREG(0) <= alu_c_flag;SREG(1) <= alu_z_flag;SREG(2) <= alu_n_flag;SREG(3) <= alu_v_flag;SREG(4) <= alu_s_flag;SREG(5) <= alu_h_flag;SREG(6) <= alu_t_flag;SREG(7) <= alu_i_flag;
						when ex_nop =>
							pipe2 <= fetch;
							
						when others =>
					end case;
					
					if (IR(15 downto 9)&IR(3 downto 1)="1001010110") then						-- JMP
						pipe1<= ex_jmp;
						pipe2 <= ex_nop;
					elsif	(IR(15 downto 9)&IR(3 downto 0) = "10010000000") then				-- LDS
						pipe1<= ex_lds;
						pipe2 <= ex_nop;
					elsif	(IR(15 downto 9)&IR(3 downto 0) = "10010010000") then				-- STS
						pipe1<= ex_sts;
						pipe2 <= ex_nop;
					elsif IR(15 downto 10) = "000011" then 										-- ADD
						pipe1<= ex_add;
						Rd_adr_save <= IR(8 downto 4);
						alu_rd <= GPR(conv_integer(IR(8 downto 4)));
						alu_rr <= GPR(conv_integer(IR(9)&IR(3 downto 0)));
						alu_add <= '1';
					elsif IR(15 downto 10) = "000111" then 										-- ADC
						pipe1<= ex_adc;
						Rd_adr_save <= IR(8 downto 4);
						alu_rd <= GPR(conv_integer(IR(8 downto 4)));
						alu_rr <= GPR(conv_integer(IR(9)&IR(3 downto 0)));
						alu_adc <= '1';
					elsif IR(15 downto 10) = "000110" then 										-- SUB
						pipe1<= ex_sub;
						Rd_adr_save <= IR(8 downto 4);
						alu_rd <= GPR(conv_integer(IR(8 downto 4)));
						alu_rr <= GPR(conv_integer(IR(9)&IR(3 downto 0)));
						alu_sub <= '1';
					elsif IR(15 downto 10) = "000010" then 										-- SBC
						pipe1<= ex_sbc;
						Rd_adr_save <= IR(8 downto 4);
						alu_rd <= GPR(conv_integer(IR(8 downto 4)));
						alu_rr <= GPR(conv_integer(IR(9)&IR(3 downto 0)));
						alu_sbc <= '1';
					elsif IR(15 downto 10) = "001000" then 										-- AND
						pipe1<= ex_and;
						Rd_adr_save <= IR(8 downto 4);
						alu_rd <= GPR(conv_integer(IR(8 downto 4)));
						alu_rr <= GPR(conv_integer(IR(9)&IR(3 downto 0)));
						alu_and <= '1';
					elsif IR(15 downto 10) = "001010" then 										-- OR
						pipe1<= ex_or;
						Rd_adr_save <= IR(8 downto 4);
						alu_rd <= GPR(conv_integer(IR(8 downto 4)));
						alu_rr <= GPR(conv_integer(IR(9)&IR(3 downto 0)));
						alu_or <= '1';
					elsif IR(15 downto 10) = "001001" then 										-- EOR
						pipe1<= ex_eor;
						Rd_adr_save <= IR(8 downto 4);
						alu_rd <= GPR(conv_integer(IR(8 downto 4)));
						alu_rr <= GPR(conv_integer(IR(9)&IR(3 downto 0)));
						alu_eor <= '1';
					elsif IR(15 downto 9)&IR(3 downto 0) = "10010100011" then 				-- INC
						pipe1<= ex_inc;
						Rd_adr_save <= IR(8 downto 4);
						alu_rd <= GPR(conv_integer(IR(8 downto 4)));
						alu_inc <= '1';
					elsif IR(15 downto 9)&IR(3 downto 0) = "10010101010" then 				-- DEC
						pipe1<= ex_dec;
						Rd_adr_save <= IR(8 downto 4);
						alu_rd <= GPR(conv_integer(IR(8 downto 4)));
						alu_dec <= '1';
					elsif IR(15 downto 10) = "000101" then 										-- CP
						pipe1<= ex_cp;
						alu_rd <= GPR(conv_integer(IR(8 downto 4)));
						alu_rr <= GPR(conv_integer(IR(9)&IR(3 downto 0)));
						alu_cp <= '1';
					elsif IR(15 downto 10) = "000001" then 										-- CPC
						pipe1<= ex_cpc;
						alu_rd <= GPR(conv_integer(IR(8 downto 4)));
						alu_rr <= GPR(conv_integer(IR(9)&IR(3 downto 0)));
						alu_cpc <= '1';
					elsif IR(15 downto 9)&IR(3 downto 0) = "10010100110" then 				-- LSR
						pipe1<= ex_lsr;
						Rd_adr_save <= IR(8 downto 4);
						alu_rd <= GPR(conv_integer(IR(8 downto 4)));
						alu_lsr <= '1';
					elsif IR(15 downto 10) = "000011" then 										-- LSL
						pipe1<= ex_lsl;
						Rd_adr_save <= IR(8 downto 4);
						alu_rd <= GPR(conv_integer(IR(8 downto 4)));
						alu_lsl <= '1';
					elsif IR(15 downto 7)&IR(3 downto 0) = "1001010001000" then 			-- BSET
						pipe1<= ex_bset;
						alu_rr <= "00000"&IR(6 downto 4);
						alu_bset <= '1';
					elsif IR(15 downto 7)&IR(3 downto 0) = "1001010011000" then 			-- BCLR
						pipe1<= ex_bclr;
						alu_rr <= "00000"&IR(6 downto 4);
						alu_bclr <= '1';
					elsif IR(15 downto 10) = "001011" then 										-- MOV
						pipe1<= ex_mov;
						Rd_adr_save <= IR(8 downto 4);
						alu_rr <= GPR(conv_integer(IR(9)&IR(3 downto 0)));
						alu_out_sel <= '1';
					elsif IR(15 downto 12) = "1110" then 											-- LDI
						pipe1<= ex_ldi;
						Rd_adr_save <= "1"&IR(7 downto 4);
						alu_rr <= IR(11 downto 8)&IR(3 downto 0);
						alu_out_sel <= '1';
					elsif IR = "0000000000000000" then 												-- NOP
						pipe1<= ex_nop;
					elsif IR(15 downto 10) = "111100" then 										-- BRBS
						if SREG(conv_integer(IR(2 downto 0))) = '1' then
							pipe1<= ex_brb;
							pipe2 <= ex_nop;
							k_adr_save <=IR(9 downto 3);
						else
							pipe1<= ex_nop;
						end if;
					elsif IR(15 downto 10) = "111101" then 										-- BRBC
						if SREG(conv_integer(IR(2 downto 0))) = '0' then
							pipe1<= ex_brb;
							pipe2 <= ex_nop;
							k_adr_save <=IR(9 downto 3);
						else
							pipe1<= ex_nop;
						end if;
						
						
					
					end if;
				
				elsif pipe2 = fetch and pipe1 /= fetch then														-- Fetch Pipe_2
					
					case pipe1 is
						when ex_add =>
							pipe1 <= fetch;
							alu_add <='0';
							GPR(conv_integer(Rd_adr_save)) <= alu_out;
							SREG(0) <= alu_c_flag;SREG(1) <= alu_z_flag;SREG(2) <= alu_n_flag;SREG(3) <= alu_v_flag;SREG(4) <= alu_s_flag;SREG(5) <= alu_h_flag;SREG(6) <= alu_t_flag;SREG(7) <= alu_i_flag;
						when ex_adc =>
							pipe1 <= fetch;
							alu_adc <='0';
							GPR(conv_integer(Rd_adr_save)) <= alu_out;
							SREG(0) <= alu_c_flag;SREG(1) <= alu_z_flag;SREG(2) <= alu_n_flag;SREG(3) <= alu_v_flag;SREG(4) <= alu_s_flag;SREG(5) <= alu_h_flag;SREG(6) <= alu_t_flag;SREG(7) <= alu_i_flag;
						when ex_sub =>
							pipe1 <= fetch;
							alu_sub <='0';
							GPR(conv_integer(Rd_adr_save)) <= alu_out;
							SREG(0) <= alu_c_flag;SREG(1) <= alu_z_flag;SREG(2) <= alu_n_flag;SREG(3) <= alu_v_flag;SREG(4) <= alu_s_flag;SREG(5) <= alu_h_flag;SREG(6) <= alu_t_flag;SREG(7) <= alu_i_flag;
						when ex_sbc =>
							pipe1 <= fetch;
							alu_sbc <='0';
							GPR(conv_integer(Rd_adr_save)) <= alu_out;
							SREG(0) <= alu_c_flag;SREG(1) <= alu_z_flag;SREG(2) <= alu_n_flag;SREG(3) <= alu_v_flag;SREG(4) <= alu_s_flag;SREG(5) <= alu_h_flag;SREG(6) <= alu_t_flag;SREG(7) <= alu_i_flag;
						when ex_and =>
							pipe1 <= fetch;
							alu_and <='0';
							GPR(conv_integer(Rd_adr_save)) <= alu_out;
							SREG(0) <= alu_c_flag;SREG(1) <= alu_z_flag;SREG(2) <= alu_n_flag;SREG(3) <= alu_v_flag;SREG(4) <= alu_s_flag;SREG(5) <= alu_h_flag;SREG(6) <= alu_t_flag;SREG(7) <= alu_i_flag;
						when ex_or =>
							pipe1 <= fetch;
							alu_or <='0';
							GPR(conv_integer(Rd_adr_save)) <= alu_out;
							SREG(0) <= alu_c_flag;SREG(1) <= alu_z_flag;SREG(2) <= alu_n_flag;SREG(3) <= alu_v_flag;SREG(4) <= alu_s_flag;SREG(5) <= alu_h_flag;SREG(6) <= alu_t_flag;SREG(7) <= alu_i_flag;
						when ex_eor =>
							pipe1 <= fetch;
							alu_eor <='0';
							GPR(conv_integer(Rd_adr_save)) <= alu_out;
							SREG(0) <= alu_c_flag;SREG(1) <= alu_z_flag;SREG(2) <= alu_n_flag;SREG(3) <= alu_v_flag;SREG(4) <= alu_s_flag;SREG(5) <= alu_h_flag;SREG(6) <= alu_t_flag;SREG(7) <= alu_i_flag;
						when ex_inc =>
							pipe1 <= fetch;
							alu_inc <='0';
							GPR(conv_integer(Rd_adr_save)) <= alu_out;
							SREG(0) <= alu_c_flag;SREG(1) <= alu_z_flag;SREG(2) <= alu_n_flag;SREG(3) <= alu_v_flag;SREG(4) <= alu_s_flag;SREG(5) <= alu_h_flag;SREG(6) <= alu_t_flag;SREG(7) <= alu_i_flag;
						when ex_dec =>
							pipe1 <= fetch;
							alu_dec <='0';
							GPR(conv_integer(Rd_adr_save)) <= alu_out;
							SREG(0) <= alu_c_flag;SREG(1) <= alu_z_flag;SREG(2) <= alu_n_flag;SREG(3) <= alu_v_flag;SREG(4) <= alu_s_flag;SREG(5) <= alu_h_flag;SREG(6) <= alu_t_flag;SREG(7) <= alu_i_flag;
						when ex_cp =>
							pipe1 <= fetch;
							alu_cp <='0';
							SREG(0) <= alu_c_flag;SREG(1) <= alu_z_flag;SREG(2) <= alu_n_flag;SREG(3) <= alu_v_flag;SREG(4) <= alu_s_flag;SREG(5) <= alu_h_flag;SREG(6) <= alu_t_flag;SREG(7) <= alu_i_flag;
						when ex_cpc =>
							pipe1 <= fetch;
							alu_cpc <='0';
							SREG(0) <= alu_c_flag;SREG(1) <= alu_z_flag;SREG(2) <= alu_n_flag;SREG(3) <= alu_v_flag;SREG(4) <= alu_s_flag;SREG(5) <= alu_h_flag;SREG(6) <= alu_t_flag;SREG(7) <= alu_i_flag;
						when ex_lsr =>
							pipe1 <= fetch;
							alu_lsr <='0';
							GPR(conv_integer(Rd_adr_save)) <= alu_out;
							SREG(0) <= alu_c_flag;SREG(1) <= alu_z_flag;SREG(2) <= alu_n_flag;SREG(3) <= alu_v_flag;SREG(4) <= alu_s_flag;SREG(5) <= alu_h_flag;SREG(6) <= alu_t_flag;SREG(7) <= alu_i_flag;
						when ex_lsl =>
							pipe1 <= fetch;
							alu_lsl <='0';
							GPR(conv_integer(Rd_adr_save)) <= alu_out;
							SREG(0) <= alu_c_flag;SREG(1) <= alu_z_flag;SREG(2) <= alu_n_flag;SREG(3) <= alu_v_flag;SREG(4) <= alu_s_flag;SREG(5) <= alu_h_flag;SREG(6) <= alu_t_flag;SREG(7) <= alu_i_flag;
						when ex_bset =>
							pipe1 <= fetch;
							alu_bset <='0';
							SREG(0) <= alu_c_flag;SREG(1) <= alu_z_flag;SREG(2) <= alu_n_flag;SREG(3) <= alu_v_flag;SREG(4) <= alu_s_flag;SREG(5) <= alu_h_flag;SREG(6) <= alu_t_flag;SREG(7) <= alu_i_flag;
						when ex_bclr =>
							pipe1 <= fetch;
							alu_bclr <='0';
							SREG(0) <= alu_c_flag;SREG(1) <= alu_z_flag;SREG(2) <= alu_n_flag;SREG(3) <= alu_v_flag;SREG(4) <= alu_s_flag;SREG(5) <= alu_h_flag;SREG(6) <= alu_t_flag;SREG(7) <= alu_i_flag;
						when ex_mov =>
							pipe1 <= fetch;
							alu_out_sel <='0';
							GPR(conv_integer(Rd_adr_save)) <= alu_out;
							SREG(0) <= alu_c_flag;SREG(1) <= alu_z_flag;SREG(2) <= alu_n_flag;SREG(3) <= alu_v_flag;SREG(4) <= alu_s_flag;SREG(5) <= alu_h_flag;SREG(6) <= alu_t_flag;SREG(7) <= alu_i_flag;
						when ex_ldi =>
							pipe1 <= fetch;
							alu_out_sel <='0';
							GPR(conv_integer(Rd_adr_save)) <= alu_out;
							SREG(0) <= alu_c_flag;SREG(1) <= alu_z_flag;SREG(2) <= alu_n_flag;SREG(3) <= alu_v_flag;SREG(4) <= alu_s_flag;SREG(5) <= alu_h_flag;SREG(6) <= alu_t_flag;SREG(7) <= alu_i_flag;
						when ex_nop =>
							pipe1 <= fetch;
							
						when others =>
					end case;
					
					
					if (IR(15 downto 9)&IR(3 downto 1)="1001010110") then						-- JMP
						pipe2<= ex_jmp;
						pipe1 <= ex_nop;
					elsif	(IR(15 downto 9)&IR(3 downto 0) = "10010000000") then				-- LDS
						pipe2<= ex_lds;
						pipe1 <= ex_nop;
					elsif	(IR(15 downto 9)&IR(3 downto 0) = "10010010000") then				-- STS
						pipe2<= ex_sts;
						pipe1 <= ex_nop;
					elsif IR(15 downto 10) = "000011" then 										-- ADD
						pipe2<= ex_add;
						Rd_adr_save <= IR(8 downto 4);
						alu_rd <= GPR(conv_integer(IR(8 downto 4)));
						alu_rr <= GPR(conv_integer(IR(9)&IR(3 downto 0)));
						alu_add <= '1';
					elsif IR(15 downto 10) = "000111" then 										-- ADC
						pipe2<= ex_adc;
						Rd_adr_save <= IR(8 downto 4);
						alu_rd <= GPR(conv_integer(IR(8 downto 4)));
						alu_rr <= GPR(conv_integer(IR(9)&IR(3 downto 0)));
						alu_adc <= '1';
					elsif IR(15 downto 10) = "000110" then 										-- SUB
						pipe2<= ex_sub;
						Rd_adr_save <= IR(8 downto 4);
						alu_rd <= GPR(conv_integer(IR(8 downto 4)));
						alu_rr <= GPR(conv_integer(IR(9)&IR(3 downto 0)));
						alu_sub <= '1';
					elsif IR(15 downto 10) = "000010" then 										-- SBC
						pipe2<= ex_sbc;
						Rd_adr_save <= IR(8 downto 4);
						alu_rd <= GPR(conv_integer(IR(8 downto 4)));
						alu_rr <= GPR(conv_integer(IR(9)&IR(3 downto 0)));
						alu_sbc <= '1';
					elsif IR(15 downto 10) = "001000" then 										-- AND
						pipe2<= ex_and;
						Rd_adr_save <= IR(8 downto 4);
						alu_rd <= GPR(conv_integer(IR(8 downto 4)));
						alu_rr <= GPR(conv_integer(IR(9)&IR(3 downto 0)));
						alu_and <= '1';
					elsif IR(15 downto 10) = "001010" then 										-- OR
						pipe2<= ex_or;
						Rd_adr_save <= IR(8 downto 4);
						alu_rd <= GPR(conv_integer(IR(8 downto 4)));
						alu_rr <= GPR(conv_integer(IR(9)&IR(3 downto 0)));
						alu_or <= '1';
					elsif IR(15 downto 10) = "001001" then 										-- EOR
						pipe2<= ex_eor;
						Rd_adr_save <= IR(8 downto 4);
						alu_rd <= GPR(conv_integer(IR(8 downto 4)));
						alu_rr <= GPR(conv_integer(IR(9)&IR(3 downto 0)));
						alu_eor <= '1';
					elsif IR(15 downto 9)&IR(3 downto 0) = "10010100011" then 				-- INC
						pipe2<= ex_inc;
						Rd_adr_save <= IR(8 downto 4);
						alu_rd <= GPR(conv_integer(IR(8 downto 4)));
						alu_inc <= '1';
					elsif IR(15 downto 9)&IR(3 downto 0) = "10010101010" then 				-- DEC
						pipe2<= ex_dec;
						Rd_adr_save <= IR(8 downto 4);
						alu_rd <= GPR(conv_integer(IR(8 downto 4)));
						alu_dec <= '1';
					elsif IR(15 downto 10) = "000101" then 										-- CP
						pipe2<= ex_cp;
						alu_rd <= GPR(conv_integer(IR(8 downto 4)));
						alu_rr <= GPR(conv_integer(IR(9)&IR(3 downto 0)));
						alu_cp <= '1';
					elsif IR(15 downto 10) = "000001" then 										-- CPC
						pipe2<= ex_cpc;
						alu_rd <= GPR(conv_integer(IR(8 downto 4)));
						alu_rr <= GPR(conv_integer(IR(9)&IR(3 downto 0)));
						alu_cpc <= '1';
					elsif IR(15 downto 9)&IR(3 downto 0) = "10010100110" then 				-- LSR
						pipe2<= ex_lsr;
						Rd_adr_save <= IR(8 downto 4);
						alu_rd <= GPR(conv_integer(IR(8 downto 4)));
						alu_lsr <= '1';
					elsif IR(15 downto 10) = "000011" then 										-- LSL
						pipe2<= ex_lsl;
						Rd_adr_save <= IR(8 downto 4);
						alu_rd <= GPR(conv_integer(IR(8 downto 4)));
						alu_lsl <= '1';
					elsif IR(15 downto 7)&IR(3 downto 0) = "1001010001000" then 			-- BSET
						pipe2<= ex_bset;
						alu_rr <= "00000"&IR(6 downto 4);
						alu_bset <= '1';
					elsif IR(15 downto 7)&IR(3 downto 0) = "1001010011000" then 			-- BCLR
						pipe2<= ex_bclr;
						alu_rr <= "00000"&IR(6 downto 4);
						alu_bclr <= '1';
					elsif IR(15 downto 10) = "001011" then 										-- MOV
						pipe2<= ex_mov;
						Rd_adr_save <= IR(8 downto 4);
						alu_rr <= GPR(conv_integer(IR(9)&IR(3 downto 0)));
						alu_out_sel <= '1';
					elsif IR(15 downto 12) = "1110" then 											-- LDI
						pipe2<= ex_ldi;
						Rd_adr_save <= "1"&IR(7 downto 4);
						alu_rr <= IR(11 downto 8)&IR(3 downto 0);
						alu_out_sel <= '1';
					elsif IR = "0000000000000000" then 												-- NOP
						pipe2<= ex_nop;
					elsif IR(15 downto 10) = "111100" then 										-- BRBS
						if SREG(conv_integer(IR(2 downto 0))) = '1' then
							pipe2<= ex_brb;
							pipe1 <= ex_nop;
							k_adr_save <=IR(9 downto 3);
						else
							pipe2<= ex_nop;
						end if;
					elsif IR(15 downto 10) = "111101" then 										-- BRBC
						if SREG(conv_integer(IR(2 downto 0))) = '0' then
							pipe2<= ex_brb;
							pipe1 <= ex_nop;
							k_adr_save <=IR(9 downto 3);
						else
							pipe2<= ex_nop;
						end if;
					
					end if;
				else
				
				pipe2<= ex_nop;
									
				end if;
			
			end if;
					
		end if;
	end if;
	end process;
--alu_rd <= GPR(conv_integer(IR(8 downto 4)));
--
--
--alu_rr <=	IR(11 downto 8)&IR(3 downto 0) when alu_out_sel='1' else 
--				"00000"&IR(6 downto 4) when alu_bset = '1' or alu_bclr = '1' else
--				GPR(conv_integer(IR(9)&IR(3 downto 0)));
end Behavioral;
