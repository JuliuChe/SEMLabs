ARCHITECTURE studentVersion OF sawtoothGen IS
signal saw : unsigned(sawtooth'range);
BEGIN
  sawtoothGen: process(reset, clock)
  begin
    if reset = '1' then
      saw <= (others => '0');
    elsif (rising_edge(clock)) and (en = '1') then
      saw <= saw + step;
    end if;
  end process sawtoothGen;
  
  sawtooth <= saw;
END ARCHITECTURE studentVersion;

