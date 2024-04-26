-------------------------------------------------------------------------------
-- Author: Kauê Rodrigues Barbosa (kaue.rodrigueskrb@usp.br)
-- Module Name: serial_in
-- Description:
-- Recieves 8 bits via serial port from computer and displays it at 7 digits 
-- display.
-------------------------------------------------------------------------------


library IEEE;
use IEEE.numeric_bit.all;

entity sin is
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
end sin;

architecture arch_serial of sin is

    component shift_register is
        generic( 
            WIDTH     : natural := 11
        );
    
        port( 
            clock, reset, serial_in, enable  : in  bit;
            data_out   : out bit_vector(WIDTH-1 downto 0) 
        );
    end component;

    signal enable_storage, reset_intern : bit;
	 signal reset_tick, tick, enable_shift : bit;
    signal receive_count : natural := 0;
    signal parallel_intern, parallel_intern2 : bit_vector((WIDTH+3)-1 downto 0); -- DATA_WIDTH - 1
	 signal clock_count : unsigned(1 downto 0);

    constant DATA_WIDTH : natural := WIDTH + 2 + 1; -- Dados + paridade + stop bits

    type estados is (idle, wait_start_bit, receive_data, done_st);
    signal estado : estados := idle;
begin

	 TICK_PROCESS: process(clock, reset, reset_tick)
	 begin
		if reset = '1' or reset_tick = '1' then
			clock_count <= "00";
		elsif rising_edge(clock) then
			clock_count <= clock_count + 1;
		end if;
	 end process;
	 
	 tick <= '1' when clock_count = "01" else '0';
	 reset_tick <= '1' when estado = wait_start_bit else '0';	
	 
    DATA_STORAGE: shift_register generic map(DATA_WIDTH) 
    port map(clock, reset_intern, serial_data, enable_shift, parallel_intern);

    TRANSMISSION:
    process(clock, reset, start, tick, estado)
    begin
		if reset = '1' then
         done <= '0';
			reset_intern <= '0'; 
			estado <= idle;
      elsif rising_edge(clock) then
			case (estado) is
				when idle =>
					done <= '0';
					if start = '0' then
						estado <= idle;
					else
						estado <= wait_start_bit;
					end if;
				
				when wait_start_bit => 
					parallel_intern2 <= (others => '0');
					if serial_data = '1' then
						estado <= wait_start_bit;
               else					   
                  estado <= receive_data;
               end if;
				
				when receive_data => 
					  if tick = '1' then
						  if (receive_count < DATA_WIDTH-1) then -- Nao recebi todos os bits ainda
							  parallel_intern2 <= serial_data & parallel_intern2((WIDTH+3)-1 downto 1);
							  enable_shift <= '1';
							  receive_count <= receive_count + 1;
							  estado <= receive_data;
						  else 
							  enable_shift <= '0';
							  receive_count <= 0;
							  estado <= done_st;
						  end if;
					  else
							enable_shift <= '0';
					  end if;
					  
				when done_st =>
					  enable_storage <= '0'; 	
                 done <= '1';
                 estado <= idle;

			end case;
      end if;
    end process;

    parallel_data <= parallel_intern2(WIDTH+1 downto 2) when POLARITY = TRUE else
                     not parallel_intern2(WIDTH+1 downto 2);

    parity_bit <= parallel_intern2(WIDTH+2);

end arch_serial;