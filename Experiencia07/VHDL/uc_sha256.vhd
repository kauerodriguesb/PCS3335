library IEEE;
use IEEE.numeric_bit.all;

entity uc_sha256 is
    Port (
        rst, clk  : in bit;
        multisteps_done, rx_done, tx_done : in bit; 
		en_load, multisteps_reset, tx_go, rx_go  : out bit;
    );
end uc_sha256;

architecture arch_uc of uc_sha256 is
	
    type estados is (recebe, carrega, multisteps, transmite);
    signal estado : estados := recebe;

begin

    process(rst, clk)
    begin
        if rst = '1' then
            en_load <= '0';
            multisteps_reset <= '1';
            tx_go <= '0';
            rx_go <= '0';
            estado <= recebe;
        elsif rising_edge(clock) then

            case (estado) is

                when recebe =>
                    rx_go <= '1'; 
                    if rx_done = '1' then
                        rx_go <= '0';
                        estado <= carrega;
                    else 
                        estado <= recebe;
                    end if;

                when carrega => 
                    en_load <= '1';
                    if rx_done = '0' then
                        estado <= multisteps;
                    end if;

                when multisteps => 
                    if multisteps_done = '1' then
                        estado <= transmite;
                    elsif rx_done = '1' then
                        estado <= carrega;
                    end if;

                when transmite => 
                    tx_go <= '1';
                    estado <= recebe;

            end case;
        end if;
    end process;
end arch_uc;