--
--  Copyright (C) 2024 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Generic_Tiny_Text;

package Screen is

   procedure Swap;

   procedure Set_Pixel
      (X, Y : Natural);

   package Text is new Generic_Tiny_Text
      (Width         => 128,
       Height        => 32,
       Set_Pixel     => Set_Pixel,
       Clear_Screen  => Swap);

   task Screen_IO;

end Screen;
