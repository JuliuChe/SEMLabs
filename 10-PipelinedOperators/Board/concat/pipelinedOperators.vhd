-- VHDL Entity Board.pipelineCounter_ebs3.symbol
--
-- Created:
--          by - axel.amand.UNKNOWN (WE7860)
--          at - 11:16:01 08.05.2023
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2019.2 (Build 5)
--
LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

ENTITY pipelineCounter_ebs3 IS
    GENERIC( 
        counterBitNb : positive := 16
    );
    PORT( 
        clock    : IN     std_ulogic;
        reset_n  : IN     std_ulogic;
        countOut : OUT    unsigned (counterBitNb-1 DOWNTO 0)
    );

-- Declarations

END pipelineCounter_ebs3 ;





-- VHDL Entity PipelinedOperators.pipelineCounter.symbol
--
-- Created:
--          by - francois.francois (Aphelia)
--          at - 08:50:00 03/11/19
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2019.2 (Build 5)
--
LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

ENTITY pipelineCounter IS
    GENERIC( 
        bitNb   : positive;
        stageNb : positive
    );
    PORT( 
        countOut : OUT    unsigned (bitNb-1 DOWNTO 0);
        clock    : IN     std_ulogic;
        reset    : IN     std_ulogic
    );

-- Declarations

END pipelineCounter ;





-- VHDL Entity PipelinedOperators.pipelineAdder.symbol
--
-- Created:
--          by - francois.francois (Aphelia)
--          at - 08:50:15 03/11/19
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2019.2 (Build 5)
--
LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

ENTITY pipelineAdder IS
    GENERIC( 
        bitNb   : positive;
        stageNb : positive
    );
    PORT( 
        sum   : OUT    signed (bitNb-1 DOWNTO 0);
        clock : IN     std_ulogic;
        reset : IN     std_ulogic;
        cIn   : IN     std_ulogic;
        cOut  : OUT    std_ulogic;
        a     : IN     signed (bitNb-1 DOWNTO 0);
        b     : IN     signed (bitNb-1 DOWNTO 0)
    );

-- Declarations

END pipelineAdder ;





-- VHDL Entity PipelinedOperators.parallelAdder.symbol
--
-- Created:
--          by - axel.amand.UNKNOWN (WE7860)
--          at - 11:43:49 28.04.2023
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2019.2 (Build 5)
--
LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

ENTITY parallelAdder IS
    GENERIC( 
        bitNb : positive := 32
    );
    PORT( 
        sum  : OUT    signed (bitNb-1 DOWNTO 0);
        cIn  : IN     std_ulogic;
        cOut : OUT    std_ulogic;
        a    : IN     signed (bitNb-1 DOWNTO 0);
        b    : IN     signed (bitNb-1 DOWNTO 0)
    );

-- Declarations

END parallelAdder ;





ARCHITECTURE masterVersion OF parallelAdder IS

  signal sum_int: unsigned(sum'high+1 downto 0);

BEGIN

  sum_int <= resize(unsigned(a), sum_int'length) +
             resize(unsigned(b), sum_int'length) +
             resize('0' & cIn, sum_int'length);

  sum <= signed(sum_int(sum'range));
  cOut <= sum_int(sum_int'high);

END ARCHITECTURE masterVersion;





ARCHITECTURE masterVersion OF pipelineAdder IS

  constant stageBitNb : positive := sum'length/stageNb;
  subtype stageOperandType is signed(stageBitNb-1 downto 0);
  type stageOperandVectorType is array(stageNb-1 downto 0) of stageOperandType;
  type stageOperandMatrixType is array(stageNb-1 downto 0) of stageOperandVectorType;
  subtype carryType is std_ulogic_vector(stageNb downto 0);

  signal a_int, b_int, sum_int : stageOperandMatrixType;
  signal carryIn, carryOut : carryType;

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

  carryIn(0) <= cIn;

  distributeInput: for wordIndex in stageOperandVectorType'range generate
    a_int(wordIndex)(0) <= a(wordIndex*stageBitNb+stageBitNb-1 downto wordIndex*stageBitNb);
    b_int(wordIndex)(0) <= b(wordIndex*stageBitNb+stageBitNb-1 downto wordIndex*stageBitNb);
  end generate distributeInput;

  inputRegistersX: for wordIndex in stageOperandVectorType'high downto 1 generate
    inputRegistersY: for pipeIndex in stageOperandMatrixType'high downto 1 generate
      upperTriangle: if wordIndex >= pipeIndex generate
        inputRegisters: process(reset, clock)
        begin
          if reset = '1' then
            a_int(wordIndex)(pipeIndex) <= (others => '0');
            b_int(wordIndex)(pipeIndex) <= (others => '0');
          elsif rising_edge(clock) then
            a_int(wordIndex)(pipeIndex) <= a_int(wordIndex)(pipeIndex-1);
            b_int(wordIndex)(pipeIndex) <= b_int(wordIndex)(pipeIndex-1);
          end if;
        end process inputRegisters;
      end generate upperTriangle;
    end generate inputRegistersY;
  end generate inputRegistersX;

  operation: for index in stageOperandVectorType'range generate
    partialAdder: parallelAdder
      GENERIC MAP (bitNb => stageBitNb)
      PORT MAP (
         a    => a_int(index)(index),
         b    => b_int(index)(index),
         sum  => sum_int(index)(index),
         cIn  => carryIn(index),
         cOut => carryOut(index)
      );
      carryRegisters: process(reset, clock)
      begin
        if reset = '1' then
          carryIn(index+1) <= '0';
        elsif rising_edge(clock) then
          carryIn(index+1) <= carryOut(index);
        end if;
      end process carryRegisters;
  end generate operation;

  outputRegistersX: for wordIndex in stageOperandVectorType'range generate
    outputRegistersY: for pipeIndex in stageOperandMatrixType'range generate
      lowerTriangle: if wordIndex < pipeIndex generate
        outputRegisters: process(reset, clock)
        begin
          if reset = '1' then
            sum_int(wordIndex)(pipeIndex) <= (others => '0');
          elsif rising_edge(clock) then
            sum_int(wordIndex)(pipeIndex) <= sum_int(wordIndex)(pipeIndex-1);
          end if;
        end process outputRegisters;
      end generate lowerTriangle;
    end generate outputRegistersY;
  end generate outputRegistersX;

  packOutput: for index in stageOperandVectorType'range generate
    sum(index*stageBitNb+stageBitNb-1 downto index*stageBitNb) <=
      sum_int(index)(stageOperandMatrixType'high);
  end generate packOutput;

  cOut <= carryOut(carryOut'high-1);

END ARCHITECTURE masterVersion;




ARCHITECTURE masterVersion OF pipelineCounter IS

  signal initCounter : unsigned(countOut'length/stageNb-1 downto 0);
  signal b : signed(countOut'range);
  signal sum : signed(countOut'range);

  COMPONENT pipelineAdder
  GENERIC (
    bitNb   : positive := 32;
    stageNb : positive := 4
  );
  PORT (
    reset : IN     std_ulogic;
    clock : IN     std_ulogic;
    cIn   : IN     std_ulogic;
    a     : IN     signed (bitNb-1 DOWNTO 0);
    b     : IN     signed (bitNb-1 DOWNTO 0);
    sum   : OUT    signed (bitNb-1 DOWNTO 0);
    cOut  : OUT    std_ulogic
  );
  END COMPONENT;

BEGIN

  adder: pipelineAdder
    GENERIC MAP (
      bitNb => countOut'length,
      stageNb => stageNb
      )
    PORT MAP (
       reset => reset,
       clock => clock,
       cIn   => '0',
       a     => sum,
       b     => b,
       sum   => sum,
       cOut  => open
    );

  prepareBInput: process(reset, clock)
  begin
    if reset = '1' then
      initCounter <= (others => '0');
    elsif rising_edge(clock) then
      if initCounter < stageNb then
        initCounter <= initCounter + 1;
      end if;
    end if;
  end process prepareBInput;

  selectInitOrRun: process(initCounter, sum)
  begin
    if initCounter < stageNb-1 then
      b <= signed(resize(initCounter+stageNb-1, b'length));
      countOut <= resize(initCounter, countOut'length);
    else
      b <= to_signed(stageNb-1, b'length);
      countOut <= unsigned(sum);
    end if;
  end process selectInitOrRun;

END ARCHITECTURE masterVersion;




-- VHDL Entity Board.DFF.symbol
--
-- Created:
--          by - francois.francois (Aphelia)
--          at - 13:07:05 02/19/19
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2019.2 (Build 5)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY DFF IS
    PORT( 
        CLK : IN     std_uLogic;
        CLR : IN     std_uLogic;
        D   : IN     std_uLogic;
        Q   : OUT    std_uLogic
    );

-- Declarations

END DFF ;





ARCHITECTURE sim OF DFF IS
BEGIN

  process(clk, clr)
  begin
    if clr = '1' then
      q <= '0';
    elsif rising_edge(clk) then
      q <= d;
    end if;
  end process;

END ARCHITECTURE sim;





-- VHDL Entity Board.inverterIn.symbol
--
-- Created:
--          by - francois.francois (Aphelia)
--          at - 13:07:14 02/19/19
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2019.2 (Build 5)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY inverterIn IS
    PORT( 
        in1  : IN     std_uLogic;
        out1 : OUT    std_uLogic
    );

-- Declarations

END inverterIn ;





ARCHITECTURE sim OF inverterIn IS
BEGIN

  out1 <= NOT in1;

END ARCHITECTURE sim;





-- VHDL netlist generated by SCUBA Diamond (64-bit) 3.12.1.454
-- Module  Version: 5.7
--C:\lscc\diamond\3.12\ispfpga\bin\nt64\scuba.exe -w -n pll -lang vhdl -synth synplify -bus_exp 7 -bb -arch sa5p00 -type pll -fin 100.00 -fclkop 60 -fclkop_tol 10.0 -fclkos 75 -fclkos_tol 10.0 -phases 0 -fclkos2 50 -fclkos2_tol 10.0 -phases2 0 -fclkos3 10 -fclkos3_tol 10.0 -phases3 0 -phase_cntl STATIC -enable_s -enable_s2 -enable_s3 -pllLocked -fb_mode 1 -fdc C:/temp/clocker/pll/pll.fdc 

-- Offers 10MHz, 50MHz, 60MHz and 75MHz clocks

library IEEE;
  use IEEE.std_logic_1164.all;
library ECP5U;
  use ECP5U.components.all;

ENTITY pll IS
    PORT( 
        clkIn100M : IN     std_ulogic;
        en75M     : IN     std_ulogic;
        en50M     : IN     std_ulogic;
        en10M     : IN     std_ulogic;
        clk60MHz  : OUT    std_ulogic;
        clk75MHz  : OUT    std_ulogic;
        clk50MHz  : OUT    std_ulogic;
        clk10MHz  : OUT    std_ulogic;
        pllLocked : OUT    std_ulogic
    );

-- Declarations

END pll ;

architecture rtl of pll is

    -- internal signal declarations
    signal REFCLK: std_logic;
    signal CLKOS3_t: std_logic;
    signal CLKOS2_t: std_logic;
    signal CLKOS_t: std_logic;
    signal CLKOP_t: std_logic;
    signal scuba_vhi: std_logic;
    signal scuba_vlo: std_logic;

    attribute FREQUENCY_PIN_CLKOS3 : string; 
    attribute FREQUENCY_PIN_CLKOS2 : string; 
    attribute FREQUENCY_PIN_CLKOS : string; 
    attribute FREQUENCY_PIN_CLKOP : string; 
    attribute FREQUENCY_PIN_CLKI : string; 
    attribute ICP_CURRENT : string; 
    attribute LPF_RESISTOR : string; 
    attribute FREQUENCY_PIN_CLKOS3 of PLLInst_0 : label is "10.000000";
    attribute FREQUENCY_PIN_CLKOS2 of PLLInst_0 : label is "50.000000";
    attribute FREQUENCY_PIN_CLKOS of PLLInst_0 : label is "75.000000";
    attribute FREQUENCY_PIN_CLKOP of PLLInst_0 : label is "60.000000";
    attribute FREQUENCY_PIN_CLKI of PLLInst_0 : label is "100.000000";
    attribute ICP_CURRENT of PLLInst_0 : label is "5";
    attribute LPF_RESISTOR of PLLInst_0 : label is "16";
    attribute syn_keep : boolean;
    attribute NGD_DRC_MASK : integer;
    attribute NGD_DRC_MASK of rtl : architecture is 1;

begin
    -- component instantiation statements
    scuba_vhi_inst: VHI
        port map (Z=>scuba_vhi);

    scuba_vlo_inst: VLO
        port map (Z=>scuba_vlo);

    PLLInst_0: EHXPLLL
        generic map (PLLRST_ENA=> "DISABLED", INTFB_WAKE=> "DISABLED", 
        STDBY_ENABLE=> "DISABLED", DPHASE_SOURCE=> "DISABLED", 
        CLKOS3_FPHASE=>  0, CLKOS3_CPHASE=>  59, CLKOS2_FPHASE=>  0, 
        CLKOS2_CPHASE=>  11, CLKOS_FPHASE=>  0, CLKOS_CPHASE=>  7, 
        CLKOP_FPHASE=>  0, CLKOP_CPHASE=>  9, PLL_LOCK_MODE=>  0, 
        CLKOS_TRIM_DELAY=>  0, CLKOS_TRIM_POL=> "FALLING", 
        CLKOP_TRIM_DELAY=>  0, CLKOP_TRIM_POL=> "FALLING", 
        OUTDIVIDER_MUXD=> "DIVD", CLKOS3_ENABLE=> "DISABLED", 
        OUTDIVIDER_MUXC=> "DIVC", CLKOS2_ENABLE=> "DISABLED", 
        OUTDIVIDER_MUXB=> "DIVB", CLKOS_ENABLE=> "DISABLED", 
        OUTDIVIDER_MUXA=> "DIVA", CLKOP_ENABLE=> "ENABLED", CLKOS3_DIV=>  60, 
        CLKOS2_DIV=>  12, CLKOS_DIV=>  8, CLKOP_DIV=>  10, CLKFB_DIV=>  3, 
        CLKI_DIV=>  5, FEEDBK_PATH=> "CLKOP")
        port map (CLKI=>clkIn100M, CLKFB=>CLKOP_t, PHASESEL1=>scuba_vlo, 
            PHASESEL0=>scuba_vlo, PHASEDIR=>scuba_vlo, 
            PHASESTEP=>scuba_vlo, PHASELOADREG=>scuba_vlo, 
            STDBY=>scuba_vlo, PLLWAKESYNC=>scuba_vlo, RST=>scuba_vlo, 
            ENCLKOP=>scuba_vlo, ENCLKOS=>en75M, ENCLKOS2=>en50M, 
            ENCLKOS3=>en10M, CLKOP=>CLKOP_t, CLKOS=>CLKOS_t, 
            CLKOS2=>CLKOS2_t, CLKOS3=>CLKOS3_t, LOCK=>pllLocked, 
            INTLOCK=>open, REFCLK=>REFCLK, CLKINTFB=>open);

    clk10MHz <= CLKOS3_t;
    clk50MHz <= CLKOS2_t;
    clk75MHz <= CLKOS_t;
    clk60MHz <= CLKOP_t;
end rtl;




--
-- VHDL Architecture Board.pipelineCounter_ebs3.struct
--
-- Created:
--          by - axel.amand.UNKNOWN (WE7860)
--          at - 11:16:01 08.05.2023
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2019.2 (Build 5)
--
LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

-- LIBRARY Board;
-- LIBRARY Lattice;
-- LIBRARY PipelinedOperators;

ARCHITECTURE struct OF pipelineCounter_ebs3 IS

    -- Architecture declarations
    constant pipelineStageNb: positive := 5;

    -- Internal signal declarations
    SIGNAL clk_sys      : std_ulogic;
    SIGNAL logic0       : std_ulogic;
    SIGNAL logic1       : std_uLogic;
    SIGNAL reset        : std_ulogic;
    SIGNAL resetSynch   : std_ulogic;
    SIGNAL resetSynch_n : std_ulogic;


    -- Component Declarations
    COMPONENT DFF
    PORT (
        CLK : IN     std_uLogic ;
        CLR : IN     std_uLogic ;
        D   : IN     std_uLogic ;
        Q   : OUT    std_uLogic 
    );
    END COMPONENT;
    COMPONENT inverterIn
    PORT (
        in1  : IN     std_uLogic ;
        out1 : OUT    std_uLogic 
    );
    END COMPONENT;
    COMPONENT pll
    PORT (
        clkIn100M : IN     std_ulogic ;
        en75M     : IN     std_ulogic ;
        en50M     : IN     std_ulogic ;
        en10M     : IN     std_ulogic ;
        clk60MHz  : OUT    std_ulogic ;
        clk75MHz  : OUT    std_ulogic ;
        clk50MHz  : OUT    std_ulogic ;
        clk10MHz  : OUT    std_ulogic ;
        pllLocked : OUT    std_ulogic 
    );
    END COMPONENT;
    COMPONENT pipelineCounter
    GENERIC (
        bitNb   : positive;
        stageNb : positive
    );
    PORT (
        countOut : OUT    unsigned (bitNb-1 DOWNTO 0);
        clock    : IN     std_ulogic ;
        reset    : IN     std_ulogic 
    );
    END COMPONENT;

    -- Optional embedded configurations
    -- pragma synthesis_off
--     FOR ALL : DFF USE ENTITY Board.DFF;
--     FOR ALL : inverterIn USE ENTITY Board.inverterIn;
--     FOR ALL : pipelineCounter USE ENTITY PipelinedOperators.pipelineCounter;
--     FOR ALL : pll USE ENTITY Lattice.pll;
    -- pragma synthesis_on


BEGIN
    -- Architecture concurrent statements
    -- HDL Embedded Text Block 5 eb5
    logic1 <= '1';

    -- HDL Embedded Text Block 6 eb6
    logic0 <= '0';


    -- Instance port mappings.
    I_dff : DFF
        PORT MAP (
            CLK => clock,
            CLR => reset,
            D   => logic1,
            Q   => resetSynch_n
        );
    I_inv1 : inverterIn
        PORT MAP (
            in1  => reset_n,
            out1 => reset
        );
    I_inv2 : inverterIn
        PORT MAP (
            in1  => resetSynch_n,
            out1 => resetSynch
        );
    I_pll : pll
        PORT MAP (
            clkIn100M => clock,
            en75M     => logic0,
            en50M     => logic0,
            en10M     => logic0,
            clk60MHz  => clk_sys,
            clk75MHz  => OPEN,
            clk50MHz  => OPEN,
            clk10MHz  => OPEN,
            pllLocked => OPEN
        );
    I_cnt : pipelineCounter
        GENERIC MAP (
            bitNb   => counterBitNb,
            stageNb => pipelineStageNb
        )
        PORT MAP (
            countOut => countOut,
            clock    => clk_sys,
            reset    => resetSynch
        );

END struct;




