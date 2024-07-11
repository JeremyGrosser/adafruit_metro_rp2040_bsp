--
--  Copyright (C) 2024 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Adafruit_Metro_RP2040.GPIO; use Adafruit_Metro_RP2040.GPIO;
with Adafruit_Metro_RP2040.Pins; use Adafruit_Metro_RP2040.Pins;

procedure Example is
begin
   loop
      Digital_Write (D13, True);
      delay 0.1;
      Digital_Write (D13, False);
      delay 0.1;
   end loop;
end Example;
