--
--  Copyright (C) 2024 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with HAL;

package Adafruit_Metro_RP2040.GPIO
   with Preelaborate
is

   procedure Pin_Mode
      (Pin     : Natural;
       Output  : Boolean;
       Pull_Up : Boolean := False);

   procedure Digital_Write
      (Pin  : Natural;
       High : Boolean);

   function Digital_Read
      (Pin : Natural)
      return Boolean;

   procedure Analog_Write
      (Pin : Natural;
       Duty_Cycle : HAL.UInt8);

   function Analog_Read
      (Pin : Natural)
      return HAL.UInt10;

end Adafruit_Metro_RP2040.GPIO;
