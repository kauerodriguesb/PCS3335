entity experiencia_06 is
  port (
    clk, rst, start : in bit;
	 entrada_serial : in bit; 
	 done, parity_bit : out bit;
	 parallel_data : out bit_vector(7 downto 0);
	 HEX0: out bit_vector(6 downto 0); -- display 1
	 HEX1: out bit_vector(6 downto 0) -- display 1	 
  );
end experiencia_06;

architecture arch of experiencia_06 is
	 
	 signal clk_intern, parity_intern : bit;
	 signal parallel_temp: bit_vector(7 downto 0);
	 
	 -- Declaração dos components
	 component serial_in is
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
	 end component;
	 
	 component divisor_clock is
    port ( 
        clk_in  : in  bit;
        rst     : in  bit;
        clk_out : out  bit
    );
	 end component;

	 
	component hex2seg is
    port(
		hex : in  bit_vector(3 downto 0); -- Entrada binaria
    	seg : out bit_vector(6 downto 0)  -- Saída hexadecimal
    );
	end component;
	
begin


	DIVISAO_CLOCK: divisor_clock port map(clk, not rst, clk_intern);
	
	RECEPCAO: serial_in
	generic map(TRUE, 8, 1, 4) 
	port map(clk_intern, not rst, not start, entrada_serial, done, parity_intern, parallel_temp);
	
	SEGUNDO_CARACTERE: hex2seg port map(parallel_temp(3 downto 0),HEX0);
	PRIMEIRO_CARACTERE: hex2seg port map(parallel_temp(7 downto 4),HEX1);
	
	parity_bit <= parity_intern;

end architecture;