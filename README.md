# Adafruit Metro RP2040 BSP (Ada)

```ada
with Adafruit_Metro_RP2040.GPIO;
with Adafruit_Metro_RP2040.Pins;
with Adafruit_Metro_RP2040.Time;
with Adafruit_Metro_RP2040;

procedure Example is
   package MRP renames Adafruit_Metro_RP2040;
   use MRP.Pins;
   use MRP.GPIO;
   use MRP.Time;
begin
   MRP.Time.Initialize;
   loop
      Digital_Write (D13, True);
      Delay_Milliseconds (100);
      Digital_Write (D13, False);
      Delay_Milliseconds (100);
   end loop;
end Example;
```

See also: [Adafruit Metro RP2040 PCB](https://github.com/adafruit/Adafruit-Metro-RP2040-PCB)

![Pinout diagram](https://cdn-learn.adafruit.com/assets/assets/000/123/326/original/adafruit_products_Adafruit_Metro_RP2040_Pinout.png)

This BSP provides simplified abstractions over the RP2040's peripherals to make
it easier to prototype with Arduino-compatible shields.

Much functionality of the RP2040 is not exposed here, use
[rp2040_hal](https://github.com/JeremyGrosser/rp2040_hal) directly if you need
more complex behavior.
