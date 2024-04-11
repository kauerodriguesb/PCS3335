-------------------------------------------------------------------------------
-- Author: Kauê Rodrigues Barbosa (kaue.rodrigueskrb@usp.br)
-- Module Name: divisor_clock
-- Description:
-- Divides the original clock of FPGA (50 MHz), creating a 4.8 kHz serial clock
-------------------------------------------------------------------------------

library IEEE;
use IEEE.numeric_bit.all;

entity divisor_clock is
    Port ( clk_in : in  bit;
           rst    : in  bit;
           clk_out : out  bit);
end divisor_clock;

architecture arch_div of divisor_clock is

    -- Desconsidero 3200 ciclos iniciais para a contagem ficar inteira.
    -- Após, crio um ciclo de clock na saída para cada 10416 ciclos da entrada.

    constant SKIP_CYCLES : integer := 3200;     -- Ciclos a serem desconsiderados
    constant MAX_COUNT : integer := 5208-1;     -- Conto até 10416/2 - 1, para manter duty cicle de 50%
    
    signal count : integer range 0 to MAX_COUNT := 0;
    signal skip_count : integer range 0 to SKIP_CYCLES - 1 := 0;
    signal internal : bit := '0';
begin
    process(clk_in, rst)
    begin
        if rst = '1' then
            count <= 0;
            skip_count <= 0;
            internal <= '0';
        elsif rising_edge(clk_in) then
            if skip_count < SKIP_CYCLES - 1 then
                skip_count <= skip_count + 1;
            else
                if count = MAX_COUNT then
                    count <= 0;
                    internal <= not internal; -- Inverte o sinal do clock de saída
                else
                    count <= count + 1;
                end if;
            end if;
        end if;
    end process;
    
    clk_out <= internal;
end arch_div;