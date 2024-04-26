-------------------------------------------------------------------------------
-- Author: Kauê Rodrigues Barbosa (kaue.rodrigueskrb@usp.br)
-- Module Name: shift_register
-- Description:
-- Shift register with generic width 
-------------------------------------------------------------------------------

library IEEE;
use IEEE.numeric_bit.all;

entity shift_register is
    generic( 
        WIDTH     : natural := 11
    );

    port( 
        clock, reset, serial_in, enable  : in  bit;
        data_out   : out bit_vector(WIDTH-1 downto 0) 
    );
end shift_register;

architecture arch_shift of shift_register is
    signal data : bit_vector(WIDTH-1 downto 0) := (others => '0');
begin
	 process(clock, reset)
	 begin
		if (reset = '1') then
			data <= (others => '1');
		elsif rising_edge(clock) then 
			if enable = '1' then
				data <= serial_in & data(WIDTH-1 downto 1);
			end if;
		end if;
	 end process;
	 
	 data_out <= data;
end arch_shift;