--
--  Copyright (C) 2024 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Adafruit_Metro_RP2040.Pins;
with RP2040_SVD.SPI;
with RP.SPI;
with RP.GPIO;
with RP;
with HAL.SPI;

package body Adafruit_Metro_RP2040.SPI is

   SCK  : RP.GPIO.GPIO_Point := (Pin => Adafruit_Metro_RP2040.Pins.SCK);
   MOSI : RP.GPIO.GPIO_Point := (Pin => Adafruit_Metro_RP2040.Pins.MOSI);
   MISO : RP.GPIO.GPIO_Point := (Pin => Adafruit_Metro_RP2040.Pins.MISO);

   Port : RP.SPI.SPI_Port (0, RP2040_SVD.SPI.SPI0_Periph'Access);

   procedure Initialize is
   begin
      Port.Configure;
      SCK.Configure (RP.GPIO.Output, RP.GPIO.Pull_Up, RP.GPIO.SPI);
      MOSI.Configure (RP.GPIO.Output, RP.GPIO.Pull_Up, RP.GPIO.SPI);
      MISO.Configure (RP.GPIO.Input, RP.GPIO.Pull_Up, RP.GPIO.SPI);
   end Initialize;

   procedure Set_Speed
      (Hz : Natural)
   is
   begin
      Port.Set_Speed (RP.Hertz (Hz));
   end Set_Speed;

   procedure Transfer
      (Data : in out HAL.UInt8_Array)
   is
      use HAL.SPI;
      Status : SPI_Status;
   begin
      for I in Data'Range loop
         Port.Transmit (SPI_Data_8b (Data (I .. I)), Status, Timeout => 0);
         Port.Receive (SPI_Data_8b (Data (I .. I)), Status, Timeout => 0);
      end loop;
   end Transfer;

end Adafruit_Metro_RP2040.SPI;
