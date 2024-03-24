-------------------------------------------------------------------------------
-- Author: Kauê Rodrigues Barbosa (kaue.rodrigueskrb@usp.br)
-- Module Name: contador_tb
-- Description:
-- Testbench for contador
-------------------------------------------------------------------------------

library IEEE;
use IEEE.numeric_std.all;

entity contador_tb is
end contador_tb;

architecture testbench of contador_tb is

    -- Component declaration for contador
    component contador
        port (
            rst, clk  : in  bit;
            controle  : out bit_vector(5 downto 0);
            count_end : out bit
        );
    end component;

    -- Signals for the testbench
    signal rst_tb, clk_tb : bit := '0';
    signal controle_tb    : bit_vector(5 downto 0);
    signal count_end_tb   : bit;

    -- Clock process
    constant PERIOD : time := 20 ns;  -- 50 MHz
    begin

    -- Instantiate the contador module
    uut: contador port map (rst_tb; clk_tb; controle_tb; count_end_tb);

    -- Clock process
    clk_process: process
    begin
        while true loop -- run until end of simulation
            clk_tb <= '0';
            wait for PERIOD / 2;
            clk_tb <= '1';
            wait for PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Stimulus process
    stimulus: process
    begin
        -- Reset
        rst_tb <= '0';
        wait for PERIOD;

        assert count_end = '0' report "Falha reset" severity note;

        rst_tb <= '0';
        wait for PERIOD * 64;

        assert count_end = '1' report "Falha na contagem" severity note;
        
        wait;
    end process;

end testbench;
