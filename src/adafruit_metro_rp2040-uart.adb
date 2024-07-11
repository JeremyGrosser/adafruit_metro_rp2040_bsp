--
--  Copyright (C) 2024 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
pragma Style_Checks ("M120");
with Ada.Interrupts.Names;
with Chests.Ring_Buffers;
with Adafruit_Metro_RP2040.Pins;
with RP2040_SVD.UART;
with RP.UART;
with RP.GPIO;
with RP;
with HAL.UART;

package body Adafruit_Metro_RP2040.UART is

   package Byte_Buffers is new Chests.Ring_Buffers
      (Element_Type => HAL.UInt8,
       Capacity     => 32);

   RXD : RP.GPIO.GPIO_Point := (Pin => Adafruit_Metro_RP2040.Pins.D0);
   TXD : RP.GPIO.GPIO_Point := (Pin => Adafruit_Metro_RP2040.Pins.D1);

   Port : RP.UART.UART_Port :=
      (Num    => 0,
       Periph => RP2040_SVD.UART.UART0_Periph'Access,
       Config => RP.UART.Default_UART_Configuration);

   protected Receiver is
      procedure Reset;
      entry Get
         (Data : out HAL.UInt8);
      function Length
         return Natural;
   private
      Count  : Natural := 0;
      Buffer : Byte_Buffers.Ring_Buffer;
      procedure UART_Interrupt
         with Attach_Handler => Ada.Interrupts.Names.UART0_Interrupt_CPU_1;
   end Receiver;

   protected body Receiver is
      procedure UART_Interrupt is
         use type RP.UART.UART_FIFO_Status;
         use HAL.UART;
         use Byte_Buffers;
         Data   : HAL.UInt8_Array (1 .. 1);
         Status : UART_Status;
      begin
         while Port.Receive_Status /= RP.UART.Empty loop
            Port.Receive (UART_Data_8b (Data), Status, Timeout => 0);
            if Status = Ok then
               if Is_Full (Buffer) then
                  Delete_First (Buffer);
                  Count := Count - 1;
               end if;
               Append (Buffer, Data (1));
               Count := Count + 1;
            end if;
         end loop;
      end UART_Interrupt;

      procedure Reset is
      begin
         Byte_Buffers.Clear (Buffer);
         Count := 0;
      end Reset;

      entry Get
         (Data : out HAL.UInt8)
         when Count > 0
      is
      begin
         Data := Byte_Buffers.First_Element (Buffer);
         Byte_Buffers.Delete_First (Buffer);
         Count := Count - 1;
      end Get;

      function Length
         return Natural
      is (Count);
   end Receiver;

   procedure Initialize is
   begin
      Port.Configure;
      TXD.Configure (RP.GPIO.Output, RP.GPIO.Pull_Up, RP.GPIO.UART);
      RXD.Configure (RP.GPIO.Output, RP.GPIO.Floating, RP.GPIO.UART);
      Receiver.Reset;
      Port.Set_FIFO_IRQ_Level (RX => RP.UART.Lvl_Eighth, TX => RP.UART.Lvl_Eighth);
      Port.Enable_IRQ (RP.UART.Receive);
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
   is (Receiver.Length);

   procedure Read
      (Data : out HAL.UInt8_Array)
   is
   begin
      for I in Data'Range loop
         Receiver.Get (Data (I));
      end loop;
   end Read;

end Adafruit_Metro_RP2040.UART;
