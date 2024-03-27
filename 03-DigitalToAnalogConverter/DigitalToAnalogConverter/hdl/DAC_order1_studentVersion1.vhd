ARCHITECTURE order1_studentVersion_05_Decale OF DAC IS

signal accum: unsigned (parallelIn'length + 1 - 1 downto 0);
signal parallelInDecal: unsigned (parallelIn'range);

BEGIN

parallelInDecal <= parallelIn - shift_right(parallelIn,1) + 2**(parallelIn'length -2);



  process(clock, reset, accum)
  begin
    if reset = '1' then 
      accum <= (others => '0');
    elsif rising_edge(clock) then
      if accum(accum'high) = '1' then
        accum <= accum + resize(parallelInDecal, accum'length) - (2**parallelIn'length);
	else
		accum <= accum + resize(parallelInDecal, accum'length); 
      end if;  
    end if;  
  end process;
  
  
  serialOut <= accum(accum'high);
  
END ARCHITECTURE order1_studentVersion_05_Decale;


