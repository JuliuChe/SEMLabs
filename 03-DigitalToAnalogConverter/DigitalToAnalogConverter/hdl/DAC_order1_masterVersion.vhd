ARCHITECTURE order1_masterVersion OF DAC IS

  signal parallelIn1: unsigned(parallelIn'range);
  signal integrator: unsigned(parallelIn'high+1 downto 0);
  signal quantized: std_ulogic;

BEGIN

--  parallelIn1 <= parallelIn;
  parallelIn1 <= parallelIn/2 + 2**(parallelIn'length-2);

  integrate: process(reset, clock)
  begin
    if reset = '1' then
      integrator <= (others => '0');
    elsif rising_edge(clock) then
      if quantized = '0' then
        integrator <= integrator + parallelIn1;
      else
        integrator <= integrator + parallelIn1 - 2**parallelIn'length;
      end if;
    end if;
  end process integrate;

  quantized <= integrator(integrator'high);

  serialOut <= quantized;

END ARCHITECTURE order1_masterVersion;
