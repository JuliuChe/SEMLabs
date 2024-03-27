ARCHITECTURE studentVersion OF sawtoothToSquare IS
BEGIN
  sawtoothToSquare: process(sawtooth)
  begin
  if sawtooth(bitNb-1) = '1' then
	square <= to_unsigned(2**bitNb - 1, bitNb);
  else
	square <= (others => '0');
  end if;
  end process sawtoothToSquare;
  
END ARCHITECTURE studentVersion;
