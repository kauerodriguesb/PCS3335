-------------------------------------------------------------------------------
-- Author: Kauê Rodrigues Barbosa (kaue.rodrigueskrb@usp.br)
-- Module Name: contador
-- Description:
-- VHDL module that count 64 times
-------------------------------------------------------------------------------

library IEEE;
use IEEE.numeric_bit.all;


entity contador is
    Port (
        rst, clk  : in bit;
		contagem  : out bit_vector(5 downto 0);
        count_end : out bit
    );
end contador;

architecture arch_contador of contador is
	 signal count : unsigned(5 downto 0) := (others => '0');
begin
    process(rst,clk) 
    begin
        if (rst = '0') then 
            count <= (others => '0');
        elsif (clk'event and clk = '1') then 
				if (count = 64) then
					count <= (others => '0');
				else
					count <= count + 1;
			   end if;
        end if;
    end process;
	 
	 contagem <= bit_vector(count);	 
	 count_end <= '1' when count = "111111" else '0';

end arch_contador;