/*ARCHITECTURE studentVersion OF resizer IS
BEGIN
  resizeProcess: process(resizeIn)
  if inputBitNb < outputBitNb generate
  begin
	resizeOut(outputBitNb-1 downto (outputBitNb - inputBitNb)) <= resizeIn;
	resizeOut((outputBitNb - inputBitNb - 1) DOWNTO 0) <= (others => '0');
  elsif inputBitNb = outputBitNb then
	resizeOut <= resizeIn;
  else 
	resizeOut <= resizeIn((inputBitNb-1) downto inputBitNb-outputBitNb);
  end process resizeProcess;
  end generate;
  --resizeOut <= (others => '0');
END ARCHITECTURE studentVersion;
*/

--------------------------------------------------------------------------------
ARCHITECTURE studentVersion OF resizer IS
BEGIN
lessOrEqual: if inputBitNb<=outputBitNb generate
	process(resizeIn)
	begin
  resizeOut<=(resize(resizeIn,outputBitNb) sll (outputBitNb-inputBitNb));
 end process;
end generate lessOrEqual;

greaterThan: if inputBitNb>outputBitNb generate
	process(resizeIn)
	begin
	resizeOut<=resizeIn((inputBitNb-1) downto inputBitNb-outputBitNb);
	end process;
end generate greaterThan;
END ARCHITECTURE studentVersion;
--------------------------------------------------------------------------------