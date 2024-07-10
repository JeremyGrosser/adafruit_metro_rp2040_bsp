--
--  Copyright (C) 2024 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
pragma Style_Checks ("M120");
with Adafruit_Metro_RP2040.Pins;
with RP2040_SVD.I2C;
with RP.I2C_Master;
with HAL.I2C;
with RP.GPIO;

package body Adafruit_Metro_RP2040.I2C is

   SCL  : RP.GPIO.GPIO_Point := (Pin => Adafruit_Metro_RP2040.Pins.SCL);
   SDA  : RP.GPIO.GPIO_Point := (Pin => Adafruit_Metro_RP2040.Pins.SDA);
   Port : RP.I2C_Master.I2C_Master_Port (0, RP2040_SVD.I2C.I2C0_Periph'Access);

   procedure Initialize is
   begin
      Port.Configure (100_000);
      SCL.Configure (RP.GPIO.Output, RP.GPIO.Pull_Up, RP.GPIO.I2C, Schmitt => True);
      SDA.Configure (RP.GPIO.Output, RP.GPIO.Pull_Up, RP.GPIO.I2C, Schmitt => True);
   end Initialize;

   procedure Write
      (Addr  : HAL.UInt7;
       Data  : HAL.UInt8_Array;
       Error : out Boolean)
   is
      use HAL.I2C;
      use HAL;
      HAL_Addr : constant I2C_Address := I2C_Address (Shift_Left (UInt8 (Addr), 1));
      Status   : I2C_Status;
   begin
      Port.Master_Transmit (HAL_Addr, I2C_Data (Data), Status);
      Error := Status /= Ok;
   end Write;

end Adafruit_Metro_RP2040.I2C;
