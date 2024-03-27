ARCHITECTURE masterVersion OF sawtoothToSquare IS
BEGIN

  square <= (others => sawtooth(sawtooth'high));

END ARCHITECTURE masterVersion;
