entity ch is
	port (
		x,y,z: in bit_vector(31 downto 0);
		q: out bit_vector(31 downto 0)
	);
end ch;

ARCHITECTURE arq_ch OF ch IS
BEGIN

	q <= (x and y) or ((not x) and z);
  
END ARCHITECTURE arq_ch;



entity maj is
	port (
		x,y,z: in bit_vector(31 downto 0);
		q: out bit_vector(31 downto 0)
	);
end maj;
                            
ARCHITECTURE arq_maj OF maj IS
BEGIN    

	q <= (x and y) xor (x and z) xor (y and z);
	
END ARCHITECTURE arq_maj;



entity sum0 is
	port (
		x: in bit_vector(31 downto 0);
		q: out bit_vector(31 downto 0)
	);
end sum0;

ARCHITECTURE arq_sum0 OF sum0 IS

	function rotate_right(x: bit_vector; n: integer) return bit_vector is
		constant xlength : integer := x'length;
		variable result 	: bit_vector(31 downto 0);
	begin
		if n = xlength then
			result := x;
			return result;
		end if;
		result := x(n-1 downto 0) & x(xlength-1 downto n);
		return result;
	end function rotate_right;

BEGIN

	q <= rotate_right(x, 2) xor rotate_right(x, 13) xor rotate_right(x, 22);

END ARCHITECTURE arq_sum0;



entity sum1 is
	port (
		x: in bit_vector(31 downto 0);
		q: out bit_vector(31 downto 0)
	);
end sum1;

ARCHITECTURE arq_sum1 OF sum1 IS

	function rotate_right(x: bit_vector; n: integer) return bit_vector is
		constant xlength : integer := x'length;
		variable result 	: bit_vector(31 downto 0);
	begin
		if n = xlength then
			result := x;
			return result;
		end if;
		result := x(n-1 downto 0) & x(xlength-1 downto n);
		return result;
	end function rotate_right;
	
BEGIN

	q <= rotate_right(x, 6) xor rotate_right(x, 11) xor rotate_right(x, 25);
	
END ARCHITECTURE arq_sum1;



entity sigma0 is
	port(
		x: in bit_vector(31 downto 0);
		q: out bit_vector(31 downto 0)
	);
end sigma0; 

ARCHITECTURE arq_sigma0 OF sigma0 IS

	function rotate_right(x: bit_vector; n: integer) return bit_vector is
		constant xlength : integer := x'length;
		variable result 	: bit_vector(31 downto 0);
	begin
		if n = xlength then
			result := x;
			return result;
		end if;
		result := x(n-1 downto 0) & x(xlength-1 downto n);
		return result;
	end function rotate_right;
	
	function shift_right(x: bit_vector; n: integer) return bit_vector is
		constant xlength : integer := x'length;
		variable internal : bit_vector(31 downto 0) := (others => '0');
		variable result 	: bit_vector(31 downto 0);
	begin
		if n >= xlength then
			result := (others => '0');
			return result;
		end if;
		result := internal(n-1 downto 0) & x(xlength-1 downto n);
		return result;
	end function shift_right;
	
BEGIN
 
	q <= rotate_right(x, 7) xor rotate_right(x, 18) xor shift_right(x, 3);
	
END ARCHITECTURE arq_sigma0;



entity sigma1 is
	port(
		x: in bit_vector(31 downto 0);
		q: out bit_vector(31 downto 0)
	) ;
end sigma1;

ARCHITECTURE arq_sigma1 OF sigma1 IS

	function rotate_right(x: bit_vector; n: integer) return bit_vector is
		constant xlength : integer := x'length;
		variable result 	: bit_vector(31 downto 0);
	begin
		if n = xlength then
			result := x;
			return result;
		end if;
		result := x(n-1 downto 0) & x(xlength-1 downto n);
		return result;
	end function rotate_right;
	
	function shift_right(x: bit_vector; n: integer) return bit_vector is
		constant xlength : integer := x'length;
		variable internal : bit_vector(31 downto 0) := (others => '0');
		variable result 	: bit_vector(31 downto 0);
	begin
		if n >= xlength then
			result := (others => '0');
			return result;
		end if;
		result := internal(n-1 downto 0) & x(xlength-1 downto n);
		return result;
	end function shift_right;

BEGIN
  
	q <= rotate_right(x, 17) xor rotate_right(x, 19) xor shift_right(x, 10);
  
END ARCHITECTURE arq_sigma1; 