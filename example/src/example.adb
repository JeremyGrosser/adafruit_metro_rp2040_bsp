--
--  Copyright (C) 2024 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Adafruit_Metro_RP2040.GPIO; use Adafruit_Metro_RP2040.GPIO;
with Adafruit_Metro_RP2040.Pins; use Adafruit_Metro_RP2040.Pins;
with Adafruit_Metro_RP2040.Time; use Adafruit_Metro_RP2040.Time;

procedure Example is
begin
   loop
      Digital_Write (D13, True);
      Delay_Milliseconds (100);
      Digital_Write (D13, False);
      Delay_Milliseconds (100);
   end loop;
end Example;
