ARCHITECTURE order1_studentVersion OF DAC IS

signal accum: unsigned (parallelIn'length + 4 - 1 downto 0);
--signal accum2: unsigned (parallelIn'length + 4 - 1 downto 0);

BEGIN

  process(clock, reset, accum)
  begin
    if reset = '1' then 
      accum <= (others => '0');
    elsif rising_edge(clock) then
      accum <= accum + resize(parallelIn, accum'length);
      if accum(accum'high) = '1' then
        accum <= accum - (2**parallelIn'length);
      end if;  
    end if;  
  end process;
  
  
  serialOut <= accum(accum'high);
  
END ARCHITECTURE order1_studentVersion;


