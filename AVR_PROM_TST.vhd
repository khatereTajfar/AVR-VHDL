--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:00:47 10/07/2019 
-- Design Name:   
-- Module Name:   D:/AVR/AVR_CORE/AVR_PROM_TST.vhd
-- Project Name:  AVR_CORE
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: AVR_PROM
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
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY PROM_TST IS
END PROM_TST;
 
ARCHITECTURE behavior OF PROM_TST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT AVR_PROM
    PORT(
         address_in : IN  std_logic_vector(13 downto 0);
         data_out : OUT  std_logic_vector(15 downto 0)
         
        );
    END COMPONENT;
    

   --Inputs
   signal address_in : std_logic_vector(13 downto 0) := (others => '0');
  

 	--Outputs
   signal data_out : std_logic_vector(15 downto 0);

  
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: AVR_PROM PORT MAP (
          address_in => address_in,
          data_out => data_out
        );

  
 

   -- Stimulus process
   stim_proc: process
   begin		
      for i in 0 to 20 loop
		address_in <= conv_std_logic_vector(i,14);
      wait for 10 ns;
		end loop;

      -- insert stimulus here 

      wait;
   end process;

END;
