ARCHITECTURE studentVersion OF lowpass IS
  --lowpassOut <= (others => '0');
  signal integrator : unsigned( (signalBitNb+shiftBitNb-1) downto 0);
BEGIN
  accumulator: process(clock)
  begin
  if reset='1' then
	integrator <=to_unsigned(0,(signalBitNb+shiftBitNb));
  else
	integrator <= integrator + lowpassIn - (integrator srl shiftBitNb);
  end if; 
  end process accumulator;
 
 lowpassOut <= integrator( (signalBitNb+shiftBitNb-1) downto shiftBitNb);
  
END ARCHITECTURE studentVersion;
