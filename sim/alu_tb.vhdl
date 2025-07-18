-- =============================================================================
-- TESTBENCH COMPLETO
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_tb is
end alu_tb;

architecture thorough_test of alu_tb is
    -- Segnali per collegare il testbench all'ALU
    signal a, b     : std_logic_vector(31 downto 0) := (others => '0');
    signal op       : std_logic_vector(2 downto 0) := (others => '0');
    signal result   : std_logic_vector(31 downto 0);
    signal zero     : std_logic;
    signal overflow : std_logic;
    
    -- Costanti per test
    constant CLK_PERIOD : time := 10 ns;
    
begin
    -- =======================================================================
    -- ISTANZA DELL'ALU
    -- =======================================================================
    uut: entity work.alu
        port map(
            a => a,
            b => b,
            op => op,
            result => result,
            zero => zero,
            overflow => overflow
        );
    
    -- =======================================================================
    -- PROCESSO DI STIMOLO E TEST
    -- =======================================================================
    stimulus: process
    begin
        report "=== INIZIO TEST ALU 32-BIT ===";
        
        -- ===================================================================
        -- TEST OPERAZIONI ARITMETICHE
        -- ===================================================================
        report "=== TEST ARITMETICI ===";
        
        -- Test addizione normale
        a <= std_logic_vector(to_signed(500, 32));
        b <= std_logic_vector(to_signed(300, 32));
        op <= "000";  -- ADD
        wait for CLK_PERIOD;
        assert result = std_logic_vector(to_signed(800, 32))
            report "ERRORE: Addizione 500+300 = " & integer'image(to_integer(signed(result))) & " (dovrebbe essere 800)" severity error;
        assert overflow = '0' 
            report "ERRORE: Overflow non dovrebbe essere attivo" severity error;
        
        -- Test addizione con overflow positivo
        a <= x"7FFFFFFF";  -- Massimo intero positivo (2^31 - 1)
        b <= x"00000001";  -- +1
        op <= "000";
        wait for CLK_PERIOD;
        assert overflow = '1' 
            report "ERRORE: Overflow positivo non rilevato" severity error;
        
        -- Test sottrazione normale
        a <= std_logic_vector(to_signed(500, 32));
        b <= std_logic_vector(to_signed(300, 32));
        op <= "001";  -- SUB
        wait for CLK_PERIOD;
        assert result = std_logic_vector(to_signed(200, 32))
            report "ERRORE: Sottrazione 500-300 = " & integer'image(to_integer(signed(result))) & " (dovrebbe essere 200)" severity error;
        
        -- Test sottrazione con underflow
        a <= x"80000000";  -- Minimo intero negativo (-2^31)
        b <= x"00000001";  -- -1
        op <= "001";
        wait for CLK_PERIOD;
        assert overflow = '1' 
            report "ERRORE: Underflow negativo non rilevato" severity error;
        
        -- ===================================================================
        -- TEST OPERAZIONI LOGICHE
        -- ===================================================================
        report "=== TEST LOGICI ===";
        
        -- Test AND
        a <= x"FFFF0000";
        b <= x"FF00FF00";
        op <= "010";
        wait for CLK_PERIOD;
        assert result = x"FF000000"
            report "ERRORE: AND fallito" severity error;
        
        -- Test OR
        a <= x"00FF00FF";
        b <= x"0F0F0F0F";
        op <= "011";
        wait for CLK_PERIOD;
        assert result = x"0FFF0FFF"
            report "ERRORE: OR fallito" severity error;
        
        -- Test XOR
        a <= x"AAAAAAAA";
        b <= x"55555555";
        op <= "100";
        wait for CLK_PERIOD;
        assert result = x"FFFFFFFF"
            report "ERRORE: XOR fallito" severity error;
        
        -- ===================================================================
        -- TEST CONFRONTO E SHIFT
        -- ===================================================================
        report "=== TEST CONFRONTO E SHIFT ===";
        
        -- Test SLT (Set Less Than) - caso true
        a <= std_logic_vector(to_signed(-50, 32));
        b <= std_logic_vector(to_signed(20, 32));
        op <= "101";
        wait for CLK_PERIOD;
        assert result = x"00000001"
            report "ERRORE: SLT (-50 < 20) fallito" severity error;
        
        -- Test SLL (Shift Left Logical)
        a <= x"0000000F";  -- 15 in decimale
        b <= x"00000004";  -- Shift di 4 posizioni
        op <= "110";
        wait for CLK_PERIOD;
        assert result = x"000000F0"
            report "ERRORE: SLL fallito" severity error;
        
        -- Test SRL (Shift Right Logical)
        a <= x"F0000000";
        b <= x"00000004";  -- Shift di 4 posizioni
        op <= "111";
        wait for CLK_PERIOD;
        assert result = x"0F000000"
            report "ERRORE: SRL fallito" severity error;
        
        -- ===================================================================
        -- TEST CASI SPECIALI
        -- ===================================================================
        report "=== TEST CASI SPECIALI ===";
        
        -- Test rilevamento zero
        a <= x"00000000";
        b <= x"00000000";
        op <= "000";  -- ADD: 0 + 0 = 0
        wait for CLK_PERIOD;
        assert zero = '1' 
            report "ERRORE: Flag zero non attivo per risultato 0" severity error;
        assert result = x"00000000"
            report "ERRORE: Risultato dovrebbe essere 0" severity error;
        
        -- ===================================================================
        report "=== TUTTI I TEST COMPLETATI ===";
        wait;
        
    end process stimulus;
    
end architecture thorough_test;