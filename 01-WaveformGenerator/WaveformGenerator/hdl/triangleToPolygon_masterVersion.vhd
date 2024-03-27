ARCHITECTURE masterVersion OF triangleToPolygon IS

  constant clipLow: positive := 2**(triangle'length-2);
  constant clipHigh: positive := 5*clipLow;

  signal triangleGain: unsigned(triangle'length downto 0);

begin

  gain_1_5: process(triangle)
  begin
    triangleGain <= ("0" & triangle) + ( "00" & triangle(triangle'high downto 1) );
  end process gain_1_5;

  clip: process(triangleGain)
  begin
    if triangleGain < clipLow then
      polygon <= (others => '0');
    elsif triangleGain > clipHigh then
      polygon <= (others => '1');
    else
      polygon <= triangleGain(polygon'range) - clipLow;
    end if;
  end process clip;

END ARCHITECTURE masterVersion;
