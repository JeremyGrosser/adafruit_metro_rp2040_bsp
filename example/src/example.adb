--
--  Copyright (C) 2024 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Adafruit_Metro_RP2040.GPIO;
with Adafruit_Metro_RP2040.Pins;
with Adafruit_Metro_RP2040.Time;
with Adafruit_Metro_RP2040.LED;
with Adafruit_Metro_RP2040;

procedure Example is
   package MRP renames Adafruit_Metro_RP2040;
   use MRP.Pins;
   use MRP.GPIO;
   use MRP.Time;
begin
   MRP.Time.Initialize;
   MRP.LED.Initialize;

   loop
      Digital_Write (D13, True);
      Delay_Milliseconds (100);
      Digital_Write (D13, False);
      Delay_Milliseconds (100);
   end loop;
end Example;
