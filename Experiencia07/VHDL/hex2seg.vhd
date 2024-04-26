-------------------------------------------------------------------------------
-- Author: Bruno Albertini (balbertini@usp.br)
-- Module Name: hex2seg
-- Description:
-- VHDL module to convert from hex (4b) to 7-segment
-------------------------------------------------------------------------------
entity hex2seg is
    port ( hex : in  bit_vector(3 downto 0); -- Entrada binaria
           seg : out bit_vector(6 downto 0)  -- Saída hexadecimal
           -- A saída corresponde aos segmentos gfedcba nesta ordem. Cobre 
           -- todos valores possíveis de entrada.
        );
end hex2seg;

architecture comportamental of hex2seg is
begin
	
	seg <= "1000000" when (hex = "0000") else
			 "1001111" when (hex = "0001") else
			 "0100100" when (hex = "0010") else
			 "0110000" when (hex = "0011") else
			 "0011001" when (hex = "0100") else
			 "0010010" when (hex = "0101") else
			 "0000010" when (hex = "0110") else
			 "1111000" when (hex = "0111") else
			 "0000000" when (hex = "1000") else
			 "0010000" when (hex = "1001") else
			 "0001000" when (hex = "1010") else 
			 "0000011" when (hex = "1011") else
			 "1000110" when (hex = "1100") else
			 "0100001" when (hex = "1101") else
			 "0000110" when (hex = "1110") else
			 "0001110" when (hex = "1111") else
			 "1111111"; -- catch all 
	
end comportamental;