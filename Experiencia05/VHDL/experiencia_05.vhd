entity experiencia_05 is
  port (
    clk, rst, tx_go : in bit;
	 tx_done, serial_saida : out bit;
	 DATA : in bit_vector(7 downto 0)
  );
end experiencia_05;

architecture arch of experiencia_05 is

	-- Declaração dos signals    
	--signal extendido : bit_vector(31 downto 0);
	--signal a_out, b_out, c_out, d_out, e_out, f_out, g_out, h_out : bit_vector(31 downto 0);
	--signal resultado : bit_vector(31 downto 0);
	--signal padrao : bit_vector(31 downto 0) := (others => '0');	
    --signal hexs: bit_vector(11 downto 0); -- Sem utilidade
	 
	 signal clk_intern, serial_o : bit;
	 
	 -- Declaração dos components
	 component serial_out is
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

	-- not rst pq esta no botao

	DIVISAO_CLOCK: divisor_clock port map(clk, not rst, clk_intern);
	
	TX: serial_out generic map(TRUE, 8, 1, 1) port map(clk_intern, not rst, not tx_go, tx_done, DATA(7 downto 0), serial_saida);

end architecture;