--
-- VHDL Architecture PipelinedOperators_test.PipelineCounter_tester.test
--
-- Created:
--          by - zas.UNKNOWN (ZELL)
--          at - 16:00:38 02/20/2020
--
-- using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
--
ARCHITECTURE test OF PipelineCounter_tester IS

  constant clockFrequency: real := 66.0E6;
  constant clockPeriod: time := (1.0/clockFrequency) * 1 sec;
  signal sClock: std_uLogic := '1';

BEGIN
  ------------------------------------------------------------------------------
                                                              -- clock and reset
  sClock <= not sClock after clockPeriod/2;
  clock <= transport sClock after clockPeriod*9/10;
  reset <= '1', '0' after 2*clockPeriod;

END ARCHITECTURE test;

