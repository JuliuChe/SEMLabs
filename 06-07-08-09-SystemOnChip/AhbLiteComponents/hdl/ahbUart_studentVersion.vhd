--==============================================================================
--
-- AHB UART
--
-- Implements a serial port.
--
--------------------------------------------------------------------------------
--
-- Write registers
--
-- 00, data register receives the word to be sent to the serial port.
-- 01, control register is used to control the peripheral.
-- 02, scaler register is used to set the baud rate.
--
--------------------------------------------------------------------------------
--
-- Read registers
-- 00, data register provides the last word received by the serial port.
-- 01, status register is used to get the peripheral's state.
--     bit 0: data ready for read
--     bit 1: sending in progress
--     bit 2: receiving in progress
--




ARCHITECTURE studentVersion OF ahbUart IS

--Write Registers
signal DataWRegister, controlRegister, periodRegister:std_ulogic_vector(txFifoDepth-1 downto 0);

--Read Registers
signal DataRRegister, statusRegister:std_ulogic_vector(txFifoDepth-1 downto 0);

signal readyCase:std_ulogic;


BEGIN

process(hClk, hReset_n)
begin 
	if (hReset_n = '0') then
		hRData <= (OTHERS=>'0');
		hReady <= '0';
		hResp <= '0';
		TxD <= '1';
		readyCase <= '0';
	elsif rising_edge(hClk) then
	
		if(readyCase = '0') then
			readyCase <='1' ;
		else
			readyCase <=  readyCase;
		end if;

		if hSel = '1' then
			if hTrans = "10" then
				if(hWrite = '1') then --write state
					if(hAddr = to_unsigned(0,hAddr'length)) then
						--writeOut <= '1';
						DataWRegister <= hWData(txFifoDepth-1 downto 0);
					elsif (hAddr = to_unsigned(1,hAddr'length))  then
						--writeConfig <= '1';
						controlRegister <=hWData(txFifoDepth-1 downto 0);
					elsif (hAddr = to_unsigned(2, hAddr'length)) then
						periodRegister <= hWData(txFifoDepth-1 downto 0);
					end if;
				else -- Read state
					if(hAddr = to_unsigned(0,hAddr'length)) then
						hRData(txFifoDepth-1 downto 0) <= DataRRegister;
					elsif (hAddr = to_unsigned(1,hAddr'length)) then
						hRData(txFifoDepth-1 downto 0) <= statusRegister;
					end if;
				end if;
			else
			end if;
		else
		end if;
	end if;
end process;


process(readyCase)
	begin
		if readyCase = '0' then
			hReady <= '0';
		else
			hready <='1';
		end if;
end process;

hResp <= '0';

hRData <= RxD;
  -- AHB-Lite
  hRData  <=	(OTHERS => '0');
  hReady  <=	'0';	
  hResp	  <=	'0';	

  -- Serial
  TxD <= '0';

END ARCHITECTURE studentVersion;

