# ALU a 32 bit in VHDL

## Descrizione

Questo progetto implementa una **Arithmetic Logic Unit (ALU)** a 32 bit utilizzando il linguaggio VHDL.  
L’ALU è un componente fondamentale nei processori, responsabile dell’esecuzione delle principali operazioni aritmetiche e logiche.

Il progetto include anche un **testbench** dedicato alla verifica funzionale, che consente di simulare e validare il comportamento del componente in differenti scenari operativi.

## File presenti

- `alu.vhdl`: contiene la descrizione architetturale e comportamentale dell'ALU.
- `alu_tb.vhdl`: testbench completo per la simulazione e la verifica del corretto funzionamento dell’ALU.

## Funzionalità

L’ALU supporta diverse operazioni su due operandi a 32 bit, selezionate tramite un segnale di controllo (opcode).

| Opcode | Operazione             | Descrizione                        |
|--------|------------------------|------------------------------------|
| "000"  | Addizione              | Somma tra A e B (`A + B`)         |
| "001"  | Sottrazione            | Differenza tra A e B (`A - B`)    |
| "010"  | AND logico bit a bit   | `A AND B`                          |
| "011"  | OR logico bit a bit    | `A OR B`                           |
| "100"  | XOR logico bit a bit   | `A XOR B`                          |
| "101"  | NOT                    | Complemento bit a bit di A (`~A`) |
| "110"  | Incremento             | Incremento di A (`A + 1`)         |
| "111"  | Decremento             | Decremento di A (`A - 1`)         |

> *Nota: Il comportamento esatto può variare in base alla specifica implementazione. Consultare `alu.vhdl` per i dettagli.*

## Istruzioni per la simulazione

È possibile simulare il progetto utilizzando ambienti come **GHDL** e visualizzare le waveform con **GTKWave**.

### Simulazione con GHDL

```bash
ghdl -a alu.vhdl
ghdl -a alu_tb.vhdl
ghdl -e alu_tb
ghdl -r alu_tb --vcd=wave.vcd
```

⚠️Se non riuscite a vedere il file wave.vcd, allora potete usare EDA playground : 
![Waveform Screenshot](https://github.com/user-attachments/assets/e1ec7cef-f2cc-4e95-9253-f3a123d1868c)

