library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
    port(
        a       : in  std_logic_vector(7 downto 0);  -- Primo numero
        b       : in  std_logic_vector(7 downto 0);  -- Secondo numero
        op      : in  std_logic_vector(1 downto 0);  -- Solo 2 bit per 4 operazioni
        result  : out std_logic_vector(7 downto 0);  -- Risultato
        zero    : out std_logic;                     -- Flag: risultato = 0
        overflow: out std_logic                      -- Flag: overflow
    );
end entity alu;

architecture behavior of alu is
    signal temp_result : std_logic_vector(15 downto 0);  -- 16 bit per moltiplicazione
    signal alu_result  : std_logic_vector(7 downto 0);
begin
    process(a, b, op)
    begin
        -- Reset dei flag
        overflow <= '0';
        temp_result <= (others => '0');
        
        case op is
            when "00" =>  -- ADDIZIONE
                temp_result(8 downto 0) <= std_logic_vector(unsigned('0' & a) + unsigned('0' & b));
                -- Overflow se il risultato è > 255
                if unsigned(temp_result(8 downto 0)) > 255 then
                    overflow <= '1';
                end if;
                
            when "01" =>  -- SOTTRAZIONE
                if unsigned(a) >= unsigned(b) then
                    temp_result(7 downto 0) <= std_logic_vector(unsigned(a) - unsigned(b));
                else
                    temp_result(7 downto 0) <= (others => '0');  -- Risultato = 0 se a < b
                    overflow <= '1'; 
                end if;
                
            when "10" =>  -- MOLTIPLICAZIONE
                temp_result <= std_logic_vector(unsigned(a) * unsigned(b));
                -- Overflow se il risultato è > 255
                if unsigned(temp_result) > 255 then
                    overflow <= '1';
                end if;
                
            when "11" =>  -- DIVISIONE
                if unsigned(b) = 0 then
                    temp_result(7 downto 0) <= (others => '1');  -- Errore: divisione per zero
                    overflow <= '1';
                else
                    temp_result(7 downto 0) <= std_logic_vector(unsigned(a) / unsigned(b));
                end if;
                
            when others =>
                temp_result <= (others => '0');
        end case;
    end process;
    
    -- Assegnazione del risultato (prendo solo i primi 8 bit)
    alu_result <= temp_result(7 downto 0);
    result <= alu_result;
    
    -- Flag zero
    zero <= '1' when unsigned(alu_result) = 0 else '0';
    
end architecture behavior;
