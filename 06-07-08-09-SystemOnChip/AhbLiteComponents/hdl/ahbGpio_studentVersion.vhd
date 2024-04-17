--==============================================================================
--
-- AHB general purpose input/outputs
--
-- Provides "ioNb" input/output signals .
--
--------------------------------------------------------------------------------
--
-- Write registers
--
-- 00, data register receives the values to drive the output lines.
-- 01, output enable register defines the signal direction:
--     when '1', the direction is "out".
--
--------------------------------------------------------------------------------
--
-- Read registers
-- 00, data register provides the values detected on the lines.
--
ARCHITECTURE studentVersion OF ahbGpio IS

signal configRegister:unsigned(ioNb-1 downto 0);
signal dataRegister:unsigned(ioNb-1 downto 0);


BEGIN

process(hClk, hReset_n)
begin
	if (hReset_n = '0') then
		ioOut <= (OTHERS => '0');
		ioEn  <= (OTHERS => '0');
		hReady  <=	'0';	
		hResp	  <=	'0';
		hRData  <=	(OTHERS => '0');
	elsif rising_edge(hClk) then
		--hAddr, hWData, hTrans, hWrite, hSel, ioIn
		if(hSel = '1') then
			if(hAddr = to_unsigned(0,hAddr'length)) then --write or read
				if(hTrans=to_unsigned(2,hTrans'length) and hWrite = '1')			
			else --only write
				if(hTrans=to_unsigned(2,hTrans'length) and hWrite = '1') then
					configRegister <= hWData;
					hReady <= '1';
				else
					configRegister <= configRegister;
				end if;
			end if;
		else
		
		end if;
	end if;
	
	
end procees;

	
  -- AHB-Lite
  --hRData  <=	(OTHERS => '0');
  --hReady  <=	'0';	
  --hResp	  <=	'0';	

  -- Out
  --ioOut <= (OTHERS => '0');
  --ioEn  <= (OTHERS => '0');

END ARCHITECTURE studentVersion;

