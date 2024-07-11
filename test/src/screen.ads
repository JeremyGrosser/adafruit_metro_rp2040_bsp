--
--  Copyright (C) 2024 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
package Screen is

   procedure Clear;

   procedure Set_Pixel
      (X, Y : Natural);

   task Screen_IO;

end Screen;
