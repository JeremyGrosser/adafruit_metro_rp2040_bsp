--
--  Copyright (C) 2024 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with HAL;

package Adafruit_Metro_RP2040.UART
   with Elaborate_Body
is

   procedure Initialize;

   procedure Set_Speed
      (Baud : Natural);

   procedure Write
      (Data : HAL.UInt8_Array);

   function Available
      return Natural;

   procedure Read
      (Data : out HAL.UInt8_Array;
       Last : out Natural);

end Adafruit_Metro_RP2040.UART;
