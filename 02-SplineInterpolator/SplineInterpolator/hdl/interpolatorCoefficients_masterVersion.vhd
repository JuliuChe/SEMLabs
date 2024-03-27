ARCHITECTURE masterVersion OF interpolatorCoefficients IS
BEGIN

  calcCoeffs: process(interpolateLinear, sample1, sample2, sample3, sample4)
  begin
    if interpolateLinear = '1' then
      a <= (others => '0');
      b <= (others => '0');
      c <=   resize(2*sample3, c'length)
           - resize(2*sample2, c'length);
      d <=   resize(  sample2, d'length);
    else
      a <=   resize(  sample4, a'length)
           - resize(3*sample3, a'length)
           + resize(3*sample2, a'length)
           - resize(  sample1, a'length);
      b <=   resize(2*sample1, b'length)
           - resize(5*sample2, b'length)
           + resize(4*sample3, b'length)
           - resize(  sample4, b'length);
      c <=   resize(  sample3, c'length)
           - resize(  sample1, c'length);
      d <=   resize(  sample2, d'length);
    end if;
  end process calcCoeffs;

END ARCHITECTURE masterVersion;

