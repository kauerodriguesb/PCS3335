library IEEE;
use IEEE.numeric_bit.all;

entity sha256_1b is
port (
    clock, reset : in bit;
    serial_in : in bit;
    serial_out : out bit
);
end sha256_1b;


architecture arch_sha of sha256_1b is

    component divisor_clock_send is  
        port ( 
            clk_in  : in  bit;
            rst     : in  bit;
            clk_out : out  bit
        );
    end component;  
    
    component divisor_clock_receive is  
        port ( 
            clk_in  : in  bit;
            rst     : in  bit;
            clk_out : out  bit
        );
    end component; 

    component registrador_N is
        generic (
            WIDTH : natural := 8
        );
    
        Port (
            D : in bit_vector(WIDTH-1 downto 0);
            enable, clk, clear : in bit;
            Q : out bit_vector(WIDTH-1 downto 0)
        );
    end component;

    component uc_sha256 is
        Port (
            rst, clk  : in bit;
            multisteps_done, rx_done, tx_done : in bit; 
            en_load, multisteps_reset, tx_go, rx_go  : out bit
        );
    end component;

    component sin is
        generic( 
            POLARITY  : boolean := TRUE;
            WIDTH     : natural := 8;
            PARITY    : natural := 1;
            CLOCK_MUL : natural := 4
        );
    
        port( 
            clock, reset, start, serial_data : in  bit; -- clock ja reduzido da fpga
            done, parity_bit                 : out  bit;
            parallel_data                    : out bit_vector(WIDTH-1 downto 0)
        );
    end component;

    component sout is
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

    component multisteps is 
        port(
            clk, rst : in bit;
            msgi : in bit_vector(511 downto 0);
            haso : out bit_vector(255 downto 0);
            done : out bit
        );
    end component; 

    signal clock_send, clock_receive : bit;
    signal en_load, rx_done, rx_go, tx_done, tx_go, parity_b, multisteps_done, multisteps_reset : bit;
    signal parallel_data : bit_vector(7 downto 0);
    signal msgi : bit_vector(511 downto 0);
    signal haso : bit_vector(255 downto 0);

begin

    CLKSND: divisor_clock_send port map(clock, reset, clock_send);

    CLKRCV: divisor_clock_receive port map(clock, reset, clock_receive);

    REGN: registrador_N 
    generic map(8) 
    port map(parallel_data, en_load, clock, reset, msgi);

    UC: uc_sha256 port map(reset, clock, multisteps_done, rx_done, tx_done, en_load, multisteps_reset, tx_go);

    TX: sin 
    generic map(TRUE, 8, 1, 4)
    port map(clock_receive, reset, rx_go, serial_in, rx_done, parity_b, parallel_data);

    RX: sout 
    generic map(TRUE, 8, 1, 2)
    port map(clock_send, reset, tx_go, tx_done, haso(7 downto 0), serial_out);

    MULTI: multisteps port map(clock, reset, msgi, haso, multisteps_done);

end arch_sha;