--
--  Copyright (C) 2024 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
pragma Style_Checks ("M120");
with RP.GPIO;
with RP.PWM;
with RP.ADC;

package body Adafruit_Metro_RP2040.GPIO is

   procedure Pin_Mode
      (Pin     : Natural;
       Output  : Boolean;
       Pull_Up : Boolean := False)
   is
      P : RP.GPIO.GPIO_Point := (Pin => RP.GPIO.GPIO_Pin (Pin));
   begin
      P.Configure
         (Mode => (if Output then RP.GPIO.Output else RP.GPIO.Input),
          Pull => (if Pull_Up then RP.GPIO.Pull_Up else RP.GPIO.Floating));
   end Pin_Mode;

   procedure Digital_Write
      (Pin  : Natural;
       High : Boolean)
   is
      P : RP.GPIO.GPIO_Point := (Pin => RP.GPIO.GPIO_Pin (Pin));
   begin
      if High then
         P.Set;
      else
         P.Clear;
      end if;
   end Digital_Write;

   function Digital_Read
      (Pin : Natural)
      return Boolean
   is
      P : constant RP.GPIO.GPIO_Point := (Pin => RP.GPIO.GPIO_Pin (Pin));
   begin
      return P.Set;
   end Digital_Read;

   procedure Analog_Write
      (Pin : Natural;
       Duty_Cycle : HAL.UInt8)
   is
      use type RP.PWM.Period;
      P : RP.GPIO.GPIO_Point := (Pin => RP.GPIO.GPIO_Pin (Pin));
      PWM : constant RP.PWM.PWM_Point := RP.PWM.To_PWM (P);
   begin
      if not RP.PWM.Initialized then
         RP.PWM.Initialize;
      end if;

      P.Configure (RP.GPIO.Output, RP.GPIO.Floating, RP.GPIO.PWM);

      if not RP.PWM.Enabled (PWM.Slice) then
         RP.PWM.Set_Mode (PWM.Slice, RP.PWM.Free_Running);
         RP.PWM.Set_Frequency (PWM.Slice, 2_550_000);
         RP.PWM.Set_Interval (PWM.Slice, 2_550);
         RP.PWM.Enable (PWM.Slice);
      end if;
      RP.PWM.Set_Duty_Cycle (PWM.Slice, PWM.Channel, RP.PWM.Period (Duty_Cycle) * 10);
   end Analog_Write;

   function Analog_Read
      (Pin : Natural)
      return HAL.UInt10
   is
      use type RP.ADC.Analog_Value;
      P : RP.GPIO.GPIO_Point := (Pin => RP.GPIO.GPIO_Pin (Pin));
      Chan : constant RP.ADC.ADC_Channel := RP.ADC.To_ADC_Channel (P);
   begin
      P.Configure (RP.GPIO.Analog);
      if not RP.ADC.Enabled then
         RP.ADC.Enable;
      end if;

      RP.ADC.Configure (Chan);
      return HAL.UInt10 (RP.ADC.Read (Chan) / 4);
   end Analog_Read;

end Adafruit_Metro_RP2040.GPIO;
