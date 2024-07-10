--
--  Copyright (C) 2024 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
pragma Style_Checks ("M120");
with Chests.Ring_Buffers;
with Adafruit_Metro_RP2040.Pins;
with RP2040_SVD.UART;
with RP2040_SVD.Interrupts;
with RP.UART;
with RP.GPIO;
with RP;
with HAL.UART;
with RP_Interrupts;

package body Adafruit_Metro_RP2040.UART is

   package Byte_Buffers is new Chests.Ring_Buffers
      (Element_Type => HAL.UInt8,
       Capacity     => 32);
   Buffer : Byte_Buffers.Ring_Buffer;

   RXD : RP.GPIO.GPIO_Point := (Pin => Adafruit_Metro_RP2040.Pins.D0);
   TXD : RP.GPIO.GPIO_Point := (Pin => Adafruit_Metro_RP2040.Pins.D1);

   Port : RP.UART.UART_Port :=
      (Num    => 0,
       Periph => RP2040_SVD.UART.UART0_Periph'Access,
       Config => RP.UART.Default_UART_Configuration);

   procedure UART0_Handler is
      use type RP.UART.UART_FIFO_Status;
      use HAL.UART;
      use Byte_Buffers;
      Data   : HAL.UInt8_Array (1 .. 1);
      Status : UART_Status;
   begin
      while Port.Receive_Status /= RP.UART.Empty loop
         Port.Receive (UART_Data_8b (Data), Status, Timeout => 0);
         if not Is_Full (Buffer) and then Status = Ok then
            Append (Buffer, Data (1));
         end if;
      end loop;
   end UART0_Handler;

   procedure Initialize is
   begin
      Port.Configure;
      TXD.Configure (RP.GPIO.Output, RP.GPIO.Pull_Up, RP.GPIO.UART);
      RXD.Configure (RP.GPIO.Output, RP.GPIO.Floating, RP.GPIO.UART);
      Byte_Buffers.Clear (Buffer);
      Port.Set_FIFO_IRQ_Level (RX => RP.UART.Lvl_Eighth, TX => RP.UART.Lvl_Eighth);
      Port.Enable_IRQ (RP.UART.Receive);
      RP_Interrupts.Attach_Handler
         (Handler => UART0_Handler'Access,
          Id      => RP2040_SVD.Interrupts.UART0_Interrupt,
          Prio    => RP_Interrupts.Interrupt_Priority'First);
   end Initialize;

   procedure Set_Speed
      (Baud : Natural)
   is
   begin
      Port.Configure ((Baud => RP.Hertz (Baud), others => <>));
   end Set_Speed;

   procedure Write
      (Data : HAL.UInt8_Array)
   is
      use HAL.UART;
      Status : UART_Status;
   begin
      Port.Transmit (UART_Data_8b (Data), Status, Timeout => 0);
   end Write;

   function Available
      return Natural
   is (Byte_Buffers.Length (Buffer));

   procedure Read
      (Data : out HAL.UInt8_Array;
       Last : out Natural)
   is
      use Byte_Buffers;
   begin
      Last := Data'First - 1;
      for I in Data'Range loop
         exit when Is_Empty (Buffer);
         Data (I) := Last_Element (Buffer);
         Delete_Last (Buffer);
         Last := I;
      end loop;
   end Read;

end Adafruit_Metro_RP2040.UART;
