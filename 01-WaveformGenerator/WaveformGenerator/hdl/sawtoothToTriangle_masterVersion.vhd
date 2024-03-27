ARCHITECTURE masterVersion OF sawtoothToTriangle IS

  signal MSB: std_uLogic;
  signal triangleInt: unsigned(triangle'range);

begin

  MSB <= sawtooth(sawtooth'high);

  foldDown: process(MSB, sawtooth)
  begin
    if MSB = '0' then
      triangleInt <= sawtooth;
    else
      triangleInt <= not sawtooth;
    end if;
  end process foldDown;

  triangle <= triangleInt(triangleInt'high-1 downto 0) & '0';

END ARCHITECTURE masterVersion;
