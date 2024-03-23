entity experiencia03 is
  port (
    SW: in bit_vector(9 downto 0);
	KEY3 : in bit;
    HEX0: out bit_vector(6 downto 0); -- display 1
    HEX1: out bit_vector(6 downto 0); -- display 2
    HEX2: out bit_vector(6 downto 0); -- etc	
    HEX3: out bit_vector(6 downto 0);	
    HEX4: out bit_vector(6 downto 0);	
    HEX5: out bit_vector(6 downto 0);	
	LEDR: out bit_vector(9 downto 0)
  );
end experiencia03 ;

architecture arch of experiencia03 is

	-- Declaração dos signals    
	signal extendido : bit_vector(31 downto 0);
	signal a_out, b_out, c_out, d_out, e_out, f_out, g_out, h_out : bit_vector(31 downto 0);
	signal resultado : bit_vector(31 downto 0);
	signal padrao : bit_vector(31 downto 0) := (others => '0');	
    --signal hexs: bit_vector(11 downto 0); -- Sem utilidade
	 
	 -- Declaração dos components
	 component stepfun is 
	 port(
		ai, bi, ci, di, ei, fi, gi, hi : in bit_vector(31 downto 0);
		kpw : in bit_vector(31 downto 0);
		ao, bo, co, do, eo, fo, go, ho : out bit_vector(31 downto 0)
	 );
	 end component;
	 
	component hex2seg is
    port(
		hex : in  bit_vector(3 downto 0); -- Entrada binaria
    	seg : out bit_vector(6 downto 0)  -- Saída hexadecimal
    );
	end component;
	
begin

	-- Extensao do sinal original
	 extendido(31 downto 24) <= SW(7 downto 0);
	 extendido(23 downto 16) <= SW(7 downto 0);
	 extendido(15 downto 8) <= SW(7 downto 0);
	 extendido(7 downto 0) <= SW(7 downto 0);
	 
	-- Port map
	step: stepfun port map(extendido, extendido, extendido, extendido, extendido,
									extendido, extendido, extendido, extendido, a_out, b_out, 
									c_out, d_out, e_out, f_out, g_out, h_out);
	 
	-- Resultado
	resultado <= a_out when Sw(9 downto 8) = "00" else
			     b_out when Sw(9 downto 8) = "10" else
			     e_out when Sw(9 downto 8) = "11" else
				 padrao;
					  
	-- Saidas dos displays
	--hexs <= "00" & SW; -- Parece não fazer nada. Conferir na próxima aula
    HEX0C: hex2seg port map(resultado(3 downto 0),HEX0); -- hex guarda os valores de cada display
    HEX1C: hex2seg port map(resultado(7 downto 4),HEX1);
    HEX2C: hex2seg port map(resultado(11 downto 8),HEX2);
    HEX3C: hex2seg port map(resultado(15 downto 12),HEX3);
    HEX4C: hex2seg port map(resultado(19 downto 16),HEX4);
    HEX5C: hex2seg port map(resultado(23 downto 20),HEX5);
	 
	-- LEDs 
	LEDR(9) <= '0';
	LEDR(8) <= '0';
	LEDR(7) <= resultado(31);
	LEDR(6) <= resultado(30);
	LEDR(5) <= resultado(29);
	LEDR(4) <= resultado(28);
	LEDR(3) <= resultado(27);
	LEDR(2) <= resultado(26);
	LEDR(1) <= resultado(25);
	LEDR(0) <= resultado(24);
end architecture;