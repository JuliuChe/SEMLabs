
ARCHITECTURE rtl OF mainDecoder IS

  signal lvec_controls : std_ulogic_vector(10 downto 0);

BEGIN

  process(op)
  begin
    case op is
      when "0000011" => lvec_controls <= "10010010000"; -- lw
      when "0100011" => lvec_controls <= "00111000000"; -- sw
      when "0110011" => lvec_controls <= "1--00000100"; -- R-type
      when "1100011" => lvec_controls <= "01000001010"; -- beq
      when "0010011" => lvec_controls <= "10010000100"; -- I-type ALU
      when "1101111" => lvec_controls <= "11100100001"; -- jal
      when others    => lvec_controls <= "-----------"; -- not valid
    end case;
  end process;

  (regwrite, immSrc(1), immSrc(0), ALUSrc, memWrite, resultSrc(1), resultSrc(0),
    branch, ALUOp(1), ALUOp(0), jump) <= lvec_controls after g_tDec;

END ARCHITECTURE rtl;
