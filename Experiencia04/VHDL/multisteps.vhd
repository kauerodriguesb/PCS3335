library IEEE;
use IEEE.numeric_std.all;

entity multisteps is 
port(
    clk, rst : in bit;
    msgi : in bit_vector(511 downto 0);
    haso : out bit_vector(255 downto 0);
    done : out bit
);

architecture arch_multi of multisteps is
    
    type H_values is array (0 to 7) of bit_vector(31 downto 0);  -- Vetor de constantes
    constant H : H_values := (
        x"6a09e667", x"bb67ae85", x"3c6ef372", x"a54ff53a", x"510e527f", x"9b05688c", x"1f83d9ab", x"5be0cd19"
    );

    component stepfun is 
        port(
            ai, bi, ci, di, ei, fi, gi, hi : in bit_vector(31 downto 0);
            kpw : in bit_vector(31 downto 0);
            ao, bo, co, do, eo, fo, go, ho : out bit_vector(31 downto 0)
        );
    end component;

    component sigma0 is
        port(
            x: in bit_vector(31 downto 0);
            q: out bit_vector(31 downto 0)
        );
    end component; 

    component sigma1 is
        port(
            x: in bit_vector(31 downto 0);
            q: out bit_vector(31 downto 0)
        ) ;
    end component;

    signal result_sig1, result_sig0 : bit_vector(1535 downto 0); -- Contem os resultados das funcoes sigma

begin
    -- Primeiros valores de W
    process
    begin
        for i in 0 to 15 loop
            W(i) <= msgi(((i+1)*32-1) downto i*32);
        end loop;
        wait;
    end process;

    -- Ultimos valores de W
    process
    begin
        for i in 16 to 63 loop
            instance_sig0_i : sigma0 port map (W(i-15), result_sig0((((i-16)+1)*32-1) downto (i-16)*32));
            instance_sig1_i : sigma1 port map (W(i-2),  result_sig1((((i-16)+1)*32-1) downto (i-16)*32));

            W(i) <= result_sig1((((i-16)+1)*32-1) downto (i-16)*32) + 
                    W(i-7)                                          +
                    result_sig0((((i-16)+1)*32-1) downto (i-16)*32) +
                    W(i-16);
        end loop;
    end process;

    



end arch_multi;
