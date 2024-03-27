ARCHITECTURE studentVersion OF sawtoothToTriangle IS
signal salut : unsigned(bitNb-1 downto 0);
BEGIN
  sawtoothToTriangle: process(sawtooth) 
  begin
  if sawtooth(bitNb-1) = '1' then
	salut <= not sawtooth;
  else
	salut <= sawtooth;
  end if;
  end process sawtoothToTriangle;
  triangle <= salut sll 1;
END ARCHITECTURE studentVersion;
