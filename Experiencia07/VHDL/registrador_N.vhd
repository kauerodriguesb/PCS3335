-------------------------------------------------------------------------------
-- Author: Kauê Rodrigues Barbosa (kaue.rodrigueskrb@usp.br)
-- Module Name: registrador_32
-- Description:
-- 32 bit register with enable
-------------------------------------------------------------------------------

library IEEE;
use IEEE.numeric_bit.all;

entity registrador_N is
    generic (
        WIDTH : natural := 8
    );

    Port (
        D : in bit_vector(WIDTH-1 downto 0);
        enable, clk, clear : in bit;
        Q : out bit_vector(WIDTH-1 downto 0)
    );
end registrador_N;

architecture arch_reg of registrador_N is
begin
    process(clk, clear, enable)
    begin
        if rising_edge(clk) then
            if clear = '1' then 
                Q <= (others => '0');
            elsif enable = '1' then 
                Q <= D;
            end if;
        end if;
    end process;
end arch_reg;