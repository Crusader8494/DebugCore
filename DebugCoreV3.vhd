----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/23/2020 05:23:27 PM
-- Design Name: 
-- Module Name: DebugCore - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DebugCore is
    Port ( CLK100MHz : in STD_LOGIC;
           RESET : in STD_LOGIC;
           RESET_OUT : out STD_LOGIC := '0';
           
           Transmit_WR_EN : out STD_LOGIC := '0';
           Transmit_WRD   : out STD_LOGIC_VECTOR (7 downto 0) := x"00";
           
           Receive_WR_EN  : out STD_LOGIC := '0';
           Receive_WRD    : in  STD_LOGIC_VECTOR (7 downto 0);
           
           Transmit_AF : in STD_LOGIC;
           Transmit_FU : in STD_LOGIC;
           
           Receieve_AE : in STD_LOGIC;
           Receieve_EM : in STD_LOGIC;
                                      
           State_MM : in STD_LOGIC;
           State_RM : in STD_LOGIC;
           State_RC : in STD_LOGIC;
           
           MON0 : in  STD_LOGIC_VECTOR (15 downto 0);
           MON1 : in  STD_LOGIC_VECTOR (15 downto 0);
           MON2 : in  STD_LOGIC_VECTOR (15 downto 0);
           MON3 : in  STD_LOGIC_VECTOR (15 downto 0);
           MON4 : in  STD_LOGIC_VECTOR (15 downto 0);
           MON5 : in  STD_LOGIC_VECTOR (15 downto 0);
           MON6 : in  STD_LOGIC_VECTOR (15 downto 0);
           MON7 : in  STD_LOGIC_VECTOR (15 downto 0);
           
           REG0 : out STD_LOGIC_VECTOR (15 downto 0) := x"0000";
           REG1 : out STD_LOGIC_VECTOR (15 downto 0) := x"0000";
           REG2 : out STD_LOGIC_VECTOR (15 downto 0) := x"0000";
           REG3 : out STD_LOGIC_VECTOR (15 downto 0) := x"0000";
           REG4 : out STD_LOGIC_VECTOR (15 downto 0) := x"0000";
           REG5 : out STD_LOGIC_VECTOR (15 downto 0) := x"0000";
           REG6 : out STD_LOGIC_VECTOR (15 downto 0) := x"0000";
           REG7 : out STD_LOGIC_VECTOR (15 downto 0) := x"0000"

           );
end DebugCore;

architecture Behavioral of DebugCore is

    Constant ESC                  : STD_LOGIC_VECTOR (7 downto 0) := "00011011";
    Constant SHIFT_1               : STD_LOGIC_VECTOR (7 downto 0) := "00100001";
    Constant SHIFT_2               : STD_LOGIC_VECTOR (7 downto 0) := "01000000";
    Constant SHIFT_3               : STD_LOGIC_VECTOR (7 downto 0) := "00100011";
    
    Constant Carriage_Return      : STD_LOGIC_VECTOR (7 downto 0) := "00001101";
    Constant Equals_Sign          : STD_LOGIC_VECTOR (7 downto 0) := "00111101";
    Constant Right_Carrot         : STD_LOGIC_VECTOR (7 downto 0) := "00111110";
    Constant Space                : STD_LOGIC_VECTOR (7 downto 0) := "00100000";
    
    Constant Letter_A             : STD_LOGIC_VECTOR (7 downto 0) := "01000001";
    Constant Letter_B             : STD_LOGIC_VECTOR (7 downto 0) := "01000010";
    Constant Letter_C             : STD_LOGIC_VECTOR (7 downto 0) := "01000011";
    Constant Letter_D             : STD_LOGIC_VECTOR (7 downto 0) := "01000100";
    Constant Letter_E             : STD_LOGIC_VECTOR (7 downto 0) := "01000101";
    Constant Letter_F             : STD_LOGIC_VECTOR (7 downto 0) := "01000110";
    Constant Letter_G             : STD_LOGIC_VECTOR (7 downto 0) := "01000111";
    Constant Letter_H             : STD_LOGIC_VECTOR (7 downto 0) := "01001000";
    Constant Letter_I             : STD_LOGIC_VECTOR (7 downto 0) := "01001001";
    Constant Letter_J             : STD_LOGIC_VECTOR (7 downto 0) := "01001010";
    Constant Letter_K             : STD_LOGIC_VECTOR (7 downto 0) := "01001011";
    Constant Letter_L             : STD_LOGIC_VECTOR (7 downto 0) := "01001100";
    Constant Letter_M             : STD_LOGIC_VECTOR (7 downto 0) := "01001101";
    Constant Letter_N             : STD_LOGIC_VECTOR (7 downto 0) := "01001110";
    Constant Letter_O             : STD_LOGIC_VECTOR (7 downto 0) := "01001111";
    Constant Letter_P             : STD_LOGIC_VECTOR (7 downto 0) := "01010000";
    Constant Letter_Q             : STD_LOGIC_VECTOR (7 downto 0) := "01010001";
    Constant Letter_R             : STD_LOGIC_VECTOR (7 downto 0) := "01010010";
    Constant Letter_S             : STD_LOGIC_VECTOR (7 downto 0) := "01010011";
    Constant Letter_T             : STD_LOGIC_VECTOR (7 downto 0) := "01010100";
    Constant Letter_U             : STD_LOGIC_VECTOR (7 downto 0) := "01010101";
    Constant Letter_V             : STD_LOGIC_VECTOR (7 downto 0) := "01010110";
    Constant Letter_W             : STD_LOGIC_VECTOR (7 downto 0) := "01010111";
    Constant Letter_X             : STD_LOGIC_VECTOR (7 downto 0) := "01011000";
    Constant Letter_Y             : STD_LOGIC_VECTOR (7 downto 0) := "01011001";
    Constant Letter_Z             : STD_LOGIC_VECTOR (7 downto 0) := "01011010";
    
    Constant Letter_a1            : STD_LOGIC_VECTOR (7 downto 0) := "01100001";
    Constant Letter_b1            : STD_LOGIC_VECTOR (7 downto 0) := "01100010";
    Constant Letter_c1            : STD_LOGIC_VECTOR (7 downto 0) := "01100011";
    Constant Letter_d1            : STD_LOGIC_VECTOR (7 downto 0) := "01100100";
    Constant Letter_e1            : STD_LOGIC_VECTOR (7 downto 0) := "01100101";
    Constant Letter_f1            : STD_LOGIC_VECTOR (7 downto 0) := "01100110";
    Constant Letter_g1            : STD_LOGIC_VECTOR (7 downto 0) := "01100111";
    Constant Letter_h1            : STD_LOGIC_VECTOR (7 downto 0) := "01101000";
    Constant Letter_i1            : STD_LOGIC_VECTOR (7 downto 0) := "01101001";
    Constant Letter_j1            : STD_LOGIC_VECTOR (7 downto 0) := "01101010";
    Constant Letter_k1            : STD_LOGIC_VECTOR (7 downto 0) := "01101011";
    Constant Letter_l1            : STD_LOGIC_VECTOR (7 downto 0) := "01101100";
    Constant Letter_m1            : STD_LOGIC_VECTOR (7 downto 0) := "01101101";
    Constant Letter_n1            : STD_LOGIC_VECTOR (7 downto 0) := "01101110";
    Constant Letter_o1            : STD_LOGIC_VECTOR (7 downto 0) := "01101111";
    Constant Letter_p1            : STD_LOGIC_VECTOR (7 downto 0) := "01110000";
    Constant Letter_q1            : STD_LOGIC_VECTOR (7 downto 0) := "01110001";
    Constant Letter_r1            : STD_LOGIC_VECTOR (7 downto 0) := "01110010";
    Constant Letter_s1            : STD_LOGIC_VECTOR (7 downto 0) := "01110011";
    Constant Letter_t1            : STD_LOGIC_VECTOR (7 downto 0) := "01110100";
    Constant Letter_u1            : STD_LOGIC_VECTOR (7 downto 0) := "01110101";
    Constant Letter_v1            : STD_LOGIC_VECTOR (7 downto 0) := "01110110";
    Constant Letter_w1            : STD_LOGIC_VECTOR (7 downto 0) := "01110111";
    Constant Letter_x1            : STD_LOGIC_VECTOR (7 downto 0) := "01111000";
    Constant Letter_y1            : STD_LOGIC_VECTOR (7 downto 0) := "01111001";
    Constant Letter_z1            : STD_LOGIC_VECTOR (7 downto 0) := "01111010";
    
    Constant Zero       : STD_LOGIC_VECTOR (7 downto 0) := "00110000";
    Constant One        : STD_LOGIC_VECTOR (7 downto 0) := "00110001";
    Constant Two        : STD_LOGIC_VECTOR (7 downto 0) := "00110010";
    Constant Three      : STD_LOGIC_VECTOR (7 downto 0) := "00110011";
    Constant Four       : STD_LOGIC_VECTOR (7 downto 0) := "00110100";
    Constant Five       : STD_LOGIC_VECTOR (7 downto 0) := "00110101";
    Constant Six        : STD_LOGIC_VECTOR (7 downto 0) := "00110110";
    Constant Seven      : STD_LOGIC_VECTOR (7 downto 0) := "00110111";
    Constant Eight      : STD_LOGIC_VECTOR (7 downto 0) := "00111000";
    Constant Nine       : STD_LOGIC_VECTOR (7 downto 0) := "00111001";
    
    type Main_State is (
        RESET_INIT,
        RESET_WAIT,
        RESET_INT,
        RESET_REG,
        MAIN_MENU,
        RUN_COMMAND,
        RUN_MONITOR
    );
    
    type RUN_State is (
        CLEAR,
        PROMPT1,
        WA1T,
        WA1T2,
        CAPTURE_REG_SEL_TRGRD,
        CAPTURE_REG_SEL,
        PROMPT2,
        CAPTURE_REG_VAL_TRGRD,
        CAPTURE_REG_VAL,
        EXECUTE_CHANGE,
        PROMPT3,
        ERROR
    );
    
    type Register_Data is array (0 to 16) of STD_LOGIC_VECTOR (7 downto 0);
    signal Register_Val_Data : Register_Data;
    
    type Main_Menu_Array is array (0 to 30) of STD_LOGIC_VECTOR (7 downto 0);
    Constant Main_Menu_Text : Main_Menu_Array := (Letter_M,Letter_A,Letter_I,Letter_N,Space,Letter_M,Letter_E,Letter_N,Letter_U,Carriage_Return,
                                                    One,Right_Carrot,Space,Letter_M,Letter_O,Letter_N,Letter_I,Letter_T,Letter_O,Letter_R,
                                                    Carriage_Return,Two,Right_Carrot,Space,Letter_C,Letter_O,Letter_M,Letter_M,Letter_A,Letter_N,
                                                    Letter_D);
    
    type Monitor_Reg_Data is array (0 to 7) of STD_LOGIC_VECTOR (15 downto 0);
    signal Monitor_Registers : Monitor_Reg_Data;
    
    type Monitor_Menu_Array is array (0 to 163) of STD_LOGIC_VECTOR (7 downto 0);
    type Monitor_Menu_Array_1 is array (0 to 15) of STD_LOGIC_VECTOR (7 downto 0);
    signal Monitor_Menu_Text : Monitor_Menu_Array;
    signal Monitor_ASCII_0 : Monitor_Menu_Array_1;
    signal Monitor_ASCII_1 : Monitor_Menu_Array_1;
    signal Monitor_ASCII_2 : Monitor_Menu_Array_1;
    signal Monitor_ASCII_3 : Monitor_Menu_Array_1;
    signal Monitor_ASCII_4 : Monitor_Menu_Array_1;
    signal Monitor_ASCII_5 : Monitor_Menu_Array_1;
    signal Monitor_ASCII_6 : Monitor_Menu_Array_1;
    signal Monitor_ASCII_7 : Monitor_Menu_Array_1;
    
    signal Register_Sel : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
    signal Register_Val : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
    
    signal Register_Sel_Bin : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
    signal Register_Val_Bin : STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000";
    
    --signal DebugState_MAIN_MENU : STD_LOGIC := '0';
    --signal DebugState_RUN_MON : STD_LOGIC := '0';
    --signal DebugState_RUN_COMM : STD_LOGIC := '0';
    
    signal MainLoop_State : Main_State := RESET_INIT;
    signal MAIN_MENULoop_State  : RUN_State := CLEAR;
    signal RUN_MONITORLoop_State  : RUN_State := PROMPT1;
    signal RUN_COMMANDLoop_State  : RUN_State := PROMPT1;
    signal State_Counter  : natural := 0;
    signal Main_Menu_Counter : natural := 0;
    signal Monitor_Menu_Counter : natural := 0;
    signal Array_Pointer  : natural := 0;
    
begin

    Monitor_Menu_Text <= (Letter_M,Letter_O,Letter_N,Letter_I,Letter_T,Letter_O,Letter_R,Space,Letter_M,Letter_E,Letter_N,Letter_U,Carriage_Return,One,Right_Carrot,Monitor_ASCII_0(0),Monitor_ASCII_0(1),Monitor_ASCII_0(2),Monitor_ASCII_0(3),
    Monitor_ASCII_0(4),Monitor_ASCII_0(5),Monitor_ASCII_0(6),Monitor_ASCII_0(7),Monitor_ASCII_0(8),Monitor_ASCII_0(9),Monitor_ASCII_0(10),Monitor_ASCII_0(11),Monitor_ASCII_0(12),Monitor_ASCII_0(13),Monitor_ASCII_0(14),Monitor_ASCII_0(15),Carriage_Return,
    Two,Right_Carrot,Monitor_ASCII_1(0),Monitor_ASCII_1(1),Monitor_ASCII_1(2),Monitor_ASCII_1(3),Monitor_ASCII_1(4),Monitor_ASCII_1(5),Monitor_ASCII_1(6),Monitor_ASCII_1(7),Monitor_ASCII_1(8),Monitor_ASCII_1(9),Monitor_ASCII_1(10),Monitor_ASCII_1(11),
    Monitor_ASCII_1(12),Monitor_ASCII_1(13),Monitor_ASCII_1(14),Monitor_ASCII_1(15),Carriage_Return,Three,Right_Carrot,Monitor_ASCII_2(0),Monitor_ASCII_2(1),Monitor_ASCII_2(2),Monitor_ASCII_2(3),Monitor_ASCII_2(4),Monitor_ASCII_2(5),Monitor_ASCII_2(6),Monitor_ASCII_2(7),
    Monitor_ASCII_2(8),Monitor_ASCII_2(9),Monitor_ASCII_2(10),Monitor_ASCII_2(11),Monitor_ASCII_2(12),Monitor_ASCII_2(13),Monitor_ASCII_2(14),Monitor_ASCII_2(15),Carriage_Return,Four,Right_Carrot,Monitor_ASCII_3(0),Monitor_ASCII_3(1),Monitor_ASCII_3(2),Monitor_ASCII_3(3),
    Monitor_ASCII_3(4),Monitor_ASCII_3(5),Monitor_ASCII_3(6),Monitor_ASCII_3(7),Monitor_ASCII_3(8),Monitor_ASCII_3(9),Monitor_ASCII_3(10),Monitor_ASCII_3(11),Monitor_ASCII_3(12),Monitor_ASCII_3(13),Monitor_ASCII_3(14),Monitor_ASCII_3(15),Carriage_Return,Five,Right_Carrot,
    Monitor_ASCII_4(0),Monitor_ASCII_4(1),Monitor_ASCII_4(2),Monitor_ASCII_4(3),Monitor_ASCII_4(4),Monitor_ASCII_4(5),Monitor_ASCII_4(6),Monitor_ASCII_4(7),Monitor_ASCII_4(8),Monitor_ASCII_4(9),Monitor_ASCII_4(10),Monitor_ASCII_4(11),Monitor_ASCII_4(12),Monitor_ASCII_4(13),
    Monitor_ASCII_4(14),Monitor_ASCII_4(15),Carriage_Return,Six,Right_Carrot,Monitor_ASCII_5(0),Monitor_ASCII_5(1),Monitor_ASCII_5(2),Monitor_ASCII_5(3),Monitor_ASCII_5(4),Monitor_ASCII_5(5),Monitor_ASCII_5(6),Monitor_ASCII_5(7),Monitor_ASCII_5(8),Monitor_ASCII_5(9),
    Monitor_ASCII_5(10),Monitor_ASCII_5(11),Monitor_ASCII_5(12),Monitor_ASCII_5(13),Monitor_ASCII_5(14),Monitor_ASCII_5(15),Carriage_Return,Seven,Right_Carrot,Monitor_ASCII_6(0),Monitor_ASCII_6(1),Monitor_ASCII_6(2),Monitor_ASCII_6(3),Monitor_ASCII_6(4),Monitor_ASCII_6(5),
    Monitor_ASCII_6(6),Monitor_ASCII_6(7),Monitor_ASCII_6(8),Monitor_ASCII_6(9),Monitor_ASCII_6(10),Monitor_ASCII_6(11),Monitor_ASCII_6(12),Monitor_ASCII_6(13),Monitor_ASCII_6(14),Monitor_ASCII_6(15),Carriage_Return,Eight,Right_Carrot,Monitor_ASCII_7(0),Monitor_ASCII_7(1),
    Monitor_ASCII_7(2),Monitor_ASCII_7(3),Monitor_ASCII_7(4),Monitor_ASCII_7(5),Monitor_ASCII_7(6),Monitor_ASCII_7(7),Monitor_ASCII_7(8),Monitor_ASCII_7(9),Monitor_ASCII_7(10),Monitor_ASCII_7(11),Monitor_ASCII_7(12),Monitor_ASCII_7(13),Monitor_ASCII_7(14),Monitor_ASCII_7(15));

    MainLoop : process(CLK100MHz) is
    begin
    
        if rising_edge(CLK100MHz) then
        
            case MainLoop_State is
                when RESET_INIT =>
                    if State_Counter >= 500000 then
                        MainLoop_State <= RESET_WAIT;
                        State_Counter <= 0;
                        RESET_OUT <= '0';
                    else
                        RESET_OUT <= '1';
                        State_Counter <= State_Counter + 1;
                    end if;
                when RESET_WAIT =>
                    if State_Counter >= 500000 then
                        MainLoop_State <= MAIN_MENU;
                        State_Counter <= 0;
                    else
                        State_Counter <= State_Counter + 1;
                    end if;
                when RESET_INT =>
                    MainLoop_State <= MAIN_MENU;
                when RESET_REG =>
                    MainLoop_State <= MAIN_MENU;
                when MAIN_MENU =>
                    
                    if Receive_WRD = SHIFT_1 or State_RC  = '1' then
                        MainLoop_State <= RUN_COMMAND;
                    elsif Receive_WRD = SHIFT_2 or State_RM = '1' then
                        MainLoop_State <= RUN_MONITOR;
                    elsif Receive_WRD = SHIFT_3 or State_MM = '1' then
                        MainLoop_State <= MAIN_MENU;
                    elsif Receive_WRD = ESC then
                        MainLoop_State <= MAIN_MENU;
                    else
                        null;
                    end if;
                    
                    case MAIN_MENULoop_State is
                    
                        when CLEAR =>
                            if Main_Menu_Counter <= 23 then
                                if State_Counter = 0 then --SETUP CLEAR
                                    State_Counter <= State_Counter + 1;
                                    
                                    Transmit_WRD <= Carriage_Return;
                                end if;
                                
                                if State_Counter = 1 then --SEND CLEAR
                                    State_Counter <= State_Counter + 1;
                                    
                                    Transmit_WR_EN <= '1';
                                end if;
                                
                                if State_Counter = 2 then --STOP CLEAR
                                    State_Counter <= 0;
                                    Main_Menu_Counter <= Main_Menu_Counter + 1;
                                    
                                    Transmit_WR_EN <= '0';
                                end if;
                            else
                                State_Counter <= 0;
                                Main_Menu_Counter <= 0;
                                MAIN_MENULoop_State <= PROMPT1;
                            end if;
                        when PROMPT1 =>
                            if Main_Menu_Counter <= Main_Menu_Text'Length - 1 then
                                if State_Counter = 0 then --SETUP Character from the Main_Menu_Text array
                                    State_Counter <= State_Counter + 1;
                                    
                                    Transmit_WRD <= Main_Menu_Text(Main_Menu_Counter);
                                end if;
                                
                                if State_Counter = 1 then --SEND Character
                                    State_Counter <= State_Counter + 1;
                                    
                                    Transmit_WR_EN <= '1';
                                end if;
                                
                                if State_Counter = 2 then --STOP Character
                                    State_Counter <= 0;
                                    
                                    Main_Menu_Counter <= Main_Menu_Counter + 1;
                                    Transmit_WR_EN <= '0';
                                end if;
                            else
                                MAIN_MENULoop_State <= WA1T;
                            end if;
                        when WA1T =>
                            State_Counter <= 0;
                            Main_Menu_Counter <= 0;
                        when others =>
                            null;
                    end case;


                when RUN_MONITOR     =>
                    
                    if Receive_WRD = SHIFT_1 or State_RC  = '1' then
                        MainLoop_State <= RUN_COMMAND;
                    elsif Receive_WRD = SHIFT_2 or State_RM = '1' then
                        MainLoop_State <= RUN_MONITOR;
                    elsif Receive_WRD = SHIFT_3 or State_MM = '1' then
                        MainLoop_State <= MAIN_MENU;
                    elsif Receive_WRD = ESC then
                        MainLoop_State <= MAIN_MENU;
                    else
                        null;
                    end if;
                    
                    case RUN_MONITORLoop_State is
                        when CLEAR => -- Clear display with 24 Line Feeds.
                            if Monitor_Menu_Counter <= 23 then
                                if State_Counter = 0 then --SETUP CLEAR
                                    State_Counter <= State_Counter + 1;
                                    
                                    Transmit_WRD <= Carriage_Return;
                                end if;
                                
                                if State_Counter = 1 then --SEND CLEAR
                                    State_Counter <= State_Counter + 1;
                                    
                                    Transmit_WR_EN <= '1';
                                end if;
                                
                                if State_Counter = 2 then --STOP CLEAR
                                    State_Counter <= 0;
                                    Monitor_Menu_Counter <= Monitor_Menu_Counter + 1;
                                    
                                    Transmit_WR_EN <= '0';
                                end if;
                            else
                                RUN_MONITORLoop_State <= WA1T;
                                State_Counter <= 0;
                                Monitor_Menu_Counter <= 0;
                            end if;
                        when WA1T => -- Calculate the text to be displayed
                            
                                if State_Counter = 0 then --Clock in values to array from inputs
                                    State_Counter <= State_Counter + 1;
                                    
                                    Monitor_Registers <= (MON0,MON1,MON2,MON3,MON4,MON5,MON6,MON7);
                                end if;
                                
                                if State_Counter = 1 then -- 0 = 00110000, 1 = 00110001
                                    State_Counter <= State_Counter + 1;

                                    for ii in 0 to 15 loop
                                        Monitor_ASCII_0(ii) <= "0011000" & Monitor_Registers(0)((15 - ii) downto (15 - ii));
                                    end loop;
                                    ------------------------------------------------------
                                    for ii in 0 to 15 loop
                                        Monitor_ASCII_1(ii) <= "0011000" & Monitor_Registers(1)((15 - ii) downto (15 - ii));
                                    end loop;
                                    ------------------------------------------------------
                                    for ii in 0 to 15 loop
                                        Monitor_ASCII_2(ii) <= "0011000" & Monitor_Registers(2)((15 - ii) downto (15 - ii));
                                    end loop;
                                    ------------------------------------------------------
                                    for ii in 0 to 15 loop
                                        Monitor_ASCII_3(ii) <= "0011000" & Monitor_Registers(3)((15 - ii) downto (15 - ii));
                                    end loop;
                                    ------------------------------------------------------
                                    for ii in 0 to 15 loop
                                        Monitor_ASCII_4(ii) <= "0011000" & Monitor_Registers(4)((15 - ii) downto (15 - ii));
                                    end loop;
                                    ------------------------------------------------------
                                    for ii in 0 to 15 loop
                                        Monitor_ASCII_5(ii) <= "0011000" & Monitor_Registers(5)((15 - ii) downto (15 - ii));
                                    end loop;
                                    ------------------------------------------------------
                                    for ii in 0 to 15 loop
                                        Monitor_ASCII_6(ii) <= "0011000" & Monitor_Registers(6)((15 - ii) downto (15 - ii));
                                    end loop;
                                    ------------------------------------------------------
                                    for ii in 0 to 15 loop
                                        Monitor_ASCII_7(ii) <= "0011000" & Monitor_Registers(7)((15 - ii) downto (15 - ii));
                                    end loop;

                                end if;
                                
                                if State_Counter = 2 then --STOP CLEAR
                                    State_Counter <= 0;
                                    
                                    RUN_MONITORLoop_State <= PROMPT1;
                                end if;
                                
                        when PROMPT1 => -- Display text that was calculated
                            if Monitor_Menu_Counter <= Monitor_Menu_Text'Length - 1 then
                                if State_Counter = 0 then --SETUP CLEAR
                                    State_Counter <= State_Counter + 1;
                                    
                                    Transmit_WRD <= Monitor_Menu_Text(Monitor_Menu_Counter);
                                end if;
                                
                                if State_Counter = 1 then --SEND CLEAR
                                    State_Counter <= State_Counter + 1;
                                    
                                    Transmit_WR_EN <= '1';
                                end if;
                                
                                if State_Counter = 2 then --STOP CLEAR
                                    State_Counter <= 0;
                                    Monitor_Menu_Counter <= Monitor_Menu_Counter + 1;
                                    
                                    Transmit_WR_EN <= '0';
                                end if;
                            else
                                State_Counter <= 0;
                                Monitor_Menu_Counter <= 0;
                                RUN_MONITORLoop_State <= WA1T2;
                            end if;
                        when WA1T2 => -- Wait for Text to be displayed for the right amount of time
                            if State_Counter >= 100000000 then
                                RUN_MONITORLoop_State <= CLEAR;
                                State_Counter <= 0;
                                Monitor_Menu_Counter <= 0;
                            else
                                State_Counter <= State_Counter + 1;
                            end if;
                        when others =>
                            null;
                    end case;
                when RUN_COMMAND     =>
                    
                    if Receive_WRD = SHIFT_1 or State_RC  = '1' then
                        MainLoop_State <= RUN_COMMAND;
                    elsif Receive_WRD = SHIFT_2 or State_RM = '1' then
                        MainLoop_State <= RUN_MONITOR;
                    elsif Receive_WRD = SHIFT_3 or State_MM = '1' then
                        MainLoop_State <= MAIN_MENU;
                    elsif Receive_WRD = ESC then
                        MainLoop_State <= MAIN_MENU;
                    else
                        null;
                    end if;
                    
                    case RUN_COMMANDLoop_State is
                        when PROMPT1 =>
                            if State_Counter = 0 then --SETUP R
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= Letter_R;
                            end if;
                            
                            if State_Counter = 1 then --SEND R
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 2 then --STOP R
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            
                            if State_Counter = 3 then --SETUP E
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= Letter_E;
                            end if;
                            
                            if State_Counter = 4 then --SEND E
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 5 then --STOP E
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            
                            if State_Counter = 6 then --SETUP G
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= Letter_G;
                            end if;
                            
                            if State_Counter = 7 then --SEND G
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 8 then --STOP G
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            
                            if State_Counter = 9 then --SETUP =
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= Equals_Sign;
                            end if;
                            
                            if State_Counter = 10 then --SEND =
                                State_Counter <= State_Counter + 1;
                            
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 11 then --STOP =
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            
                            if State_Counter = 12 then --SETUP >
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= Right_Carrot;
                            end if;
                            
                            if State_Counter = 13 then --SEND >
                                State_Counter <= State_Counter + 1;
                            
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 14 then --STOP >
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                                                        
                            if State_Counter >= 15 then --PROCEED TO CAPTURE REG SEL
                                State_Counter <= 0;
                                RUN_COMMANDLoop_State <= CAPTURE_REG_SEL_TRGRD;
                            end if;
                            
                        when CAPTURE_REG_SEL_TRGRD =>
                            
                            if Receieve_EM = '0' then
                                RUN_COMMANDLoop_State <= CAPTURE_REG_SEL;
                            else
                                null;    
                            end if;
                            
                        when CAPTURE_REG_SEL =>
                            if State_Counter = 0 then --Receieve enable
                                State_Counter <= State_Counter + 1;
                                
                                Receive_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 1 then --Receieve stop
                                State_Counter <= State_Counter + 1;
                                
                                Receive_WR_EN <= '0';
                            end if;
                            
                            if State_Counter = 2 then --Receieve capture
                                State_Counter <= State_Counter + 1;
                                
                                Register_Sel <= Receive_WRD;
                            end if;
                            
                            if State_Counter = 3 then --SETUP Echo
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= Receive_WRD;
                            end if;
                            
                            if State_Counter = 4 then --SEND Echo
                                State_Counter <= State_Counter + 1;
                            
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 5 then --STOP Echo
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;                            
                            
                            if State_Counter = 6 then --Error Check  COME BACK TO THIS LATER FOR ERROR CHECK
                                State_Counter <= State_Counter + 1;

                            end if;
                            
                            if State_Counter >= 7 then --Proceed to PROMPT2
                                State_Counter <= 0;
                                
                                RUN_COMMANDLoop_State <= PROMPT2;
                            end if;
                            
                        when PROMPT2 =>
                            if State_Counter = 0 then --SETUP CR
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= Carriage_Return;
                            end if;
                            
                            if State_Counter = 1 then --SEND CR
                                State_Counter <= State_Counter + 1;
                            
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 2 then --STOP CR
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            if State_Counter = 3 then --SETUP V
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= Letter_V;
                            end if;
                            
                            if State_Counter = 4 then --SEND V
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 5 then --STOP V
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            
                            if State_Counter = 6 then --SETUP A
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= Letter_A;
                            end if;
                            
                            if State_Counter = 7 then --SEND A
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 8 then --STOP A
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            
                            if State_Counter = 9 then --SETUP L
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= Letter_L;
                            end if;
                            
                            if State_Counter = 10 then --SEND L
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 11 then --STOP L
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            
                            if State_Counter = 12 then --SETUP =
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= Equals_Sign;
                            end if;
                            
                            if State_Counter = 13 then --SEND =
                                State_Counter <= State_Counter + 1;
                            
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 14 then --STOP =
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            
                            if State_Counter = 15 then --SETUP >
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= Right_Carrot;
                            end if;
                            
                            if State_Counter = 16 then --SEND >
                                State_Counter <= State_Counter + 1;
                            
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 17 then --STOP >
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                                                        
                            if State_Counter >= 18 then --PROCEED TO CAPTURE REG SEL
                                State_Counter <= 0;
                                RUN_COMMANDLoop_State <= CAPTURE_REG_VAL_TRGRD;
                            end if;
                            
                        when CAPTURE_REG_VAL_TRGRD =>
                        
                            if Receieve_EM = '0' then
                                RUN_COMMANDLoop_State <= CAPTURE_REG_VAL;
                            else
                                null;    
                            end if;
                        
                        when CAPTURE_REG_VAL =>

                            if State_Counter = 0 then --Pull Data from FIFO                             
                                
                                if Receieve_EM = '0' then
                                    State_Counter <= State_Counter + 1;
                                else
                                    null;
                                end if;
                                
                                -- Receive_WR_EN <= '1'; -- mistake???????????????????????????????????????????????????????????????????????????
                            end if;
                            
                            if State_Counter = 1 then --Pull Data from FIFO
                                State_Counter <= State_Counter + 1;
                                
                                Receive_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 2 then --SEND CR
                                State_Counter <= State_Counter + 1;
                            
                                Receive_WR_EN <= '0';
                            end if;
                            
                            if State_Counter = 3 then --STOP CR
                                State_Counter <= State_Counter + 1;
                                
                                Register_Val_Data(Array_Pointer) <= Receive_WRD;
                            end if;
                            
                            if State_Counter = 4 then --SETUP Echo
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= Receive_WRD;
                            end if;
                            
                            if State_Counter = 5 then --SEND Echo
                                State_Counter <= State_Counter + 1;
                            
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 6 then --STOP Echo
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                                               
                            if State_Counter >= 7 then --Increment Array pointer
                                State_Counter <= 0;
                        
                                if Array_Pointer >= 16 then
                                    Array_Pointer <= 0;
                                    RUN_COMMANDLoop_State <= EXECUTE_CHANGE;
                                else
                                
                                    Array_Pointer <= Array_Pointer + 1;
                                
                                end if;
                            end if;
                                    
                        when EXECUTE_CHANGE  =>
                            if State_Counter = 0 then --FOR loop. Iterates through array to convert from ASCII to Binary.
                                State_Counter <= State_Counter + 1;
                                
                                for ii in 0 to 16 loop
                                    if Register_Val_Data(ii) = "00110000" then
                                        Register_Val_Data(ii) <= "00000000";
                                    elsif Register_Val_Data(ii) = "00110001" then
                                        Register_Val_Data(ii) <= "00000001";
                                    elsif Register_Val_Data(ii) = "00001101" then
                                        Register_Val_Data(ii) <= "00000010";
                                    else
                                        Register_Val_Data(ii) <= "00000001";
                                        --RUNLoop_State <= ERROR;
                                        --State_Counter <= 0;
                                    end if;
                                end loop;
                            end if;
                            
                            if State_Counter = 1 then
                                State_Counter <= State_Counter + 1;
                                
                                Register_Val_Bin <= Register_Val_Data(0)(0 downto 0) & Register_Val_Data(1)(0 downto 0) & Register_Val_Data(2)(0 downto 0) & Register_Val_Data(3)(0 downto 0) &
                                    Register_Val_Data(4)(0 downto 0) & Register_Val_Data(5)(0 downto 0) &Register_Val_Data(6)(0 downto 0) & Register_Val_Data(7)(0 downto 0) & Register_Val_Data(8)(0 downto 0) &
                                    Register_Val_Data(9)(0 downto 0) & Register_Val_Data(10)(0 downto 0) & Register_Val_Data(11)(0 downto 0) & Register_Val_Data(12)(0 downto 0) &Register_Val_Data(13)(0 downto 0) & 
                                    Register_Val_Data(14)(0 downto 0) & Register_Val_Data(15)(0 downto 0);
                            end if;
                            
                            if State_Counter = 2 then
                                State_Counter <= State_Counter + 1;
                                
                                Register_Sel_Bin <= "0000" & Register_Sel(3 downto 0);
                            end if;
                            
                            if State_Counter = 3 then
                                State_Counter <= State_Counter + 1;
                                
                                if Register_Sel_Bin = "00000000" then
                                    REG0 <= Register_Val_Bin;
                                elsif Register_Sel_Bin = "00000001" then
                                    REG1 <= Register_Val_Bin;
                                elsif Register_Sel_Bin = "00000010" then
                                    REG2 <= Register_Val_Bin;
                                elsif Register_Sel_Bin = "00000011" then
                                    REG3 <= Register_Val_Bin;
                                elsif Register_Sel_Bin = "00000100" then
                                    REG4 <= Register_Val_Bin;
                                elsif Register_Sel_Bin = "00000101" then
                                    REG5 <= Register_Val_Bin;
                                elsif Register_Sel_Bin = "00000110" then
                                    REG6 <= Register_Val_Bin;
                                elsif Register_Sel_Bin = "00000111" then
                                    REG7 <= Register_Val_Bin;
                                else
                                    RUN_COMMANDLoop_State <= ERROR;
                                    State_Counter <= 0;
                                end if;
                            end if;
                            
                            if State_Counter = 4 then
                                State_Counter <= 0;
                                RUN_COMMANDLoop_State <= PROMPT3;
                            end if;
                            
                        when PROMPT3 =>
                            if State_Counter = 0 then --SETUP CR
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= Carriage_Return;
                            end if;
                            
                            if State_Counter = 1 then --SEND CR
                                State_Counter <= State_Counter + 1;
                            
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 2 then --STOP CR
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            if State_Counter = 3 then --SETUP D
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= Letter_D;
                            end if;
                            
                            if State_Counter = 4 then --SEND D
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 5 then --STOP D
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            
                            if State_Counter = 6 then --SETUP O
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= Letter_O;
                            end if;
                            
                            if State_Counter = 7 then --SEND O
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 8 then --STOP O
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            
                            if State_Counter = 9 then --SETUP N
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= Letter_N;
                            end if;
                            
                            if State_Counter = 10 then --SEND N
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 11 then --STOP N
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            
                            if State_Counter = 12 then --SETUP E
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= Letter_E;
                            end if;
                            
                            if State_Counter = 13 then --SEND E
                                State_Counter <= State_Counter + 1;
                            
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 14 then --STOP E
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            
                            if State_Counter = 15 then --SETUP _
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= Space;
                            end if;
                            
                            if State_Counter = 16 then --SEND _
                                State_Counter <= State_Counter + 1;
                            
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 17 then --STOP _
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            
                            if State_Counter = 18 then --SETUP R
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= Letter_R;
                            end if;
                            
                            if State_Counter = 19 then --SEND R
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 20 then --STOP R
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            
                            if State_Counter = 21 then --SETUP E
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= Letter_E;
                            end if;
                            
                            if State_Counter = 22 then --SEND E
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 23 then --STOP E
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            
                            if State_Counter = 23 then --SETUP G
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= Letter_G;
                            end if;
                            
                            if State_Counter = 24 then --SEND G
                                State_Counter <= State_Counter + 1;
                            
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 25 then --STOP G
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            
                            if State_Counter = 26 then --SETUP Reg Sel
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= Register_Sel;
                            end if;
                            
                            if State_Counter = 27 then --SEND Reg Sel
                                State_Counter <= State_Counter + 1;
                            
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 28 then --STOP Reg Sel
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            
                            if State_Counter = 29 then --SETUP _
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= Space;
                            end if;
                            
                            if State_Counter = 30 then --SEND _
                                State_Counter <= State_Counter + 1;
                            
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 31 then --STOP _
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            
                            if State_Counter = 32 then --SETUP Bit 0
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= "0011" & Register_Val_Data(0)(3 downto 0); -- REALLY FUCKING DUMB
                            end if;
                            
                            if State_Counter = 33 then --SEND Bit 0
                                State_Counter <= State_Counter + 1;
                            
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 34 then --STOP Bit 0
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            
                            if State_Counter = 35 then --SETUP Bit 1
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= "0011" & Register_Val_Data(1)(3 downto 0); -- REALLY FUCKING DUMB
                            end if;
                            
                            if State_Counter = 36 then --SEND Bit 1
                                State_Counter <= State_Counter + 1;
                            
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 37 then --STOP Bit 1
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            
                            if State_Counter = 38 then --SETUP Bit 2
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= "0011" & Register_Val_Data(2)(3 downto 0); -- REALLY FUCKING DUMB
                            end if;
                            
                            if State_Counter = 39 then --SEND Bit 2
                                State_Counter <= State_Counter + 1;
                            
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 40 then --STOP Bit 2
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            
                            if State_Counter = 41 then --SETUP Bit 3
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= "0011" & Register_Val_Data(3)(3 downto 0); -- REALLY FUCKING DUMB
                            end if;
                            
                            if State_Counter = 42 then --SEND Bit 3
                                State_Counter <= State_Counter + 1;
                            
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 43 then --STOP Bit 3
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            
                            if State_Counter = 44 then --SETUP Bit 4
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= "0011" & Register_Val_Data(4)(3 downto 0); -- REALLY FUCKING DUMB
                            end if;
                            
                            if State_Counter = 45 then --SEND Bit 4
                                State_Counter <= State_Counter + 1;
                            
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 46 then --STOP Bit 4
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;

                            if State_Counter = 47 then --SETUP Bit 5
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= "0011" & Register_Val_Data(5)(3 downto 0); -- REALLY FUCKING DUMB
                            end if;
                            
                            if State_Counter = 48 then --SEND Bit 5
                                State_Counter <= State_Counter + 1;
                            
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 49 then --STOP Bit 5
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            
                            if State_Counter = 50 then --SETUP Bit 6
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= "0011" & Register_Val_Data(6)(3 downto 0); -- REALLY FUCKING DUMB
                            end if;
                            
                            if State_Counter = 51 then --SEND Bit 6
                                State_Counter <= State_Counter + 1;
                            
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 52 then --STOP Bit 6
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            
                            if State_Counter = 53 then --SETUP Bit 7
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= "0011" & Register_Val_Data(7)(3 downto 0); -- REALLY FUCKING DUMB
                            end if;
                            
                            if State_Counter = 54 then --SEND Bit 7
                                State_Counter <= State_Counter + 1;
                            
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 55 then --STOP Bit 7
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            
                            if State_Counter = 56 then --SETUP Bit 8
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= "0011" & Register_Val_Data(8)(3 downto 0); -- REALLY FUCKING DUMB
                            end if;
                            
                            if State_Counter = 57 then --SEND Bit 8
                                State_Counter <= State_Counter + 1;
                            
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 58 then --STOP Bit 8
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            
                            if State_Counter = 59 then --SETUP Bit 9
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= "0011" & Register_Val_Data(9)(3 downto 0); -- REALLY FUCKING DUMB
                            end if;
                            
                            if State_Counter = 60 then --SEND Bit 9
                                State_Counter <= State_Counter + 1;
                            
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 61 then --STOP Bit 9
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            
                            if State_Counter = 62 then --SETUP Bit 10
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= "0011" & Register_Val_Data(10)(3 downto 0); -- REALLY FUCKING DUMB
                            end if;
                            
                            if State_Counter = 63 then --SEND Bit 10
                                State_Counter <= State_Counter + 1;
                            
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 64 then --STOP Bit 10
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;                                                                                                                                                                                                                                                            
                            
                            if State_Counter = 65 then --SETUP Bit 11
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= "0011" & Register_Val_Data(11)(3 downto 0); -- REALLY FUCKING DUMB
                            end if;
                            
                            if State_Counter = 66 then --SEND Bit 11
                                State_Counter <= State_Counter + 1;
                            
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 67 then --STOP Bit 11
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            
                            if State_Counter = 68 then --SETUP Bit 12
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= "0011" & Register_Val_Data(12)(3 downto 0); -- REALLY FUCKING DUMB
                            end if;
                            
                            if State_Counter = 69 then --SEND Bit 12
                                State_Counter <= State_Counter + 1;
                            
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 70 then --STOP Bit 12
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            
                            if State_Counter = 71 then --SETUP Bit 13
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= "0011" & Register_Val_Data(13)(3 downto 0); -- REALLY FUCKING DUMB
                            end if;
                            
                            if State_Counter = 72 then --SEND Bit 13
                                State_Counter <= State_Counter + 1;
                            
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 73 then --STOP Bit 13
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            
                            if State_Counter = 74 then --SETUP Bit 14
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= "0011" & Register_Val_Data(14)(3 downto 0); -- REALLY FUCKING DUMB
                            end if;
                            
                            if State_Counter = 75 then --SEND Bit 14
                                State_Counter <= State_Counter + 1;
                            
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 76 then --STOP Bit 14
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            
                            if State_Counter = 77 then --SETUP Bit 15
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= "0011" & Register_Val_Data(15)(3 downto 0); -- REALLY FUCKING DUMB
                            end if;
                            
                            if State_Counter = 78 then --SEND Bit 15
                                State_Counter <= State_Counter + 1;
                            
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 79 then --STOP Bit 15
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;

                            if State_Counter = 80 then --SETUP CR
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= Carriage_Return;
                            end if;
                            
                            if State_Counter = 81 then --SEND CR
                                State_Counter <= State_Counter + 1;
                            
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 82 then --STOP CR
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                                                                                    
                            if State_Counter >= 83 then --PROCEED TO CAPTURE REG SEL
                                State_Counter <= 0;
                                RUN_COMMANDLoop_State <= PROMPT1;
                            end if;
                            
                        when ERROR =>
                            if State_Counter = 0 then --SETUP CR
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= Carriage_Return;
                            end if;
                            
                            if State_Counter = 1 then --SEND CR
                                State_Counter <= State_Counter + 1;
                            
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 2 then --STOP CR
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            if State_Counter = 3 then --SETUP E
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= Letter_E;
                            end if;
                            
                            if State_Counter = 4 then --SEND E
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 5 then --STOP E
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            
                            if State_Counter = 6 then --SETUP R
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= Letter_R;
                            end if;
                            
                            if State_Counter = 7 then --SEND R
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 8 then --STOP R
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            
                            if State_Counter = 9 then --SETUP R
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= Letter_R;
                            end if;
                            
                            if State_Counter = 10 then --SEND R
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 11 then --STOP R
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            
                            if State_Counter = 12 then --SETUP O
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= Letter_O;
                            end if;
                            
                            if State_Counter = 13 then --SEND O
                                State_Counter <= State_Counter + 1;
                            
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 14 then --STOP O
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            
                            if State_Counter = 15 then --SETUP R
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= Letter_R;
                            end if;
                            
                            if State_Counter = 16 then --SEND R
                                State_Counter <= State_Counter + 1;
                            
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 17 then --STOP R
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            
                            if State_Counter = 18 then --SETUP CR
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WRD <= Carriage_Return;
                            end if;
                            
                            if State_Counter = 19 then --SEND CR
                                State_Counter <= State_Counter + 1;
                            
                                Transmit_WR_EN <= '1';
                            end if;
                            
                            if State_Counter = 20 then --STOP CR
                                State_Counter <= State_Counter + 1;
                                
                                Transmit_WR_EN <= '0';
                            end if;
                            
                            if State_Counter >= 21 then --PROCEED TO PROMPT1
                                State_Counter <= 0;
                                RUN_COMMANDLoop_State <= PROMPT1;
                            end if;
                        when others =>
                            null;
                    end case;
            end case;
        
        end if;
        
    end process;

end Behavioral;

