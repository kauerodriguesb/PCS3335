-------------------------------------------------------------------------------
-- Author: Kauê Rodrigues Barbosa (kaue.rodrigueskrb@usp.br)
-- Module Name: serial_in
-- Description:
-- Recieves 8 bits via serial port from computer and displays it at 7 digits 
-- display.
-------------------------------------------------------------------------------

library IEEE;
use IEEE.numeric_bit.all;

entity shift_register is
    generic( 
        WIDTH     : natural := 8
    );

    port( 
        clock, reset, serial_in, enable  : in  bit;
        data_out   : out bit_vector(WIDTH-1 downto 0) 
    );
end shift_register;

architecture arch_shift of shift_register is
    signal data : bit_vector(WIDTH-1 downto 0);
begin
	 process(clock, reset)
	 begin
		if (reset = '1') then
			data <= (others => '0');
		else 
			if (rising_edge(clock) and enable = '1') then				
				for i in 1 to WIDTH-1 loop
					data(i) <= data(i-1);
				end loop;
			end if;
		end if;
	 end process;
	 
	 data_out <= data;
end arch_shift;

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
        clock, reset, start, serial_data : in  bit; -- clock ja reduzido da fpga
        done, parity_bit                 : out  bit;
        parallel_data                    : out bit_vector(WIDTH-1 downto 0)
    );
end serial_in;

architecture arch_serial of serial_in is
    --signal done                         : bit := '0';
    --signal parity_s, data_reg           : bit_vector(WIDTH-1 downto 0);
    --signal serial_intern: bit := '0';
    --signal count, stop_count: natural := 0;

    component shift_register is
        generic( 
            WIDTH     : natural := 8
        );
    
        port( 
            clock, reset, serial_in, enable  : in  bit;
            data_out   : out bit_vector(WIDTH-1 downto 0) 
        );
    end component;

    signal clk_intern, enable_storage : bit;
    signal receive_count : natural := 0;
    signal parallel_intern : bit_vector(WIDTH-1 downto 0);

    constant DATA_WIDTH : natural := WIDTH + 2 + 1;

    type estados is (idle, wait_start_bit, receive_data, done_st);
    signal estado : estados := idle;
begin
	 
    DATA_STORAGE: shift_register generic map(DATA_WIDTH) --Stores data, parity bit and stop bits (2)
    port map(clock, reset, serial_data, enable_storage, parallel_intern);   

    TRANSMISSION:
    process(clock, reset, start)
    begin
		if reset = '1' then
            done <= '0';
			parallel_intern <= (others => '1'); 
			estado <= idle;
        elsif rising_edge(clock) then
			case (estado) is
				when idle => 
					estado <= wait_start_bit;
				
				when wait_start_bit => 
					if start = '1' then
						estado <= wait_start_bit;
                    elsif start = '0' then
                        done <= '0';
                        estado <= receive_data;
                    end if;
				
				when receive_data => 
                    receive_count <= receive_count + 1;
                    enable_storage <= '1';
                    if (receive_count < DATA_WIDTH-1) then -- Nao recebi todos os bits ainda
                        estado <= receive_data;
                    else 
                        enable_storage <= '0'; 
                        receive_count <= 0;
                        estado <= done_st;
                    end if;
				
				when done_st => 
                    done <= '1';
                    estado <= idle;

			end case;
        end if;
    end process;

    parallel_data <= parallel_intern(WIDTH-1 downto 0) when POLARITY = TRUE else
                     not parallel_intern(WIDTH-1 downto 0);

    parity_bit <= parallel_intern(WIDTH);

end arch_serial;