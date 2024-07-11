--
--  Copyright (C) 2024 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Ada.Real_Time; use Ada.Real_Time;
with Adafruit_Metro_RP2040.LED;
with Adafruit_Metro_RP2040.SPI;
with Adafruit_Metro_RP2040.UART;
with Adafruit_Metro_RP2040.GPIO;
with Adafruit_Metro_RP2040.Pins;
with Adafruit_Metro_RP2040;
with HAL;

with Screen;

procedure Test is
   package MRP renames Adafruit_Metro_RP2040;

   Data : HAL.UInt8_Array (1 .. 2);
   T : Time;

   use type HAL.UInt10;
   use type HAL.UInt8;
   DC : HAL.UInt8 := 255;
begin
   MRP.LED.Initialize;
   MRP.SPI.Initialize;
   MRP.SPI.Set_Speed (5_000_000);
   MRP.UART.Initialize;
   MRP.UART.Set_Speed (9_600);

   MRP.GPIO.Pin_Mode (MRP.Pins.D13, Output => True);
   MRP.GPIO.Pin_Mode (MRP.Pins.D12, Output => True);

   T := Clock;

   loop
      MRP.GPIO.Digital_Write
         (MRP.Pins.D13, MRP.GPIO.Analog_Read (MRP.Pins.A0) > 512);
      MRP.GPIO.Analog_Write (MRP.Pins.D12, DC);
      DC := DC - 25;

      Screen.Swap;
      for X in 0 .. 127 loop
         Screen.Set_Pixel (X, 16);
      end loop;
      for Y in 0 .. 31 loop
         Screen.Set_Pixel (64, Y);
      end loop;

      Data := (16#AA#, 16#55#);
      MRP.SPI.Transfer (Data);

      Data := (16#AA#, 16#55#);
      MRP.UART.Write (Data);
      if MRP.UART.Available >= Data'Length then
         MRP.UART.Read (Data);
      end if;

      MRP.LED.Set_Color (R => 32);
      T := T + Milliseconds (100);
      delay until T;

      MRP.LED.Set_Color (G => 32);
      T := T + Milliseconds (100);
      delay until T;

      MRP.LED.Set_Color (B => 32);
      T := T + Milliseconds (100);
      delay until T;

      MRP.LED.Set_Color;
      T := T + Milliseconds (900);
      delay until T;
   end loop;
end Test;
