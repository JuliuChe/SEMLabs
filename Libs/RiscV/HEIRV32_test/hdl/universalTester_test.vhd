LIBRARY std;
  USE std.textio.ALL;

LIBRARY ieee;
  USE ieee.std_logic_textio.ALL;

LIBRARY Common_test;
  USE Common_test.testutils.all;

ARCHITECTURE test OF universalTester IS

  constant clockPeriod  : time := 1.0/66E6 * 1 sec;
  signal sClock         : std_uLogic := '1';
  signal sReset         : std_uLogic ;

  signal testInfo       : string(1 to 40) := (others => ' ');

BEGIN

 ------------------------------------------------------------------------------
                                                              -- reset and clock
  sReset <= '1', '0' after 3.5*clockPeriod;
  rst <= sReset;

  sClock <= not sClock after clockPeriod/2;
  clk <= transport sClock after 0.9*clockPeriod;

  btns <= (others => '1'), (others=>'0') after 4.15 us;

  process
    -- Wait list
    -- 3 clk for beq
    -- 4 clk for others
    -- 5 clk for lw
  begin
    en <= '0';

    testInfo <= pad("Wait reset", testInfo'length);
    wait until rst = '0';

    while true loop
      en <= '1';

      testInfo <= pad("Running", testInfo'length);
      wait;

    end loop;
  end process;

END ARCHITECTURE test;

