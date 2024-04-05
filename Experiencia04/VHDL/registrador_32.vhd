-------------------------------------------------------------------------------
-- Author: Kauê Rodrigues Barbosa (kaue.rodrigueskrb@usp.br)
-- Module Name: registrador_32
-- Description:
-- 32 bit register with enable
-------------------------------------------------------------------------------

library IEEE;
use IEEE.numeric_bit.all;

entity registrador_32 is
    Port (
        D : in bit_vector(31 downto 0);
        enable, clk  : in bit;
        Q : out bit_vector(31 downto 0)
    );
end registrador_32;

architecture arch_reg of registrador_32 is
begin
    process
    begin
        wait until clk'event and clk = '1';
        if enable = '1' then Q <= D;
        end if;
    end process;

end arch_reg;