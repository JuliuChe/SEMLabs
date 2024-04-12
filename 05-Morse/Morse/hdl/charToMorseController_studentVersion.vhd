ARCHITECTURE studentVersion OF charToMorseController IS

  signal isA, isB, isC, isD, isE, isF, isG, isH,
         isI, isJ, isK, isL, isM, isN, isO, isP,
         isQ, isR, isS, isT, isU, isV, isW, isX,
         isY, isZ,
         is0, is1, is2, is3, is4, is5, is6, is7,
         is8, is9 : std_ulogic;

type stateDote is (waitStartDot, sendDotStart, sendDotWait, sendDotSpacerStart, 
	sendDotSpacerWait, EndDot); 
type stateDash is (waitStartDash, sendDashStart, sendDashWait, sendDashSpacerStart, 
	sendDashSpacerWait, EndDash);
type stateChar is (waitForChar, storeChar, waitWordChar, waitWordCharSpacer, getNextChar,
	sendDot1, sendDash1, 
	sendDotWaitDot2, sendDotDot2, sendDotDash2, sendDashDot2, sendDashWaitDash2, sendDashDash2, 
	sendDotDotWaitDot3, sendDotDotDot3, sendDotDotDash3, sendDotDashDot3, sendDotDashWaitDash3, sendDotDashDash3, 
	sendDashDotWaitDot3, sendDashDotDot3, sendDashDotDash3, sendDashDashDot3, sendDashDashWaitDash3, sendDashDashDash3, 
	
	sendDotDotDotWaitDot4, sendDotDotDotDot4, sendDotDotDotDash4, 
	sendDotDotDashDot4, sendDotDotDashWaitDash4, sendDotDotDashDash4,
	sendDotDashDotWaitDot4, sendDotDashDotDot4,  
	
	sendDotDashDashDot4, sendDotDashDashWaitDash4, sendDotDashDashDash4,
	sendDashDotDotWaitDot4, sendDashDotDotDot4, sendDashDotDotDash4,
	sendDashDotDashDot4, sendDashDotDashWaitDash4, sendDashDotDashDash4,
	sendDashDashDotWaitDot4, sendDashDashDotDot4, sendDashDashDotDash4,
	sendDashDashDashDot4, sendDashDashDashWaitDash4, sendDashDashDashDash4,
	
	sendDotDotDotDotWaitDot5, sendDotDotDotDotDot5, 
	sendDotDotDotDotDash5,
	sendDotDotDotDashWaitDash5, sendDotDotDotDashDash5,
	sendDotDotDashDashWaitDash5, sendDotDotDashDashDash5,
	sendDashDotDotDotWaitDot5, sendDashDotDotDotDot5,
	sendDashDashDotDotWaitDot5, sendDashDashDotDotDot5,
	sendDashDashDashDotWaitDot5, sendDashDashDashDotDot5,
	sendDotDashDashDashWaitDash5, sendDotDashDashDashDash5,
	sendDashDashDashDashDot5,
	sendDashDashDashDashWaitDash5, sendDashDashDashDashDash5,
	
	
	endOfChar, sendSpacerWaitChar);

constant dotTime : positive := 1;
signal morseOutDot, strtCnterDot, dotSMActive, morseOutDash, strtCnterDash, dashSMActive, morseOutChar, strtCnterChar, charSMActive, sendDt, sendDs, rdChr : std_ulogic := '0';
signal unitNbDot, unitNbChar, unitNbDash : unsigned(unitNb'range) := to_unsigned(0, unitNb'length);
signal presentDot, nextDot : stateDote;
signal presentDash, nextDash : stateDash;
signal presentChar, nextChar : stateChar;

--Additionnal Inputs
signal sendDot, sendDash : std_ulogic;

--Additionnal outputs
signal dotSent, dashSent : std_ulogic;

BEGIN
  ------------------------------------------------------------------------------
  --------------------------- CHAR SENT STATE MACHINE --------------------------
  nxt_Charstate : process(presentChar,isA, isB, isC, isD, isE, isF, isG, isH,
         isI, isJ, isK, isL, isM, isN, isO, isP, isQ, isR, isS, isT, isU, isV, 
		 isW, isX, isY, isZ, is0, is1, is2, is3, is4, is5, is6, is7, is8, is9, 
		 charNotReady, counterDone, dashSent, dotSent)
	BEGIN
		case presentChar is
		
			-- Beginning of coding of a letter
			when waitForChar =>
				if charNotReady = '0' then 
					nextChar <= storeChar;
				else
					nextChar <= waitForChar;
				end if;
			when storeChar =>
				if (isA or isE or isF or isH or isI or isJ or isL or isP or isR 
				or isS or isU or isV or isW or is1 or is2 or is3 or is4 or is5) = '1' then 
					nextChar <= sendDot1;
				elsif (isB or isC or isD or isG or isK or isM or isN or isO or isQ
				or isT or isX or isY or isZ or is0 or is6 or is7 or is8 or is9) = '1' then
					nextChar <= sendDash1;
				else
					nextChar <= waitWordChar;
				end if;

			--Beginning of 1st Character : -
			when sendDot1 =>
				if dotSent = '1' then
					if (isF or isH or isI or isS or isU or isV or is2 or is3 or 
					is4 or is5) = '1' then
						nextChar <= sendDotWaitDot2;
					elsif (isA or isJ or isL or isP or isR or isW or is1) = '1' then
						nextChar <= sendDotDash2;
					else --char is e
						nextChar <= endOfChar;
					end if;
				else
					nextChar <= sendDot1;
				end if;
			when sendDash1 =>
				if dashSent = '1' then
					if (isB or isC or isD or isK or isN or isX or isY 
					or is6) = '1' then
						nextChar <= sendDashDot2;
					elsif (isG or isM or isO or isQ or isZ or is7 or is8 
					or is9 or is0) = '1' then
						nextChar <= sendDashWaitDash2;
					else --char is t
						nextChar <= endOfChar;
					end if;
				else
					nextChar <= sendDash1;
				end if;
				
			-- Beginning of 2nd Character : -/-
			when sendDotWaitDot2 =>
				nextChar <= sendDotDot2;
			when sendDotDot2 =>
				if dotSent = '1' then
					if (isH or isS or isV or is3 or is4 or is5) = '1' then
						nextChar <= sendDotDotWaitDot3;
					elsif (isF or isU or is2) = '1' then
						nextChar <= sendDotDotDash3;
					else --char is i
						nextChar <= endOfChar;
					end if;
				else
					nextChar <= sendDotDot2;
				end if;
			when sendDotDash2 =>
				if dashSent = '1' then
					if  (isL or  isR) = '1' then
						nextChar <= sendDotDashDot3;
					elsif (isJ or isP or isW or is1) = '1' then
						nextChar <= sendDotDashWaitDash3;
					else -- char is a
						nextChar <= endOfChar;
					end if;
				else
					nextChar <= sendDotDash2;
				end if;
			when sendDashDot2 =>
				if dotSent = '1' then
					if (isB or isD or isX or is6) = '1' then
						nextChar <= sendDashDotWaitDot3;
					elsif (isC or isK or isY) = '1' then
						nextChar <= sendDashDotDash3;
					else -- char is n 
						nextChar <= endOfChar;
					end if;
				else
					nextChar <= sendDashDot2;
				end if;
			when sendDashWaitDash2 =>
				nextChar <= sendDashDash2;
			when sendDashDash2 =>
				if dashSent = '1' then
					if (isG or isQ or isZ or is7) = '1' then
						nextChar <= sendDashDashDot3;
					elsif (isO or is8 or is9 or is0) = '1' then
						nextChar <= sendDashDashWaitDash3;
					else -- char is m
						nextChar <= endOfChar;
					end if;
				else
					nextChar <=  sendDashDash2;
				end if;
			-- End of 2nd Character : -/-	
			
			-- Beginning of 3rd Character: -/-/-
			when sendDotDotWaitDot3 =>
				nextChar <= sendDotDotDot3;
			when sendDotDotDot3 =>
				if dotSent = '1' then
					if (isH or is4 or is5) = '1' then
						nextChar <= sendDotDotDotWaitDot4;
					elsif (isV or is3) = '1' then
						nextChar <= sendDotDotDotDash4;
					else -- char is s
						nextChar <= endOfChar;
					end if;
				else
					nextChar <= sendDotDotDot3;
				end if;
			when sendDotDotDash3 =>
				if dashSent = '1' then
					if isF = '1' then
						nextChar <= sendDotDotDashDot4;
					elsif is2 = '1' then
						nextChar <= sendDotDotDashWaitDash4;
					else -- char is u
						nextChar <= endOfChar; 
					end if;
				else 
					nextChar <= sendDotDotDash3;
				end if;
			when sendDotDashDot3 =>
				if dotSent = '1' then
					if isL = '1'then
						nextChar <= sendDotDashDotWaitDot4;
					else -- char is r
						nextChar <= endOfChar;
					end if;
				else
					nextChar <= sendDotDashDot3;
				end if;
			when sendDotDashWaitDash3 =>
				nextChar <= sendDotDashDash3;
			when sendDotDashDash3 =>
				if dashSent = '1' then
					if isP = '1' then
						nextChar <= sendDotDashDashDot4;
					elsif (isJ or is1) = '1' then
						nextChar <= sendDotDashDashWaitDash4;
					else -- char is w
						nextChar <= endOfChar;
					end if;
				else
					nextChar <= sendDotDashDash3;
				end if;
			when sendDashDotWaitDot3 =>
				nextChar <= sendDashDotDot3;
			when sendDashDotDot3 =>
				if dotSent = '1' then
					if (isB or is6) = '1'  then
						nextChar <= sendDashDotDotWaitDot4;
					elsif isX = '1' then
						nextChar <= sendDashDotDotDash4;
					else -- char is d
						nextChar <= endOfChar;
					end if;
				else
					nextChar <= sendDashDotDot3;
				end if;
			when sendDashDotDash3 =>
				if dashSent = '1' then
					if isC = '1' then
						nextChar <= sendDashDotDashDot4;
					elsif isY = '1' then
						nextChar <= sendDashDotDashWaitDash4;
					else -- char is k
						nextChar <= endOfChar;
					end if;
				else
					nextChar <= sendDashDotDash3;
				end if;
			when sendDashDashDot3 =>
				if dotSent = '1' then
					if (isZ or is7) = '1' then
						nextChar <= sendDashDashDotWaitDot4; --z or 7 
					elsif isQ = '1' then
						nextChar <= sendDashDashDotDash4; -- q then end 
					else -- char is g
						nextChar <= endOfChar;
					end if;
				else
					nextChar <= sendDashDashDot3;
				end if;
			when sendDashDashWaitDash3 =>
				nextChar <= sendDashDashDash3;
			when sendDashDashDash3 =>
				if dashSent = '1' then
					if is8 = '1' then
						nextChar <= sendDashDashDashDot4;
					elsif (is0 or is9) = '1' then
						nextChar <= sendDashDashDashWaitDash4;
					else -- char is o
						nextChar <= endOfChar;
					end if;
				else
					nextChar <= sendDashDashDash3;
				end if;
			-- END of 3rd Character : -/-/-
			
			-- Beginning of 4th Character : -/-/-/-
				-- Beginning of 4th Character : -/-/-/Dot
			when sendDotDotDotWaitDot4 =>  
				nextChar <=  sendDotDotDotDot4;
			when sendDotDotDotDot4 =>
				if dotSent = '1' then
					if is5 = '1' then
						nextChar <= sendDotDotDotDotWaitDot5;
					elsif is4 = '1' then
						nextChar <= sendDotDotDotDotDash5;
					else 
						nextChar <= endOfChar; -- char is h 
					end if;
				else
					nextChar <= sendDotDotDotDot4;
				end if;
			when sendDotDotDashDot4 =>
				if dotSent = '1' then
					nextChar <= endOfChar; --char is f
				else
					nextChar <= sendDotDotDashDot4;
				end if;
			when sendDotDashDotWaitDot4 => nextChar <= sendDotDashDotDot4; 
			when sendDotDashDotDot4 =>
				if dotSent = '1' then
					nextChar <= endOfChar; --char is l
				else
					nextChar <= sendDotDashDotDot4;
				end if;
			when sendDotDashDashDot4 =>
				if dotSent = '1' then
					nextChar <= endOfChar; --char is p
				else
					nextChar <= sendDotDashDashDot4;
				end if;
			when sendDashDotDotWaitDot4 =>  
				nextChar <=  sendDashDotDotDot4;
			when sendDashDotDotDot4 =>
				if dotSent = '1' then
					if is6 = '1' then
						nextChar <= sendDashDotDotDotWaitDot5; 
					else
						nextChar <= endOfChar; --char is b 
					end if;
				else
					nextChar <= sendDashDotDotDot4;
				end if;
			when sendDashDotDashDot4 =>
				if dotSent = '1' then
					nextChar <= endOfChar; -- char is c 
				else
					nextChar <= sendDashDotDashDot4;
				end if;
			when sendDashDashDashDot4 => 
				if dotSent = '1' then
					nextChar <= sendDashDashDashDotWaitDot5;
				else
					nextChar <= sendDashDashDashDot4;
				end if;
			when sendDashDashDotWaitDot4 =>  
				nextChar <=  sendDashDashDotDot4;
			when sendDashDashDotDot4 => 
				if dotSent = '1' then
					if is7 = '1' then
						nextChar <= sendDashDashDotDotWaitDot5;
					else
						nextChar <= endOfChar; -- char is z
					end if;
				else
					nextChar <= sendDashDashDotDot4;
				end if;
				
				-- Beginning of 4th Character : -/-/-/Dash
			when sendDotDotDotDash4 => 
				if dashSent = '1' then
					if is3 = '1' then
						nextChar <= sendDotDotDotDashWaitDash5;
					else 
						nextChar <= endOfChar; -- char is v
					end if;
				else
					nextChar <= sendDotDotDotDash4;
				end if;
			when sendDotDotDashWaitDash4 =>  
				nextChar <=  sendDotDotDashDash4;
			when sendDotDotDashDash4 =>
				if dashSent = '1' then
					nextChar <= sendDotDotDashDashWaitDash5;
				else
					nextChar <= sendDotDotDashDash4;
				end if;
			when sendDotDashDashWaitDash4 =>  nextChar <=  sendDotDashDashDash4;
			when sendDotDashDashDash4 =>
				if dashSent = '1' then
					if is1 = '1' then
						nextChar <= sendDotDashDashDashWaitDash5; 
					else
						nextChar <= endOfChar; -- char is j
					end if;
				else
					nextChar <= sendDotDashDashDash4;
				end if;
			when sendDashDotDotDash4 =>
				if dashSent = '1' then
					nextChar <= endOfChar; -- char is x
				else
					nextChar <= sendDashDotDotDash4;
				end if;
			when sendDashDotDashWaitDash4 =>  
				nextChar <=  sendDashDotDashDash4;
			when sendDashDotDashDash4 =>
				if dashSent = '1' then
					nextChar <= endOfChar; -- char is y
				else
					nextChar <= sendDashDotDashDash4;
				end if;
			when sendDashDashDotDash4 =>
				if dashSent = '1' then
					nextChar <= endOfChar; -- char is q
				else
					nextChar <= sendDashDashDotDash4;
				end if;
			when sendDashDashDashWaitDash4 =>  
				nextChar <=  sendDashDashDashDash4;
			when sendDashDashDashDash4 => 
				if dashSent = '1' then
					if is9 = '1' then
						nextChar <= sendDashDashDashDashDot5;
					elsif is0 = '1' then
						nextChar <= sendDashDashDashDashWaitDash5;
					end if;
				else
					nextChar <= sendDashDashDashDash4;
				end if;
				-- End of 4th Character : -/-/-/Dash
			-- End of 4th Character : -/-/-/-
			
			-- Beginning of 5th Character : -/-/-/-/-
			when sendDotDotDotDotWaitDot5 => 
				nextChar <= sendDotDotDotDotDot5; 
			when sendDotDotDotDotDot5 =>  
				if dotSent = '1' then 
					nextChar <=  endOfChar; --char is 5
				else
					nextChar <= sendDotDotDotDotDot5 ;
				end if;
			when sendDotDotDotDotDash5 => 
				if dashSent = '1' then 
					nextChar <= endOfChar; --char is 4
				else
					nextChar <= sendDotDotDotDotDash5 ;
				end if;
			when sendDashDotDotDotWaitDot5 => 
				nextChar <= sendDashDotDotDotDot5;
			when sendDashDotDotDotDot5 =>  
				if dotSent = '1' then 
					nextChar <= endOfChar;  -- char is 6
				else
					nextChar <= sendDashDotDotDotDot5;
				end if;
			when sendDashDashDotDotWaitDot5 => 
				nextChar <= sendDashDashDotDotDot5;
			when sendDashDashDotDotDot5 => 
				if dotSent = '1' then 
					nextChar <= endOfChar; -- char is 7
				else
					nextChar <= sendDashDashDotDotDot5;
				end if;
			when sendDotDotDotDashWaitDash5 => 
				nextChar <= sendDotDotDotDashDash5;
			when sendDotDotDotDashDash5 => 
				if dashSent = '1' then 
					nextChar <= endOfChar;--char is 3
				else
					nextChar <= sendDotDotDotDashDash5;
				end if;
			when sendDotDotDashDashWaitDash5 => 
				nextChar <= sendDotDotDashDashDash5;
			when sendDotDotDashDashDash5 => 
				if dashSent = '1' then 
					nextChar <= endOfChar; -- char is 2
				else
					nextChar <= sendDotDotDashDashDash5;
				end if;
			when sendDotDashDashDashWaitDash5 => 
				nextChar <= sendDotDashDashDashDash5;
			when sendDotDashDashDashDash5 => 
				if dashSent = '1' then 
					nextChar <= endOfChar; -- char is 1
				else
					nextChar <= sendDotDashDashDashDash5;
				end if;
			when sendDashDashDashDotWaitDot5 => 
				nextChar <= sendDashDashDashDotDot5;
			when sendDashDashDashDotDot5 =>  
				if dotSent = '1' then 
					nextChar <= endOfChar; -- char is 8
				else
					nextChar <= sendDashDashDashDotDot5;
				end if;
			when sendDashDashDashDashDot5 =>  
				if dotSent = '1' then 
					nextChar <= endOfChar; -- char is 9
				else
					nextChar <= sendDashDashDashDashDot5;
				end if;
			when sendDashDashDashDashWaitDash5 => 
				nextChar <= sendDashDashDashDashDash5;
			when sendDashDashDashDashDash5 => 
				if dashSent = '1' then 
					nextChar <= endOfChar; -- char is 0  
				else
					nextChar <= sendDashDashDashDashDash5;
				end if;
			-- End of 5th Character : -/-/-/-/-
			
			
			
			-- End of coding of a letter
			when waitWordChar =>
				nextChar <= waitWordCharSpacer;
			when waitWordCharSpacer =>
				if counterDone = '1' then
					nextChar <= endOfChar;
				else
					nextChar <= waitWordCharSpacer;
				end if;
			when endOfChar =>
				nextChar <= sendSpacerWaitChar;
			when sendSpacerWaitChar =>
				if counterDone = '1' then 
					nextChar <= getNextChar;
				else
					nextChar <= sendSpacerWaitChar;
				end if;
			when getNextChar =>
				nextChar <= waitForChar;
			when others =>
				nextChar <= waitForChar; 
		end case;
	end process;
	
	-- CHAR SENT STATE MACHINE
	state_Char_reg : process(clock,reset)
	BEGIN
		if reset = '1' then
			presentChar <= waitForChar;
		elsif rising_edge(clock) then
			presentChar <= nextChar;
		end if;
	end process;
	
	
	-- OUTPUT : 
	outputChar : process(presentChar)
	BEGIN
		case presentChar is
			when waitForChar =>
				charSMActive <= '0';
				sendDs <= '0';
				sendDt <= '0';
				morseOutChar <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				strtCnterChar <= '0';
				rdChr <= '0';
			when storeChar =>
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '0';
				sendDt <= '0';
				strtCnterChar <= '0';
				rdChr <= '0';
			-- CHAR SENT STATE MACHINE
			when sendDot1 =>
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '0';
				sendDt <= '1';
				strtCnterChar <= '0';
				rdChr <= '0';
			when sendDash1 =>
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '1';
				sendDt <= '0';
				strtCnterChar <= '0';
				rdChr <= '0';
			-- CHAR SENT STATE MACHINE
			when sendDotDot2 =>
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '0';
				sendDt <= '1';
				strtCnterChar <= '0';
				rdChr <= '0';
			when sendDotDash2 =>
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '1';
				sendDt <= '0';
				strtCnterChar <= '0';
				rdChr <= '0';
			when sendDashDot2 =>
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '0';
				sendDt <= '1';
				strtCnterChar <= '0';
				rdChr <= '0';
			when sendDashDash2 =>
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '1';
				sendDt <= '0';
				strtCnterChar <= '0';
				rdChr <= '0';
			-- CHAR SENT STATE MACHINE
			when sendDotDotDot3 =>
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '0';
				sendDt <= '1';
				strtCnterChar <= '0';
				rdChr <= '0';
			when sendDotDotDash3 =>
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '1';
				sendDt <= '0';
				strtCnterChar <= '0';
				rdChr <= '0';
			when sendDotDashDot3 =>
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '0';
				sendDt <= '1';
				strtCnterChar <= '0';
				rdChr <= '0';
			when sendDotDashDash3 =>
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '1';
				sendDt <= '0';
				strtCnterChar <= '0';
				rdChr <= '0';
			-- CHAR SENT STATE MACHINE
			when sendDashDotDot3 =>
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '0';
				sendDt <= '1';
				strtCnterChar <= '0';
				rdChr <= '0';
			when sendDashDotDash3 =>
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '1';
				sendDt <= '0';
				strtCnterChar <= '0';
				rdChr <= '0';
			when sendDashDashDot3 =>
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '0';
				sendDt <= '1';
				strtCnterChar <= '0';
				rdChr <= '0';
			when sendDashDashDash3 =>
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '1';
				sendDt <= '0';
				strtCnterChar <= '0';
				rdChr <= '0';
			when sendDotDotDotDot4 =>
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '0'; 
				sendDt <= '1';
				strtCnterChar <= '0';
				rdChr <= '0';
			when sendDotDotDotDash4 =>
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '1'; 
				sendDt <= '0';
				strtCnterChar <= '0';
				rdChr <= '0';
			when sendDotDotDashDot4 =>
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '0'; 
				sendDt <= '1';
				strtCnterChar <= '0';
				rdChr <= '0';
			when sendDotDotDashDash4 =>
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '1'; 
				sendDt <= '0';
				strtCnterChar <= '0';
				rdChr <= '0';
			when sendDotDashDotDot4 => 
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '0'; 
				sendDt <= '1';
				strtCnterChar <= '0';
				rdChr <= '0';
			when sendDotDashDashDot4 =>
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '0'; 
				sendDt <= '1';
				strtCnterChar <= '0';
				rdChr <= '0';
			when sendDotDashDashDash4 => 
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '1'; 
				sendDt <= '0';
				strtCnterChar <= '0';
				rdChr <= '0';
			when sendDashDotDotDot4 => 
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '0'; 
				sendDt <= '1';
				strtCnterChar <= '0';
				rdChr <= '0';
			when sendDashDotDotDash4 =>
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '1'; 
				sendDt <= '0';
				strtCnterChar <= '0';
				rdChr <= '0';
			when sendDashDotDashDot4 =>
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '0'; 
				sendDt <= '1';
				strtCnterChar <= '0';
				rdChr <= '0';
			when sendDashDotDashDash4 => 
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '1'; 
				sendDt <= '0';
				strtCnterChar <= '0';
				rdChr <= '0';
			when sendDashDashDotDot4 => 
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '0'; 
				sendDt <= '1';
				strtCnterChar <= '0';
				rdChr <= '0';
			when sendDashDashDotDash4 => 
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '1'; 
				sendDt <= '0';
				strtCnterChar <= '0';
				rdChr <= '0';
			when sendDashDashDashDot4 => 
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '0'; 
				sendDt <= '1';
				strtCnterChar <= '0';
				rdChr <= '0';
			when sendDashDashDashDash4 => 
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '1'; 
				sendDt <= '0';
				strtCnterChar <= '0';
				rdChr <= '0';
			when sendDotDotDotDotDot5 => 
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '0'; 
				sendDt <= '1';
				strtCnterChar <= '0';
				rdChr <= '0';
			when sendDotDotDotDotDash5 => 
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '1'; 
				sendDt <= '0';
				strtCnterChar <= '0';
				rdChr <= '0';
			when sendDotDotDotDashDash5 => 
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '1'; 
				sendDt <= '0';
				strtCnterChar <= '0';
				rdChr <= '0';
			when sendDotDotDashDashDash5 => 
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '1'; 
				sendDt <= '0';
				strtCnterChar <= '0';
				rdChr <= '0';
			when sendDashDotDotDotDot5 => 
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '0'; 
				sendDt <= '1';
				strtCnterChar <= '0';
				rdChr <= '0';
			when sendDashDashDotDotDot5 => 
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '0'; 
				sendDt <= '1';
				strtCnterChar <= '0';
				rdChr <= '0';
			when sendDashDashDashDotDot5 => 
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '0'; 
				sendDt <= '1';
				strtCnterChar <= '0';
				rdChr <= '0';
			when sendDotDashDashDashDash5 =>
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '1'; 
				sendDt <= '0';
				strtCnterChar <= '0';
				rdChr <= '0';
			when sendDashDashDashDashDot5 => 
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '0'; 
				sendDt <= '1';
				strtCnterChar <= '0';
				rdChr <= '0';
			when sendDashDashDashDashDash5 => 
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '1'; 
				sendDt <= '0';
				strtCnterChar <= '0';
				rdChr <= '0';
			-- CHAR SENT STATE MACHINE
			when waitWordChar =>
				morseOutChar <= '0';
				charSMActive <= '1';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '0';
				sendDt <= '0';
				strtCnterChar <= '1';
				rdChr <= '0';
			when waitWordCharSpacer =>
				charSMActive <= '1';
				unitNbChar <= to_unsigned(2*dotTime, unitNb'length);
				sendDs <= '0';
				sendDt <= '0';
				strtCnterChar <= '0';
				rdChr <= '0';
			when endOfChar =>
				morseOutChar <= '0';
				charSMActive <= '1';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '0';
				sendDt <= '0';
				strtCnterChar <= '1';
				rdChr <= '0';
			when sendSpacerWaitChar =>
				charSMActive <= '1';
				unitNbChar <= to_unsigned(2*dotTime, unitNb'length);
				sendDs <= '0';
				sendDt <= '0';
				strtCnterChar <= '0';
				rdChr <= '0';
			when getNextChar =>
				morseOutChar <= '0';
				charSMActive <= '1';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '0';
				sendDt <= '0';
				strtCnterChar <= '0';
				rdChr <= '1';
			when others =>
				morseOutChar <= '0';
				charSMActive <= '0';
				unitNbChar <= to_unsigned(0, unitNb'length);
				sendDs <= '0';
				sendDt <= '0';
				strtCnterChar <= '0';
				rdChr <= '0';
			end case;
	end process;
  
  --------------------------- END CHAR SENT STATE MACHINE ----------------------
  
  
  --------------------------- DOT SENT STATE MACHINE ---------------------------
	nxt_Dotstate : process(presentDot,sendDot, counterDone)
	BEGIN
		case presentDot is
			when waitStartDot =>
				if sendDot = '1' then 
					nextDot <= sendDotStart;
				else
					nextDot <= waitStartDot;
				end if;
			when sendDotStart =>
				nextDot <= sendDotWait;
			when sendDotWait =>
				if counterDone = '1' then
					nextDot <= sendDotSpacerStart;
				else
					nextDot <= sendDotWait;
				end if;
			when sendDotSpacerStart =>
				nextDot <= sendDotSpacerWait;
			when sendDotSpacerWait =>
				if counterDone = '1' then
					nextDot <= EndDot;
				else
					nextDot <= sendDotSpacerWait;
				end if;
			when endDot =>
				nextDot <= waitStartDot;
			when others =>
				nextDot <= waitStartDot; 
		end case;
	end process;
	
	state_Dot_reg : process(clock,reset)
	BEGIN
		if reset = '1' then
			presentDot <= waitStartDot;
			
		elsif rising_edge(clock) then
			presentDot <= nextDot;
		end if;
	end process;
	
	
	-- OUTPUT : morseOut, unitNb, dotSent,startCounter
	outputDot : process(presentDot)
	BEGIN
		case presentDot is
			when waitStartDot =>
				morseOutDot <= '0';
				dotSMActive <= '0';
				unitNbDot <= to_unsigned(0, unitNb'length);
				dotSent <= '0';
				strtCnterDot <= '0';
			when sendDotStart =>
				morseOutDot <= '0';
				dotSMActive <= '1';
				unitNbDot <= to_unsigned(0, unitNb'length);
				dotSent <= '0';
				strtCnterDot <= '1';
			when sendDotWait =>
				morseOutDot <= '1';
				dotSMActive <= '1';
				unitNbDot <= to_unsigned(dotTime, unitNb'length);
				dotSent <= '0';
				strtCnterDot <= '0';
			when sendDotSpacerStart =>
				morseOutDot <= '0';
				dotSMActive <= '1';
				unitNbDot <= to_unsigned(0, unitNb'length);
				dotSent <= '0';
				strtCnterDot <= '1';
			when sendDotSpacerWait =>
				morseOutDot <= '0';
				dotSMActive <= '1';
				unitNbDot <= to_unsigned(dotTime, unitNb'length);
				dotSent <= '0';
				strtCnterDot <= '0';
			when endDot =>
				morseOutDot <= '0';
				dotSMActive <= '1';
				unitNbDot <= to_unsigned(0, unitNb'length);
				dotSent <= '1';
				strtCnterDot <= '0';
				--sendDt <= '0';
			when others =>
				morseOutDot <= '0';
				dotSMActive <= '0';
				unitNbDot <= to_unsigned(0, unitNb'length);
				dotSent <= '0';
				strtCnterDot <= '0';
		end case;
	end process;
		
------------------------- END DOT SENT STATE MACHINE --------------------------		

--------------------------- DASH SENT STATE MACHINE ---------------------------
	nxt_Dashstate : process(presentDash,sendDash, counterDone)
	BEGIN
		case presentDash is
			when waitStartDash =>
				if sendDash = '1' then 
					nextDash <= sendDashStart;
				else
					nextDash <= waitStartDash;
				end if;
			when sendDashStart =>
				nextDash <= sendDashWait;
			when sendDashWait =>
				if counterDone = '1' then
					nextDash <= sendDashSpacerStart;
				else
					nextDash <= sendDashWait;
				end if;
			when sendDashSpacerStart =>
				nextDash <= sendDashSpacerWait;
			when sendDashSpacerWait =>
				if counterDone = '1' then
					nextDash <= EndDash;
				else
					nextDash <= sendDashSpacerWait;
				end if;
			when endDash =>
				nextDash <= waitStartDash;
			when others =>
				nextDash <= waitStartDash; 
		end case;
	end process;
	
	state_Dashreg : process(clock,reset)
		BEGIN
		if reset = '1' then
			presentDash <= waitStartDash;
		elsif rising_edge(clock) then
			presentDash <= nextDash;
		end if;
	end process;
	
	
	-- OUTPUT : morseOut, unitNb, dashSent,startCounter
	outputDash : process(presentDash)
	BEGIN
		case presentDash is
			when waitStartDash =>
				morseOutDash <= '0';
				dashSMActive <= '0';
				unitNbDash <= to_unsigned(0, unitNb'length);
				dashSent <= '0';
				strtCnterDash <= '0';
			when sendDashStart =>
				morseOutDash <= '0';
				dashSMActive <= '1';
				unitNbDash <= to_unsigned(0, unitNb'length);
				dashSent <= '0';
				strtCnterDash <= '1';
			when sendDashWait =>
				morseOutDash <= '1';
				dashSMActive <= '1';
				unitNbDash <= to_unsigned(3*dotTime, unitNb'length);
				dashSent <= '0';
				strtCnterDash <= '0';
			when sendDashSpacerStart =>
				morseOutDash <= '0';
				dashSMActive <= '1';
				unitNbDash <= to_unsigned(0, unitNb'length);
				dashSent <= '0';
				strtCnterDash <= '1';
			when sendDashSpacerWait =>
				morseOutDash <= '0';
				dashSMActive <= '1';
				unitNbDash <= to_unsigned(dotTime, unitNb'length);
				dashSent <= '0';
				strtCnterDash <= '0';
			when endDash =>
				morseOutDash <= '0';
				dashSMActive <= '1';
				unitNbDash <= to_unsigned(0, unitNb'length);
				dashSent <= '1';
				strtCnterDash <= '0';
				--sendDash <= '0';
			when others =>
				dashSMActive <= '0';
				morseOutDash <= '0';
				unitNbDash <=to_unsigned(0, unitNb'length);
				dashSent <= '0';
				strtCnterDash <= '0';
		end case;
	end process;
------------------------- END DASH SENT STATE MACHINE --------------------------			
			


  ------------------------------------------------------------------------------
                                                   -- conditions for morse units
  isA <= '1' when std_match(unsigned(char), "1-0" & x"1") else '0';
  isB <= '1' when std_match(unsigned(char), "1-0" & x"2") else '0';
  isC <= '1' when std_match(unsigned(char), "1-0" & x"3") else '0';
  isD <= '1' when std_match(unsigned(char), "1-0" & x"4") else '0';
  isE <= '1' when std_match(unsigned(char), "1-0" & x"5") else '0';
  isF <= '1' when std_match(unsigned(char), "1-0" & x"6") else '0';
  isG <= '1' when std_match(unsigned(char), "1-0" & x"7") else '0';
  isH <= '1' when std_match(unsigned(char), "1-0" & x"8") else '0';
  isI <= '1' when std_match(unsigned(char), "1-0" & x"9") else '0';
  isJ <= '1' when std_match(unsigned(char), "1-0" & x"A") else '0';
  isK <= '1' when std_match(unsigned(char), "1-0" & x"B") else '0';
  isL <= '1' when std_match(unsigned(char), "1-0" & x"C") else '0';
  isM <= '1' when std_match(unsigned(char), "1-0" & x"D") else '0';
  isN <= '1' when std_match(unsigned(char), "1-0" & x"E") else '0';
  isO <= '1' when std_match(unsigned(char), "1-0" & x"F") else '0';
  isP <= '1' when std_match(unsigned(char), "1-1" & x"0") else '0';
  isQ <= '1' when std_match(unsigned(char), "1-1" & x"1") else '0';
  isR <= '1' when std_match(unsigned(char), "1-1" & x"2") else '0';
  isS <= '1' when std_match(unsigned(char), "1-1" & x"3") else '0';
  isT <= '1' when std_match(unsigned(char), "1-1" & x"4") else '0';
  isU <= '1' when std_match(unsigned(char), "1-1" & x"5") else '0';
  isV <= '1' when std_match(unsigned(char), "1-1" & x"6") else '0';
  isW <= '1' when std_match(unsigned(char), "1-1" & x"7") else '0';
  isX <= '1' when std_match(unsigned(char), "1-1" & x"8") else '0';
  isY <= '1' when std_match(unsigned(char), "1-1" & x"9") else '0';
  isZ <= '1' when std_match(unsigned(char), "1-1" & x"A") else '0';
  is0 <= '1' when std_match(unsigned(char), "011" & x"0") else '0';
  is1 <= '1' when std_match(unsigned(char), "011" & x"1") else '0';
  is2 <= '1' when std_match(unsigned(char), "011" & x"2") else '0';
  is3 <= '1' when std_match(unsigned(char), "011" & x"3") else '0';
  is4 <= '1' when std_match(unsigned(char), "011" & x"4") else '0';
  is5 <= '1' when std_match(unsigned(char), "011" & x"5") else '0';
  is6 <= '1' when std_match(unsigned(char), "011" & x"6") else '0';
  is7 <= '1' when std_match(unsigned(char), "011" & x"7") else '0';
  is8 <= '1' when std_match(unsigned(char), "011" & x"8") else '0';
  is9 <= '1' when std_match(unsigned(char), "011" & x"9") else '0';
  
  sendDot <= sendDt;
  sendDash <= sendDs;
  
  morseOut <= morseOutDash when dashSMActive = '1' else morseOutDot when dotSMActive = '1' else morseOutChar when charSMActive = '1' else '0';
  startCounter <= strtCnterDot when dotSMActive = '1' else strtCnterDash when dashSMActive = '1' else strtCnterChar when charSMActive = '1' else '0';
  readChar <= rdChr;
  unitNb <= unitNbDot when dotSMActive = '1' else unitNbDash when dashSMActive = '1' else unitNbChar when charSMActive = '1' else to_unsigned(0, unitNb'length);

END ARCHITECTURE studentVersion;
