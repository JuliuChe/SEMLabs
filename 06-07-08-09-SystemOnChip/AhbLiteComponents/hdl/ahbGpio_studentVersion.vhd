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

signal configRegister:std_ulogic_vector(ioOut'length-1 downto 0);
signal outputRegister, inputRegister:std_ulogic_vector(ioOut'length-1 downto 0);
signal readyCase, writeConfig, writeOut, readIn : std_uLogic;


BEGIN

process(hClk, hReset_n)
begin
	if (hReset_n = '0') then
		writeOut <= '0';
		writeConfig <= '0';
		readIn <= '0';
		readyCase <= '0';
	elsif rising_edge(hClk) then
		readIn <= '0';
		writeOut <= '0';
		writeConfig <= '0';
		
		if(readyCase = '0') then
			readyCase <='1' ;
		else
			readyCase <=  readyCase;
		end if;
		--hAddr, hWData, hTrans, hWrite, hSel, ioIn
		if hSel = '1' then
			if hTrans = "10" then
	
				if(hWrite = '1') then --write 
					if(hAddr = to_unsigned(0,hAddr'length)) then
						writeOut <= '1';
						--outputRegister <= hWData(ioOut'length-1 downto 0);
					elsif (hAddr = to_unsigned(1,hAddr'length))  then
						writeConfig <= '1';
						--configRegister <=hWData(ioOut'length-1 downto 0);
					end if;
				--else --read
					--readIn <= '1';
					--hRData(ioOut'length-1 downto 0) <= ioIn;
				end if;
			else
			end if;
		else
		end if;
	end if;
end process;

process(hClk, hReset_n)
begin 
	if (hReset_n = '0') then
		outputRegister <= (OTHERS => '0');
		configRegister  <= (OTHERS => '0');
	elsif	rising_edge(hClk) then
		--if readIn = '1' then
		--end if;
		
		if writeOut = '1' then
		outputRegister <= hWData(ioOut'length-1 downto 0);
		end if;
		
		if writeConfig = '1' then
		configRegister <=hWData(ioOut'length-1 downto 0);
		end if;
	end if;
end process;


hRData(hrData'high downto ioOut'length) <= (OTHERS => '0');
hRData(ioOut'length-1 downto 0) <= ioIn;



ioEn <=configRegister(ioEn'length-1 downto 0);
--inputRegister(ioIn'length-1 downto 0) <= ioIn;
ioOut <= outputRegister(ioOut'length-1 downto 0);

process(readyCase)
	begin
		if readyCase = '0' then
			hReady <= '0';
		else
			hready <='1';
		end if;
end process;

		

hResp <= '0';
	
  -- AHB-Lite
  --hRData  <=	(OTHERS => '0');
  --hReady  <=	'0';	
  --hResp	  <=	'0';	

  -- Out
  --ioOut <= (OTHERS => '0');
  --ioEn  <= (OTHERS => '0');

END ARCHITECTURE studentVersion;

