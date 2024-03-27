ARCHITECTURE studentVersion OF interpolatorTrigger IS
signal counterClock : unsigned(counterBitNb-1 downto 0);
BEGIN
  counting: process(clock, reset)
  begin
    if reset = '1' then
      counterClock <= to_unsigned(0, counterBitNb);
    elsif rising_edge(clock) then
      if en = '1' then
        counterClock <= counterClock + 1;
      end if;
    end if;
  end process counting;
  
  compare: process(counterClock, en)
  begin
    if ((counterClock + 1) = 0) and (en = '1') then
      triggerOut <= '1';
    else 
      triggerOut <= '0';
    end if;
  end process compare;
END ARCHITECTURE studentVersion;
