ARCHITECTURE masterVersion OF interpolatorShiftRegister IS

  -- signal sample4_int: signed(sampleIn'range);
  -- signal sample3_int: signed(sampleIn'range);
  -- signal sample2_int: signed(sampleIn'range);
  -- signal sample1_int: signed(sampleIn'range);
  
  type samplesArray is array(3 downto 0) of signed(sampleIn'range);
  signal samples: samplesArray;

begin

  shiftThem: process(reset, clock)
  begin
    if reset = '1' then
		samples <= (others=>(others=>'0'));
      -- sample1_int <= (others => '0');
      -- sample2_int <= (others => '0');
      -- sample3_int <= (others => '0');
      -- sample4_int <= (others => '0');
    elsif rising_edge(clock) then
      if shiftSamples = '1' then
        -- sample1_int <= sample2_int;
        -- sample2_int <= sample3_int;
        -- sample3_int <= sample4_int;
        -- sample4_int <= sampleIn;
		samples(0) <= samples(1);
		samples(1) <= samples(2);
		samples(2) <= samples(3);
		samples(3) <= sampleIn;
      end if;
    end if;
  end process shiftThem;

  sample4 <= samples(3);
  sample3 <= samples(2);
  sample2 <= samples(1);
  sample1 <= samples(0);

END ARCHITECTURE masterVersion;
