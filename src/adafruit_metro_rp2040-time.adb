--
--  Copyright (C) 2024 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with RP.Timer.Interrupts;
with RP.Timer;

package body Adafruit_Metro_RP2040.Time is

   Delays : RP.Timer.Interrupts.Delays;

   procedure Initialize is
   begin
      Delays.Enable;
   end Initialize;

   function Clock
      return Time
   is (Time (RP.Timer.Clock));

   function Milliseconds
      (Ms : Natural)
      return Time
   is (Time ((RP.Timer.Ticks_Per_Second / 1_000) * Ms));

   function Microseconds
      (Us : Natural)
      return Time
   is (Time ((RP.Timer.Ticks_Per_Second / 1_000_000) * Us));

   procedure Delay_Until
      (T : Time)
   is
   begin
      Delays.Delay_Until (RP.Timer.Time (T));
   end Delay_Until;

   procedure Delay_Milliseconds
      (Ms : Natural)
   is
   begin
      Delay_Until (Clock + Milliseconds (Ms));
   end Delay_Milliseconds;

   procedure Delay_Microseconds
      (Us : Natural)
   is
   begin
      Delay_Until (Clock + Microseconds (Us));
   end Delay_Microseconds;

end Adafruit_Metro_RP2040.Time;
