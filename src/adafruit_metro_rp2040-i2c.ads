--
--  Copyright (C) 2024 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with HAL;

package Adafruit_Metro_RP2040.I2C
   with Elaborate_Body
is

   procedure Initialize;

   procedure Write
      (Addr  : HAL.UInt7;
       Data  : HAL.UInt8_Array;
       Error : out Boolean);

end Adafruit_Metro_RP2040.I2C;
