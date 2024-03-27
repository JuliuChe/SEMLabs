
ARCHITECTURE rtl OF instructionForwarder IS
    signal lvec_irMem : std_ulogic_vector(readData'range);
BEGIN

--    forwardIR : process(rst, clk)
--    begin
--        if rst = '1' then
--            lvec_irMem <= (others => '0');
--        elsif rising_edge(clk) then
--            if en = '1' and IRWrite = '1' then
--                lvec_irMem <= readData;
--            end if;
--        end if;
--    end process forwardIR;

    forwardIR : process(readData, irWrite)
    begin
        if irWrite = '1' then
            lvec_irMem <= readData;
        end if;
    end process forwardIR;

    instruction <= lvec_irMem;

END ARCHITECTURE rtl;
