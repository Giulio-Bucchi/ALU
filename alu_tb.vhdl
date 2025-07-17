library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_tb is
end alu_tb;

architecture sim of alu_tb is
    -- Segnali per collegare l'ALU
    signal a       : std_logic_vector(7 downto 0);
    signal b       : std_logic_vector(7 downto 0);
    signal op      : std_logic_vector(1 downto 0);
    signal result  : std_logic_vector(7 downto 0);
    signal zero    : std_logic;
    signal overflow: std_logic;
    
begin
    -- Istanza dell'ALU
    uut: entity work.alu
        port map(
            a       => a,
            b       => b,
            op      => op,
            result  => result,
            zero    => zero,
            overflow => overflow
        );
    
    -- Processo di test
    process
    begin
        -- TEST 1: ADDIZIONE 
        report "Test 1: Addizione 12 + 8";
        a <= "00001100";  -- 12
        b <= "00001000";  -- 8
        op <= "00";       
        wait for 10 ns;
        assert result = "00010100";
        
        -- TEST 2: SOTTRAZIONE 
        report "Test 2: Sottrazione 25 - 10";
        a <= "00011001";  -- 25
        b <= "00001010";  -- 10
        op <= "01";       
        wait for 10 ns;
        assert result = "00001111";
        
        -- TEST 3: MOLTIPLICAZIONE
        report "Test 3: Moltiplicazione 4 * 5";
        a <= "00000100";  -- 4
        b <= "00000101";  -- 5
        op <= "10";       
        wait for 10 ns;
        assert result = "00010100";
        -- TEST 4: DIVISIONE
        report "Test 4: Divisione 20 / 4";
        a <= "00010100";  -- 20
        b <= "00000100";  -- 4
        op <= "11";       
        wait for 10 ns;
        assert result = "00000101";
               
        
        -- Fine dei test
        wait for 100 ns;
        report "Tutti i test completati con successo!" severity note;
        wait;
    end process;
end sim;
