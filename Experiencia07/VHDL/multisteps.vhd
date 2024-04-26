library IEEE;
use IEEE.numeric_bit.all;

entity multisteps is 
port(
    clk, rst : in bit;
    msgi : in bit_vector(511 downto 0);
    haso : out bit_vector(255 downto 0);
    done : out bit
);
end multisteps;

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

    component contador is
        Port (
            rst, clk  : in bit;
            contagem  : out bit_vector(5 downto 0);
            count_end : out bit
        );
    end component;

    component calcula_kpw is 
        port(
            msg : in bit_vector(511 downto 0);
            contagem : in bit_vector(5 downto 0);
            kpw_out : out bit_vector(31 downto 0)
        );
    end component;

    signal contagem : bit_vector(5 downto 0);
    signal fim_contagem : bit;
    signal kpw : bit_vector(31 downto 0);

    signal ai, bi, ci, di, ei, fi, gi, hi : bit_vector(31 downto 0);
    signal ao, bo, co, do, eo, fo, go, ho : bit_vector(31 downto 0);

begin
    
    CONTAGEM_LBL: contador port map(rst, clk, contagem, fim_contagem);

    CALCULO_KPW: calcula_kpw port map(msgi, contagem, kpw);

    STEP_INST: stepfun port map(ai, bi, ci, di, ei, fi, gi, hi,
                                kpw,
                                ao, bo, co, do, eo, fo, go, ho);

    ai <= H(0) when contagem(5 downto 4) = "00" else ao;
    bi <= H(1) when contagem(5 downto 4) = "00" else bo;
    ci <= H(2) when contagem(5 downto 4) = "00" else co;
    di <= H(3) when contagem(5 downto 4) = "00" else do;
    ei <= H(4) when contagem(5 downto 4) = "00" else eo;
    fi <= H(5) when contagem(5 downto 4) = "00" else fo;
    gi <= H(6) when contagem(5 downto 4) = "00" else go;
    hi <= H(7) when contagem(5 downto 4) = "00" else ho;

    haso(31 downto 0) <= bit_vector(unsigned(ao) + unsigned(H(0)));
    haso(63 downto 32) <= bit_vector(unsigned(bo) + unsigned(H(1)));
    haso(95 downto 64) <= bit_vector(unsigned(co) + unsigned(H(2)));
    haso(127 downto 96) <= bit_vector(unsigned(do) + unsigned(H(3)));
    haso(159 downto 128) <= bit_vector(unsigned(eo) + unsigned(H(4)));
    haso(191 downto 160) <= bit_vector(unsigned(fo) + unsigned(H(5)));
    haso(223 downto 192) <= bit_vector(unsigned(go) + unsigned(H(6)));
    haso(255 downto 224) <= bit_vector(unsigned(ho) + unsigned(H(7)));
    
end arch_multi;
