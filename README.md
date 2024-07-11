# Adafruit Metro RP2040 BSP (Ada)

This BSP provides simplified abstractions over the RP2040's peripherals to make
it easier to prototype with Arduino-compatible shields.

Much functionality of the RP2040 is not exposed here, use
[rp2040_hal](https://github.com/JeremyGrosser/rp2040_hal) directly if you need
more complex behavior.

## Example 
```ada
with Adafruit_Metro_RP2040.GPIO; use Adafruit_Metro_RP2040.GPIO;
with Adafruit_Metro_RP2040.Pins; use Adafruit_Metro_RP2040.Pins;
with Adafruit_Metro_RP2040.Time; use Adafruit_Metro_RP2040.Time;

procedure Example is
begin
   loop
      Digital_Write (D13, True);
      Delay_Milliseconds (100);
      Digital_Write (D13, False);
      Delay_Milliseconds (100);
   end loop;
end Example;
```

See [test/src/test.adb](test/src/test.adb) for a more comprehensive example.

## Building
Build with [Alire](https://alire.ada.dev/)

```
cd example/
alr build
elf2uf2 bin/example bin/example.uf2
```

## Runtime
This branch uses the `light-cortex-m0p` runtime and does not support tasking, protected types, or heap allocation.

## Pinout
![Pinout diagram](https://cdn-learn.adafruit.com/assets/assets/000/123/326/original/adafruit_products_Adafruit_Metro_RP2040_Pinout.png)

## Schematic and PCB files
[Adafruit Metro RP2040 PCB](https://github.com/adafruit/Adafruit-Metro-RP2040-PCB)

