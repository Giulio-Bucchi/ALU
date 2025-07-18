-- =============================================================================
-- ALU 32-bit per architettura RISC - VERSIONE CORRETTA
-- Supporta 8 operazioni fondamentali
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
    port(
        a       : in  std_logic_vector(31 downto 0);  -- Primo operando (32 bit)
        b       : in  std_logic_vector(31 downto 0);  -- Secondo operando (32 bit)
        op      : in  std_logic_vector(2 downto 0);   -- Codice operazione (3 bit = 8 operazioni)
        result  : out std_logic_vector(31 downto 0);  -- Risultato operazione
        zero    : out std_logic;                      -- Flag: risultato = 0
        overflow: out std_logic                       -- Flag: overflow aritmetico
    );
end entity alu;

architecture behavior of alu is
    -- Segnali interni per il risultato
    signal alu_result : std_logic_vector(31 downto 0);
    signal overflow_flag : std_logic;
    
begin

    -- Processo combinatorio principale per tutte le operazioni
    alu_operation: process(a, b, op)
        -- Variabili per conversioni signed/unsigned
        variable a_signed : signed(31 downto 0);
        variable b_signed : signed(31 downto 0);
        variable a_unsigned : unsigned(31 downto 0);
        variable b_unsigned : unsigned(31 downto 0);
        
        -- Variabili per calcoli estesi (33 bit per rilevare overflow)
        variable temp_add : signed(32 downto 0);
        variable temp_sub : signed(32 downto 0);
        variable shift_amount : integer range 0 to 31;
        
        -- Variabili per risultato finale
        variable temp_result : std_logic_vector(31 downto 0);
        variable temp_overflow : std_logic;
        
    begin
        -- Inizializzazione variabili
        temp_result := (others => '0');
        temp_overflow := '0';
        
        -- Conversione degli operandi
        a_signed := signed(a);
        b_signed := signed(b);
        a_unsigned := unsigned(a);
        b_unsigned := unsigned(b);
        
        -- Decodifica dell'operazione
        case op is
            -- =================================================================
            -- ADDIZIONE SIGNED (000)
            -- =================================================================
            when "000" =>
                -- Calcolo con 33 bit per rilevare overflow
                temp_add := resize(a_signed, 33) + resize(b_signed, 33);
                temp_result := std_logic_vector(temp_add(31 downto 0));
                
                -- Controllo overflow: confronto bit di segno
                -- Se bit 32 diverso da bit 31, c'è overflow
                if temp_add(32) /= temp_add(31) then
                    temp_overflow := '1';
                end if;
                
            -- =================================================================
            -- SOTTRAZIONE SIGNED (001)
            -- =================================================================
            when "001" =>
                -- Calcolo con 33 bit per rilevare underflow
                temp_sub := resize(a_signed, 33) - resize(b_signed, 33);
                temp_result := std_logic_vector(temp_sub(31 downto 0));
                
                -- Controllo underflow: stesso principio dell'addizione
                if temp_sub(32) /= temp_sub(31) then
                    temp_overflow := '1';
                end if;
                
            -- =================================================================
            -- AND BITWISE (010)
            -- =================================================================
            when "010" =>
                temp_result := a and b;
                
            -- =================================================================
            -- OR BITWISE (011)
            -- =================================================================
            when "011" =>
                temp_result := a or b;
                
            -- =================================================================
            -- XOR BITWISE (100)
            -- =================================================================
            when "100" =>
                temp_result := a xor b;
                
            -- =================================================================
            -- SLT - Set Less Than (101)
            -- =================================================================
            when "101" =>
                if a_signed < b_signed then
                    temp_result := x"00000001";  -- True
                else
                    temp_result := x"00000000";  -- False
                end if;
                
            -- =================================================================
            -- SLL - Shift Left Logical (110)
            -- =================================================================
            when "110" =>
                -- Prendo solo i primi 5 bit di b per shift amount (0-31)
                shift_amount := to_integer(b_unsigned(4 downto 0));
                temp_result := std_logic_vector(shift_left(a_unsigned, shift_amount));
                
            -- =================================================================
            -- SRL - Shift Right Logical (111)
            -- =================================================================
            when "111" =>
                -- Prendo solo i primi 5 bit di b per shift amount (0-31)
                shift_amount := to_integer(b_unsigned(4 downto 0));
                temp_result := std_logic_vector(shift_right(a_unsigned, shift_amount));
                
            -- =================================================================
            -- OPERAZIONE NON VALIDA
            -- =================================================================
            when others =>
                temp_result := (others => '0');
                
        end case;
        
        -- Assegnazione finale ai segnali interni
        alu_result <= temp_result;
        overflow_flag <= temp_overflow;
        
    end process alu_operation;
    -- =======================================================================
    -- ASSEGNAZIONE USCITE
    -- =======================================================================
    
    -- Risultato principale
    result <= alu_result;
    
    -- Flag overflow
    overflow <= overflow_flag;
    
    -- Flag zero: attivo quando il risultato è tutto 0
    zero <= '1' when unsigned(alu_result) = 0 else '0';
    
end architecture behavior;
