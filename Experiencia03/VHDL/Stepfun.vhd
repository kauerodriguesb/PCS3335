library IEEE;
use IEEE.numeric_bit.all;

entity somador is 
    port(
        x, y : in bit_vector(31 downto 0);
        q : out bit_vector(31 downto 0)
    );
end somador;
    
architecture arch_somador of somador is
begin 
    
    q <= bit_vector(unsigned(x) + unsigned(y));
    
end arch_somador;

entity stepfun is 
port(
    ai, bi, ci, di, ei, fi, gi, hi : in bit_vector(31 downto 0);
    kpw : in bit_vector(31 downto 0);
    ao, bo, co, do, eo, fo, go, ho : out bit_vector(31 downto 0)
);
end stepfun;

architecture arch_stepfun of stepfun is
    
    -- Declaração dos components 
    component somador is 
    port(
        x, y : in bit_vector(31 downto 0);
        q : out bit_vector(31 downto 0)
    );
    end component;
    
    component ch is 
    port(
        x, y, z : in bit_vector(31 downto 0);
        q : out bit_vector(31 downto 0)
    );
    end component;
    
    component sum0 is 
    port(
        x : in bit_vector(31 downto 0);
        q : out bit_vector(31 downto 0)
    );
    end component;
    
    component sum1 is 
    port(
        x : in bit_vector(31 downto 0);
        q : out bit_vector(31 downto 0)
    );
    end component;
    
    component maj is 
    port(
        x, y, z : in bit_vector(31 downto 0);
        q : out bit_vector(31 downto 0)
    );
    end component;
    
    -- Declaração dos signals
    signal soma1, soma2, soma3, soma4, soma5, soma6 : bit_vector(31 downto 0);
    signal ch_out, maj_out, sum0_out, sum1_out : bit_vector(31 downto 0);
    --signal SW : bit_vector(7 downto 0); -- Entrada das chaves é declarada na entidade principal
begin 

    -- Somas
    soma1_port: somador port map(hi, kpw, soma1);
    soma2_port: somador port map(ch_out, soma1, soma2);
    soma3_port: somador port map(sum1_out, soma2, soma3);
    soma4_port: somador port map(maj_out, soma3, soma4);
    soma5_port: somador port map(sum0_out, soma4, soma5);
    soma6_port: somador port map(di, soma3, soma6);
    
    -- Funções 
    ch_port: ch port map(ei, fi, gi, ch_out);
    sum0_port: sum0 port map(ai, sum0_out);
    sum1_port: sum1 port map(ei, sum1_out);
    maj_port: maj port map(ai, bi, ci, maj_out);
    
    -- Resultados
    ao <= soma5;
    bo <= ai;
    co <= bi;
    do <= ci;
    eo <= soma6;
    fo <= ei;
    go <= fi;
    ho <= gi;
     
end arch_stepfun;
