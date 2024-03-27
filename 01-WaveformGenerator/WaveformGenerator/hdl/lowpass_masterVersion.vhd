ARCHITECTURE masterVersion OF lowpass IS

  constant additionalBitNb: positive := shiftBitNb;
  signal lowpassReg: unsigned(lowpassIn'length+additionalBitNb-1 downto 0);

begin

  filter: process(reset, clock)
  begin
    if reset = '1' then
      lowpassReg <= (others => '0');
    elsif rising_edge(clock) then
      lowpassReg <= lowpassReg + lowpassIn - shift_right(lowpassReg, shiftBitNb);
    end if;
  end process filter;

  lowpassOut <= lowpassReg(lowpassReg'high downto lowpassReg'high-lowpassOut'length+1);

END ARCHITECTURE masterVersion;
