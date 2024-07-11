--
--  Copyright (C) 2024 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Ada.Real_Time; use Ada.Real_Time;
with Adafruit_Metro_RP2040.I2C;
with Adafruit_Metro_RP2040;
with SSD1306;
with HAL; use HAL;

package body Screen is
   package MRP renames Adafruit_Metro_RP2040;

   FPS   : constant := 10;
   Error : Boolean := True;

   procedure I2C_Write
      (Data : UInt8_Array)
   is
   begin
      MRP.I2C.Write (16#3C#, Data, Error);
   end I2C_Write;

   package OLED is new SSD1306 (I2C_Write);

   procedure Set_Pixel
      (X, Y : Natural)
   is
   begin
      OLED.Set_Pixel
         (X   => OLED.Column (X),
          Y   => OLED.Row (Y),
          Set => True);
   end Set_Pixel;

   procedure Swap is
   begin
      OLED.Swap;
   end Swap;

   task body Screen_IO is
      T : Time := Clock;
   begin
      MRP.I2C.Initialize;
      loop
         if Error then
            OLED.Initialize;
         end if;
         OLED.Update;
         T := T + Milliseconds (1_000 / FPS);
         delay until T;
      end loop;
   end Screen_IO;
end Screen;
