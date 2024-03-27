ARCHITECTURE studentVersion OF interpolatorCalculatePolynom IS
-- cre les signaux x u v w y m=oversamplingBitNb
--------------------------------------------------------------------------------
  constant size : positive := d'length + 3 * oversamplingBitNb + 1 + 8 ;
  signal x : signed(size-1 downto 0);
  signal u : signed(size-1 downto 0);
  signal v : signed(size-1 downto 0);
  signal w : signed(size-1 downto 0);
  signal y : signed(size-1 downto 0);

BEGIN
  process(clock, reset)
  begin
    if reset = '1' then
      --METTRE A 0 les truc quon assigne dans le elsif
      --sampleOut <= (others => '0');
      x <= (others => '0');
      u <= (others => '0');
      v <= (others => '0');
      w <= (others => '0');
      y <= (others => '0');
    elsif rising_edge(clock) then
      if en = '1' then
        if restartPolynom = '1' then
          --initialiser les signaux
          x <= 
            SHIFT_LEFT(resize(d, size), 3*oversamplingBitNb + 1);
          u <=
            resize(a, size) +
            SHIFT_LEFT(resize(b, size), oversamplingBitNb) + 
            SHIFT_LEFT(resize(c, size), 2*oversamplingBitNb);
          v <=
            SHIFT_LEFT(resize(a, size), 2) +
            SHIFT_LEFT(resize(a, size), 1) +
            -- resize(6*a, size) +
            SHIFT_LEFT(resize(b, size), oversamplingBitNb + 1);
          w <=
            SHIFT_LEFT(resize(a, size), 2) +
            SHIFT_LEFT(resize(a, size), 1);
            -- resize(6*a, size);
          y <= resize(d, size);
        else
          --calculer de manière itérative
          x <= x + u;
          u <= u + v;
          v <= v + w;
          y <= SHIFT_RIGHT(x, 3 * oversamplingBitNb + 1);
        end if;
      end if;
    end if;
    -- assigner sampleOut
  end process;

  sampleOut <= resize(y, signalBitNb);

END ARCHITECTURE studentVersion;
