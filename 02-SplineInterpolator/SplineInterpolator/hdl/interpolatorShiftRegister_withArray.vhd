ARCHITECTURE withArray OF interpolatorShiftRegister IS
  subtype registerType is signed(sampleIn'range);
  type registerArray is array(1 to 4) of registerType;
  signal samples : registerArray;
BEGIN
  process(clock, reset)
  begin
    if reset = '1' then  
      samples <= (others => (others => '0'));
    elsif rising_edge(clock) then
      if shiftSamples = '1' then
        for i in samples'low to samples'high-1 loop
          samples(i) <= samples(i+1);
        end loop;
        samples(samples'high) <= sampleIn;
      end if;
    end if;
  end process;

  sample1 <= samples(1); 
  sample2 <= samples(2);
  sample3 <= samples(3);
  sample4 <= samples(4);

END ARCHITECTURE withArray;
