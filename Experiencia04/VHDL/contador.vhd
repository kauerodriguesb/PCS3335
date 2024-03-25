-------------------------------------------------------------------------------
-- Author: Kauê Rodrigues Barbosa (kaue.rodrigueskrb@usp.br)
-- Module Name: contador
-- Description:
-- VHDL module that count 64 times
-------------------------------------------------------------------------------

library IEEE;
use IEEE.numeric_bit.all;
--use IEEE.numeric_std.all;

entity contador is
    Port (rst, clk  : in bit;
          controle  : out bit_vector(5 downto 0); --Usado pra verificar na simulação 
          count_end : out bit
    );
end contador;

architecture arch_contador of contador is
    signal internal : bit_vector(5 downto 0); -- Controle
begin
    process(rst,clk)
        variable count : integer;
    begin
        if (rst = '0') then 
            count := 0;
            internal <= "000000";
        elsif (clk'event and clk = '1') then 
            count := count + 1;
            internal <= bit_vector(to_unsigned(count, internal'length));
        end if;

        if (count = 64) then
            count := 0;
            count_end <= '1';
            internal <= "000000";
        end if;
    end process;

    controle <= internal;

end arch_contador;