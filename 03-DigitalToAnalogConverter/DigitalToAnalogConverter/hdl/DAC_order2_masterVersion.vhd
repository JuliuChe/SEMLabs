ARCHITECTURE order2_masterVersion OF DAC IS

  constant attenuationShift: positive := 3;
  constant acc1BitNb: positive := parallelIn'length+5;
  constant acc2BitNb: positive := parallelIn'length+5;
  signal parallelIn1, parallelIn2: signed(parallelIn'high downto 0);
  signal acc1: signed(acc1BitNb-1 downto 0);
  signal acc2: signed(acc2BitNb-1 downto 0);
  constant c1: signed(acc1'range)
    := shift_left(to_signed(1, acc1'length), parallelIn'length-1);
  constant c2: signed(acc2'range)
    := resize(shift_left(c1, 4), acc2'length);
  signal quantized: std_ulogic;

BEGIN
  ------------------------------------------------------------------------------
                                                -- offset input to signed values

  parallelIn1(parallelIn1'high) <= not parallelIn(parallelIn'high);
  parallelIn1(parallelIn1'high-1 downto 0) <= 
    signed(parallelIn(parallelIn'high-1 downto 0));
                                                             -- attenuate signal
  parallelIn2 <= parallelIn1 - shift_right(parallelIn1, attenuationShift);

  ------------------------------------------------------------------------------
                                                               -- SD integrators
  integrate1: process(reset, clock)
  begin
    if reset = '1' then
      acc1 <= (others => '0');
    elsif rising_edge(clock) then
      if quantized = '1' then
        acc1 <= acc1 + resize(parallelIn2, acc1'length) - c1;
      else
        acc1 <= acc1 + resize(parallelIn2, acc1'length) + c1;
      end if;
    end if;
  end process integrate1;

  integrate2: process(reset, clock)
  begin
    if reset = '1' then
      acc2 <= (others => '0');
    elsif rising_edge(clock) then
      if quantized = '1' then
        acc2 <= acc2 + resize(acc1, acc2'length) - c2;
      else
        acc2 <= acc2 + resize(acc1, acc2'length) + c2;
      end if;
    end if;
  end process integrate2;

  ------------------------------------------------------------------------------
                                                  -- test last integrator output
  quantized <= '1' when acc2 >= 0 else '0';
  serialOut <= quantized;

END ARCHITECTURE order2_masterVersion;

