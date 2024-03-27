
ARCHITECTURE rtl OF instrDecoder IS
BEGIN

    decode : process(op)
    begin
        case op is
            when "0000011" => immSrc <= "00"; -- lw
            when "0100011" => immSrc <= "01"; -- sw
            when "0110011" => immSrc <= "--"; -- R-type
            when "1100011" => immSrc <= "10"; -- beq
            when "0010011" => immSrc <= "00"; -- l-type ALU
            when "1101111" => immSrc <= "11"; -- jal
            when others => immSrc <= "--"; -- unknwon
        end case;
    end process decode;

END ARCHITECTURE rtl;
