library IEEE;
use IEEE.numeric_std.all;

entity multisteps is 
port(
    clk, rst : in bit;
    msgi : in bit_vector(511 downto 0);
    haso : out bit_vector(255 downto 0);
    done : out bit
);
