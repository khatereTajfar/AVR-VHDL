----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:46:07 10/07/2019 
-- Design Name: 
-- Module Name:    AVR_PROM - Behavioral 
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

entity AVR_PROM is port (
address_in : in  std_logic_vector (13 downto 0);
data_out   : out std_logic_vector (15 downto 0));
end AVR_PROM;

architecture Behavioral of AVR_PROM is

begin
data_out <= 
				 x"940C" when address_in = 16#0000# else
             x"0030" when address_in = 16#0001# else
             x"E00A" when address_in = 16#0030# else
             x"E114" when address_in = 16#0031# else
             x"E04A" when address_in = 16#0032# else
             x"E15E" when address_in = 16#0033# else
             x"0F10" when address_in = 16#0034# else
             x"1740" when address_in = 16#0035# else
             x"0000" when address_in = 16#0036# else
             x"F469" when address_in = 16#0037# else
             x"9503" when address_in = 16#0038# else
             x"1F14" when address_in = 16#0039# else
             x"940C" when address_in = 16#003A# else
             x"0035" when address_in = 16#003B# else
             x"950A" when address_in = 16#0045# else
             x"2F14" when address_in = 16#0046# else
             x"940C" when address_in = 16#0047# else
             x"0035" when address_in = 16#0048# else
             x"ffff";
end Behavioral;

