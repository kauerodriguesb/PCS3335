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
        count_end : out bit
    );
end contador;

architecture arch_contador of contador is
begin
    process(rst,clk)
        variable count : integer;
    begin
        if (rst = '0') then 
            count := 0;
        elsif (clk'event and clk = '1') then 
            count := count + 1;
        end if;

        if (count = 64) then
            count := 0;
            count_end <= '1';
        end if;
    end process;

end arch_contador;