
ARCHITECTURE rtl OF aluDecoder IS
    signal lsig_rTypeSub : std_ulogic;
BEGIN
    lsig_rTypeSub <= funct7 and op; -- true for R-type substract

    decode : process(op, funct3, funct7, ALUOp, lsig_rTypeSub)
    begin
        case ALUOp is
            when "00" => ALUControl <= "000" after g_tDec; -- addition
            when "01" => ALUControl <= "001" after g_tDec; -- substraction
            when others =>
                case funct3 is -- R-type or I-type
                    when "000" =>
                        if lsig_rTypeSub = '1' then
                            ALUControl <= "001" after g_tDec; -- sub
                        else
                            ALUControl <= "000" after g_tDec; -- add, addi
                        end if;
                    when "010" => ALUControl <= "101" after g_tDec; -- slt, slti
                    when "110" => ALUControl <= "011" after g_tDec; -- or, ori
                    when "111" => ALUControl <= "010" after g_tDec; -- and, andi
                    when others => ALUControl <= "---" after g_tDec; -- unknown
                end case;
        end case;
    end process decode;
END ARCHITECTURE rtl;
