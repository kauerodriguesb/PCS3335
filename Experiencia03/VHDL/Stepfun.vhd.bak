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


-- Componente importante no projeto final. Desnecessário p/ atividade do Judge

--entity extende_palavra is 
--port(
--	x : in bit_vector(7 downto 0);
--    q : out bit_vector(31 downto 0)
--);
--end extende_palavra;

--architecture arch_extende of extende_palavra is
--begin 
--	
--    -- Replicação da palavra para formar as entradas
--    y(31 downto 24) <= x(7 downto 0);
--    y(23 downto 16) <= x(7 downto 0);
--    y(15 downto 8) <= x(7 downto 0);
--    y(7 downto 0) <= x(7 downto 0);
--    
--end arch_extender;


entity stepfun is 
port(
    ai, bi, ci, di, ei, fi, gi, hi : in bit_vector(31 downto 0);
    kpw : in bit_vector(31 downto 0);
    ao, bo, co, do, eo, fo, go, ho : out bit_vector(31 downto 0)
);
end stepfun;

architecture arch_stepfun of stepfun is
    
    -- Components 
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
    
    --component extende_palavra is 
    --port(
    --	x : in bit_vector(7 downto 0);
    --	q : out bit_vector(31 downto 0)
    --);
    --end component;
    
    -- Signals 
    signal soma1, soma2, soma3, soma4, soma5, soma6 : bit_vector(31 downto 0);
    signal ch_out, maj_out, sum0_out, sum1_out : bit_vector(31 downto 0);
    --entrada_serial : bit_vector(7 downto 0); -- Aqui eh a ideia. No codigo da entrega vem da pinagem

begin 
    
    -- Replicação da palavra para formar as entradas
    -- ext1: extende_palavra port map(entrada_serial, ai);
    -- ext2: extende_palavra port map(entrada_serial, bi);
    -- etc ...
    
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
