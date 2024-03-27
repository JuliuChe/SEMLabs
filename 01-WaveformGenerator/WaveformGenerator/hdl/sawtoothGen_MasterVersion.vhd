ARCHITECTURE masterVersion OF sawtoothGen IS

  signal counter: unsigned(sawtooth'range);

begin

  count: process(reset, clock)
  begin
    if reset = '1' then
      counter <= (others => '0');
    elsif rising_edge(clock) then
      if en = '1' then
        counter <= counter + step;
      end if;
    end if;
  end process count;

  sawtooth <= counter;

END ARCHITECTURE masterVersion;



