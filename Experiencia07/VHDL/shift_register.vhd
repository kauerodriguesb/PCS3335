-------------------------------------------------------------------------------
-- Author: Kauê Rodrigues Barbosa (kaue.rodrigueskrb@usp.br)
-- Module Name: shift_register
-- Description:
-- Recieves serial data and registers it 
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
    data : bit_vector(WIDTH-1 downto 0);
begin
	 process(clock, reset)
	 begin
		if (reset = '1') then
			data <= (others => '0');
		else 
			if (rising_edge(clock) and enable = '1') then				
				for i in 1 to WIDTH-1 loop
					data(i) <= data(i-1);
				end for;
			end if;
		end if;
	 end process;
	 
	 data_out <= data;
end arch_shift;