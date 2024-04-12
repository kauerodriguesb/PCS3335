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
        serial_o : out  bit
    );
end serial_out;

architecture arch_serial of serial_out is
    signal done                               : bit := '0';
    signal intern                             : bit_vector(WIDTH-1 downto 0);
    signal start_bit, serial_intern, stop_bit : bit := '0';
    signal count, stop_count: natural := 0;

    type estados is (ready, send_data_true, send_data_false, send_parity_bit_odd,
                     send_parity_bit_even, send_stop_true, send_stop_false, done_st);
    signal estado : estados := ready;
begin
    
    -- Verificação da polariadade
    --start_bit <= '0' when POLARITY = TRUE else '1';
    --intern    <= data when POLARITY = TRUE else not data;
    --stop_bit  <= '1' when POLARITY = TRUE else '0';

    intern <= data;

    TRANSMISSION:
    process(clock, reset, tx_go)
        variable paridade : bit := '0';
    begin
        if rising_edge(clock) then
            case (estado) is 
                when ready =>
                    if POLARITY = TRUE then
                        serial_intern <= '1';
                    elsif POLARITY = FALSE then
                        serial_intern <= '0';
                    end if;

                    if tx_go = '0' then
                        estado <= ready;
                    elsif tx_go = '1' then
                        done <= '0';
                        if POLARITY = TRUE then
                            serial_intern <= '0';
                            estado <= send_data_true;
                        elsif POLARITY = FALSE then
                            serial_intern <= '1';
                            estado <= send_data_false;
                        end if;
                    end if;

                when send_data_true =>
                    serial_intern <= intern(count);
                    count <= count + 1;
                    if count < 7 then 
                        estado <= send_data_true;
                    elsif PARITY = 1 then
                        count <= 0;
                        estado <= send_parity_bit_odd;
                    elsif PARITY = 0 then
                        count <= 0;
                        estado <= send_parity_bit_even;
                    end if;
                
                when send_data_false => 
                    serial_intern <= not intern(count);
                    count <= count + 1;
                    if count < 7 then 
                        estado <= send_data_false;
                    elsif PARITY = 1 then
                        count <= 0;
                        estado <= send_parity_bit_odd;
                    elsif PARITY = 0 then
                        count <= 0;
                        estado <= send_parity_bit_even;
                    end if;

                when send_parity_bit_odd =>
                    for i in intern'range loop
                        paridade := paridade xor intern(i);
                    end loop;

                    serial_intern <= not paridade;
                    estado <= send_stop_true;
                    
                
                when send_parity_bit_even =>
                    for i in intern'range loop
                        paridade := paridade xor intern(i);
                    end loop;

                    serial_intern <= paridade;   
                    estado <= send_stop_true;
               
                
                when send_stop_true =>
                    serial_intern <= '1';
                    stop_count <= stop_count + 1;
                    if stop_count < STOP_BITS then
                        estado <= send_stop_true;
                    else 
                        stop_count <= 0;
                        estado <= done_st;
                    end if;

                when send_stop_false =>
                    serial_intern <= '0';
                    stop_count <= stop_count + 1;
                    if stop_count < STOP_BITS then
                        estado <= send_stop_true;
                    else 
                        stop_count <= 0;
                        estado <= done_st;
                    end if;

                when done_st =>
                    done <= '1';
                    estado <= ready;
            end case;
        end if;
    end process;

    serial_o <= serial_intern;
    tx_done    <= done;
end arch_serial;
--
--        if reset = '0' then
--            done <= '0';
--        elsif tx_go = '1' then
--            done <= '0';
--            if rising_edge(clock) then
--                serial_intern <= start_bit;
--
--                for i in 0 to WIDTH-1 loop
--                    serial_intern <= intern(i);
--                end loop;
--                
--                if PARITY = 1 then
--                    for i in intern'range loop
--                        paridade := paridade xor intern(i);
--                    end loop;
--                    serial_intern <= not paridade;
--                else 
--                    for i in intern'range loop
--                        paridade := paridade xor intern(i);
--                    end loop;
--                    serial_intern <= paridade;
--                end if;
--                
--                for i in 0 to STOP_BITS loop
--                    serial_intern <= stop_bit;
--                end loop;               
--            end if;
--            done <= '1';
--        end if;
--    end process;
--
--    serial_o <= serial_intern;
--    tx_done    <= done;
