ARCHITECTURE studentVersion OF offsetToUnsigned IS

signal transformUnsigned : unsigned(bitNb+1-1 downto 0);

BEGIN
  process(signedIn)
    begin
    transformUnsigned <= resize(unsigned(signedIn), transformUnsigned'length) + 2**(signedIn'length-1);
  
  end process;
  
  unsignedOut <= resize(transformUnsigned, unsignedOut'length);
  
END ARCHITECTURE studentVersion;
