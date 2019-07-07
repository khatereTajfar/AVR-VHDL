----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:30:32 10/07/2019 
-- Design Name: 
-- Module Name:    AVR_SRAM - Behavioral 
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

entity AVR_SRAM is port(
					clk     : in std_logic;
					address : in  std_logic_vector (10 downto 0);
					sram_we : in  std_logic;
					din     : in  std_logic_vector (7 downto 0);
					dout    : out	std_logic_vector (7 downto 0)
					   );
end AVR_SRAM;

architecture Behavioral of AVR_SRAM is

type RAMFileType is array(0 to 2047) of std_logic_vector(7 downto 0);
signal RAMFile : RAMFileType := (others => x"00"); 

begin

DataWrite:process(clk)
	begin
		if clk='1' and clk'event then         
			if sram_we='1' then                   
				RAMFile(CONV_INTEGER(address)) <= din;	
			end if;
		end if;
	end process;	

dout <= RAMFile(CONV_INTEGER(address));


end Behavioral;
