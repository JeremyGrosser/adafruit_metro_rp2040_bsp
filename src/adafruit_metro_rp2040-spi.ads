--
--  Copyright (C) 2024 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with HAL;

package Adafruit_Metro_RP2040.SPI
   with Preelaborate
is

   procedure Initialize;

   procedure Set_Speed
      (Hz : Natural);

   procedure Transfer
      (Data : in out HAL.UInt8_Array);

end Adafruit_Metro_RP2040.SPI;
