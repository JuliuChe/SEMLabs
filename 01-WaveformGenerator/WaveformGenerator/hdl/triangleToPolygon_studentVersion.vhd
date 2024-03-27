ARCHITECTURE studentVersion OF triangleToPolygon IS
signal biggerTriangle: unsigned(bitNb downto 0); 
signal futurePolygone: unsigned(bitNb downto 0);
constant minVal : positive := 2**((bitNb + 1) - 3);  
constant maxVal : positive := 5 * minVal - 1;  

BEGIN

  triangle_1_5 : process(triangle)
  begin
    biggerTriangle <= resize(triangle, bitNb+1) + resize((triangle srl 1), bitNb+1);
  end process triangle_1_5; 
	
  triangleToPolygon: process(biggerTriangle)
  begin 
    if biggerTriangle < minVal then -- inferieur 1/8
      futurePolygone <=  to_unsigned(minVal, bitNb+1);
    elsif biggerTriangle >= maxVal then -- supperieur 5/8
      futurePolygone <= to_unsigned(maxVal, bitNb+1);
    else -- on est entre les deux
      futurePolygone <= (biggerTriangle);
    end if;
  end process triangleToPolygon;
  
  polygon <= futurePolygone(bitNb-1 downto 0) - minVal;
  --polygon <= (others => '0');
END ARCHITECTURE studentVersion;
