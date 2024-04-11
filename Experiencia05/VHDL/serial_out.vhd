-------------------------------------------------------------------------------
-- Author: Kauê Rodrigues Barbosa (kaue.rodrigueskrb@usp.br)
-- Module Name: serial_out
-- Description:
-- Sends 8 bits via serial port to a computer
-------------------------------------------------------------------------------

library IEEE;
use IEEE.numeric_bit.all;

entity serial_out is
    generic( 
        POLARITY  : boolean := TRUE;
        WIDTH     : natural := 7;
        PARITY    : natural := 1;
        STOP_BITS : natural := 1
    );

    port( 
        clock, reset, tx_go  : in  bit;
        tx_done              : out  bit;
        data                 : in bit_vector(WIDTH-1 downto 0);    
        serial_out : out  bit
    );
end serial_out;

architecture arch_serial of serial_out is
    signal done                               : bit   := '0';
    signal intern                             : bit_vector(WIDTH-1 downto 0);
    signal start_bit, serial_intern, stop_bit : bit := '0';
begin
    
    -- Verificação da polariadade
    start_bit <= '0' when POLARITY = TRUE else '1';
    intern    <= data when POLARITY = TRUE else not data;
    stop_bit  <= '1' when POLARITY = TRUE else '0';

    TRANSMISSION:
    process(clock, reset, tx_go)
        variable paridade : bit := 0;
    begin
        if reset = 0 then
            done <= '0';
        elsif tx_go = 1 then
            done <= '0';
            if rising_edge(clock)
                serial_intern <= start_bit;

                for i in 0 to WIDTH-1 loop
                    serial_intern <= intern(i);
                end loop;
                
                if PARITY = 1 then
                    for i in intern'range loop
                        paridade := paridade xor intern(i);
                    end loop;
                    serial_intern <= not paridade;
                else 
                    for i in intern'range loop
                        paridade := paridade xor intern(i);
                    end loop;
                    serial_intern <= paridade;
                end if;
                
                for i in 0 to STOP_BITS loop
                    serial_intern <= stop_bit;
                end loop;               
            end if;
            done <= '1';
        end if;
    end process;

    serial_out <= serial_intern;
    tx_done    <= done;
end arch_serial;