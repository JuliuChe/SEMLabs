ARCHITECTURE noPipe OF pipelineAdder IS

  constant stageBitNb : positive := sum'length/stageNb;
  subtype stageOperandType is signed(stageBitNb-1 downto 0);
  type stageOperandArrayType is array(stageNb-1 downto 0, stageNb-1 downto 0) of stageOperandType;
  subtype carryType is std_ulogic_vector(stageNb downto 0);

  signal a_int, b_int, sum_int : stageOperandArrayType;
  signal carryIn, carryOut, carryIn2 : carryType;

  COMPONENT parallelAdder
  GENERIC (
    bitNb : positive := 32
  );
  PORT (
    sum  : OUT    signed (bitNb-1 DOWNTO 0);
    cIn  : IN     std_ulogic ;
    cOut : OUT    std_ulogic ;
    a    : IN     signed (bitNb-1 DOWNTO 0);
    b    : IN     signed (bitNb-1 DOWNTO 0)
  );
  END COMPONENT;

BEGIN

    --carryIn(0) <= cIn;
	input_process : process(a, b)
	begin
		for index in stageOperandArrayType'range loop 
			a_int(index,0) <= a(index*stageBitNb+stageBitNb-1 downto index*stageBitNb);
			b_int(index,0) <= b(index*stageBitNb+stageBitNb-1 downto index*stageBitNb);
		end loop; 
	end process;

	process(clock, reset) 
	begin 
		if reset = '1' then
			for index1 in stageOperandArrayType'range  loop
				for index2 in 1 to stageOperandArrayType'high  loop
					a_int(index1,index2) <= (others => '0'); 
					b_int(index1,index2) <= (others => '0');
				end loop;
			end loop;
		elsif rising_edge(clock) then
			for index1 in stageOperandArrayType'range  loop
				for index2 in 1 to stageOperandArrayType'high  loop
					if(index2 <= index1) then
						a_int(index1,index2) <= a_int(index1,index2-1); 
						b_int(index1,index2) <= b_int(index1,index2-1);
					end if;			
				end loop;
			end loop;
		end if;
    end process; 
	
	pipeline: for index in stageOperandArrayType'range generate
	partialAdder: parallelAdder
	  GENERIC MAP (bitNb => stageBitNb)
	  PORT MAP (
		 a    => a_int(index,index),
		 b    => b_int(index,index),
		 sum  => sum_int(index,index),
		 cIn  => carryIn(index),
		 cOut => carryOut(index)
	  );
	sum(index*stageBitNb+stageBitNb-1 downto index*stageBitNb) <= sum_int(index, stageOperandArrayType'length-1);
  end generate pipeline;


	
	
	process(clock, reset)
	begin
		if reset = '1' then
		for index1 in stageOperandArrayType'range  loop
			if (index1 > 0) then
				carryIn2(index1)<='0';
			else
				carryIn2(index1)<= cIn;
			
			end if;
			for index2 in 1 to stageOperandArrayType'high  loop
				if (index2 > index1) then
					sum_int(index1,index2) <= (others => '0');
				end if;
			end loop;
		end loop;
		elsif rising_edge(clock) then
			for index1 in stageOperandArrayType'range  loop
			carryIn2(index1+1)<=carryOut(Index1);
				for index2 in 1 to stageOperandArrayType'high  loop
					if (index2 > index1) then
						sum_int(index1,index2) <= sum_int(index1,index2-1);
					end if;
				end loop;
			end loop;
		end if;
	end process;
	
	carryIn <= carryIn2;
  cOut <= carryOut(carryIn'high);

END ARCHITECTURE noPipe;
