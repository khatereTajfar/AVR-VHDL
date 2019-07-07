--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:52:24 27/07/2019 
-- Design Name:   
-- Module Name:   D:/AVR/AVR_CORE/AVR_CORE_TST.vhd
-- Project Name:  AVR_CORE
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: AVR_Core
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
 
ENTITY AVR_CORE_TST IS
END AVR_CORE_TST;
 
ARCHITECTURE behavior OF AVR_CORE_TST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT AVR_Core
    PORT(
         ireset : IN  std_logic;
         iclk : IN  std_logic;
         adr : OUT  std_logic_vector(5 downto 0);
         iore : OUT  std_logic;
         iowe : OUT  std_logic;
         irqlines : IN  std_logic_vector(22 downto 0);
         irqack : OUT  std_logic;
         irqackad : OUT  std_logic_vector(4 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal ireset : std_logic := '0';
   signal iclk : std_logic := '0';
   signal irqlines : std_logic_vector(22 downto 0) := (others => '0');

 	--Outputs
   signal adr : std_logic_vector(5 downto 0);
   signal iore : std_logic;
   signal iowe : std_logic;
   signal irqack : std_logic;
   signal irqackad : std_logic_vector(4 downto 0);

   -- Clock period definitions
   constant iclk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: AVR_Core PORT MAP (
          ireset => ireset,
          iclk => iclk,
          adr => adr,
          iore => iore,
          iowe => iowe,
          irqlines => irqlines,
          irqack => irqack,
          irqackad => irqackad
        );

   -- Clock process definitions
   iclk_process :process
   begin
		iclk <= '0';
		wait for iclk_period/2;
		iclk <= '1';
		wait for iclk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for iclk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
