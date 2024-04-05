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
    type K_values is array (0 to 63) of bit_vector(31 downto 0);  -- Vetor de constantes
    constant K : K_values := (
        x"428a2f98", x"71374491", x"b5c0fbcf", x"e9b5dba5", x"e9b5dba5", x"3956c25b", x"59f111f1", x"923f82a4", x"ab1c5ed5",
        x"d807aa98", x"12835b01", x"243185be", x"550c7dc3", x"72be5d74", x"80deb1fe", x"9bdc06a7", x"c19bf174",
        x"e49b69c1", x"efbe4786", x"0fc19dc6", x"240ca1cc", x"2de92c6f", x"4a7484aa", x"5cb0a9dc", x"76f988da",
        x"983e5152", x"a831c66d", x"b00327c8", x"bf597fc7", x"c6e00bf3", x"d5a79147", x"06ca6351", x"14292967",
        x"27b70a85", x"2e1b2138", x"4d2c6dfc", x"53380d13", x"650a7354", x"766a0abb", x"81c2c92e", x"92722c85",
        x"a2bfe8a1", x"a81a664b", x"c24b8b70", x"c76c51a3", x"d192e819", x"d6990624", x"f40e3585", x"106aa070",
        x"19a4c116", x"1e376c08", x"2748774c", x"34b0bcb5", x"391c0cb3", x"4ed8aa4a", x"5b9cca4f", x"682e6ff3",
        x"748f82ee", x"78a5636f", x"84c87814", x"8cc70208", x"90befffa", x"a4506ceb", x"bef9a3f7", x"c67178f2"
    ); 

    type H_values is array (0 to 7) of bit_vector(31 downto 0);  -- Vetor de constantes
    constant H : H_values := (
        x"6a09e667", x"bb67ae85", x"3c6ef372", x"a54ff53a", x"510e527f", x"9b05688c", x"1f83d9ab", x"5be0cd19"
    );

    type W_vector is array (0 to 63) of bit_vector(31 downto 0);  -- Vetor de constantes

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

    signal W : W_vector;
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
