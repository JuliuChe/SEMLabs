ARCHITECTURE masterVersion OF interpolatorCalculatePolynom IS

  constant additionalBitNb: positive := 1;
  constant internalsBitNb: positive := signalBitNb + 3*oversamplingBitNb + 1
    + additionalBitNb;
  signal x: signed(internalsBitNb-1 downto 0);
  signal u: signed(internalsBitNb-1 downto 0);
  signal v: signed(internalsBitNb-1 downto 0);
  signal w: signed(internalsBitNb-1 downto 0);

BEGIN

  iterativePolynom: process(reset, clock)
  begin
    if reset = '1' then
      x <= (others => '0');
      u <= (others => '0');
      v <= (others => '0');
      w <= (others => '0');
      sampleOut <= (others => '0');
    elsif rising_edge(clock) then
      if en = '1' then
        if restartPolynom = '1' then
          x <=   shift_left(resize(2*d, x'length), 3*oversamplingBitNb);
          u <=   resize(a, u'length)
               + shift_left(resize(b, u'length), oversamplingBitNb)
               + shift_left(resize(c, u'length), 2*oversamplingBitNb);
          v <=   resize(6*a, v'length)
               + shift_left(resize(2*b, v'length), oversamplingBitNb);
          w <=   resize(6*a, w'length);
          sampleOut <= resize(d, sampleOut'length);
        else
          x <= x + u;
          u <= u + v;
          v <= v + w;
          sampleOut <= resize(
            shift_right(x, 3*oversamplingBitNb+1), sampleOut'length
          );
                                                               -- limit overflow
          if x(x'high downto x'high-additionalBitNb) = "01" then
            sampleOut <= not shift_left(
              resize("10", sampleOut'length), sampleOut'length-2
            );
          end if;
                                                              -- limit underflow
          if x(x'high downto x'high-additionalBitNb) = "10" then
            sampleOut <= shift_left(
              resize("10", sampleOut'length), sampleOut'length-2
            );
          end if;
        end if;
      end if;
    end if;
  end process iterativePolynom;

END ARCHITECTURE masterVersion;
