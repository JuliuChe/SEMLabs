ARCHITECTURE order2_studentVersion OF DAC IS

signal parallelInInverted : signed(parallelIn'range);
signal parallelInRefactored : signed(parallelIn'range);
signal accum1 : signed(parallelIn'length + 4 - 1 downto 0);
signal accum2 : signed(parallelIn'length + 5 - 1 downto 0);


BEGIN
	
parallelInInverted(parallelInInverted'high) <= not parallelIn(parallelIn'high);
parallelInInverted(parallelInInverted'high-1 downto 0) <= signed(parallelIn(parallelIn'high-1 downto 0));
parallelInRefactored <= parallelInInverted - shift_right(parallelInInverted,3);

firstAccumulator : process(clock, reset)
begin
	if reset = '1' then
		accum1 <= (others => '0');
	elsif rising_edge(clock) then
		if accum2(accum2'high) = '0' then
			accum1 <= accum1 + resize(parallelInRefactored, accum1'length) - 2**(parallelIn'length-1);
		else
			accum1 <= accum1 + resize(parallelInRefactored, accum1'length) + 2**(parallelIn'length-1);
		end if;
	end if;
end process firstAccumulator;


secondAccumulator : process(clock, reset)
begin
	if reset = '1' then
		accum2 <= (others => '0');
	elsif rising_edge(clock) then
		if accum2(accum2'high) = '0' then
			accum2 <= accum2 + accum1 - 2**(parallelIn'length + 3);
		else
			accum2 <= accum2 + accum1 + 2**(parallelIn'length + 3);
		end if;
	end if;
end process secondAccumulator;

serialOut <= not accum2(accum2'high);
  
END ARCHITECTURE order2_studentVersion;
