ARCHITECTURE studentVersion OF interpolatorShiftRegister IS
BEGIN
  process(clock, reset)
  begin
    if reset = '1' then  
      sample1 <= (others => '0');
      sample2 <= (others => '0');
      sample3 <= (others => '0');
      sample4 <= (others => '0');
    elsif rising_edge(clock) then
      if shiftSamples = '1' then
        sample1 <= sample2;
        sample2 <= sample3;
        sample3 <= sample4;
        sample4 <= sampleIn;
      end if;
    end if;
  end process;
END ARCHITECTURE studentVersion;
