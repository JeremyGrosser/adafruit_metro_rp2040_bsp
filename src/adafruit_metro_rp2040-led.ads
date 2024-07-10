--
--  Copyright (C) 2024 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with HAL;

package Adafruit_Metro_RP2040.LED
   with Preelaborate
is

   procedure Initialize;

   procedure Set_Color
      (R, G, B : HAL.UInt8 := 0);

end Adafruit_Metro_RP2040.LED;
