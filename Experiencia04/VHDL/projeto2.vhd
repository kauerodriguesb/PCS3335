entity projeto2 is
	port (
		SW: in bit_vector(9 downto 0);
		KEY3 : in bit;
		HEX0: out bit_vector(6 downto 0); -- display 1
		HEX1: out bit_vector(6 downto 0); -- display 2
		HEX2: out bit_vector(6 downto 0);	
		HEX3: out bit_vector(6 downto 0);	
		HEX4: out bit_vector(6 downto 0);	
		HEX5: out bit_vector(6 downto 0);	-- etc
		LEDR: out bit_vector(9 downto 0)
	);
end projeto2 ;

architecture arch of projeto2 is
    component hex2seg is
        port( 
			hex : in  bit_vector(3 downto 0); -- Entrada binaria
            seg : out bit_vector(6 downto 0)  -- Saída hexadecimal
        );
    end component;

	-- Declaração dos signals
	signal x, y, z : bit_vector(31 downto 0);
	signal reversed : bit_vector(7 downto 0);
	signal q_ch, q_maj, q_sum0, q_sum1, q_sigma0, q_sigma1 : bit_vector(31 downto 0);
	signal resultado : bit_vector(31 downto 0);
	signal padrao : bit_vector(31 downto 0) := (others => '0');
	--signal hexs: bit_vector(11 downto 0); -- Sem uso
	 
	-- Declaração dos components 
	component ch is
        port (
            x, y, z: in bit_vector(31 downto 0);
            q: out bit_vector(31 downto 0)
        );
    end component;
	 
	component maj is
        port (
            x, y, z: in bit_vector(31 downto 0);
            q: out bit_vector(31 downto 0)
        );
    end component;
	 
	component sum0 is
        port (
            x: in bit_vector(31 downto 0);
            q: out bit_vector(31 downto 0)
        );
    end component;
	 
	component sum1 is
        port (
            x: in bit_vector(31 downto 0);
            q: out bit_vector(31 downto 0)
        );
    end component;
	 
	component sigma0 is
        port (
            x: in bit_vector(31 downto 0);
            q: out bit_vector(31 downto 0)
        );
    end component;
	 
	component sigma1 is
        port (
            x: in bit_vector(31 downto 0);
            q: out bit_vector(31 downto 0)
        );
    end component;
begin
	 
	-- Sinal x	 
	x(31 downto 24) <= SW(7 downto 0);
	x(23 downto 16) <= SW(7 downto 0);
	x(15 downto 8) <= SW(7 downto 0);
	x(7 downto 0) <= SW(7 downto 0);
	
	-- Sinal y
	y <= not x;
	
	-- Sinal z
	reversed(0) <= SW(7);
	reversed(1) <= SW(6);
	reversed(2) <= SW(5);
	reversed(3) <= SW(4);
	reversed(4) <= SW(3);
	reversed(5) <= SW(2);
	reversed(6) <= SW(1);
	reversed(7) <= SW(0);
	
	z(31 downto 24) <= reversed(7 downto 0);
	z(23 downto 16) <= reversed(7 downto 0);
	z(15 downto 8) <= reversed(7 downto 0);
	z(7 downto 0) <= reversed(7 downto 0);
	
	 -- Instatiations
    ch_inst: ch port map (x, y, z, q_ch);
	maj_inst: maj port map (x, y, z, q_maj);
	sum0_inst: sum0 port map (x, q_sum0);
	sum1_inst: sum1 port map (x, q_sum1);
	sigma0_inst: sigma0 port map (x, q_sigma0);
	sigma1_inst: sigma1 port map (x, q_sigma1); 
	 
	 resultado <= q_ch when SW(9 downto 8) = "11" and KEY3 = '0' else -- ativo alto
					  q_maj when SW(9 downto 8) = "11" and KEY3 = '1' else
					  q_sum0 when SW(9 downto 8) = "01" and KEY3 = '0' else
					  q_sum1 when SW(9 downto 8) = "01" and KEY3 = '1' else
					  q_sigma0 when SW(9 downto 8) = "10" and KEY3 = '0' else
					  q_sigma1 when SW(9 downto 8) = "10" and KEY3 = '1' else
					  padrao; -- this should never be reached 
					  
					  
	 -- Saidas dos displays
	--hexs <= "00" & SW; -- Sem uso
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