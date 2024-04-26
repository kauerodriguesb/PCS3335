entity experiencia_07 is
  port (
    clk, rst : in bit;
	 entrada_serial : in bit; 
	 saida_serial   : out bit;
	 LED : out bit
  );
end experiencia_07;

architecture arch of experiencia_07 is
	 
	   component sha256_1b is
		port (
			 clock, reset : in bit;
			 serial_in : in bit;
			 serial_out : out bit
		);
		end component;
		
		signal teste: bit;
	
begin
		LED <= teste;
		saida_serial <= teste;

		INST: sha256_1b port map(clk, not rst, entrada_serial, teste);

end architecture;