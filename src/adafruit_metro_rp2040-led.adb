--
--  Copyright (C) 2024 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Adafruit_Metro_RP2040.Pins;

with RP2040_SVD;
with RP.GPIO;
with RP.PIO;
with RP.PIO.WS2812;

package body Adafruit_Metro_RP2040.LED is

   PIO0_Periph : aliased RP.PIO.PIO_Peripheral
         with Import, Address => RP2040_SVD.PIO0_Base;
   PIO0 : aliased RP.PIO.PIO_Device (0, PIO0_Periph'Access);

   NEOPIX : aliased RP.GPIO.GPIO_Point :=
      (Pin => Adafruit_Metro_RP2040.Pins.NEOPIX);
   Strip  : RP.PIO.WS2812.Strip
      (Pin => NEOPIX'Access,
       PIO => PIO0'Access,
       SM  => 0,
       Number_Of_LEDs => 1);

   procedure Set_Color
      (R, G, B : HAL.UInt8 := 0)
   is
   begin
      Strip.Set_RGB
         (Id => 1,
          R  => R,
          G  => G,
          B  => B);
      Strip.Update (Blocking => True);
   end Set_Color;

   procedure Initialize is
   begin
      PIO0.Enable;
      Strip.Initialize;
      Strip.Clear;
      Strip.Update (Blocking => True);
   end Initialize;

end Adafruit_Metro_RP2040.LED;
