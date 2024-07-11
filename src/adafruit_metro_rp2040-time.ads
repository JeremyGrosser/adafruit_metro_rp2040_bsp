--
--  Copyright (C) 2024 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
package Adafruit_Metro_RP2040.Time
   with Elaborate_Body
is

   type Time is mod 2 ** 64;

   procedure Initialize;

   function Clock
      return Time;

   function Milliseconds
      (Ms : Natural)
      return Time;

   function Microseconds
      (Us : Natural)
      return Time;

   procedure Delay_Until
      (T : Time);

   procedure Delay_Milliseconds
      (Ms : Natural);

   procedure Delay_Microseconds
      (Us : Natural);

end Adafruit_Metro_RP2040.Time;
