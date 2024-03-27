ARCHITECTURE masterVersion OF sineTable IS

  signal changeSign : std_uLogic;
  signal flipPhase : std_uLogic;
  signal phaseTableAddress1 : unsigned(tableAddressBitNb-1 downto 0);
  signal phaseTableAddress2 : unsigned(phaseTableAddress1'range);
  signal quarterSine : signed(sine'range);

  signal shiftPhase : std_uLogic := '0';  -- can be used to build a cosine

begin

  changeSign <= phase(phase'high);
  flipPhase <= phase(phase'high-1);

  phaseTableAddress1 <= phase(phase'high-2 downto phase'high-2-tableAddressBitNb+1);

  checkPhase: process(flipPhase, shiftPhase, phaseTableAddress1)
  begin
    if (flipPhase xor shiftPhase) = '0' then
      phaseTableAddress2 <= phaseTableAddress1;
    else
      phaseTableAddress2 <= 0 - phaseTableAddress1;
    end if;
  end process checkPhase;


  quarterTable: process(phaseTableAddress2, flipPhase, shiftPhase)
  begin
    case to_integer(phaseTableAddress2) is
      when 0 => if (flipPhase xor shiftPhase) = '0' then
                  quarterSine <= to_signed(16#0000#, quarterSine'length);
                else
                  quarterSine <= to_signed(16#7FFF#, quarterSine'length);
                end if;
      when 1 => quarterSine <= to_signed(16#18F9#, quarterSine'length);
      when 2 => quarterSine <= to_signed(16#30FB#, quarterSine'length);
      when 3 => quarterSine <= to_signed(16#471C#, quarterSine'length);
      when 4 => quarterSine <= to_signed(16#5A82#, quarterSine'length);
      when 5 => quarterSine <= to_signed(16#6A6D#, quarterSine'length);
      when 6 => quarterSine <= to_signed(16#7641#, quarterSine'length);
      when 7 => quarterSine <= to_signed(16#7D89#, quarterSine'length);
      when others => quarterSine <= (others => '-');
    end case;
  end process quarterTable;

  checkSign: process(changeSign, flipPhase, shiftPhase, quarterSine)
  begin
    if (changeSign xor (flipPhase and shiftPhase)) = '0' then
      sine <= quarterSine;
    else
      sine <= 0 - quarterSine;
    end if;
  end process checkSign;

END ARCHITECTURE masterVersion;

