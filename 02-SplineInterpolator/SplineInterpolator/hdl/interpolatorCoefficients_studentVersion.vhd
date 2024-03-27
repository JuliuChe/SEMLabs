ARCHITECTURE studentVersion OF interpolatorCoefficients IS
BEGIN
--------------------------------------------------------------------------------
  process(interpolateLinear, sample1, sample2, sample3, sample4 )
  begin
    if interpolateLinear = '0' then
      
      a <= resize(-sample1, a'length) + resize(3*sample2, a'length) + 
      resize(-3*sample3, a'length) + resize(sample4, a'length);
      
      b <= resize(2*sample1, b'length) + resize(-5*sample2, b'length) + 
      resize(4*sample3, b'length) + resize(-sample4, b'length);
      
      c <= resize(-sample1, c'length) + resize(sample3, c'length);
      d <= resize(sample2, d'length);

    end if;
  end process;
END ARCHITECTURE studentVersion;
