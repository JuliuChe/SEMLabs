ARCHITECTURE studentVersion OF sineTable IS

  signal phaseTableAddress, phaseTableAddress1 : unsigned(tableAddressBitNb-1 downto 0);
  signal quarterSine : signed(sine'range);

BEGIN

  phaseTableAddress <= phase(phase'high-2 downto phase'high-2-tableAddressBitNb+1);

  flipH:process(phaseTableAddress, phase)
  begin
    if phase(phase'high-1) = '1' then
      phaseTableAddress1 <= (not phaseTableAddress)+1;
    else
      phaseTableAddress1<=phaseTableAddress;
    end if;
  end process flipH;

  quarterTable: process(phaseTableAddress1, phase)
  begin
    case to_integer(phaseTableAddress1) is
      when 0 => 
      if phase(phase'high-1)='1' then
        quarterSine <= to_signed(16#7FFF#, quarterSine'length);
      else
        quarterSine <= to_signed(16#0000#, quarterSine'length);
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

  flipV: process(quarterSine, phase)
  begin
    if phase(phase'high) = '1' then
      sine <= -quarterSine;
    else
      sine <= quarterSine;
    end if;
  end process flipV;

END ARCHITECTURE studentVersion;
