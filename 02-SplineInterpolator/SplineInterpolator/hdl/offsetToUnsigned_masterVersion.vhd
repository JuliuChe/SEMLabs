ARCHITECTURE masterVersion OF offsetToUnsigned IS

BEGIN

  unsignedOut <= not(signedIn(signedIn'high)) & unsigned(signedIn(signedIn'high-1 downto 0));

END ARCHITECTURE masterVersion;
