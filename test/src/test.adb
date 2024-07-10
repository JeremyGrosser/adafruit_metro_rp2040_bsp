--
--  Copyright (C) 2024 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Adafruit_Metro_RP2040.LED;
with Adafruit_Metro_RP2040.SPI;
with Adafruit_Metro_RP2040.I2C;
with Adafruit_Metro_RP2040.UART;
with Adafruit_Metro_RP2040.GPIO;
with Adafruit_Metro_RP2040.Pins;
with Adafruit_Metro_RP2040;
with RP.Timer.Interrupts;
with RP.Timer; use RP.Timer;
with RP.Clock;
with HAL;

with SSD1306;

procedure Test is
   package MRP renames Adafruit_Metro_RP2040;
   Delays : RP.Timer.Interrupts.Delays;

   Screen_Error : Boolean := True;

   procedure Screen_Write
      (Data : HAL.UInt8_Array)
   is
   begin
      MRP.I2C.Write (16#3C#, Data, Screen_Error);
   end Screen_Write;

   package Screen is new SSD1306 (Screen_Write);

   Data : HAL.UInt8_Array (1 .. 2);
   T : Time;

   use type HAL.UInt10;
   use type HAL.UInt8;
   DC : HAL.UInt8 := 255;
begin
   RP.Clock.Initialize (12_000_000);
   MRP.LED.Initialize;
   MRP.I2C.Initialize;
   MRP.SPI.Initialize;
   MRP.SPI.Set_Speed (5_000_000);
   MRP.UART.Initialize;
   MRP.UART.Set_Speed (9_600);

   MRP.GPIO.Pin_Mode (MRP.Pins.D13, Output => True);
   MRP.GPIO.Pin_Mode (MRP.Pins.D12, Output => True);

   Delays.Enable;
   T := Clock;

   loop
      MRP.GPIO.Digital_Write
         (MRP.Pins.D13, MRP.GPIO.Analog_Read (MRP.Pins.A0) > 512);
      MRP.GPIO.Analog_Write (MRP.Pins.D12, DC);
      DC := DC - 25;

      if Screen_Error then
         Screen.Initialize;
      end if;
      Screen.Clear;
      for X in Screen.Column'Range loop
         Screen.Set_Pixel (X => X, Y => Screen.Row'Last / 2, Set => True);
      end loop;
      for Y in Screen.Row'Range loop
         Screen.Set_Pixel (X => Screen.Column'Last / 2, Y => Y, Set => True);
      end loop;
      Screen.Update;

      Data := (16#AA#, 16#55#);
      MRP.SPI.Transfer (Data);

      Data := (16#AA#, 16#55#);
      MRP.UART.Write (Data);

      MRP.LED.Set_Color (R => 32);
      T := T + Milliseconds (100);
      Delays.Delay_Until (T);

      MRP.LED.Set_Color (G => 32);
      T := T + Milliseconds (100);
      Delays.Delay_Until (T);

      MRP.LED.Set_Color (B => 32);
      T := T + Milliseconds (100);
      Delays.Delay_Until (T);

      MRP.LED.Set_Color;
      T := T + Milliseconds (900);
      Delays.Delay_Until (T);
   end loop;
end Test;
