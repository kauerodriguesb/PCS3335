library ieee;
use ieee.numeric_bit.all;

entity tb is end;

architecture arch of tb is

    component sha256_1b is
        port (clock, reset : in  bit;		-- Clock da placa, GPIO_0_D2  
                serial_in    : in  bit;		-- GPIO_0_D0
                serial_out	 : out bit		-- GPIO_0_D1
        );
    end component;

    constant PERIOD50M : time := 20 ns;
    constant PERIOD4800 : time := 52083*4 ns;

    signal reset, serial_in, serial_out : bit;
    signal clock50M, clock4800 : bit;
    signal finished : bit := '0';
begin

    clock50M <= not clock50M and not finished after PERIOD50M/2;
    clock4800 <= not clock4800 and not finished after PERIOD4800/2;

    sha256: sha256_1b
    port map(clock50M, reset, serial_in, serial_out);


    Estimulo : process
    begin
        reset <= '1';
        serial_in <= '1';
        wait until rising_edge(clock4800);
        wait until rising_edge(clock4800);
        wait until rising_edge(clock4800);
        wait until rising_edge(clock4800);
        reset <= '0';
        wait until rising_edge(clock4800);
        serial_in <= '0';   --SB
        wait until rising_edge(clock4800);
        serial_in <= '1';   --D0
        wait until rising_edge(clock4800);
        serial_in <= '0';   --D1
        wait until rising_edge(clock4800); --D2
        wait until rising_edge(clock4800); --D3
        wait until rising_edge(clock4800); --D4
        wait until rising_edge(clock4800); --D5
        wait until rising_edge(clock4800); --D6
        wait until rising_edge(clock4800); --D7
        wait until rising_edge(clock4800); --Paridade
        wait until rising_edge(clock4800);
        serial_in <= '1';   --Stop bit 1
        wait until rising_edge(clock4800); --Stopbit

        wait until falling_edge(serial_out);
        wait for PERIOD4800/2;
        assert serial_out = '0' --Sb
        report "Sb";
        wait for PERIOD4800;
        assert serial_out = '1' --D1
        report "D1";
        wait for PERIOD4800;
        assert serial_out = '1' --D2
        report "D2";
        wait for PERIOD4800;
        assert serial_out = '1' --D3
        report "D3";
        wait for PERIOD4800;
        assert serial_out = '0' --D4
        report "D4";
        wait for PERIOD4800;
        assert serial_out = '1' --D5
        report "D5";
        wait for PERIOD4800;
        assert serial_out = '0' --D6
        report "D6";
        wait for PERIOD4800;
        assert serial_out = '0' --D7
        report "D7";
        wait for PERIOD4800;
        assert serial_out = '1' --D8
        report "D8";
        wait for PERIOD4800;
        assert serial_out = '0'; --Paridade
        wait for PERIOD4800;
        assert serial_out = '1'; --End 
        wait for PERIOD4800;
        finished <= '1';
        wait;
    end process;
end arch; -- arch