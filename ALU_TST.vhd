--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:02:38 17/07/2019 
-- Design Name:   
-- Module Name:   D:/AVR/AVR_CORE/ALU_TST.vhd
-- Project Name:  AVR_CORE
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: AVR_ALU
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY ALU_TST IS
END ALU_TST;
 
ARCHITECTURE behavior OF ALU_TST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT AVR_ALU
    PORT(
         Rr_in : IN  std_logic_vector(7 downto 0);
         Rd_in : IN  std_logic_vector(7 downto 0);
         c_flag_in : IN  std_logic;
         z_flag_in : IN  std_logic;
         n_flag_in : IN  std_logic;
         v_flag_in : IN  std_logic;
         s_flag_in : IN  std_logic;
         h_flag_in : IN  std_logic;
			alu_oc   : IN std_logic;
         idc_add : IN  std_logic;
         idc_adc : IN  std_logic;
         idc_sub : IN  std_logic;
         idc_sbc : IN  std_logic;
         idc_and : IN  std_logic;
         idc_or : IN  std_logic;
         idc_eor : IN  std_logic;
         idc_inc : IN  std_logic;
         idc_dec : IN  std_logic;
         idc_cp : IN  std_logic;
         idc_cpc : IN  std_logic;
         idc_lsr : IN  std_logic;
         idc_lsl : IN  std_logic;
         data_out : OUT  std_logic_vector(7 downto 0);
         c_flag_out : OUT  std_logic;
         z_flag_out : OUT  std_logic;
         n_flag_out : OUT  std_logic;
         v_flag_out : OUT  std_logic;
         s_flag_out : OUT  std_logic;
         h_flag_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Rr_in : std_logic_vector(7 downto 0) := (others => '0');
   signal Rd_in : std_logic_vector(7 downto 0) := (others => '0');
   signal c_flag_in : std_logic := '0';
   signal z_flag_in : std_logic := '0';
   signal n_flag_in : std_logic := '0';
   signal v_flag_in : std_logic := '0';
   signal s_flag_in : std_logic := '0';
   signal h_flag_in : std_logic := '0';
	signal alu_oc   : std_logic := '0';
   signal idc_add : std_logic := '0';
   signal idc_adc : std_logic := '0';
   signal idc_sub : std_logic := '0';
   signal idc_sbc : std_logic := '0';
   signal idc_and : std_logic := '0';
   signal idc_or : std_logic := '0';
   signal idc_eor : std_logic := '0';
   signal idc_inc : std_logic := '0';
   signal idc_dec : std_logic := '0';
   signal idc_cp : std_logic := '0';
   signal idc_cpc : std_logic := '0';
   signal idc_lsr : std_logic := '0';
   signal idc_lsl : std_logic := '0';

 	--Outputs
   signal data_out : std_logic_vector(7 downto 0);
   signal c_flag_out : std_logic;
   signal z_flag_out : std_logic;
   signal n_flag_out : std_logic;
   signal v_flag_out : std_logic;
   signal s_flag_out : std_logic;
   signal h_flag_out : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: AVR_ALU PORT MAP (
          Rr_in => Rr_in,
          Rd_in => Rd_in,
          c_flag_in => c_flag_in,
          z_flag_in => z_flag_in,
          n_flag_in => n_flag_in,
          v_flag_in => v_flag_in,
          s_flag_in => s_flag_in,
          h_flag_in => h_flag_in,
			 alu_oc => alu_oc,
          idc_add => idc_add,
          idc_adc => idc_adc,
          idc_sub => idc_sub,
          idc_sbc => idc_sbc,
          idc_and => idc_and,
          idc_or => idc_or,
          idc_eor => idc_eor,
          idc_inc => idc_inc,
          idc_dec => idc_dec,
          idc_cp => idc_cp,
          idc_cpc => idc_cpc,
          idc_lsr => idc_lsr,
          idc_lsl => idc_lsl,
          data_out => data_out,
          c_flag_out => c_flag_out,
          z_flag_out => z_flag_out,
          n_flag_out => n_flag_out,
          v_flag_out => v_flag_out,
          s_flag_out => s_flag_out,
          h_flag_out => h_flag_out
        );
 

   -- Stimulus process
   stim_proc: process
   begin		
      alu_oc<='1';
		Rd_in<=x"0F";
		Rr_in<=x"0A";
		h_flag_in<='0';
		c_flag_in<='1';
		z_flag_in<='0';
		n_flag_in<='0';
		s_flag_in<='0';
		v_flag_in<='0';
		idc_add<='1';
      wait for 20 ns;

		Rd_in<=x"0F";
		Rr_in<=x"0A";
		h_flag_in<='0';
		c_flag_in<='1';
		z_flag_in<='0';
		n_flag_in<='0';
		s_flag_in<='0';
		v_flag_in<='0';
		idc_add<='0';
		idc_adc<='1';
      wait for 20 ns;
		
		Rd_in<=x"0F";
		Rr_in<=x"0A";
		h_flag_in<='0';
		c_flag_in<='1';
		z_flag_in<='0';
		n_flag_in<='0';
		s_flag_in<='0';
		v_flag_in<='0';
		idc_adc<='0';
		idc_sub<='1';
      wait for 20 ns;
		
		Rd_in<=x"0F";
		Rr_in<=x"0A";
		h_flag_in<='0';
		c_flag_in<='1';
		z_flag_in<='1';
		n_flag_in<='0';
		s_flag_in<='0';
		v_flag_in<='0';
		idc_sub<='0';
		idc_sbc<='1';
      wait for 20 ns;
		
		Rd_in<=x"0F";
		Rr_in<=x"0A";
		h_flag_in<='0';
		c_flag_in<='1';
		z_flag_in<='0';
		n_flag_in<='0';
		s_flag_in<='0';
		v_flag_in<='0';
		idc_sbc<='0';
		idc_and<='1';
      wait for 20 ns;
		
		Rd_in<=x"0F";
		Rr_in<=x"0A";
		h_flag_in<='1';
		c_flag_in<='1';
		z_flag_in<='1';
		n_flag_in<='1';
		s_flag_in<='1';
		v_flag_in<='1';
		idc_and<='0';
		idc_or<='1';
      wait for 20 ns;
		
		Rd_in<=x"0F";
		Rr_in<=x"0A";
		h_flag_in<='0';
		c_flag_in<='1';
		z_flag_in<='0';
		n_flag_in<='0';
		s_flag_in<='0';
		v_flag_in<='0';
		idc_or<='0';
		idc_eor<='1';
      wait for 20 ns;
		
		Rd_in<=x"0F";
		Rr_in<=x"0A";
		h_flag_in<='0';
		c_flag_in<='1';
		z_flag_in<='0';
		n_flag_in<='0';
		s_flag_in<='0';
		v_flag_in<='0';
		idc_eor<='0';
		idc_cp<='1';
      wait for 20 ns;
		
		Rd_in<=x"0F";
		Rr_in<=x"0A";
		h_flag_in<='0';
		c_flag_in<='1';
		z_flag_in<='0';
		n_flag_in<='0';
		s_flag_in<='0';
		v_flag_in<='0';
		idc_cp<='0';
		idc_cpc<='1';
      wait for 20 ns;
		
		Rd_in<=x"0F";
		Rr_in<=x"0A";
		h_flag_in<='0';
		c_flag_in<='1';
		z_flag_in<='0';
		n_flag_in<='0';
		s_flag_in<='0';
		v_flag_in<='0';
		idc_cpc<='0';
		idc_lsl<='1';
      wait for 20 ns;
		
		Rd_in<=x"0F";
		Rr_in<=x"0A";
		h_flag_in<='0';
		c_flag_in<='1';
		z_flag_in<='0';
		n_flag_in<='0';
		s_flag_in<='0';
		v_flag_in<='0';
		idc_lsl<='0';
		idc_lsr<='1';
      wait for 20 ns;
		
		Rd_in<=x"0F";
		Rr_in<=x"0A";
		h_flag_in<='0';
		c_flag_in<='1';
		z_flag_in<='0';
		n_flag_in<='0';
		s_flag_in<='0';
		v_flag_in<='0';
		idc_lsr<='0';
		idc_inc<='1';
      wait for 20 ns;
		
		Rd_in<=x"0F";
		Rr_in<=x"0A";
		h_flag_in<='0';
		c_flag_in<='1';
		z_flag_in<='0';
		n_flag_in<='0';
		s_flag_in<='0';
		v_flag_in<='0';
		idc_inc<='0';
		idc_dec<='1';
      wait for 20 ns;
		alu_oc<='0';
		

      wait;
   end process;

END;
