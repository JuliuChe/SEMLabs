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
signal DataWRegister, controlRegister, periodRegister:std_ulogic_vector(txFifoDepth-1 downto 0):=0;
signal TXCnter: unsigned(txFifoDepth-1 downto 0);

--Read Registers
signal DataRRegister, statusRegister:std_ulogic_vector(txFifoDepth-1 downto 0);
signal RXCnter: unsigned(txFifoDepth-1 downto 0);

--serial clock --- PROBABLY GARBAGE AT THIS STAGE
signal myClk:std_ulogic;
signal myCnter:std_ulogic_vector(periodRegister'range);
signal resetCnter:std_ulogic;
signal readyCase:std_ulogic;


-- COUNTER FOR TX
signal TXCounter: unsigned(txFifoDepth-1 downto 0);
signal TXCountDone: std_ulogic;
signal TXNbCounter: unsigned(unitnB'range);
signal TXNbCountDone: std_ulogic;




-- TX block
type stateTX is (Idle, TXStartBit, Transmit, NextBit, TXStopBit);
signal presentTXState, nextTXState : stateTX;
signal startTXCounter:std_ulogic := 0;  
--RX block
type stateRX is (Idle, RXStartBit, Recieve, NextBit, RXStopBit);
signal presentRXState, nextRXState : stateRX;


BEGIN




----------- AHB BLOCK -----------
signal DataR_h, statusR_h, DataW_h, PerW_h :std_ulogic_vector(txFifoDepth-1 downto 0);
signal writeDat, writePer, readData, readStat: std_ulogic;

process(hClk, hReset_n)
begin
	if (hReset_n = '0') then
		DataR_h <= '0';
		statusR_h<= '0';
		DataW_h <= '0';
		PerW_h <= '0';

		hReady <='0';
		hResp <= '0';
		hRData <= (OTHERS => '0');
		
	elsif rising_edge(hClk) then
		if(hReady = '0') then
			hReady <='1' ;
		else
			hReady <=  hReady;
		end if;
		--hAddr, hWData, hTrans, hWrite, hSel, ioIn
		if hSel = '1' then
			if hTrans = "10" then -- We are in SEQ Mode
				if(hWrite = '1') then --write 
					if(hAddr = to_unsigned(0,hAddr'length)) then
						writeDat <= '1';
						--outputRegister <= hWData(ioOut'length-1 downto 0);
					elsif (hAddr = to_unsigned(2,hAddr'length))  then
						writePer <= '1';
						--configRegister <=hWData(ioOut'length-1 downto 0);
					end if;
				else
					if(hAddr = to_unsigned(0,hAddr'length)) then
						readData <= '1';
					elsif (hAddr = to_unsigned(2,hAddr'length))  then
						readStat <= '1';
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
		DataW_h <= (OTHERS => '0');
		PerW_h <= (OTHERS => '0');
	elsif	rising_edge(hClk) then
		if writeDat = '1' then
		DataW_h <= hWData(hAddr'length-1 downto 0);
		end if;
		
		if writePer = '1' then
		PerW_h <= hWData(hAddr'length-1 downto 0);
		end if;
		
		if readData <= '1' then
		hRData <= DataR_h 
		end if;
		
		if readStat = '1' then
		
		end if; 
	end if;
end process;


hRData(hrData'high downto ioOut'length) <= (OTHERS => '0');
hRData(ioOut'length-1 downto 0) <= ioIn;



ioEn <=configRegister(ioEn'length-1 downto 0);
--inputRegister(ioIn'length-1 downto 0) <= ioIn;
ioOut <= outputRegister(ioOut'length-1 downto 0);
















-- TX FSM
-- Calculating Next State
nextTXState : process(presentTXState, DataWRegister, StartBit)

-- TX Loading Next State 
process(hClk, hReset_n)
BEGIN
	if hReset_n = '1' then
		presentTXState <= Idle;
	elsif rising_edge(hClk) then
		presentTXState <= nextTXState;
	end if;
end process;



-- OUTPUT : 
outputTX : process(presentTXState)

-- In transmitting : output startTXCounter = '1'


-- FSM That counts from 0 to periodRegister
-- count unit base period
  countTXDuration: process(hReset_n, hClk)
  begin
    if reset = '1' then
      TXCounter <= (others => '0');
    elsif rising_edge(clock) then
      if TXCounter = 0 then
        if (startTXCounter = '1') or (unitNbCounter > 0) then
          unitCounter <= unitCounter + 1;
        end if;
      else
        if unitCountDone = '0' then
          unitCounter <= unitCounter + 1;
        else
          unitCounter <= (others => '0');
        end if;
      end if;
    end if;
  end process countUnitDuration;

  unitCountDone <= '1' when unitCounter = unitCountDivide
    else '0';
                                                     -- count unit period number
  countPeriods: process(reset, clock)
  begin
    if reset = '1' then
      unitNbCounter <= (others => '0');
    elsif rising_edge(clock) then
      if unitNbCounter = 0 then
        if startCounter = '1' then
          unitNbCounter <= unitNbCounter + 1;
        end if;
      else
        if unitNbCountDone = '0' then
          if unitCountDone = '1' then
            unitNbCounter <= unitNbCounter + 1;
          end if;
        else
          unitNbCounter <= (others => '0');
        end if;
      end if;
    end if;
  end process countPeriods;

  unitNbCountDone <= '1' when (unitNbCounter = unitNb) and (unitCountDone = '1')
    else '0';

  done <= unitNbCountDone;
-- RX FSM
-- Calculating Next State
nextTXState : process(presentTXState, DataWRegister, StartBit)

-- RX Loading Next State 
process(hClk, hReset_n)
	BEGIN
		if hReset_neset = '1' then
			presentRXState <= Idle;
		elsif rising_edge(clock) then
			presentRXState <= nextRXState;
		end if;
	end process;



-- OUTPUT : 
outputRX : process(presentRXState)







-- TODO : TO SEE LATER 
process(hClk, hReset_n)
begin
	if (hReset_n = '0') then
		myCnter <= (OTHERS=>'0');
	elsif rising_edge(hClk) then
		if resetCnter = '0' then
			myCnter <= std_ulogic_vector(unsigned(myCnter)+1);
		else
			myCnter <= (OTHERS=>'0');
		end if;
	end if;
end process;

process(myCnter)
begin 
	if std_ulogic_vector(unsigned(myCnter)+1) = periodRegister then
		resetCnter <= '1';
	else
		if unsigned(myCnter) > shift_right(unsigned(periodRegister),1) then
			myClk <='1';
		else
			myClk <='0';
		end if;
		resetCnter <= '0';
	end if;
end process;

process(hClk, hReset_n)
begin 
	if (hReset_n = '0') then
		hRData <= (OTHERS=>'0');
		--hReady <= '0';
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

--hResp <= '0';

--hRData <= RxD;
  -- AHB-Lite
--  hRData  <=	(OTHERS => '0');
--  hReady  <=	'0';	
--  hResp	  <=	'0';	

  -- Serial
--  TxD <= '0';

END ARCHITECTURE studentVersion;

