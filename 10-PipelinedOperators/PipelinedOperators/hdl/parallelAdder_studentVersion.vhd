ARCHITECTURE studentVersion OF parallelAdder IS

signal sumInt: unsigned(a'high+1 downto 0);

BEGIN

	sumInt <= resize(unsigned(a), sumInt'length)  
			+ resize(unsigned(b), sumInt'length) 
			+ resize('0' & cIn, sumInt'length);
	
	sum <= signed(sumInt(sumInt'high-1 downto 0));
	cOut <= sumInt(sumInt'high);

END ARCHITECTURE studentVersion;
