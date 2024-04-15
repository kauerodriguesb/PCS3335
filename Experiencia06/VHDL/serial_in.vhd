-------------------------------------------------------------------------------
-- Author: Kauê Rodrigues Barbosa (kaue.rodrigueskrb@usp.br)
-- Module Name: serial_in
-- Description:
-- Recieves 8 bits via serial port from computer and displays it at 7 digits 
-- display.
-------------------------------------------------------------------------------

library IEEE;
use IEEE.numeric_bit.all;

entity serial_in is
    generic( 
        POLARITY  : boolean := TRUE;
        WIDTH     : natural := 8;
        PARITY    : natural := 1;
        CLOCK_MUL : natural := 4
    );

    port( 
        clock, reset, start, serial_data : in  bit;
        done, parity_bit                 : out  bit;
        parallel_data                    : out bit_vector(WIDTH-1 downto 0)
    );
end serial_in;

architecture arch_serial of serial_in is
    --signal done                         : bit := '0';
    --signal parity_s, data_reg           : bit_vector(WIDTH-1 downto 0);
    --signal serial_intern: bit := '0';
    --signal count, stop_count: natural := 0;

    type estados is (idle, wait_start_bit, receive_data, receive_parity, receive_stop_bits, done_st);
    signal estado : estados := ready;
begin
	 
	 --parity_s(0) <= data_reg(0);
	 --PARIDADE: for i in 1 to WIDTH-1 generate
	 --		parity_s(i) <= parity_s(i-1) xor data_reg(i);
	 --end generate PARIDADE;

    TRANSMISSION:
    process(clock, reset, tx_go)
    begin
		  if reset = '1' then
				--serial_intern <= '1'; 
				estado <= idle;
        elsif rising_edge(clock) then
		  
				case (estado) is
					when idle => 
						estado <= wait_start_bit;
					
					when wait_start_bit => 
						if start = '1' then
							estado <= wait_start_bit;
						end if;
					
					when receive_data => ;
					
					when receive_parity => ;
					
					when receive_stop_bits => ;
					
					when done_st => ;
				
				end case;
		  
            case (estado) is 
                when ready =>						  
                    if tx_go = '0' then
                        estado <= ready;
                    elsif tx_go = '1' then
								serial_intern <= '0';
								data_reg <= data;
                        done <= '0';
                        estado <= send_data;
                    end if;

                when send_data =>
                    serial_intern <= data_reg(count);
                    count <= count + 1;
                    if count < WIDTH-1 then 
                        estado <= send_data;
                    else 
								estado <= send_parity;
                    end if;
						  
					 when send_parity  =>
						  count <= 0;
                    serial_intern <= not parity_s(WIDTH-1);
                    estado <= send_stop_bits;
						  
					 when send_stop_bits =>
                    serial_intern <= '1';
						  stop_count <= stop_count + 1;
                    if stop_count < STOP_BITS-1 then 
								estado <= send_stop_bits;
						  else 
								stop_count <= 0;
								done <= '1';
								estado <= done_st;
						  end if;
					
					 when done_st =>                   
						  estado <= ready; 
                
            end case;
        end if;
    end process;

    serial_o <= serial_intern when POLARITY = TRUE else not serial_intern;
    tx_done    <= done;
end arch_serial;